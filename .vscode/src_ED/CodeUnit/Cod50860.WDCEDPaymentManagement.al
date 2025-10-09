codeunit 50860 "WDC-ED Payment Management"
{
    Permissions = TableData "Cust. Ledger Entry" = rm,
                  TableData "Vendor Ledger Entry" = rm;
    trigger OnRun()
    begin
        CreatePaymentHeaders();
    end;

    local procedure ProcessPaymentStep(PaymentHeaderNo: Code[20]; PaymentStep: Record "WDC-ED Payment Step")
    var
        PaymentStatus: Record "WDC-ED Payment Status";
        ActionValidated: Boolean;
    begin
        PaymentHeader.Get(PaymentHeaderNo);
        PaymentHeader.SetRange("No.", PaymentHeader."No.");

        if PaymentStep."Verify Header RIB" and not PaymentHeader."RIB Checked" then
            Error(Text008);

        PaymentLine.SetRange("No.", PaymentHeader."No.");
        PaymentLine.SetRange("Copied To No.", '');

        if PaymentStep."Acceptation Code<>No" then begin
            PaymentLine.SetRange("Acceptation Code", PaymentLine."Acceptation Code"::No);
            if PaymentLine.FINDSET then
                Error(Text002);
            PaymentLine.SetRange("Acceptation Code");
        end;

        if PaymentStep."Verify Lines RIB" then begin
            PaymentLine.SetFilter("Bank Account No.", '');
            if PaymentLine.FINDSET then
                Error(Text003);
            // PaymentLine.SetRange("RIB Checked");
        end;

        if PaymentStep."Verify Due Date" then begin
            PaymentLine.SetRange("Due Date", 0D);
            if PaymentLine.FINDSET then
                Error(Text006);
            PaymentLine.SetRange("Due Date");
        end;

        Step.Get(PaymentStep."Payment Class", PaymentStep."Line No.");

        ActionValidated := ProcessPaymentStepByActionType();


        if ActionValidated then begin
            PaymentHeader.Validate("Status No.", Step."Next Status");
            PaymentHeader.Modify();
            PaymentLine.SetRange("No.", PaymentHeader."No.");
            PaymentLine.ModifyAll("Status No.", Step."Next Status");
            PaymentStatus.Get(PaymentHeader."Payment Class", Step."Next Status");
            PaymentLine.ModifyAll("Payment in Progress", PaymentStatus."Payment in Progress");
        end else
            Message(Text007);
    end;

    procedure ProcessPaymentStepByActionType() ActionValidated: Boolean
    var
        Window: Dialog;
    begin
        case Step."Action Type" of
            Step."Action Type"::None:
                exit(true);
            Step."Action Type"::"Cancel File":
                begin
                    PaymentHeader."File Export Completed" := false;
                    PaymentHeader.Modify();
                    exit(true);
                end;
            Step."Action Type"::File:
                begin
                    PaymentHeader."File Export Completed" := false;
                    PaymentHeader.Modify();
                    Commit();

                    case Step."Export Type" of
                        Step."Export Type"::Report:
                            REPORT.RunModal(Step."Export No.", true, false, PaymentHeader);
                        Step."Export Type"::XMLport:
                            RunXmlPortExport(Step."Export No.", PaymentHeader);
                    end;

                    PaymentHeader.Find;
                    exit(PaymentHeader."File Export Completed");
                end;
            Step."Action Type"::Report:
                begin
                    REPORT.RunModal(Step."Report No.", true, true, PaymentLine);
                    exit(true);
                end;
            Step."Action Type"::Ledger:
                begin
                    InvPostingBuffer[1].DeleteAll();
                    CheckDim();
                    Window.Open(
                      '#1#################################\\' +
                      Text005);
                    if PaymentLine.FINDSET then
                        repeat
                            Window.Update(1, Text005 + ' ' + PaymentLine."No." + ' ' + Format(PaymentLine."Line No."));
                            OldPaymentLine := PaymentLine;
                            HeaderAccountUsedGlobally := false;
                            GenerInvPostingBuffer();
                            PaymentLine."Acc. Type Last Entry Debit" := EntryTypeDebit;
                            PaymentLine."Acc. No. Last Entry Debit" := EntryNoAccountDebit;
                            PaymentLine."P. Group Last Entry Debit" := EntryPostGroupDebit;
                            PaymentLine."Acc. Type Last Entry Credit" := EntryTypeCredit;
                            PaymentLine."Acc. No. Last Entry Credit" := EntryNoAccountCredit;
                            PaymentLine."P. Group Last Entry Credit" := EntryPostGroupCredit;
                            PaymentLine.Validate("Status No.", Step."Next Status");
                            PaymentLine.Posted := true;
                            PaymentLine.Modify();
                        until PaymentLine.Next() = 0;
                    Window.Close();
                    GenerEntries();
                    exit(true);
                end;
        end;
    end;

    procedure UpdtBuffer()
    var
        CurrExchRate: Record "Currency Exchange Rate";
    begin
        InvPostingBuffer[2] := InvPostingBuffer[1];
        if InvPostingBuffer[2].Find() then begin
            InvPostingBuffer[2].Validate(Amount, InvPostingBuffer[2].Amount + InvPostingBuffer[1].Amount);
            InvPostingBuffer[2]."Amount (LCY)" := Round(CurrExchRate.ExchangeAmtFCYToLCY(PaymentHeader."Posting Date",
                  PaymentHeader."Currency Code", InvPostingBuffer[2].Amount, PaymentHeader."Currency Factor"));
            InvPostingBuffer[2]."VAT Amount" :=
              InvPostingBuffer[2]."VAT Amount" + InvPostingBuffer[1]."VAT Amount";
            InvPostingBuffer[2]."Line Discount Amount" :=
              InvPostingBuffer[2]."Line Discount Amount" + InvPostingBuffer[1]."Line Discount Amount";
            if InvPostingBuffer[1]."Line Discount Account" <> '' then
                InvPostingBuffer[2]."Line Discount Account" := InvPostingBuffer[1]."Line Discount Account";
            InvPostingBuffer[2]."Inv. Discount Amount" :=
              InvPostingBuffer[2]."Inv. Discount Amount" + InvPostingBuffer[1]."Inv. Discount Amount";
            if InvPostingBuffer[1]."Inv. Discount Account" <> '' then
                InvPostingBuffer[2]."Inv. Discount Account" := InvPostingBuffer[1]."Inv. Discount Account";
            InvPostingBuffer[2]."VAT Base Amount" :=
              InvPostingBuffer[2]."VAT Base Amount" + InvPostingBuffer[1]."VAT Base Amount";
            InvPostingBuffer[2]."Amount (ACY)" :=
              InvPostingBuffer[2]."Amount (ACY)" + InvPostingBuffer[1]."Amount (ACY)";
            InvPostingBuffer[2]."VAT Amount (ACY)" :=
              InvPostingBuffer[2]."VAT Amount (ACY)" + InvPostingBuffer[1]."VAT Amount (ACY)";
            InvPostingBuffer[2]."VAT Difference" :=
              InvPostingBuffer[2]."VAT Difference" + InvPostingBuffer[1]."VAT Difference";
            InvPostingBuffer[2]."Line Discount Amt. (ACY)" :=
              InvPostingBuffer[2]."Line Discount Amt. (ACY)" +
              InvPostingBuffer[1]."Line Discount Amt. (ACY)";
            InvPostingBuffer[2]."Inv. Discount Amt. (ACY)" :=
              InvPostingBuffer[2]."Inv. Discount Amt. (ACY)" +
              InvPostingBuffer[1]."Inv. Discount Amt. (ACY)";
            InvPostingBuffer[2]."VAT Base Amount (ACY)" :=
              InvPostingBuffer[2]."VAT Base Amount (ACY)" +
              InvPostingBuffer[1]."VAT Base Amount (ACY)";
            InvPostingBuffer[2].Quantity :=
              InvPostingBuffer[2].Quantity + InvPostingBuffer[1].Quantity;
            if not InvPostingBuffer[1]."System-Created Entry" then
                InvPostingBuffer[2]."System-Created Entry" := false;
            InvPostingBuffer[2].Modify();
        end else begin
            GLEntryNoTmp += 1;
            InvPostingBuffer[1]."GL Entry No." := GLEntryNoTmp;
            InvPostingBuffer[1].Insert();
        end;
    end;

    procedure CopyLigBor(var FromPaymentLine: Record "WDC-ED Payment Line"; NewStep: Integer; var PayNum: Code[20])
    var
        ToBord: Record "WDC-ED Payment Header";
        ToPaymentLine: Record "WDC-ED Payment Line";
        Step: Record "WDC-ED Payment Step";
        Process: Record "WDC-ED Payment Class";
        PaymentStatus: Record "WDC-ED Payment Status";
        NoSeriesMgt: Codeunit "No. Series";
        i: Integer;
    begin
        if FromPaymentLine.FINDSET then begin
            Step.Get(FromPaymentLine."Payment Class", NewStep);
            Process.Get(FromPaymentLine."Payment Class");
            if PayNum = '' then begin
                i := 10000;
                //NoSeriesMgt.AreRelated(Step."Header Nos. Series", ToBord."No. Series");//HD09062025
                ToBord."No." := NoSeriesMgt.GetNextNo(Process."Header No. Series");
                ToBord."Payment Class" := FromPaymentLine."Payment Class";
                ToBord."Status No." := Step."Next Status";
                PaymentStatus.Get(ToBord."Payment Class", ToBord."Status No.");
                ToBord."Archiving Authorized" := PaymentStatus."Archiving Authorized";
                ToBord."Currency Code" := FromPaymentLine."Currency Code";
                ToBord."Currency Factor" := FromPaymentLine."Currency Factor";
                ToBord.InitHeader;
                ToBord.Insert;
            end else begin
                ToBord.Get(PayNum);
                ToPaymentLine.SetRange("No.", PayNum);
                if ToPaymentLine.FindLast() then
                    i := ToPaymentLine."Line No." + 10000
                else
                    i := 10000;
            end;
            repeat
                ToPaymentLine.Copy(FromPaymentLine);
                ToPaymentLine."No." := ToBord."No.";
                ToPaymentLine."Line No." := i;
                ToPaymentLine.IsCopy := true;
                ToPaymentLine."Status No." := Step."Next Status";
                ToPaymentLine."Copied To No." := '';
                ToPaymentLine."Copied To Line" := 0;
                ToPaymentLine.Posted := false;
                ToPaymentLine."Created from No." := FromPaymentLine."No.";
                ToPaymentLine."Dimension Set ID" := FromPaymentLine."Dimension Set ID";
                ToPaymentLine.Insert(true);
                FromPaymentLine."Copied To No." := ToPaymentLine."No.";
                FromPaymentLine."Copied To Line" := ToPaymentLine."Line No.";
                FromPaymentLine.Modify();
                i += 10000;
            until FromPaymentLine.Next() = 0;
            PayNum := ToBord."No.";
        end;
    end;

    procedure DeleteLigBorCopy(var FromPaymentLine: Record "WDC-ED Payment Line")
    var
        ToPaymentLine: Record "WDC-ED Payment Line";
    begin
        ToPaymentLine.SetCurrentKey("Copied To No.", "Copied To Line");

        if FromPaymentLine.FINDSET then
            if FromPaymentLine.Posted then
                Message(Text016)
            else
                repeat
                    ToPaymentLine.SetRange("Copied To No.", FromPaymentLine."No.");
                    ToPaymentLine.SetRange("Copied To Line", FromPaymentLine."Line No.");
                    ToPaymentLine.FindFirst();
                    ToPaymentLine."Copied To No." := '';
                    ToPaymentLine."Copied To Line" := 0;
                    ToPaymentLine.Modify();
                    FromPaymentLine.Delete(true);
                until FromPaymentLine.Next() = 0;
    end;

    procedure GenerInvPostingBuffer()
    var
        PaymentClass: Record "WDC-ED Payment Class";
        NoSeriesMgt: Codeunit "No. Series - Batch";
        Description: Text[98];
    begin
        StepLedger.SetRange("Payment Class", Step."Payment Class");
        StepLedger.SetRange("Line No.", Step."Line No.");

        if StepLedger.FINDSET() then begin
            repeat
                Clear(InvPostingBuffer[1]);
                SetPostingGroup();
                SetAccountNo();
                InvPostingBuffer[1]."System-Created Entry" := true;
                if StepLedger.Sign = StepLedger.Sign::Debit then begin
                    InvPostingBuffer[1].Validate(Amount, Abs(PaymentLine.Amount));
                    InvPostingBuffer[1].Validate("Amount (LCY)", Abs(PaymentLine."Amount (LCY)"));
                end else begin
                    InvPostingBuffer[1].Validate(Amount, Abs(PaymentLine.Amount) * -1);
                    InvPostingBuffer[1].Validate("Amount (LCY)", Abs(PaymentLine."Amount (LCY)") * -1);
                end;
                InvPostingBuffer[1]."Currency Code" := PaymentLine."Currency Code";
                InvPostingBuffer[1]."Currency Factor" := PaymentLine."Currency Factor";
                InvPostingBuffer[1].Correction := PaymentLine.Correction xor Step.Correction;
                if StepLedger."Detail Level" = StepLedger."Detail Level"::Line then
                    InvPostingBuffer[1]."Payment Line No." := PaymentLine."Line No."
                else
                    if StepLedger."Detail Level" = StepLedger."Detail Level"::"Due Date" then
                        InvPostingBuffer[1]."Due Date" := PaymentLine."Due Date";

                InvPostingBuffer[1]."Document Type" := StepLedger."Document Type";
                if StepLedger."Document No." = StepLedger."Document No."::"Header No." then
                    InvPostingBuffer[1]."Document No." := PaymentHeader."No."
                else begin
                    if (InvPostingBuffer[1].Sign = InvPostingBuffer[1].Sign::Positive) and
                       (PaymentLine."Entry No. Debit" = 0) and (PaymentLine."Entry No. Credit" = 0)
                    then begin
                        PaymentClass.Get(PaymentHeader."Payment Class");
                        if PaymentClass."Line No. Series" = '' then
                            PaymentLine.TestField("Document No.", NoSeriesMgt.GetNextNo(PaymentHeader."No. Series", PaymentLine."Posting Date", false))
                        else
                            PaymentLine.TestField("Document No.", NoSeriesMgt.GetNextNo(PaymentClass."Line No. Series", PaymentLine."Posting Date",
                                false));
                    end;
                    InvPostingBuffer[1]."Document No." := PaymentLine."Document No.";
                end;
                InvPostingBuffer[1]."Header Document No." := PaymentHeader."No.";
                if StepLedger.Sign = StepLedger.Sign::Debit then begin
                    EntryTypeDebit := InvPostingBuffer[1]."Account Type";
                    EntryNoAccountDebit := InvPostingBuffer[1]."Account No.";
                    EntryPostGroupDebit := InvPostingBuffer[1]."Posting Group";
                end else begin
                    EntryTypeCredit := InvPostingBuffer[1]."Account Type";
                    EntryNoAccountCredit := InvPostingBuffer[1]."Account No.";
                    EntryPostGroupCredit := InvPostingBuffer[1]."Posting Group";
                end;
                InvPostingBuffer[1]."System-Created Entry" := true;
                Application();
                PaymentClass.Get(PaymentHeader."Payment Class");
                if (PaymentClass."Unrealized VAT Reversal" = PaymentClass."Unrealized VAT Reversal"::Delayed) and
                   Step."Realize VAT"
                then begin
                    InvPostingBuffer[1]."Applies-to Doc. Type" := PaymentLine."Applies-to Doc. Type";
                    InvPostingBuffer[1]."Applies-to Doc. No." := PaymentLine."Applies-to Doc. No.";
                    if InvPostingBuffer[1]."Applies-to ID" = '' then
                        InvPostingBuffer[1]."Applies-to ID" := PaymentLine."Applies-to ID";
                    InvPostingBuffer[1]."Created from No." := PaymentLine."Created from No.";
                end;
                Description := GetDescriptionForInvPostingBuffer();
                InvPostingBuffer[1].Description := CopyStr(Description, 1, 50);
                InvPostingBuffer[1]."Source Type" := PaymentLine."Account Type";
                InvPostingBuffer[1]."Source No." := PaymentLine."Account No.";
                InvPostingBuffer[1]."External Document No." := PaymentLine."External Document No.";
                InvPostingBuffer[1]."Dimension Set ID" := PaymentLine."Dimension Set ID";
                UpdtBuffer();
                if (InvPostingBuffer[1].Amount >= 0) xor InvPostingBuffer[1].Correction then
                    PaymentLine."Entry No. Debit" := InvPostingBuffer[1]."GL Entry No."
                else
                    PaymentLine."Entry No. Credit" := InvPostingBuffer[1]."GL Entry No.";
            until StepLedger.Next() = 0;
            NoSeriesMgt.SaveState();
        end;
    end;

    local procedure GetDescriptionForInvPostingBuffer() Description: Text[98]
    begin
        Description :=
            StrSubstNo(StepLedger.Description, PaymentLine."Due Date", PaymentLine."Account No.", PaymentLine."Document No.");
    end;

    procedure SetPostingGroup()
    var
        PostingGroup: Code[20];
    begin
        if PaymentLine."Account Type" = PaymentLine."Account Type"::Customer then
            if ((StepLedger."Accounting Type" = StepLedger."Accounting Type"::"Payment Line Account") or
                (StepLedger."Accounting Type" = StepLedger."Accounting Type"::"Associated G/L Account") or
                (StepLedger."Accounting Type" = StepLedger."Accounting Type"::"Header Payment Account") or
                ((StepLedger."Accounting Type" = StepLedger."Accounting Type"::"Setup Account") and
                 (StepLedger."Account Type" = StepLedger."Account Type"::Customer)))
            then begin
                if PaymentLine."Posting Group" <> '' then
                    PostingGroup := PaymentLine."Posting Group"
                else
                    if StepLedger."Customer Posting Group" <> '' then
                        PostingGroup := StepLedger."Customer Posting Group"
                    else begin
                        Customer.Get(PaymentLine."Account No.");
                        PostingGroup := Customer."Customer Posting Group";
                    end;
                if not CustomerPostingGroup.Get(PostingGroup) then
                    Error(Text012, PostingGroup);
                if CustomerPostingGroup."Receivables Account" = '' then
                    Error(Text014, PostingGroup);
            end;

        if PaymentLine."Account Type" = PaymentLine."Account Type"::Vendor then
            if ((StepLedger."Accounting Type" = StepLedger."Accounting Type"::"Payment Line Account") or
                (StepLedger."Accounting Type" = StepLedger."Accounting Type"::"Associated G/L Account") or
                (StepLedger."Accounting Type" = StepLedger."Accounting Type"::"Header Payment Account") or
                ((StepLedger."Accounting Type" = StepLedger."Accounting Type"::"Setup Account") and
                 (StepLedger."Account Type" = StepLedger."Account Type"::Vendor)))
            then begin
                if PaymentLine."Posting Group" <> '' then
                    PostingGroup := PaymentLine."Posting Group"
                else
                    if StepLedger."Vendor Posting Group" <> '' then
                        PostingGroup := StepLedger."Vendor Posting Group"
                    else begin
                        Vendor.Get(PaymentLine."Account No.");
                        PostingGroup := Vendor."Vendor Posting Group";
                    end;
                if not VendorPostingGroup.Get(PostingGroup) then
                    Error(Text012, PostingGroup);
                if VendorPostingGroup."Payables Account" = '' then
                    Error(Text014, PostingGroup);
            end;
    end;

    procedure SetAccountNo()
    begin
        case StepLedger."Accounting Type" of
            StepLedger."Accounting Type"::"Payment Line Account":
                begin
                    InvPostingBuffer[1]."Account Type" := PaymentLine."Account Type";
                    InvPostingBuffer[1]."Account No." := PaymentLine."Account No.";
                    if PaymentLine."Account Type" = PaymentLine."Account Type"::Customer then
                        InvPostingBuffer[1]."Posting Group" := CustomerPostingGroup.Code;
                    if PaymentLine."Account Type" = PaymentLine."Account Type"::Vendor then
                        InvPostingBuffer[1]."Posting Group" := VendorPostingGroup.Code;
                    InvPostingBuffer[1]."Line No." := PaymentLine."Line No.";
                    DimMgt.UpdateGlobalDimFromDimSetID(PaymentLine."Dimension Set ID",
                      InvPostingBuffer[1]."Global Dimension 1 Code", InvPostingBuffer[1]."Global Dimension 2 Code");
                end;
            StepLedger."Accounting Type"::"Associated G/L Account":
                begin
                    InvPostingBuffer[1]."Account Type" := InvPostingBuffer[1]."Account Type"::"G/L Account";
                    if PaymentLine."Account Type" = PaymentLine."Account Type"::Customer then
                        InvPostingBuffer[1]."Account No." := CustomerPostingGroup."Receivables Account"
                    else
                        InvPostingBuffer[1]."Account No." := VendorPostingGroup."Payables Account";
                    InvPostingBuffer[1]."Line No." := PaymentLine."Line No.";
                end;
            StepLedger."Accounting Type"::"Setup Account":
                begin
                    InvPostingBuffer[1]."Account Type" := StepLedger."Account Type";
                    InvPostingBuffer[1]."Account No." := StepLedger."Account No.";
                    if StepLedger."Account No." = '' then begin
                        PaymentHeader.CalcFields("Payment Class Name");
                        if StepLedger.Sign = StepLedger.Sign::Debit then
                            Error(Text018, Step.Name, PaymentHeader."Payment Class Name");

                        Error(Text019, Step.Name, PaymentHeader."Payment Class Name");
                    end;
                    if StepLedger."Account Type" = StepLedger."Account Type"::Customer then
                        InvPostingBuffer[1]."Posting Group" := StepLedger."Customer Posting Group"
                    else
                        InvPostingBuffer[1]."Posting Group" := StepLedger."Vendor Posting Group";
                    InvPostingBuffer[1]."Line No." := PaymentLine."Line No.";
                end;
            StepLedger."Accounting Type"::"G/L Account / Month":
                begin
                    InvPostingBuffer[1]."Account Type" := InvPostingBuffer[1]."Account Type"::"G/L Account";
                    N := Date2DMY(PaymentLine."Due Date", 2);
                    if N < 10 then
                        Suffix := '0' + Format(N)
                    else
                        Suffix := Format(N);
                    InvPostingBuffer[1]."Account No." := CopyStr(StepLedger.Root + Suffix, 1, MaxStrLen(InvPostingBuffer[1]."Account No."));
                    InvPostingBuffer[1]."Line No." := PaymentLine."Line No.";
                end;
            StepLedger."Accounting Type"::"G/L Account / Week":
                begin
                    InvPostingBuffer[1]."Account Type" := InvPostingBuffer[1]."Account Type"::"G/L Account";
                    N := Date2DWY(PaymentLine."Due Date", 2);
                    if N < 10 then
                        Suffix := '0' + Format(N)
                    else
                        Suffix := Format(N);
                    InvPostingBuffer[1]."Account No." := CopyStr(StepLedger.Root + Suffix, 1, MaxStrLen(InvPostingBuffer[1]."Account No."));
                    InvPostingBuffer[1]."Line No." := PaymentLine."Line No.";
                end;
            StepLedger."Accounting Type"::"Bal. Account Previous Entry":
                begin
                    if (StepLedger.Sign = StepLedger.Sign::Debit) and not (PaymentLine.Correction xor Step.Correction) then begin
                        InvPostingBuffer[1]."Account Type" := PaymentLine."Acc. Type Last Entry Credit";
                        InvPostingBuffer[1]."Account No." := PaymentLine."Acc. No. Last Entry Credit";
                        InvPostingBuffer[1]."Posting Group" := PaymentLine."P. Group Last Entry Credit";
                    end else begin
                        InvPostingBuffer[1]."Account Type" := PaymentLine."Acc. Type Last Entry Debit";
                        InvPostingBuffer[1]."Account No." := PaymentLine."Acc. No. Last Entry Debit";
                        InvPostingBuffer[1]."Posting Group" := PaymentLine."P. Group Last Entry Debit";
                    end;
                    InvPostingBuffer[1]."Line No." := PaymentLine."Line No.";
                end;
            StepLedger."Accounting Type"::"Header Payment Account":
                begin
                    InvPostingBuffer[1]."Account Type" := PaymentHeader."Account Type";
                    InvPostingBuffer[1]."Account No." := PaymentHeader."Account No.";
                    if PaymentHeader."Account No." = '' then
                        Error(Text020);
                    if StepLedger."Detail Level" = StepLedger."Detail Level"::Account then
                        HeaderAccountUsedGlobally := true;
                    InvPostingBuffer[1]."Line No." := 0;
                    DimMgt.UpdateGlobalDimFromDimSetID(PaymentHeader."Dimension Set ID",
                      InvPostingBuffer[1]."Global Dimension 1 Code", InvPostingBuffer[1]."Global Dimension 2 Code");
                end;
        end;
    end;

    procedure Application()
    begin
        if StepLedger.Application <> StepLedger.Application::None then
            if StepLedger.Application = StepLedger.Application::"Applied Entry" then begin
                InvPostingBuffer[1]."Applies-to Doc. Type" := PaymentLine."Applies-to Doc. Type";
                InvPostingBuffer[1]."Applies-to Doc. No." := PaymentLine."Applies-to Doc. No.";
                InvPostingBuffer[1]."Applies-to ID" := PaymentLine."Applies-to ID";
            end else
                if StepLedger.Application = StepLedger.Application::"Entry Previous Step" then begin
                    InvPostingBuffer[1]."Applies-to ID" := PaymentLine."No." + '/' + Format(PaymentLine."Line No.") + Text011;
                    if InvPostingBuffer[1]."Account Type" = InvPostingBuffer[1]."Account Type"::Customer then begin
                        if (InvPostingBuffer[1].Amount < 0) xor InvPostingBuffer[1].Correction then
                            CustLedgerEntry.SetRange("Entry No.", OldPaymentLine."Entry No. Debit")
                        else
                            CustLedgerEntry.SetRange("Entry No.", OldPaymentLine."Entry No. Credit");
                        if CustLedgerEntry.FindFirst() then begin
                            CustLedgerEntry."Applies-to ID" := InvPostingBuffer[1]."Applies-to ID";
                            CustLedgerEntry.CalcFields("Remaining Amount");
                            CustLedgerEntry.Validate("Amount to Apply", CustLedgerEntry."Remaining Amount");
                            CustLedgerEntry.Modify();
                        end;
                    end else
                        if InvPostingBuffer[1]."Account Type" = InvPostingBuffer[1]."Account Type"::Vendor then begin
                            if (InvPostingBuffer[1].Amount < 0) xor InvPostingBuffer[1].Correction then
                                VendorLedgerEntry.SetRange("Entry No.", OldPaymentLine."Entry No. Debit")
                            else
                                VendorLedgerEntry.SetRange("Entry No.", OldPaymentLine."Entry No. Credit");
                            if VendorLedgerEntry.FindFirst() then begin
                                VendorLedgerEntry."Applies-to ID" := InvPostingBuffer[1]."Applies-to ID";
                                VendorLedgerEntry.CalcFields("Remaining Amount");
                                VendorLedgerEntry.Validate("Amount to Apply", VendorLedgerEntry."Remaining Amount");
                                VendorLedgerEntry.Modify();
                            end;
                        end;
                end else
                    if StepLedger.Application = StepLedger.Application::"Memorized Entry" then begin
                        InvPostingBuffer[1]."Applies-to ID" := PaymentLine."No." + '/' + Format(PaymentLine."Line No.") + Text011;
                        if InvPostingBuffer[1]."Account Type" = InvPostingBuffer[1]."Account Type"::Customer then begin
                            CustLedgerEntry.Reset();
                            if (InvPostingBuffer[1].Amount < 0) xor InvPostingBuffer[1].Correction then
                                CustLedgerEntry.SetRange("Entry No.", OldPaymentLine."Entry No. Debit Memo")
                            else
                                CustLedgerEntry.SetRange("Entry No.", OldPaymentLine."Entry No. Credit Memo");
                            if CustLedgerEntry.FindFirst() then begin
                                CustLedgerEntry."Applies-to ID" := InvPostingBuffer[1]."Applies-to ID";
                                CustLedgerEntry.CalcFields("Remaining Amount");
                                CustLedgerEntry.Validate("Amount to Apply", CustLedgerEntry."Remaining Amount");
                                CustLedgerEntry.Modify();
                            end;
                        end else
                            if InvPostingBuffer[1]."Account Type" = InvPostingBuffer[1]."Account Type"::Vendor then begin
                                if (InvPostingBuffer[1].Amount < 0) xor InvPostingBuffer[1].Correction then
                                    VendorLedgerEntry.SetRange("Entry No.", OldPaymentLine."Entry No. Debit Memo")
                                else
                                    VendorLedgerEntry.SetRange("Entry No.", OldPaymentLine."Entry No. Credit Memo");
                                if VendorLedgerEntry.FindFirst() then begin
                                    VendorLedgerEntry."Applies-to ID" := InvPostingBuffer[1]."Applies-to ID";
                                    VendorLedgerEntry.CalcFields("Remaining Amount");
                                    VendorLedgerEntry.Validate("Amount to Apply", VendorLedgerEntry."Remaining Amount");
                                    VendorLedgerEntry.Modify();
                                end;
                            end;
                    end;
        if StepLedger."Detail Level" = StepLedger."Detail Level"::Account then begin
            if (InvPostingBuffer[1]."Account Type" = InvPostingBuffer[1]."Account Type"::Vendor) or
               (InvPostingBuffer[1]."Account Type" = InvPostingBuffer[1]."Account Type"::Customer)
            then
                InvPostingBuffer[1]."Due Date" := PaymentLine."Due Date" // FR Payment due date
        end else
            InvPostingBuffer[1]."Due Date" := PaymentLine."Due Date"; // FR Payment due date
    end;

    procedure GenerEntries()
    var
        Currency: Record Currency;
        Difference: Decimal;
        TotalDebit: Decimal;
        TotalCredit: Decimal;
        LastGLEntryNo: Integer;

    begin
        if InvPostingBuffer[1].FindSet() then
            repeat
                LastGLEntryNo := PostInvPostingBuffer();
                PaymentLine.Reset();
                PaymentLine.SetRange("No.", PaymentHeader."No.");
                PaymentLine.SetRange("Line No.");
                if GenJnlLine.Amount >= 0 then begin
                    TotalDebit := TotalDebit + GenJnlLine."Amount (LCY)";
                    StepLedger.Get(Step."Payment Class", Step."Line No.", StepLedger.Sign::Debit);
                    PaymentLine.SetRange("Entry No. Debit", InvPostingBuffer[1]."GL Entry No.");
                    if StepLedger."Memorize Entry" then
                        PaymentLine.ModifyAll(PaymentLine."Entry No. Debit Memo", LastGLEntryNo);
                    PaymentLine.ModifyAll("Entry No. Debit", LastGLEntryNo);
                    PaymentLine.SetRange("Entry No. Debit");
                end else begin
                    TotalCredit := TotalCredit + Abs(GenJnlLine."Amount (LCY)");
                    StepLedger.Get(Step."Payment Class", Step."Line No.", StepLedger.Sign::Credit);
                    PaymentLine.SetRange("Entry No. Credit", InvPostingBuffer[1]."GL Entry No.");
                    if StepLedger."Memorize Entry" then
                        PaymentLine.ModifyAll(PaymentLine."Entry No. Credit Memo", LastGLEntryNo);
                    PaymentLine.ModifyAll("Entry No. Credit", LastGLEntryNo);
                    PaymentLine.SetRange("Entry No. Credit");
                end;
            //until InvPostingBuffer[1].Next(-1) = 0; //HD
            until InvPostingBuffer[1].Next() = 0;

        if HeaderAccountUsedGlobally then begin
            Difference := TotalDebit - TotalCredit;
            if Difference <> 0 then begin
                GenJnlLine.Init();
                GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
                Currency.Get(PaymentHeader."Currency Code");
                if Difference < 0 then begin
                    GenJnlLine."Account No." := Currency."Unrealized Losses Acc.";
                    StepLedger.Get(Step."Payment Class", Step."Line No.", StepLedger.Sign::Debit);
                    GenJnlLine.Validate("Debit Amount", -Difference);
                end else begin
                    GenJnlLine."Account No." := Currency."Unrealized Gains Acc.";
                    StepLedger.Get(Step."Payment Class", Step."Line No.", StepLedger.Sign::Credit);
                    GenJnlLine.Validate("Credit Amount", Difference);
                end;
                GenJnlLine."Posting Date" := PaymentHeader."Posting Date";
                GenJnlLine."Document No." := PaymentHeader."No.";
                GenJnlLine.Description := StrSubstNo(
                  Text100, StrSubstNo(StepLedger.Description, PaymentHeader."Document Date", '', PaymentHeader."No."));
                GenJnlLine."Shortcut Dimension 1 Code" := PaymentHeader."Shortcut Dimension 1 Code";
                GenJnlLine."Shortcut Dimension 2 Code" := PaymentHeader."Shortcut Dimension 2 Code";
                GenJnlLine."Dimension Set ID" := PaymentHeader."Dimension Set ID";
                GenJnlLine."Source Code" := PaymentHeader."Source Code";
                GenJnlLine."Reason Code" := Step."Reason Code";
                GenJnlLine."Document Date" := PaymentHeader."Document Date";
                GenJnlLine."Payment Slip Type" := PaymentHeader."Payment Slip Type";
                GenJnlPostLine.RunWithCheck(GenJnlLine);
            end;
        end;
        InvPostingBuffer[2].DeleteAll();//HD
        InvPostingBuffer[1].DeleteAll();
    end;


    local procedure GetIntegerPos(No: Code[20]; var StartPos: Integer; var EndPos: Integer)
    var
        IsDigit: Boolean;
        i: Integer;
    begin
        StartPos := 0;
        EndPos := 0;
        if No <> '' then begin
            i := StrLen(No);
            repeat
                IsDigit := No[i] in ['0' .. '9'];
                if IsDigit then begin
                    if EndPos = 0 then
                        EndPos := i;
                    StartPos := i;
                end;
                i := i - 1;
            until (i = 0) or (StartPos <> 0) and not IsDigit;
        end;
        if (StartPos = 0) and (EndPos = 0) then
            Error(Text021, No);
    end;

    procedure IncrementNoText(var No: Code[20]; IncrementByNo: Decimal)
    var
        DecimalNo: Decimal;
        StartPos: Integer;
        EndPos: Integer;
        NewNo: Text[30];
    begin
        GetIntegerPos(No, StartPos, EndPos);
        Evaluate(DecimalNo, CopyStr(No, StartPos, EndPos - StartPos + 1));
        NewNo := Format(DecimalNo + IncrementByNo, 0, 1);
        ReplaceNoText(No, NewNo, 0, StartPos, EndPos);
    end;

    local procedure ReplaceNoText(var No: Code[20]; NewNo: Code[30]; FixedLength: Integer; StartPos: Integer; EndPos: Integer)
    var
        StartNo: Code[20];
        EndNo: Code[20];
        ZeroNo: Code[20];
        NewLength: Integer;
        OldLength: Integer;
    begin
        if StartPos > 1 then
            StartNo := CopyStr(No, 1, StartPos - 1);
        if EndPos < StrLen(No) then
            EndNo := CopyStr(No, EndPos + 1);
        NewLength := StrLen(NewNo);
        OldLength := EndPos - StartPos + 1;
        if FixedLength > OldLength then
            OldLength := FixedLength;
        if OldLength > NewLength then
            ZeroNo := PadStr('', OldLength - NewLength, '0');
        if StrLen(StartNo) + StrLen(ZeroNo) + StrLen(NewNo) + StrLen(EndNo) > 20 then
            Error(Text001, No);

        No := CopyStr(StartNo + ZeroNo + NewNo + EndNo, 1, MaxStrLen(No));
    end;

    procedure CreatePaymentHeaders()
    begin
        Step.SetRange("Action Type", Step."Action Type"::"Create New Document");

        if StepSelect('', -1, Step, true) then
            ExecuteCreatePaymtHead(Step);
    end;

    procedure ExecuteCreatePaymtHead(PaymtStep: Record "WDC-ED Payment Step"): Code[20]
    var
        Bor: Record "WDC-ED Payment Header";
        StatementForm: Page "WDC-ED Payment Slip";
        InserForm: Page "WDC-ED Payment Lines List";
        PayNum: Code[20];
    begin
        PaymentLine.SetRange("Payment Class", PaymtStep."Payment Class");
        PaymentLine.SetRange("Status No.", PaymtStep."Previous Status");
        PaymentLine.SetRange("Copied To No.", '');
        PaymentLine.FilterGroup(2);
        InserForm.SetSteps(PaymtStep."Line No.");
        InserForm.SetTableView(PaymentLine);
        InserForm.LookupMode(true);
        InserForm.RunModal();
        PayNum := InserForm.GetNumBor();
        if Bor.Get(PayNum) then begin
            StatementForm.SetRecord(Bor);
            StatementForm.Run();
        end else
            Error(Text004);
        exit(PayNum);
    end;

    procedure LinesInsert(HeaderNumber: Code[20])
    var
        Header: Record "WDC-ED Payment Header";
        PaymentLine: Record "WDC-ED Payment Line";
        Step: Record "WDC-ED Payment Step";
        InserForm: Page "WDC-ED Payment Lines List";
    begin
        Header.Get(HeaderNumber);
        if StepSelect(Header."Payment Class", Header."Status No.", Step, false) then begin
            PaymentLine.SetRange("Payment Class", Header."Payment Class");
            PaymentLine.SetRange("Copied To No.", '');
            PaymentLine.SetFilter("Status No.", Format(Step."Previous Status"));
            PaymentLine.SetRange("Currency Code", Header."Currency Code");
            PaymentLine.FilterGroup(2);
            InserForm.SetSteps(Step."Line No.");
            InserForm.SetNumBor(Header."No.");
            InserForm.SetTableView(PaymentLine);
            InserForm.LookupMode(true);
            InserForm.RunModal();
        end;
    end;

    procedure StepSelect(Process: Text[30]; NextStatus: Integer; var Step: Record "WDC-ED Payment Step"; CreateDocumentFilter: Boolean) OK: Boolean
    var
        PaymentClass: Record "WDC-ED Payment Class";
        Options: Text[250];
        Choice: Integer;
        i: Integer;
    begin
        OK := false;
        i := 0;
        if Process = '' then begin
            PaymentClass.SetRange(Enable, true);
            if CreateDocumentFilter then
                PaymentClass.SetRange("Is Create Document", true);
            if PaymentClass.FINDSET() then
                repeat
                    i += 1;
                    if Options = '' then
                        Options := PaymentClass.Code
                    else
                        Options := Options + ',' + PaymentClass.Code;
                until PaymentClass.Next() = 0;
            if i > 0 then
                Choice := StrMenu(Options, 1);
            i := 1;
            if Choice > 0 then begin
                PaymentClass.FINDSET();
                while Choice > i do begin
                    i += 1;
                    PaymentClass.Next();
                end;
            end;
        end else begin
            PaymentClass.Get(Process);
            Choice := 1;
        end;
        if Choice > 0 then begin
            Options := '';
            Step.SetRange("Payment Class", PaymentClass.Code);
            Step.SetRange("Action Type", Step."Action Type"::"Create New Document");
            if NextStatus > -1 then
                Step.SetRange("Next Status", NextStatus);
            i := 0;
            if Step.FINDSET() then begin
                i += 1;
                repeat
                    if Options = '' then
                        Options := Step.Name
                    else
                        Options := Options + ',' + Step.Name;
                until Step.Next() = 0;
                if i > 0 then begin
                    Choice := StrMenu(Options, 1);
                    i := 1;
                    if Choice > 0 then begin
                        Step.FINDSET();
                        while Choice > i do begin
                            i += 1;
                            Step.Next;
                        end;
                        OK := true;
                    end;
                end;
            end;
        end;
    end;

    local procedure CheckDimCombAndValue(PaymentLine2: Record "WDC-ED Payment Line")
    var
        TableID: array[10] of Integer;
        No: array[10] of Code[20];
    begin
        if PaymentLine."Line No." = 0 then begin
            if not DimMgt.CheckDimIDComb(PaymentHeader."Dimension Set ID") then
                Error(
                  Text009,
                  PaymentHeader."No.", DimMgt.GetDimCombErr());
            TableID[1] := DATABASE::"WDC-ED Payment Header";
            No[1] := PaymentHeader."No.";
            if not DimMgt.CheckDimValuePosting(TableID, No, PaymentHeader."Dimension Set ID") then
                ThrowPmtPostError(PaymentLine2, CheckDimVauePostingHeaderErr, DimMgt.GetDimValuePostingErr());
        end;

        if PaymentLine."Line No." <> 0 then begin
            if not DimMgt.CheckDimIDComb(PaymentLine2."Dimension Set ID") then
                Error(
                  Text010,
                  PaymentHeader."No.", PaymentLine2."Line No.", DimMgt.GetDimCombErr());
            TableID[1] := TypeToTableID(PaymentLine2."Account Type".AsInteger());
            No[1] := PaymentLine2."Account No.";
            if not DimMgt.CheckDimValuePosting(TableID, No, PaymentLine2."Dimension Set ID") then
                ThrowPmtPostError(PaymentLine2, CheckDimVauePostingLineErr, DimMgt.GetDimValuePostingErr());
        end;
    end;

    local procedure CheckDim()
    begin
        PaymentLine."Line No." := 0;
        CheckDimCombAndValue(PaymentLine);

        PaymentLine.SetRange("No.", PaymentHeader."No.");
        if PaymentLine.FindSet() then
            repeat
                CheckDimCombAndValue(PaymentLine);
            until PaymentLine.Next() = 0;
    end;

    local procedure TypeToTableID(Type: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset"): Integer
    begin
        case Type of
            Type::"G/L Account":
                exit(DATABASE::"G/L Account");
            Type::Customer:
                exit(DATABASE::Customer);
            Type::Vendor:
                exit(DATABASE::Vendor);
            Type::"Bank Account":
                exit(DATABASE::"Bank Account");
            Type::"Fixed Asset":
                exit(DATABASE::"Fixed Asset");
        end;
    end;

    local procedure ThrowPmtPostError(ReceivedPaymentLine: Record "WDC-ED Payment Line"; ErrorTemplate: Text; ErrorText: Text)
    begin
        if ReceivedPaymentLine."Line No." <> 0 then
            Error(
              ErrorTemplate, PaymentHeader."No.", ReceivedPaymentLine.TableCaption(), ReceivedPaymentLine."Line No.", ErrorText);
        Error(ErrorTemplate, PaymentHeader."No.", ErrorText);
    end;

    procedure TestSourceCode("Code": Code[10])
    var
        SourceCode: Record "Source Code";
    begin
        if not SourceCode.Get(Code) then
            Error(Text017, Code);
    end;

    procedure PaymentAddr(var AddrArray: array[8] of Text[100]; PaymentAddress: Record "WDC-ED Payment Address")
    var
        FormatAddress: Codeunit "Format Address";
    begin
        FormatAddress.FormatAddr(
          AddrArray, PaymentAddress.Name, PaymentAddress."Name 2", PaymentAddress.Contact, PaymentAddress.Address, PaymentAddress."Address 2",
          PaymentAddress.City, PaymentAddress."Post Code", PaymentAddress.County, PaymentAddress."Country/Region Code");
    end;

    procedure PaymentBankAcc(var AddrArray: array[8] of Text[100]; BankAcc: Record "WDC-ED Payment Header")
    var
        FormatAddress: Codeunit "Format Address";
    begin
        FormatAddress.FormatAddr(
          AddrArray, BankAcc."Bank Name", BankAcc."Bank Name 2", BankAcc."Bank Contact", BankAcc."Bank Address", BankAcc."Bank Address 2",
          BankAcc."Bank City", BankAcc."Bank Post Code", BankAcc."Bank County", BankAcc."Bank Country/Region Code");
    end;

    procedure ArchiveDocument(Document: Record "WDC-ED Payment Header")
    var
        ArchiveHeader: Record "WDC-ED Payment Header Archive";
        ArchiveLine: Record "WDC-ED Payment Line Archive";
        PaymentLine: Record "WDC-ED Payment Line";
    begin
        Document.CalcFields("Archiving Authorized");
        if not Document."Archiving Authorized" then
            Error(Text022, Document."No.");
        ArchiveHeader.TransferFields(Document);
        ArchiveHeader.Insert();
        Document.Delete();
        PaymentLine.SetRange("No.", Document."No.");
        if PaymentLine.FINDSET then
            repeat
                ArchiveLine.TransferFields(PaymentLine);
                ArchiveLine.Insert();
                PaymentLine.Delete();
            until PaymentLine.Next() = 0;
    end;

    procedure PickPaymentStep(PaymentHeader: Record "WDC-ED Payment Header"; var PaymentStep: Record "WDC-ED Payment Step"): Boolean
    var
        PaymentSteps: Page "WDC-ED Payment Steps";
    begin
        PaymentStep.FilterGroup(2);
        // Filter on "Action Type" is passed with PaymentStep
        PaymentStep.SetRange("Payment Class", PaymentHeader."Payment Class");
        PaymentStep.SetRange("Previous Status", PaymentHeader."Status No.");
        PaymentStep.FilterGroup(0);
        if PaymentStep.IsEmpty() then
            exit(false);

        if PaymentStep.Count = 1 then begin
            PaymentStep.FindFirst();
            exit(Confirm(PaymentStep.Name, true));
        end;

        PaymentStep.FindSet();
        PaymentSteps.LookupMode(true);
        PaymentSteps.SetTableView(PaymentStep);
        PaymentSteps.SetRecord(PaymentStep);
        PaymentSteps.Editable(false);
        if PaymentSteps.RunModal() = ACTION::LookupOK then begin
            PaymentSteps.GetRecord(PaymentStep);
            exit(true);
        end;
        exit(false);
    end;

    procedure ProcessPaymentSteps(PaymentHeader: Record "WDC-ED Payment Header"; var PaymentStep: Record "WDC-ED Payment Step")
    begin
        PaymentHeader.TestNbOfLines();
        if PickPaymentStep(PaymentHeader, PaymentStep) then
            ProcessPaymentStep(PaymentHeader."No.", PaymentStep);
    end;

    local procedure RunXmlPortExport(XMLPortID: Integer; var PaymentHeader: Record "WDC-ED Payment Header")
    begin
        PaymentClass.GET(PaymentHeader."Payment Class");
        // CASE PaymentClass."SEPA Transfer Type" OF
        //     PaymentClass."SEPA Transfer Type"::"Credit Transfer":
        //         ExportSEPACreditTransfer(XMLPortID, PaymentHeader);
        //     PaymentClass."SEPA Transfer Type"::"Direct Debit":
        //         ExportSEPADirectDebit(PaymentHeader);
        //     ELSE
        XMLPORT.RUN(XMLPortID, FALSE, FALSE, PaymentHeader);
        //END;
    end;

    local procedure DeleteDirectDebitCollection(DirectDebitCollectionNo: Integer)
    var
        DirectDebitCollection: Record "Direct Debit Collection";
    begin
        if DirectDebitCollection.Get(DirectDebitCollectionNo) then
            DirectDebitCollection.Delete(true);
    end;

    local procedure PostInvPostingBuffer(): Integer
    var
        GLEntry: Record "G/L Entry";
    begin
        GenJnlLine.Init;
        GenJnlLine."Posting Date" := PaymentHeader."Posting Date";
        GenJnlLine."Document Date" := PaymentHeader."Document Date";
        GenJnlLine."Payment Slip Type" := PaymentHeader."Payment Slip Type";
        GenJnlLine.Description := InvPostingBuffer[1].Description;
        GenJnlLine."Reason Code" := Step."Reason Code";
        PaymentClass.Get(PaymentHeader."Payment Class");
        GenJnlLine."Delayed Unrealized VAT" :=
          (PaymentClass."Unrealized VAT Reversal" = PaymentClass."Unrealized VAT Reversal"::Delayed);
        GenJnlLine."Realize VAT" := Step."Realize VAT";
        GenJnlLine."Created from No." := InvPostingBuffer[1]."Created from No.";
        GenJnlLine."Document Type" := InvPostingBuffer[1]."Document Type";
        GenJnlLine."Document No." := InvPostingBuffer[1]."Document No.";
        GenJnlLine."Account Type" := InvPostingBuffer[1]."Account Type";
        GenJnlLine."Account No." := InvPostingBuffer[1]."Account No.";
        GenJnlLine."System-Created Entry" := InvPostingBuffer[1]."System-Created Entry";
        GenJnlLine."Currency Code" := InvPostingBuffer[1]."Currency Code";
        GenJnlLine."Currency Factor" := InvPostingBuffer[1]."Currency Factor";
        GenJnlLine.Validate(Amount, InvPostingBuffer[1].Amount);
        GenJnlLine.Correction := InvPostingBuffer[1].Correction;

        if PaymentHeader."Source Code" <> '' then begin
            TestSourceCode(PaymentHeader."Source Code");
            GenJnlLine."Source Code" := PaymentHeader."Source Code";
        end else begin
            Step.TestField("Source Code");
            TestSourceCode(Step."Source Code");
            GenJnlLine."Source Code" := Step."Source Code";
        end;
        GenJnlLine."Applies-to Doc. Type" := InvPostingBuffer[1]."Applies-to Doc. Type";
        GenJnlLine."Applies-to Doc. No." := InvPostingBuffer[1]."Applies-to Doc. No.";
        IF GenJnlLine."Applies-to Doc. No." = '' THEN
            GenJnlLine."Applies-to ID" := InvPostingBuffer[1]."Applies-to ID";

        GenJnlLine."Posting Group" := InvPostingBuffer[1]."Posting Group";
        GenJnlLine."Source Type" := InvPostingBuffer[1]."Source Type";
        GenJnlLine."Source No." := InvPostingBuffer[1]."Source No.";
        GenJnlLine."External Document No." := InvPostingBuffer[1]."External Document No.";
        GenJnlLine."Due Date" := InvPostingBuffer[1]."Due Date";
        GenJnlLine."Shortcut Dimension 1 Code" := InvPostingBuffer[1]."Global Dimension 1 Code";
        GenJnlLine."Shortcut Dimension 2 Code" := InvPostingBuffer[1]."Global Dimension 2 Code";
        GenJnlLine."Dimension Set ID" := InvPostingBuffer[1]."Dimension Set ID";
        GenJnlPostLine.RunWithCheck(GenJnlLine);

        GLEntry.SetRange("Document Type", GenJnlLine."Document Type");
        GLEntry.SetRange("Document No.", GenJnlLine."Document No.");
        if GLEntry.FindLast() then
            exit(GLEntry."Entry No.");
        exit(0);
    end;

    var
        InvPostingBuffer: array[2] of Record "WDC-ED Payment Post. Buffer" temporary;
        CustomerPostingGroup: Record "Customer Posting Group";
        VendorPostingGroup: Record "Vendor Posting Group";
        Customer: Record Customer;
        Vendor: Record Vendor;
        CustLedgerEntry: Record "Cust. Ledger Entry";
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        GenJnlLine: Record "Gen. Journal Line";
        PaymentLine: Record "WDC-ED Payment Line";
        OldPaymentLine: Record "WDC-ED Payment Line";
        StepLedger: Record "WDC-ED Payment Step Ledger";
        Step: Record "WDC-ED Payment Step";
        PaymentHeader: Record "WDC-ED Payment Header";
        PaymentClass: Record "WDC-ED Payment Class";
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        DimMgt: Codeunit DimensionManagement;
        N: Integer;
        Suffix: Text;
        EntryTypeDebit: Enum "Gen. Journal Account Type";
        HeaderAccountUsedGlobally: Boolean;
        EntryNoAccountDebit: Code[20];
        EntryPostGroupDebit: Code[20];
        EntryTypeCredit: Enum "Gen. Journal Account Type";
        EntryNoAccountCredit: Code[20];
        EntryPostGroupCredit: Code[20];
        GLEntryNoTmp: Integer;
        Text001: TextConst ENU = 'Number %1 cannot be extended to more than 20 characters.',
                           FRA = 'Le numéro %1 ne peut pas être étendu à plus de 20 caractères.';
        Text002: TextConst ENU = 'One or more acceptation codes are No.',
                           FRA = 'La valeur d''un ou plusieurs codes acceptation est Non';
        Text003: TextConst ENU = 'One or more lines have an incorrect RIB code.',
                           FRA = 'Une ou plusieurs lignes indiquent un code RIB incorrect';
        Text004: TextConst ENU = 'There is no Payment Header to create.',
                           FRA = 'Il n''y a pas de bordereau à créer.';
        Text005: TextConst ENU = 'Ledger Posting',
                           FRA = 'Validation en comptabilité';
        Text006: TextConst ENU = 'One or more due dates are not specified.',
                           FRA = 'Une ou plusieurs dates d''échéance ne sont pas spécifiées.';
        Text007: TextConst ENU = 'The action has been canceled.',
                           FRA = 'L''action a été annulée.';
        Text008: TextConst ENU = 'The header RIB is not correct.',
                           FRA = 'Le RIB de l''en-tête est incorrect.';
        Text009: TextConst ENU = 'The combination of dimensions used in Payment Header %1 is blocked. %2.',
                           FRA = 'La combinaison d''axes analytiques utilisée dans le bordereau %1 est bloquée. %2.',
                           Comment = '%1 - payment header no, %2 - dimension error';
        Text010: TextConst ENU = 'The combination of dimensions used in Payment Header %1, line no. %2 is blocked. %3.',
                           FRA = 'La combinaison d''axes analytiques utilisée dans le bordereau %1, ligne n° %2, est bloquée. %3.',
                           Comment = '%1 - payment header no, %2 - payment line no, %3 - dimension error';
        Text011: TextConst ENU = 'XX',
                           FRA = 'XX';
        Text012: TextConst ENU = 'Customer Posting Group %1 does not exist.',
                           FRA = 'Le groupe compta. client %1 n''existe pas.';
        Text014: TextConst ENU = 'You must enter a G/L account for customer posting group %1.',
                           FRA = 'Vous devez entrer un compte général pour le groupe compta. client %1.';
        Text016: TextConst ENU = 'A posted line cannot be deleted.',
                           FRA = 'Une ligne validée ne peut pas être supprimée.';
        Text017: TextConst ENU = 'Source Code %1 does not exist.',
                           FRA = 'Le code source %1 n''existe pas.';
        Text018: TextConst ENU = 'You must specify a debit account number for step %1 of payment type %2.',
                           FRA = 'Vous devez spécifier un numéro de compte de débit à l''étape %1 du type de règlement %2.';
        Text019: TextConst ENU = 'You must specify a credit account number for step %1 of payment type %2.',
                           FRA = 'Vous devez spécifier un numéro de compte de crédit à l''étape %1 du type de règlement %2.';
        Text020: TextConst ENU = 'You must specify an account number in the payment header.',
                           FRA = 'Vous devez spécifier un n° de compte dans le bordereau.';
        Text021: TextConst ENU = 'Code %1 does not contain a number.',
                           FRA = 'Le code %1 ne contient pas de nombre.';
        Text022: TextConst ENU = 'The status of document %1 does not authorize archiving.',
                           FRA = 'Le statut du document %1 n''autorise pas l''archivage.';
        CheckDimVauePostingLineErr: TextConst ENU = 'A dimension used in %1 %2 %3 has caused an error. %4',
                                              FRA = 'Un axe analytique utilisé dans %1 %2 %3 a provoqué une erreur. %4',
                                              Comment = '%1=Payment Header No., %2=tablecaption, %3=Payment Line No., %4=Error text';
        CheckDimVauePostingHeaderErr: TextConst ENU = 'A dimension used in %1 has caused an error. %2',
                                                FRA = 'Un axe analytique utilisé dans %1 a provoqué une erreur. %2',
                                                Comment = '%1=Payment Header No., %2=Error text';
        Text100: TextConst ENU = 'Rounding on %1',
                           FRA = 'Arrondi sur %1';
}

