report 50862 "WDC-ED Suggest Vend. Pay. FR"
{
    captionML = ENU = 'Suggest Vendor Payments', FRA = 'Proposer paiements fournisseur';
    Permissions = TableData "Vendor Ledger Entry" = rm;
    ProcessingOnly = true;

    dataset
    {
        dataitem(Vendor; Vendor)
        {
            DataItemTableView = sorting(Blocked) where(Blocked = filter(= " "));
            RequestFilterFields = "No.", "Payment Method Code";

            trigger OnAfterGetRecord()
            begin
                if StopPayments then
                    CurrReport.Break();
                Window.Update(1, "No.");
                GetVendLedgEntries(true, false);
                GetVendLedgEntries(false, false);
                CheckAmounts(false);
            end;

            trigger OnPostDataItem()
            begin
                if UsePriority and not StopPayments then begin
                    Reset;
                    CopyFilters(Vend2);
                    SetCurrentKey(Priority);
                    SetRange(Priority, 0);
                    if FindSet() then
                        repeat
                            Window.Update(1, "No.");
                            GetVendLedgEntries(true, false);
                            GetVendLedgEntries(false, false);
                            CheckAmounts(false);
                        until (Next = 0) or StopPayments;
                end;

                if UsePaymentDisc and not StopPayments then begin
                    Reset;
                    CopyFilters(Vend2);
                    Window.Open(Text007);
                    if FindSet() then
                        repeat
                            Window.Update(1, "No.");
                            PayableVendLedgEntry.SetRange("Vendor No.", "No.");
                            GetVendLedgEntries(true, true);
                            GetVendLedgEntries(false, true);
                            CheckAmounts(true);
                        until (Next = 0) or StopPayments;
                end;

                GenPayLine.LockTable();
                GenPayLine.SetRange("No.", GenPayLine."No.");
                if GenPayLine.FindLast then begin
                    LastLineNo := GenPayLine."Line No.";
                    GenPayLine.Init();
                end;

                Window.Open(Text008);

                PayableVendLedgEntry.Reset();
                PayableVendLedgEntry.SetRange(Priority, 1, 2147483647);
                MakeGenPayLines;
                PayableVendLedgEntry.Reset();
                PayableVendLedgEntry.SetRange(Priority, 0);
                MakeGenPayLines;
                PayableVendLedgEntry.Reset();
                PayableVendLedgEntry.DeleteAll();

                Window.Close;
                ShowMessage(MessageText);
            end;

            trigger OnPreDataItem()
            begin
                if LastDueDateToPayReq = 0D then
                    Error(Text000);
                if PostingDate = 0D then
                    Error(Text001);

                GenPayLineInserted := false;
                MessageText := '';

                if UsePaymentDisc and (LastDueDateToPayReq < WorkDate) then
                    if not
                       Confirm(
                         Text003 +
                         Text004, false,
                         WorkDate)
                    then
                        Error(Text005);

                Vend2.CopyFilters(Vendor);

                OriginalAmtAvailable := AmountAvailable;
                if UsePriority then begin
                    SetCurrentKey(Priority);
                    SetRange(Priority, 1, 2147483647);
                    UsePriority := true;
                end;
                Window.Open(Text006);

                NextEntryNo := 1;
            end;
        }
    }

    requestpage
    {
        SaveValues = false;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    captionML = ENU = 'Options', FRA = 'Options';
                    field(LastPaymentDate; LastDueDateToPayReq)
                    {
                        ApplicationArea = All;
                        captionML = ENU = 'Last Payment Date', FRA = 'Dernière date échéance';
                    }
                    field(UsePaymentDisc; UsePaymentDisc)
                    {
                        ApplicationArea = All;
                        captionML = ENU = 'Find Payment Discounts', FRA = 'Rechercher les escomptes';
                        MultiLine = true;
                    }
                    field(SummarizePer; SummarizePer)
                    {
                        ApplicationArea = All;
                        captionML = ENU = 'Summarize per', FRA = 'Totaliser par';
                        OptioncaptionML = ENU = ' ,Vendor,Due date', FRA = ' ,Fournisseur,Date d''échéance';
                    }
                    field(UsePriority; UsePriority)
                    {
                        ApplicationArea = All;
                        captionML = ENU = 'Use Vendor Priority', FRA = 'Utiliser priorité fournisseur';

                        trigger OnValidate()
                        begin
                            if not UsePriority and (AmountAvailable <> 0) then
                                Error(Text011);
                        end;
                    }
                    field(AvailableAmountLCY; AmountAvailable)
                    {
                        ApplicationArea = All;
                        captionML = ENU = 'Available Amount (LCY)', FRA = 'Montant disponible DS';

                        trigger OnValidate()
                        begin
                            AmountAvailableOnAfterValidate;
                        end;
                    }
                    field(CurrencyFilter; CurrencyFilter)
                    {
                        ApplicationArea = All;
                        captionML = ENU = 'Currency Filter', FRA = 'Filtre devise';
                        Editable = false;
                        TableRelation = Currency;
                    }
                }
            }
        }
    }

    procedure SetGenPayLine(NewGenPayLine: Record "WDC-ED Payment Header")
    begin
        GenPayHead := NewGenPayLine;
        GenPayLine."No." := NewGenPayLine."No.";
        PaymentClass.Get(GenPayHead."Payment Class");
        PostingDate := GenPayHead."Posting Date";
        CurrencyFilter := GenPayHead."Currency Code";
    end;

    procedure GetVendLedgEntries(Positive: Boolean; Future: Boolean)
    begin
        VendLedgEntry.Reset();
        VendLedgEntry.SetCurrentKey("Vendor No.", Open, Positive, "Due Date");
        VendLedgEntry.SetRange("Vendor No.", Vendor."No.");
        VendLedgEntry.SetRange("Document Type", VendLedgEntry."Document Type"::"Invoice", VendLedgEntry."Document Type"::"Credit Memo");//HD01
        VendLedgEntry.SetRange(Open, true);
        VendLedgEntry.SetRange(Positive, Positive);
        VendLedgEntry.SetRange("Currency Code", CurrencyFilter);
        VendLedgEntry.SetRange("Applies-to ID", '');
        if Future then begin
            VendLedgEntry.SetRange("Due Date", LastDueDateToPayReq + 1, 99991231D);
            VendLedgEntry.SetRange("Pmt. Discount Date", PostingDate, LastDueDateToPayReq);
            VendLedgEntry.SetFilter("Original Pmt. Disc. Possible", '<0');
        end else
            VendLedgEntry.SetRange("Due Date", 0D, LastDueDateToPayReq);
        VendLedgEntry.SetRange("On Hold", '');
        if VendLedgEntry.FindSet() then
            repeat
                SaveAmount;
            until VendLedgEntry.Next = 0;
    end;

    local procedure SaveAmount()
    begin
        GenPayLine."Account Type" := GenPayLine."Account Type"::Vendor;
        GenPayLine.Validate("Account No.", VendLedgEntry."Vendor No.");
        GenPayLine."Posting Date" := VendLedgEntry."Posting Date";
        GenPayLine."Currency Factor" := VendLedgEntry."Adjusted Currency Factor";
        if GenPayLine."Currency Factor" = 0 then
            GenPayLine."Currency Factor" := 1;
        GenPayLine.Validate("Currency Code", VendLedgEntry."Currency Code");
        VendLedgEntry.CalcFields("Remaining Amount");
        if ((VendLedgEntry."Document Type" = VendLedgEntry."Document Type"::"Credit Memo") and
            (VendLedgEntry."Remaining Pmt. Disc. Possible" <> 0) or
            (VendLedgEntry."Document Type" = VendLedgEntry."Document Type"::Invoice)) and
           (PostingDate <= VendLedgEntry."Pmt. Discount Date")
        then
            GenPayLine.Amount := -(VendLedgEntry."Remaining Amount" - VendLedgEntry."Original Pmt. Disc. Possible")
        else
            GenPayLine.Amount := -VendLedgEntry."Remaining Amount";
        GenPayLine.Validate(Amount);

        if UsePriority then
            PayableVendLedgEntry.Priority := Vendor.Priority
        else
            PayableVendLedgEntry.Priority := 0;
        PayableVendLedgEntry."Vendor No." := VendLedgEntry."Vendor No.";
        PayableVendLedgEntry."Entry No." := NextEntryNo;
        PayableVendLedgEntry."Vendor Ledg. Entry No." := VendLedgEntry."Entry No.";
        PayableVendLedgEntry.Amount := GenPayLine.Amount;
        PayableVendLedgEntry."Amount (LCY)" := GenPayLine."Amount (LCY)";
        PayableVendLedgEntry.Positive := (PayableVendLedgEntry.Amount > 0);
        PayableVendLedgEntry.Future := (VendLedgEntry."Due Date" > LastDueDateToPayReq);
        PayableVendLedgEntry."Currency Code" := VendLedgEntry."Currency Code";
        PayableVendLedgEntry."Due Date" := VendLedgEntry."Due Date";
        PayableVendLedgEntry.Insert();
        NextEntryNo := NextEntryNo + 1;
    end;

    procedure CheckAmounts(Future: Boolean)
    var
        CurrencyBalance: Decimal;
        PrevCurrency: Code[10];
    begin
        PayableVendLedgEntry.SetRange("Vendor No.", Vendor."No.");
        PayableVendLedgEntry.SetRange(Future, Future);
        if PayableVendLedgEntry.FindSet() then begin
            PrevCurrency := PayableVendLedgEntry."Currency Code";
            repeat
                if PayableVendLedgEntry."Currency Code" <> PrevCurrency then begin
                    if CurrencyBalance < 0 then begin
                        PayableVendLedgEntry.SetRange("Currency Code", PrevCurrency);
                        PayableVendLedgEntry.DeleteAll();
                        PayableVendLedgEntry.SetRange("Currency Code");
                    end else
                        AmountAvailable := AmountAvailable - CurrencyBalance;
                    CurrencyBalance := 0;
                    PrevCurrency := PayableVendLedgEntry."Currency Code";
                end;
                if (OriginalAmtAvailable = 0) or
                   (AmountAvailable >= CurrencyBalance + PayableVendLedgEntry."Amount (LCY)")
                then
                    CurrencyBalance := CurrencyBalance + PayableVendLedgEntry."Amount (LCY)"
                else
                    PayableVendLedgEntry.Delete();
            until PayableVendLedgEntry.Next = 0;
            if CurrencyBalance < 0 then begin
                PayableVendLedgEntry.SetRange("Currency Code", PrevCurrency);
                PayableVendLedgEntry.DeleteAll();
                PayableVendLedgEntry.SetRange("Currency Code");
            end else
                if OriginalAmtAvailable > 0 then
                    AmountAvailable := AmountAvailable - CurrencyBalance;
            if (OriginalAmtAvailable > 0) and (AmountAvailable <= 0) then
                StopPayments := true;
        end;
        PayableVendLedgEntry.Reset();
    end;

    local procedure InsertTempPaymentPostBuffer(var TempPaymentPostBuffer: Record "WDC-ED Payment Post. Buffer" temporary; var VendLedgEntry: Record "Vendor Ledger Entry")
    begin
        TempPaymentPostBuffer."Applies-to Doc. Type" := VendLedgEntry."Document Type";
        TempPaymentPostBuffer."Applies-to Doc. No." := VendLedgEntry."Document No.";
        TempPaymentPostBuffer."Currency Factor" := VendLedgEntry."Adjusted Currency Factor";
        TempPaymentPostBuffer.Amount := PayableVendLedgEntry.Amount;
        TempPaymentPostBuffer."Amount (LCY)" := PayableVendLedgEntry."Amount (LCY)";
        TempPaymentPostBuffer."Global Dimension 1 Code" := VendLedgEntry."Global Dimension 1 Code";
        TempPaymentPostBuffer."Global Dimension 2 Code" := VendLedgEntry."Global Dimension 2 Code";
        TempPaymentPostBuffer."Auxiliary Entry No." := VendLedgEntry."Entry No.";
        TempPaymentPostBuffer.Insert();
    end;

    local procedure MakeGenPayLines()
    var
        GenPayLine3: Record "Gen. Journal Line";
    begin
        TempPaymentPostBuffer.DeleteAll();

        if PayableVendLedgEntry.FindSet() then
            repeat
                PayableVendLedgEntry.SetRange("Vendor No.", PayableVendLedgEntry."Vendor No.");
                PayableVendLedgEntry.FindSet();
                repeat
                    VendLedgEntry.Get(PayableVendLedgEntry."Vendor Ledg. Entry No.");
                    TempPaymentPostBuffer."Account No." := VendLedgEntry."Vendor No.";
                    TempPaymentPostBuffer."Currency Code" := VendLedgEntry."Currency Code";
                    if SummarizePer = SummarizePer::"Due date" then
                        TempPaymentPostBuffer."Due Date" := VendLedgEntry."Due Date";

                    TempPaymentPostBuffer."Dimension Entry No." := 0;
                    TempPaymentPostBuffer."Global Dimension 1 Code" := '';
                    TempPaymentPostBuffer."Global Dimension 2 Code" := '';

                    if SummarizePer in [SummarizePer::Vendor, SummarizePer::"Due date"] then begin
                        TempPaymentPostBuffer."Auxiliary Entry No." := 0;
                        if TempPaymentPostBuffer.Find then begin
                            TempPaymentPostBuffer.Amount := TempPaymentPostBuffer.Amount + PayableVendLedgEntry.Amount;
                            TempPaymentPostBuffer."Amount (LCY)" := TempPaymentPostBuffer."Amount (LCY)" + PayableVendLedgEntry."Amount (LCY)";
                            TempPaymentPostBuffer.Modify();
                        end else begin
                            LastLineNo := LastLineNo + 10000;
                            TempPaymentPostBuffer."Payment Line No." := LastLineNo;
                            if PaymentClass."Line No. Series" = '' then begin
                                NextDocNo := CopyStr(GenPayHead."No." + '/' + Format(LastLineNo), 1, MaxStrLen(NextDocNo));
                                TempPaymentPostBuffer."Applies-to ID" := NextDocNo;
                            end else begin
                                NextDocNo := NoSeriesMgt.GetNextNo(PaymentClass."Line No. Series", PostingDate, false);
                                TempPaymentPostBuffer."Applies-to ID" := GenPayHead."No." + '/' + NextDocNo;
                            end;
                            TempPaymentPostBuffer."Document No." := NextDocNo;
                            NextDocNo := IncStr(NextDocNo);
                            TempPaymentPostBuffer.Amount := PayableVendLedgEntry.Amount;
                            TempPaymentPostBuffer."Amount (LCY)" := PayableVendLedgEntry."Amount (LCY)";
                            Window.Update(1, VendLedgEntry."Vendor No.");
                            TempPaymentPostBuffer.Insert();
                        end;
                        VendLedgEntry."Applies-to ID" := TempPaymentPostBuffer."Applies-to ID";
                        CODEUNIT.Run(CODEUNIT::"Vend. Entry-Edit", VendLedgEntry);
                    end else begin
                        GenPayLine3.Reset();
                        GenPayLine3.SetCurrentKey(
                          "Account Type", "Account No.", "Applies-to Doc. Type", "Applies-to Doc. No.");
                        GenPayLine3.SetRange("Account Type", GenPayLine3."Account Type"::Vendor);
                        GenPayLine3.SetRange("Account No.", VendLedgEntry."Vendor No.");
                        GenPayLine3.SetRange("Applies-to Doc. Type", VendLedgEntry."Document Type");
                        GenPayLine3.SetRange("Applies-to Doc. No.", VendLedgEntry."Document No.");
                        if GenPayLine3.FindFirst then
                            GenPayLine3.FieldError(
                              "Applies-to Doc. No.",
                              StrSubstNo(
                                Text016,
                                VendLedgEntry."Document Type", VendLedgEntry."Document No.",
                                VendLedgEntry."Vendor No."));
                        InsertTempPaymentPostBuffer(TempPaymentPostBuffer, VendLedgEntry);
                        Window.Update(1, VendLedgEntry."Vendor No.");
                    end;
                    VendLedgEntry.CalcFields("Remaining Amount");
                    VendLedgEntry."Amount to Apply" := VendLedgEntry."Remaining Amount";
                    CODEUNIT.Run(CODEUNIT::"Vend. Entry-Edit", VendLedgEntry);
                until PayableVendLedgEntry.Next = 0;
                PayableVendLedgEntry.SetFilter("Vendor No.", '>%1', PayableVendLedgEntry."Vendor No.");
            until not PayableVendLedgEntry.FindFirst;

        Clear(OldTempPaymentPostBuffer);
        TempPaymentPostBuffer.SetCurrentKey("Document No.");
        if TempPaymentPostBuffer.FindSet() then
            repeat
                GenPayLine.Init;
                Window.Update(1, TempPaymentPostBuffer."Account No.");
                if SummarizePer = SummarizePer::" " then begin
                    LastLineNo := LastLineNo + 10000;
                    GenPayLine."Line No." := LastLineNo;
                    if PaymentClass."Line No. Series" = '' then begin
                        NextDocNo := CopyStr(GenPayHead."No." + '/' + Format(GenPayLine."Line No."), 1, MaxStrLen(NextDocNo));
                        GenPayLine."Applies-to ID" := NextDocNo;
                    end else begin
                        NextDocNo := NoSeriesMgt.GetNextNo(PaymentClass."Line No. Series", PostingDate, false);
                        GenPayLine."Applies-to ID" := GenPayHead."No." + '/' + NextDocNo;
                    end;
                end else begin
                    GenPayLine."Line No." := TempPaymentPostBuffer."Payment Line No.";
                    NextDocNo := TempPaymentPostBuffer."Document No.";
                    GenPayLine."Applies-to ID" := TempPaymentPostBuffer."Applies-to ID";
                end;
                GenPayLine."Document No." := NextDocNo;
                OldTempPaymentPostBuffer := TempPaymentPostBuffer;
                OldTempPaymentPostBuffer."Document No." := GenPayLine."Document No.";
                if SummarizePer = SummarizePer::" " then begin
                    VendLedgEntry.Get(TempPaymentPostBuffer."Auxiliary Entry No.");
                    VendLedgEntry."Applies-to ID" := GenPayLine."Applies-to ID";
                    VendLedgEntry.Modify();
                end;
                GenPayLine."Account Type" := GenPayLine."Account Type"::Vendor;
                GenPayLine.Validate("Account No.", TempPaymentPostBuffer."Account No.");
                GenPayLine."Currency Code" := TempPaymentPostBuffer."Currency Code";
                GenPayLine."Currency Factor" := GenPayHead."Currency Factor";
                if GenPayLine."Currency Factor" = 0 then
                    GenPayLine."Currency Factor" := 1;
                GenPayLine.Validate(Amount, TempPaymentPostBuffer.Amount);
                Vend2.Get(GenPayLine."Account No.");
                GenPayLine.Validate("Bank Account Code", Vend2."Preferred Bank Account Code");
                GenPayLine."Payment Class" := GenPayHead."Payment Class";
                GenPayLine.Validate("Status No.");
                GenPayLine."Posting Date" := PostingDate;
                if SummarizePer = SummarizePer::" " then begin
                    GenPayLine."Applies-to Doc. Type" := VendLedgEntry."Document Type";
                    GenPayLine."Applies-to Doc. No." := VendLedgEntry."Document No.";
                    GenPayLine."Dimension Set ID" := VendLedgEntry."Dimension Set ID";
                end;
                case SummarizePer of
                    SummarizePer::" ":
                        GenPayLine."Due Date" := VendLedgEntry."Due Date";
                    SummarizePer::Vendor:
                        begin
                            PayableVendLedgEntry.SetCurrentKey("Vendor No.", "Due Date");
                            PayableVendLedgEntry.SetRange("Vendor No.", TempPaymentPostBuffer."Account No.");
                            PayableVendLedgEntry.FindSet();
                            GenPayLine."Due Date" := PayableVendLedgEntry."Due Date";
                            PayableVendLedgEntry.DeleteAll();
                        end;
                    SummarizePer::"Due date":
                        GenPayLine."Due Date" := TempPaymentPostBuffer."Due Date";
                end;
                if GenPayLine.Amount <> 0 then begin
                    if GenPayLine."Dimension Set ID" = 0 then // per "Customer", per "Due Date"
                        GenPayLine.DimensionSetup;
                    GenPayLine.Insert;
                end;
                GenPayLineInserted := true;
            until TempPaymentPostBuffer.Next = 0;
    end;

    local procedure ShowMessage(Text: Text)
    begin
        if (Text <> '') and GenPayLineInserted then
            Message(Text);
    end;

    local procedure AmountAvailableOnAfterValidate()
    begin
        if AmountAvailable <> 0 then
            UsePriority := true;
    end;

    var
        Text000: TextConst ENU = 'Please enter the last payment date.',
                           FRA = 'Veuillez entrer la dernière date d''échéance.';
        Text001: TextConst ENU = 'Please enter the posting date.',
                           FRA = 'Veuillez entrer une date de comptabilisation.';
        Text003: TextConst ENU = 'The selected last due date is earlier than %1.\\',
                           FRA = 'La date de dernière échéance sélectionnée est antérieure au %1.\\';
        Text004: TextConst ENU = 'Do you still want to run the batch job?',
                           FRA = 'Souhaitez-vous tout de même exécuter ce traitement par lots ?';
        Text005: TextConst ENU = 'The batch job was interrupted.',
                           FRA = 'Le traitement par lots a été interrompu.';
        Text006: TextConst ENU = 'Processing vendors     #1##########',
                           FRA = 'Traitement des fournisseurs             #1##########';
        Text007: TextConst ENU = 'Processing vendors for payment discounts #1##########',
                           FRA = 'Traitement des escomptes fournisseur    #1##########';
        Text008: TextConst ENU = 'Inserting payment journal lines #1##########',
                           FRA = 'Insertion des lignes f. paiement        #1##########';
        Text011: TextConst ENU = 'Use Vendor Priority must be activated when the value in the Amount Available field is not 0.',
                           FRA = 'Le champ Utiliser priorité fournisseur doit être activé lorsque la valeur du champ Montant disponible est différente de 0.';
        Text016: TextConst ENU = ' is already applied to %1 %2 for vendor %3.',
                           FRA = ' est déjà lettré(e) avec %1 %2 pour le fournisseur %3.';
        Vend2: Record Vendor;
        GenPayHead: Record "WDC-ED Payment Header";
        GenPayLine: Record "WDC-ED Payment Line";
        VendLedgEntry: Record "Vendor Ledger Entry";
        PayableVendLedgEntry: Record "Payable Vendor Ledger Entry" temporary;
        TempPaymentPostBuffer: Record "WDC-ED Payment Post. Buffer" temporary;
        OldTempPaymentPostBuffer: Record "WDC-ED Payment Post. Buffer" temporary;
        PaymentClass: Record "WDC-ED Payment Class";
        NoSeriesMgt: Codeunit "No. Series";
        Window: Dialog;
        UsePaymentDisc: Boolean;
        PostingDate: Date;
        LastDueDateToPayReq: Date;
        NextDocNo: Code[20];
        AmountAvailable: Decimal;
        OriginalAmtAvailable: Decimal;
        UsePriority: Boolean;
        SummarizePer: Option " ",Vendor,"Due date";
        LastLineNo: Integer;
        NextEntryNo: Integer;
        StopPayments: Boolean;
        MessageText: Text;
        GenPayLineInserted: Boolean;
        CurrencyFilter: Code[10];
}

