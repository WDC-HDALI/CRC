codeunit 54003 "WDC-ST PaymentHook"
{
    procedure PrintLine(PaymentHeader: Record "WDC-ED Payment Header"; ActionType: Integer)
    var
        PaymentStep: Record "WDC-ED Payment Step";
        Options: Text[1024];
        I: Integer;
        OptionList: Integer;
        OK: Boolean;
    begin
        PaymentStep.SETRANGE("Payment Class", PaymentHeader."Payment Class");
        PaymentStep.SETRANGE("Previous Status", PaymentHeader."Status No.");
        PaymentStep.SETRANGE("Action Type", ActionType);
        I := PaymentStep.COUNT;
        OK := FALSE;
        IF I = 1 THEN BEGIN
            PaymentStep.FindFirst;
            OK := CONFIRM(PaymentStep.Name, TRUE);
        END ELSE
            IF I > 1 THEN BEGIN
                IF PaymentStep.FindFirst() THEN BEGIN
                    REPEAT
                        IF Options = '' THEN
                            Options := PaymentStep.Name
                        ELSE
                            Options := Options + ',' + PaymentStep.Name;
                    UNTIL PaymentStep.NEXT = 0;
                    OptionList := STRMENU(Options, 1);
                    I := 1;
                    IF OptionList > 0 THEN BEGIN
                        OK := TRUE;
                        PaymentStep.FindFirst;
                        WHILE OptionList > I DO BEGIN
                            I := I + 1;
                            PaymentStep.NEXT;
                        END;
                    END;
                END;
            END;
        IF OK THEN
            Valbord(PaymentHeader, PaymentStep);
    end;

    local procedure Actualiserstat(var Rec: Record "WDC-ED Payment Header")
    var
        RecTmp: Record "WDC-ED Payment Line";
        PayClass: Record "WDC-ED Payment Status";
    begin
        CLEAR(PayClass);
        IF PayClass.GET(Rec."Payment Class", Rec."Status No.") AND ((PayClass."Calculate RS") OR
          (PayClass."Calc. RS On VAT") OR (PayClass."VAT On Commission") OR (PayClass.Commission) OR
          (PayClass."Calc. RS On Guarrantee")) THEN BEGIN
            CLEAR(RecTmp);
            RecTmp.RESET;
            RecTmp.SETFILTER("Payment Class", Rec."Payment Class");
            RecTmp.SETFILTER("Status No.", '%1', Rec."Status No.");
            RecTmp.SETFILTER("No.", Rec."No.");
            IF RecTmp.FindFirst THEN BEGIN
                REPEAT
                    RecTmp.CalcRetenu;
                    RecTmp.CalcAmount;
                    RecTmp.MODIFY;
                UNTIL RecTmp.NEXT = 0;
                COMMIT;
            END;
        END;
    end;

    local procedure BloquerClient(RecPayLine: Record "WDC-ED Payment Line")
    var
        Rec18: Record Customer;
        Rec10861: Record "WDC-ED Payment Status";
    begin
        Rec10861.RESET;
        Rec10861.SETRANGE("Payment Class", RecPayLine."Payment Class");
        Rec10861.SETRANGE(Rec10861."Line No.", RecPayLine."Status No.");
        IF Rec10861.FindFirst THEN
            IF Rec10861."Block Customer" THEN
                IF Rec18.GET(RecPayLine."Account No.") THEN BEGIN
                    Rec18.Blocked := Rec18.Blocked::All;
                    Rec18.MODIFY;
                END;
    end;

    local procedure geninv2()
    begin
        InvPostingBuffer[1].Correction := PaymentLine.Correction XOR Step.Correction;
        IF (StepLedger."Detail Level" = StepLedger."Detail Level"::Line) THEN
            InvPostingBuffer[1]."Payment Line No." := PaymentLine."Line No."
        ELSE
            IF (StepLedger."Detail Level" = StepLedger."Detail Level"::"Due Date") THEN
                InvPostingBuffer[1]."Due Date" := PaymentLine."Due Date";
        InvPostingBuffer[1]."Document Type" := StepLedger."Document Type";
        IF StepLedger."Document No." = StepLedger."Document No."::"Header No." THEN
            InvPostingBuffer[1]."Document No." := PaymentHeader."No."
        ELSE BEGIN
            IF (InvPostingBuffer[1].Sign = InvPostingBuffer[1].Sign::Positive) AND
               (PaymentLine."Entry No. Debit" = 0) AND (PaymentLine."Entry No. Credit" = 0) THEN BEGIN
                PaymentClass.GET(PaymentHeader."Payment Class");
                IF PaymentClass."Line No. Series" = '' THEN
                    PaymentLine.TESTFIELD("Document No.", NoSeriesMgt.GetNextNo(PaymentHeader."No. Series", PaymentLine."Posting Date", FALSE))
            END;
            InvPostingBuffer[1]."Document No." := PaymentLine."Document No.";
        END;
        InvPostingBuffer[1]."Header Document No." := PaymentHeader."No.";
        IF StepLedger.Sign = StepLedger.Sign::Debit THEN BEGIN
            EntryTypeDebit := InvPostingBuffer[1]."Account Type";
            EntryNoAccountDebit := InvPostingBuffer[1]."Account No.";
            EntryPostGroupDebit := InvPostingBuffer[1]."Posting Group";
        END ELSE BEGIN
            EntryTypeCredit := InvPostingBuffer[1]."Account Type";
            EntryNoAccountCredit := InvPostingBuffer[1]."Account No.";
            EntryPostGroupCredit := InvPostingBuffer[1]."Posting Group";
        END;
        InvPostingBuffer[1]."System-Created Entry" := TRUE;
        Application;
        InvPostingBuffer[1]."Source Type" := PaymentLine."Account Type";
        InvPostingBuffer[1]."Source No." := PaymentLine."Account No.";
        InvPostingBuffer[1]."External Document No." := PaymentLine."External Document No.";
        InvPostingBuffer[1]."Global Dimension 1 Code" := PaymentHeader."Shortcut Dimension 1 Code";
        InvPostingBuffer[1]."Global Dimension 2 Code" := PaymentHeader."Shortcut Dimension 2 Code";
        UpdtBuffer;
    end;

    procedure Application()
    begin
        IF StepLedger.Application <> StepLedger.Application::None THEN BEGIN
            IF StepLedger.Application = StepLedger.Application::"Applied Entry" THEN BEGIN
                InvPostingBuffer[1]."Applies-to Doc. Type" := PaymentLine."Applies-to Doc. Type";
                InvPostingBuffer[1]."Applies-to Doc. No." := PaymentLine."Applies-to Doc. No.";
                InvPostingBuffer[1]."Applies-to ID" := PaymentLine."Applies-to ID";
            END ELSE
                IF StepLedger.Application = StepLedger.Application::"Entry Previous Step" THEN BEGIN
                    InvPostingBuffer[1]."Applies-to ID" := PaymentLine."No." + '/' + FORMAT(PaymentLine."Line No.") + Text011;
                    IF InvPostingBuffer[1]."Account Type" = InvPostingBuffer[1]."Account Type"::Customer THEN BEGIN
                        IF (InvPostingBuffer[1].Amount < 0) XOR InvPostingBuffer[1].Correction THEN
                            CustLedgerEntry.SETRANGE("Entry No.", OldPaymentLine."Entry No. Debit")
                        ELSE
                            CustLedgerEntry.SETRANGE("Entry No.", OldPaymentLine."Entry No. Credit");
                        IF CustLedgerEntry.FINDFIRST THEN BEGIN
                            CustLedgerEntry."Applies-to ID" := InvPostingBuffer[1]."Applies-to ID";
                            CustLedgerEntry.CALCFIELDS("Remaining Amount");
                            CustLedgerEntry.VALIDATE("Amount to Apply", CustLedgerEntry."Remaining Amount");
                            CustLedgerEntry.MODIFY;
                        END;
                    END ELSE
                        IF InvPostingBuffer[1]."Account Type" = InvPostingBuffer[1]."Account Type"::Vendor THEN BEGIN
                            IF (InvPostingBuffer[1].Amount < 0) XOR InvPostingBuffer[1].Correction THEN
                                VendorLedgerEntry.SETRANGE("Entry No.", OldPaymentLine."Entry No. Debit")
                            ELSE
                                VendorLedgerEntry.SETRANGE("Entry No.", OldPaymentLine."Entry No. Credit");
                            IF VendorLedgerEntry.FINDFIRST THEN BEGIN
                                VendorLedgerEntry."Applies-to ID" := InvPostingBuffer[1]."Applies-to ID";
                                VendorLedgerEntry.CALCFIELDS("Remaining Amount");
                                VendorLedgerEntry.VALIDATE("Amount to Apply", VendorLedgerEntry."Remaining Amount");
                                VendorLedgerEntry.MODIFY;
                            END;
                        END;
                END ELSE
                    IF StepLedger.Application = StepLedger.Application::"Memorized Entry" THEN BEGIN
                        InvPostingBuffer[1]."Applies-to ID" := PaymentLine."No." + '/' + FORMAT(PaymentLine."Line No.") + Text011;
                        IF InvPostingBuffer[1]."Account Type" = InvPostingBuffer[1]."Account Type"::Customer THEN BEGIN
                            CustLedgerEntry.RESET;
                            IF (InvPostingBuffer[1].Amount < 0) XOR InvPostingBuffer[1].Correction THEN
                                CustLedgerEntry.SETRANGE("Entry No.", OldPaymentLine."Entry No. Debit Memo")
                            ELSE
                                CustLedgerEntry.SETRANGE("Entry No.", OldPaymentLine."Entry No. Credit Memo");
                            IF CustLedgerEntry.FINDFIRST THEN BEGIN
                                CustLedgerEntry."Applies-to ID" := InvPostingBuffer[1]."Applies-to ID";
                                CustLedgerEntry.CALCFIELDS("Remaining Amount");
                                CustLedgerEntry.VALIDATE("Amount to Apply", CustLedgerEntry."Remaining Amount");
                                CustLedgerEntry.MODIFY;
                            END;
                        END ELSE
                            IF InvPostingBuffer[1]."Account Type" = InvPostingBuffer[1]."Account Type"::Vendor THEN BEGIN
                                IF (InvPostingBuffer[1].Amount < 0) XOR InvPostingBuffer[1].Correction THEN
                                    VendorLedgerEntry.SETRANGE("Entry No.", OldPaymentLine."Entry No. Debit Memo")
                                ELSE
                                    VendorLedgerEntry.SETRANGE("Entry No.", OldPaymentLine."Entry No. Credit Memo");

                                IF VendorLedgerEntry.FINDFIRST THEN BEGIN
                                    VendorLedgerEntry."Applies-to ID" := InvPostingBuffer[1]."Applies-to ID";
                                    VendorLedgerEntry.CALCFIELDS("Remaining Amount");
                                    VendorLedgerEntry.VALIDATE("Amount to Apply", VendorLedgerEntry."Remaining Amount");
                                    VendorLedgerEntry.MODIFY;
                                END;
                            END;
                    END;
        END;
        IF StepLedger."Detail Level" = StepLedger."Detail Level"::Account THEN BEGIN
            IF (InvPostingBuffer[1]."Account Type" = InvPostingBuffer[1]."Account Type"::Vendor) OR
               (InvPostingBuffer[1]."Account Type" = InvPostingBuffer[1]."Account Type"::Customer)
            THEN
                InvPostingBuffer[1]."Due Date" := PaymentLine."Due Date"
        END ELSE
            InvPostingBuffer[1]."Due Date" := PaymentLine."Due Date";
        InvPostingBuffer[1]."Due Date" := PaymentLine."Due Date";
        IF (StepLedger."Detail Level" = StepLedger."Detail Level"::Account) AND
          (StepLedger."Accounting Type" = StepLedger."Accounting Type"::"Header Payment Account") THEN
            InvPostingBuffer[1]."Due Date" := PaymentLine."Posting Date";
    end;

    procedure UpdtBuffer()
    var
        CurrExchRate: Record 330;
    begin
        InvPostingBuffer[2] := InvPostingBuffer[1];
        IF InvPostingBuffer[2].FIND THEN BEGIN
            InvPostingBuffer[2].VALIDATE(Amount, InvPostingBuffer[2].Amount + InvPostingBuffer[1].Amount);
            InvPostingBuffer[2]."Amount (LCY)" := ROUND(CurrExchRate.ExchangeAmtFCYToLCY(PaymentHeader."Posting Date",
                  PaymentHeader."Currency Code", InvPostingBuffer[2].Amount, PaymentHeader."Currency Factor"));
            InvPostingBuffer[2]."VAT Amount" :=
              InvPostingBuffer[2]."VAT Amount" + InvPostingBuffer[1]."VAT Amount";
            InvPostingBuffer[2]."Line Discount Amount" :=
              InvPostingBuffer[2]."Line Discount Amount" + InvPostingBuffer[1]."Line Discount Amount";
            IF InvPostingBuffer[1]."Line Discount Account" <> '' THEN
                InvPostingBuffer[2]."Line Discount Account" := InvPostingBuffer[1]."Line Discount Account";
            InvPostingBuffer[2]."Inv. Discount Amount" :=
              InvPostingBuffer[2]."Inv. Discount Amount" + InvPostingBuffer[1]."Inv. Discount Amount";
            IF InvPostingBuffer[1]."Inv. Discount Account" <> '' THEN
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
            IF NOT InvPostingBuffer[1]."System-Created Entry" THEN
                InvPostingBuffer[2]."System-Created Entry" := FALSE;
            InvPostingBuffer[2].MODIFY;
        END ELSE BEGIN
            GLEntryNoTmp += 1;
            InvPostingBuffer[1]."GL Entry No." := GLEntryNoTmp;
            IF (PaymentLine."RS Code" <> '') THEN BEGIN
                RecG_GroupeRetenue.RESET;
                RecG_GroupeRetenue.SETRANGE("Type Retenue", GroupeRetenu."Type Retenue"::"à la source");
                RecG_GroupeRetenue.SETRANGE("Retention Account No.", InvPostingBuffer[1]."Account No.");
                RecG_GroupeRetenue.SETRANGE(RecG_GroupeRetenue.Active, TRUE);
                IF RecG_GroupeRetenue.FINDFIRST THEN
                    InvPostingBuffer[1]."RS Code" := PaymentLine."RS Code";
            END;
            InvPostingBuffer[1].INSERT;
        END;
    end;

    local procedure GenererInv()
    var
        PaymentClass: Record "WDC-ED Payment Class";
        StepLedgerTmp: Record "WDC-ED Payment Step Ledger";
        GroupeRetenu: Record "WDC-ST Retained Group";
    begin
        IF (StepLedger."Posting RS") THEN BEGIN
            CLEAR(GroupeRetenu);
            GroupeRetenu.RESET;
            InvPostingBuffer[1].INIT;
            InvPostingBuffer[1]."System-Created Entry" := TRUE;
            IF GroupeRetenu.GET(0, PaymentLine."RS Code") THEN;
            InvPostingBuffer[1]."Account Type" := InvPostingBuffer[1]."Account Type"::"G/L Account";
            InvPostingBuffer[1].VALIDATE("Account No.", GroupeRetenu."Retention Account No.");
            InvPostingBuffer[1]."Currency Code" := PaymentLine."Currency Code";
            InvPostingBuffer[1]."Currency Factor" := PaymentLine."Currency Factor";

            InvPostingBuffer[1].VALIDATE(Amount, PaymentLine."RS Amount");
            InvPostingBuffer[1].VALIDATE("Amount (LCY)", PaymentLine."RS Amount LCY");
            //<<HD150525
            IF PaymentLine."Account Type" = PaymentLine."Account Type"::Customer then BEGIN
                InvPostingBuffer[1].VALIDATE(Amount, ABS(PaymentLine."RS Amount")); //HD150525
                InvPostingBuffer[1].VALIDATE("Amount (LCY)", ABS(PaymentLine."RS Amount LCY"));
            END;
            //>>HD150525
            InvPostingBuffer[1]."Applies-to ID" := '';
            IF InvPostingBuffer[1].Amount <> 0 THEN
                geninv2;
        END;
        IF StepLedger."Cancel Posting RS" THEN BEGIN
            CLEAR(GroupeRetenu);
            GroupeRetenu.RESET;
            InvPostingBuffer[1].INIT;
            InvPostingBuffer[1]."System-Created Entry" := TRUE;
            IF GroupeRetenu.GET(0, PaymentLine."RS Code") THEN;
            InvPostingBuffer[1]."Account Type" := InvPostingBuffer[1]."Account Type"::"G/L Account";
            InvPostingBuffer[1]."Currency Code" := PaymentLine."Currency Code";
            InvPostingBuffer[1]."Currency Factor" := PaymentLine."Currency Factor";
            InvPostingBuffer[1].VALIDATE("Account No.", GroupeRetenu."Retention Account No.");
            InvPostingBuffer[1].VALIDATE(Amount, -PaymentLine."Validated RS Amount");
            InvPostingBuffer[1].VALIDATE("Amount (LCY)", -PaymentLine."Validated RS Amount LCY");
            InvPostingBuffer[1]."Applies-to ID" := '';
            IF InvPostingBuffer[1].Amount <> 0 THEN
                geninv2;
        END;
        IF StepLedger."RS On Guarantee" THEN BEGIN
            CLEAR(GroupeRetenu);
            GroupeRetenu.RESET;
            InvPostingBuffer[1].INIT;
            InvPostingBuffer[1]."System-Created Entry" := TRUE;
            IF GroupeRetenu.GET(1, PaymentLine."Guarantee RS Code") THEN;
            InvPostingBuffer[1]."Account Type" := InvPostingBuffer[1]."Account Type"::"G/L Account";
            InvPostingBuffer[1].VALIDATE("Account No.", GroupeRetenu."Retention Account No.");
            InvPostingBuffer[1]."Currency Code" := PaymentLine."Currency Code";
            InvPostingBuffer[1]."Currency Factor" := PaymentLine."Currency Factor";
            InvPostingBuffer[1].VALIDATE(Amount, PaymentLine."Guarantee RS Amount");
            InvPostingBuffer[1].VALIDATE("Amount (LCY)", PaymentLine."Guarantee RS Amount LCY");
            IF InvPostingBuffer[1].Amount <> 0 THEN
                geninv2;
        END;

        IF StepLedger."Posting RS On VAT" THEN BEGIN
            InvPostingBuffer[1].INIT;
            InvPostingBuffer[1]."Account Type" := InvPostingBuffer[1]."Account Type"::"G/L Account";
            InvPostingBuffer[1]."System-Created Entry" := TRUE;
            InvPostingBuffer[1].VALIDATE("Account No.", StepLedger."Compte Retenue Sur TVA");
            InvPostingBuffer[1]."Currency Code" := PaymentLine."Currency Code";
            InvPostingBuffer[1]."Currency Factor" := PaymentLine."Currency Factor";
            InvPostingBuffer[1].VALIDATE(Amount, PaymentLine."RS VAT Amount");
            InvPostingBuffer[1].VALIDATE("Amount (LCY)", PaymentLine."RS VAT Amount LCY");
            InvPostingBuffer[1]."Applies-to ID" := '';
            "G/LAccount2".RESET;
            "G/LAccount2".SETRANGE("G/LAccount2"."No.", StepLedger."Compte Retenue Sur TVA");
            IF "G/LAccount2".FindFirst THEN
                InvPostingBuffer[1].Description := "G/LAccount2".Name;
            IF InvPostingBuffer[1].Amount <> 0 THEN
                geninv2;

        END;
        IF (StepLedger."Include Commission") AND (StepLedger."Commission Account No." <> '') THEN BEGIN
            InvPostingBuffer[1].INIT;
            InvPostingBuffer[1]."Account Type" := InvPostingBuffer[1]."Account Type"::"G/L Account";
            InvPostingBuffer[1]."System-Created Entry" := TRUE;
            InvPostingBuffer[1].VALIDATE("Account No.", StepLedger."Commission Account No.");
            CLEAR(InvPostingBuffer[1]."Currency Code");
            InvPostingBuffer[1]."Currency Factor" := 1;
            InvPostingBuffer[1].VALIDATE(Amount, PaymentLine."Commission Amount");
            InvPostingBuffer[1].VALIDATE("Amount (LCY)", PaymentLine."Commission Amount LCY");
            InvPostingBuffer[1]."Applies-to ID" := '';
            "G/LAccount2".RESET;
            "G/LAccount2".SETRANGE("G/LAccount2"."No.", StepLedger."Commission Account No.");
            IF "G/LAccount2".FindFirst THEN
                InvPostingBuffer[1].Description := "G/LAccount2".Name;
            IF InvPostingBuffer[1].Amount <> 0 THEN
                geninv2;
        END;
        IF (StepLedger."Include Commission") AND (StepLedger."Commission VAT Account No." <> '') THEN BEGIN
            InvPostingBuffer[1].INIT;
            InvPostingBuffer[1]."Account Type" := InvPostingBuffer[1]."Account Type"::"G/L Account";
            InvPostingBuffer[1]."System-Created Entry" := TRUE;
            InvPostingBuffer[1].VALIDATE("Account No.", StepLedger."Commission VAT Account No.");
            CLEAR(InvPostingBuffer[1]."Currency Code");
            InvPostingBuffer[1]."Currency Factor" := 1;
            InvPostingBuffer[1].VALIDATE(Amount, PaymentLine."Commission VAT Amount");
            InvPostingBuffer[1].VALIDATE("Amount (LCY)", PaymentLine."Commission VAT Amount LCY");
            InvPostingBuffer[1]."Applies-to ID" := '';
            "G/LAccount2".RESET;
            "G/LAccount2".SETRANGE("G/LAccount2"."No.", StepLedger."Commission VAT Account No.");
            IF "G/LAccount2".FindFirst THEN
                InvPostingBuffer[1].Description := "G/LAccount2".Name;
            IF InvPostingBuffer[1].Amount <> 0 THEN
                geninv2;
        END;
    end;

    procedure Valbord(PaymentHeaderParameter: Record 50865; StepParameter: Record 50862)
    var
        Window: Dialog;
        PaymentHeader2: Record 50865;
        ActionValidated: Boolean;
        StepParametres_lr: Record 50862;
        PaymentStatus_gr: Record 50861;
        PaymentHeader_lr: Record 50865;
        Ltext001: Label 'Veillez vérifier le n° Chèque';
        Ltext002: Label 'Veillez vérifier le n° Traite';
        PaymentLine2: Record "WDC-ED Payment Line";
        usersetup: record "User Setup";
        // Authorization: record "WDC-ST Permission Step";
        Text024: Label 'Vous n''êtes pas autorisé à valider cet étape';
        Text025: Label 'Aucun paramétrage utilisateur n''a été trouvé, veuilelz contacter votre administrateur';
    begin
        PaymentHeader.GET(PaymentHeaderParameter."No.");
        Actualiserstat(PaymentHeader);
        IF UserSetup.GET(UPPERCASE(USERID)) THEN BEGIN
            //     IF NOT Authorization.GET(StepParameter."Line No.", StepParameter."Payment Class", UserSetup."Payment Slip Profil") THEN
            //         ERROR(Text024);
            // END ELSE
            //     ERROR(Text025);
            IF StepParameter."Verify Header RIB" AND NOT PaymentHeader."RIB Checked" THEN
                ERROR(Text008);
            PaymentLine.SETRANGE("No.", PaymentHeader."No.");
            PaymentLine.SETRANGE("Copied To No.", '');
            IF StepParameter."Acceptation Code<>No" THEN BEGIN
                PaymentLine.SETRANGE("Acceptation Code", PaymentLine."Acceptation Code"::No);
                IF PaymentLine.FindFirst THEN
                    ERROR(Text002);
                PaymentLine.SETRANGE("Acceptation Code");
            END;
            IF StepParameter."Verify Lines RIB" THEN BEGIN
                PaymentLine.SETRANGE("RIB Checked", FALSE);
                IF PaymentLine.FindFirst THEN
                    ERROR(Text003);
                PaymentLine.SETRANGE("RIB Checked");
            END;
            IF StepParameter."Verify Due Date" THEN BEGIN
                PaymentLine.SETRANGE("Due Date", 0D);
                IF PaymentLine.FindFirst THEN
                    ERROR(Text006);
                PaymentLine.SETRANGE("Due Date");
            END;
            IF StepParameter."Mandatory Header Bank" THEN
                PaymentHeader.TESTFIELD(PaymentHeader."Account No.");

            PaymentLine.SETFILTER("No.", '%1', PaymentHeader."No.");
            IF PaymentLine.FINDFIRST THEN
                REPEAT
                    IF StepParameter."Mandatory Reason Code" THEN
                        PaymentLine.TESTFIELD(PaymentLine."Reason Code");
                UNTIL PaymentLine.NEXT = 0;
            PaymentLine.SETFILTER(PaymentLine."Payment Class", '%1', PaymentHeader."Payment Class");
            PaymentLine.SETFILTER("No.", '%1', PaymentHeader."No.");
            IF PaymentLine.FINDSET THEN
                REPEAT
                    IF PaymentLine."Payment Class" <> 'TRS-ESP' THEN BEGIN
                        PaymentLine.TESTFIELD(Amount);
                        PaymentLine.TESTFIELD("Account No.");
                    END
                    ELSE
                        PaymentLine.TESTFIELD(Amount);
                    IF StepParameter."Mandatory Ext. Doc No." THEN
                        PaymentLine.TESTFIELD("External Document No.");

                    IF PaymentLine."External Document No." <> '' then begin
                        PaymentClass.GET(PaymentHeader."Payment Class");
                        If (PaymentClass."Payment Methode Type" = PaymentClass."Payment Methode Type"::Cheque) and
                        (StrLen(PaymentLine."External Document No.") <> 7) then
                            Error(Ltext001)
                        else
                            If (PaymentClass."Payment Methode Type" = PaymentClass."Payment Methode Type"::Draft) and
                                (StrLen(PaymentLine."External Document No.") <> 12) then
                                Error(Ltext002);
                    end;
                    IF StepParameter."Mandatory Bank Line" THEN
                        PaymentLine.TESTFIELD("Bank Account Code");
                    IF StepParameter."Mandatory Drawer" THEN
                        PaymentLine.TESTFIELD("Drawer/Beneficiary");
                    IF StepParameter."Mandatory Draw" THEN
                        PaymentLine.TESTFIELD(Draw)
                UNTIL PaymentLine.NEXT = 0;
            Step.GET(StepParameter."Payment Class", StepParameter."Line No.");
            Step1.GET(StepParameter."Payment Class", StepParameter."Line No.");
            IF PaymentLine.FindFirst THEN
                REPEAT
                    PaymentClass.GET(PaymentHeader."Payment Class");
                    IF (PaymentLine."Status No." = 0) AND (StepParameter."Next Status" <> StepParameter."Previous Status") THEN BEGIN
                        IF PaymentLine."Document No." = '' THEN
                            PaymentLine."Document No." := NoSeriesMgt.GetNextNo(PaymentClass."Line No. Series", PaymentHeader."Posting Date", TRUE);
                        PaymentLine.MODIFY;
                        COMMIT;
                    END;
                UNTIL PaymentLine.NEXT = 0;
            CASE Step."Action Type" OF
                Step."Action Type"::None:
                    ActionValidated := TRUE;
                Step."Action Type"::File:
                    BEGIN
                        PaymentHeader2.SETRANGE("No.", PaymentHeader."No.");
                        PaymentHeader."File Export Completed" := FALSE;
                        PaymentHeader.MODIFY;
                        COMMIT;
                        CASE Step."Export Type" OF
                            Step."Export Type"::Report:
                                REPORT.RUNMODAL(Step."Export No.", TRUE, FALSE, PaymentHeader2);
                            Step."Export Type"::XMLport:
                                XMLPORT.RUN(Step."Export No.", TRUE, FALSE, PaymentHeader2);
                        END;
                        PaymentHeader.GET(PaymentHeaderParameter."No.");
                        ActionValidated := PaymentHeader."File Export Completed";
                    END;
                Step."Action Type"::Report:
                    BEGIN
                        CLEAR(Statement);
                        Statement.SETCURRENTKEY("Payment Class", "Status No.", "No.");
                        Statement.SETFILTER("Payment Class", PaymentHeader."Payment Class");
                        Statement.SETFILTER("Status No.", '%1', PaymentHeader."Status No.");
                        Statement.SETFILTER("No.", PaymentHeader."No.");
                        REPORT.RUNMODAL(Step."Report No.", TRUE, TRUE, Statement);
                        ActionValidated := TRUE;
                    END;
                Step."Action Type"::Ledger:
                    BEGIN
                        InvPostingBuffer[1].DELETEALL;
                        CheckDim;
                        Window.OPEN(
                          '#1#################################\\' +
                          Text005);
                        IF PaymentLine.FindFirst THEN
                            REPEAT
                                Window.UPDATE(1, Text005 + ' ' + PaymentLine."No." + ' ' + FORMAT(PaymentLine."Line No."));
                                OldPaymentLine := PaymentLine;
                                HeaderAccountUsedGlobally := FALSE;
                                GenerInvPostingBuffer;
                                PaymentLine."Acc. Type Last Entry Debit" := EntryTypeDebit;
                                PaymentLine."Acc. No. Last Entry Debit" := EntryNoAccountDebit;
                                PaymentLine."P. Group Last Entry Debit" := EntryPostGroupDebit;
                                PaymentLine."Acc. Type Last Entry Credit" := EntryTypeCredit;
                                PaymentLine."Acc. No. Last Entry Credit" := EntryNoAccountCredit;
                                PaymentLine."P. Group Last Entry Credit" := EntryPostGroupCredit;
                                PaymentLine.VALIDATE("Status No.", Step."Next Status");
                                CLEAR(PayClass);
                                IF PayClass.GET(PaymentLine."Payment Class", Step."Next Status") THEN;
                                PaymentLine."Payment in Progress" := PayClass."Payment in Progress";
                                PaymentLine.Posted := TRUE;
                                PaymentLine.MODIFY;
                                BloquerClient(PaymentLine);
                            UNTIL PaymentLine.NEXT = 0;
                        Window.CLOSE;
                        GenerEntries;
                        ActionValidated := TRUE;
                    END;
            END;

            IF ActionValidated THEN BEGIN
                PaymentHeader.VALIDATE("Status No.", Step."Next Status");
                PaymentHeader."Validation Date" := CURRENTDATETIME;
                PaymentHeader.MODIFY;
                PaymentLine.SETRANGE("No.", PaymentHeader."No.");
                PaymentLine.MODIFYALL("Status No.", Step."Next Status");
                CLEAR(PayClass);
                IF PayClass.GET(PaymentHeader."Payment Class", Step."Next Status") THEN;

                IF Step."Origin Payment Slip" THEN BEGIN
                    IF PaymentHeader2.GET(PaymentHeader."No.") THEN BEGIN
                        PaymentHeader2."Cession No." := PaymentHeader."No.";
                        PaymentHeader2.MODIFY;

                        PaymentLine2.SETFILTER("No.", '%1', PaymentHeader."No.");
                        IF PaymentLine2.FINDFIRST THEN
                            REPEAT
                                PaymentLine2."Cession No." := PaymentHeader."No.";
                                PaymentLine2.MODIFY;
                            UNTIL PaymentLine2.NEXT = 0;
                    END;
                END;

                PaymentLine.MODIFYALL("Payment in Progress", PayClass."Payment in Progress");
            END ELSE
                MESSAGE(Text007);
        end;
    end;

    procedure GenerInvPostingBuffer()
    var
        // NoSeriesMgt: Codeunit 396;
        PaymentClass: Record 50860;
        Description: Text[98];
        StepLedgerTmp: Record 50863;
        GroupeRetenu: Record "WDC-ST Retained Group";
    begin
        StepLedger.SETRANGE("Payment Class", Step."Payment Class");
        StepLedger.SETRANGE("Line No.", Step."Line No.");
        CLEAR(StepLedgerTmp);
        StepLedgerTmp.RESET;
        IF StepLedger.FindFirst THEN BEGIN
            REPEAT
                CLEAR(InvPostingBuffer[1]);
                SetPostingGroup;
                SetAccountNo;
                InvPostingBuffer[1]."System-Created Entry" := TRUE;
                IF StepLedger.Sign = StepLedger.Sign::Debit THEN BEGIN
                    IF StepLedgerTmp.GET(Step."Payment Class", Step."Line No.", StepLedger.Sign::Credit) THEN;


                    IF (StepLedgerTmp."Posting RS") THEN BEGIN
                        InvPostingBuffer[1].VALIDATE(Amount, (PaymentLine.Amount - PaymentLine."RS Amount"));
                        InvPostingBuffer[1].VALIDATE("Amount (LCY)", (PaymentLine."Amount (LCY)" - PaymentLine."RS Amount LCY"));
                        //<<HD150525
                        IF PaymentLine."Account Type" = PaymentLine."Account Type"::Customer then BEGIN
                            InvPostingBuffer[1].VALIDATE(Amount, (PaymentLine.Amount - Abs(PaymentLine."RS Amount")));
                            InvPostingBuffer[1].VALIDATE("Amount (LCY)", (PaymentLine."Amount (LCY)" - Abs(PaymentLine."RS Amount LCY")));
                        end;
                        //>>HD150525
                    END
                    ELSE BEGIN
                        IF StepLedgerTmp."Cancel Posting RS" THEN BEGIN
                            InvPostingBuffer[1].VALIDATE(Amount, (PaymentLine.Amount - PaymentLine."Validated RS Amount"));
                            InvPostingBuffer[1].VALIDATE("Amount (LCY)", (PaymentLine."Amount (LCY)" - PaymentLine."Validated RS Amount LCY"));
                        END
                        ELSE BEGIN
                            InvPostingBuffer[1].VALIDATE(Amount, ABS(PaymentLine.Amount));
                            InvPostingBuffer[1].VALIDATE("Amount (LCY)", ABS(PaymentLine."Amount (LCY)"));
                        END;

                    END;

                    IF StepLedgerTmp."Posting RS On VAT" THEN BEGIN
                        InvPostingBuffer[1].VALIDATE(Amount, InvPostingBuffer[1].Amount - PaymentLine."RS VAT Amount");
                        InvPostingBuffer[1].VALIDATE("Amount (LCY)", InvPostingBuffer[1]."Amount (LCY)" - PaymentLine."RS VAT Amount LCY");
                    END;

                    IF StepLedgerTmp."RS On Guarantee" THEN BEGIN
                        InvPostingBuffer[1].VALIDATE(Amount, InvPostingBuffer[1].Amount - PaymentLine."Guarantee RS Amount");
                        InvPostingBuffer[1].VALIDATE("Amount (LCY)", InvPostingBuffer[1]."Amount (LCY)" - PaymentLine."Guarantee RS Amount LCY");
                    END;
                    IF (PaymentLine."Account Type" = PaymentLine."Account Type"::Vendor) THEN BEGIN
                        IF (StepLedgerTmp."Include Commission") AND (StepLedgerTmp."Commission Account No." <> '') THEN BEGIN
                            InvPostingBuffer[1].VALIDATE(Amount, InvPostingBuffer[1].Amount + PaymentLine."Commission Amount");
                            InvPostingBuffer[1].VALIDATE("Amount (LCY)", (InvPostingBuffer[1]."Amount (LCY)" + PaymentLine."Commission Amount LCY")
               );
                        END;
                        IF (StepLedgerTmp."Include Commission") AND (StepLedgerTmp."Commission VAT Account No." <> '') THEN BEGIN
                            InvPostingBuffer[1].VALIDATE(Amount, InvPostingBuffer[1].Amount + PaymentLine."Commission VAT Amount");
                            InvPostingBuffer[1].VALIDATE("Amount (LCY)", (InvPostingBuffer[1]."Amount (LCY)" +
                                                  PaymentLine."Commission VAT Amount LCY"));
                        END;
                    END;
                    IF (PaymentLine."Account Type" = PaymentLine."Account Type"::"G/L Account") THEN BEGIN

                        IF (StepLedgerTmp."Include Commission") AND (StepLedgerTmp."Commission Account No." <> '') THEN BEGIN

                            InvPostingBuffer[1].VALIDATE(Amount, InvPostingBuffer[1].Amount - PaymentLine."Commission Amount");
                            InvPostingBuffer[1].VALIDATE("Amount (LCY)", (InvPostingBuffer[1]."Amount (LCY)" - PaymentLine."Commission Amount LCY")
               );
                        END;
                        IF (StepLedgerTmp."Include Commission") AND (StepLedgerTmp."Commission VAT Account No." <> '') THEN BEGIN
                            InvPostingBuffer[1].VALIDATE(Amount, InvPostingBuffer[1].Amount - PaymentLine."Commission VAT Amount");
                            InvPostingBuffer[1].VALIDATE("Amount (LCY)", (InvPostingBuffer[1]."Amount (LCY)" -
                                                  PaymentLine."Commission VAT Amount LCY"));
                        END;

                    END;
                    IF (PaymentLine."Account Type" = PaymentLine."Account Type"::Customer) THEN BEGIN
                        IF (StepLedger."Include Commission") AND (StepLedger."Commission Account No." <> '') THEN BEGIN
                            InvPostingBuffer[1].VALIDATE(Amount, InvPostingBuffer[1].Amount + PaymentLine."Commission Amount");
                            InvPostingBuffer[1].VALIDATE("Amount (LCY)", (InvPostingBuffer[1]."Amount (LCY)" + PaymentLine."Commission Amount LCY")
               );
                        END;

                        IF (StepLedger."Include Commission") AND (StepLedger."Commission VAT Account No." <> '') THEN BEGIN
                            InvPostingBuffer[1].VALIDATE(Amount, InvPostingBuffer[1].Amount + PaymentLine."Commission VAT Amount");
                            InvPostingBuffer[1].VALIDATE("Amount (LCY)", (InvPostingBuffer[1]."Amount (LCY)" +
                                                  PaymentLine."Commission VAT Amount LCY"));
                        END;

                    END;

                END ELSE BEGIN
                    IF StepLedgerTmp.GET(Step."Payment Class", Step."Line No.", StepLedger.Sign::Debit) THEN;

                    IF (StepLedgerTmp."Posting RS") THEN BEGIN
                        InvPostingBuffer[1].VALIDATE(Amount, (PaymentLine.Amount - PaymentLine."RS Amount") * -1);
                        InvPostingBuffer[1].VALIDATE("Amount (LCY)", (PaymentLine."Amount (LCY)" - PaymentLine."RS Amount LCY") * -1);
                    END ELSE BEGIN
                        IF StepLedgerTmp."Cancel Posting RS" THEN BEGIN
                            InvPostingBuffer[1].VALIDATE(Amount, (PaymentLine.Amount - PaymentLine."Validated RS Amount") * -1);
                            InvPostingBuffer[1].VALIDATE("Amount (LCY)", (PaymentLine."Amount (LCY)" - PaymentLine."Validated RS Amount LCY") * -1);
                        END ELSE BEGIN
                            InvPostingBuffer[1].VALIDATE(Amount, ABS(PaymentLine.Amount) * -1);
                            InvPostingBuffer[1].VALIDATE("Amount (LCY)", ABS(PaymentLine."Amount (LCY)") * -1);
                        END;

                    END;
                    IF StepLedgerTmp."Posting RS On VAT" THEN BEGIN
                        InvPostingBuffer[1].VALIDATE(Amount, InvPostingBuffer[1].Amount + PaymentLine."RS VAT Amount");
                        InvPostingBuffer[1].VALIDATE("Amount (LCY)", (InvPostingBuffer[1]."Amount (LCY)" + PaymentLine."RS VAT Amount LCY"));
                    END;
                    IF StepLedgerTmp."RS On Guarantee" THEN BEGIN
                        InvPostingBuffer[1].VALIDATE(Amount, InvPostingBuffer[1].Amount + PaymentLine."Guarantee RS Amount");
                        InvPostingBuffer[1].VALIDATE("Amount (LCY)", InvPostingBuffer[1]."Amount (LCY)" + PaymentLine."Guarantee RS Amount LCY");
                    END;

                    IF (PaymentLine."Account Type" = PaymentLine."Account Type"::Vendor) THEN BEGIN
                        IF (StepLedgerTmp."Include Commission") AND (StepLedgerTmp."Commission Account No." <> '') THEN BEGIN
                            InvPostingBuffer[1].VALIDATE(Amount, InvPostingBuffer[1].Amount - PaymentLine."Commission Amount");
                            InvPostingBuffer[1].VALIDATE("Amount (LCY)", (InvPostingBuffer[1]."Amount (LCY)" - PaymentLine."Commission Amount LCY")
               );
                        END;
                        IF (StepLedgerTmp."Include Commission") AND (StepLedgerTmp."Commission VAT Account No." <> '') THEN BEGIN
                            InvPostingBuffer[1].VALIDATE(Amount, InvPostingBuffer[1].Amount - PaymentLine."Commission VAT Amount");
                            InvPostingBuffer[1].VALIDATE("Amount (LCY)", (InvPostingBuffer[1]."Amount (LCY)" -
                                                  PaymentLine."Commission VAT Amount LCY"));
                        END;
                    END;
                    IF (PaymentLine."Account Type" = PaymentLine."Account Type"::"G/L Account") THEN BEGIN
                        IF (StepLedgerTmp."Include Commission") AND (StepLedgerTmp."Commission Account No." <> '') THEN BEGIN

                            InvPostingBuffer[1].VALIDATE(Amount, InvPostingBuffer[1].Amount - PaymentLine."Commission Amount");
                            InvPostingBuffer[1].VALIDATE("Amount (LCY)", (InvPostingBuffer[1]."Amount (LCY)" - PaymentLine."Commission Amount LCY")
               );
                        END;
                        IF (StepLedgerTmp."Include Commission") AND (StepLedgerTmp."Commission VAT Account No." <> '') THEN BEGIN
                            InvPostingBuffer[1].VALIDATE(Amount, InvPostingBuffer[1].Amount - PaymentLine."Commission VAT Amount");
                            InvPostingBuffer[1].VALIDATE("Amount (LCY)", (InvPostingBuffer[1]."Amount (LCY)" -
                                                  PaymentLine."Commission VAT Amount LCY"));
                        END;
                    END;
                    IF (PaymentLine."Account Type" = PaymentLine."Account Type"::Customer) THEN BEGIN
                        IF (StepLedger."Include Commission") AND (StepLedger."Commission Account No." <> '') THEN BEGIN
                            InvPostingBuffer[1].VALIDATE(Amount, InvPostingBuffer[1].Amount + PaymentLine."Commission Amount");
                            InvPostingBuffer[1].VALIDATE("Amount (LCY)", (InvPostingBuffer[1]."Amount (LCY)" + PaymentLine."Commission Amount LCY")
               );
                        END;
                        IF (StepLedger."Include Commission") AND (StepLedger."Commission VAT Account No." <> '') THEN BEGIN
                            InvPostingBuffer[1].VALIDATE(Amount, InvPostingBuffer[1].Amount + PaymentLine."Commission VAT Amount");
                            InvPostingBuffer[1].VALIDATE("Amount (LCY)", (InvPostingBuffer[1]."Amount (LCY)" +
                                                  PaymentLine."Commission VAT Amount LCY"));
                        END;
                    END;
                END;
                IF (StepLedger."Accounting Type" = StepLedger."Accounting Type"::"Header Payment Account") THEN BEGIN
                    InvPostingBuffer[1]."Currency Code" := PaymentHeader."Currency Code";
                    InvPostingBuffer[1]."Currency Factor" := PaymentHeader."Currency Factor";
                END ELSE BEGIN
                    InvPostingBuffer[1]."Currency Code" := PaymentLine."Currency Code";
                    InvPostingBuffer[1]."Currency Factor" := PaymentLine."Currency Factor";
                END;
                InvPostingBuffer[1].Correction := PaymentLine.Correction XOR Step.Correction;
                IF StepLedger."Detail Level" = StepLedger."Detail Level"::Line THEN
                    InvPostingBuffer[1]."Payment Line No." := PaymentLine."Line No."
                ELSE
                    IF StepLedger."Detail Level" = StepLedger."Detail Level"::"Due Date" THEN
                        InvPostingBuffer[1]."Due Date" := PaymentLine."Due Date";

                InvPostingBuffer[1]."Document Type" := StepLedger."Document Type";
                IF StepLedger."Document No." = StepLedger."Document No."::"Header No." THEN
                    InvPostingBuffer[1]."Document No." := PaymentHeader."No."
                ELSE BEGIN
                    IF (InvPostingBuffer[1].Sign = InvPostingBuffer[1].Sign::Positive) AND
                       (PaymentLine."Entry No. Debit" = 0) AND (PaymentLine."Entry No. Credit" = 0)
                    THEN BEGIN
                        PaymentClass.GET(PaymentHeader."Payment Class");
                        IF PaymentClass."Line No. Series" = '' THEN
                            PaymentLine.TESTFIELD("Document No.", NoSeriesMgt.GetNextNo(PaymentHeader."No. Series", PaymentLine."Posting Date", FALSE))
                        ELSE
                            PaymentLine.TESTFIELD("Document No.", NoSeriesMgt.GetNextNo(PaymentClass."Line No. Series", PaymentLine."Posting Date",
                                FALSE));
                    END;
                    InvPostingBuffer[1]."Document No." := PaymentLine."Document No.";
                END;
                InvPostingBuffer[1]."Header Document No." := PaymentHeader."No.";
                IF StepLedger.Sign = StepLedger.Sign::Debit THEN BEGIN
                    EntryTypeDebit := InvPostingBuffer[1]."Account Type";
                    EntryNoAccountDebit := InvPostingBuffer[1]."Account No.";
                    EntryPostGroupDebit := InvPostingBuffer[1]."Posting Group";
                END ELSE BEGIN
                    EntryTypeCredit := InvPostingBuffer[1]."Account Type";
                    EntryNoAccountCredit := InvPostingBuffer[1]."Account No.";
                    EntryPostGroupCredit := InvPostingBuffer[1]."Posting Group";
                END;
                InvPostingBuffer[1]."System-Created Entry" := TRUE;
                Application;
                PaymentClass.GET(PaymentHeader."Payment Class");
                IF (PaymentClass."Unrealized VAT Reversal" = PaymentClass."Unrealized VAT Reversal"::Delayed) AND
                   Step."Realize VAT"
                THEN BEGIN
                    InvPostingBuffer[1]."Applies-to Doc. Type" := PaymentLine."Applies-to Doc. Type";
                    InvPostingBuffer[1]."Applies-to Doc. No." := PaymentLine."Applies-to Doc. No.";
                    InvPostingBuffer[1]."Applies-to ID" := PaymentLine."Applies-to ID";
                    InvPostingBuffer[1]."Created from No." := PaymentLine."Created from No.";
                END;
                Description := STRSUBSTNO(StepLedger.Description, PaymentLine."External Document No.", PaymentLine."Due Date",
                PaymentLine."Account No.", PaymentLine."Drawee Reference", PaymentHeader."No.", PaymentHeader."Account No."
                , PaymentLine."Bank Account Code");
                IF STRLEN(Description) > 50 THEN BEGIN
                    Description := COPYSTR(Description, 1, 48);
                    Description := Description + '..';
                END;
                InvPostingBuffer[1].Description := STRSUBSTNO(StepLedger.Description,
                PaymentLine."Due Date", PaymentLine."Account No.", PaymentLine."Document No.",
                PaymentLine."External Document No.", PaymentHeader."No.");
                IF STRLEN(InvPostingBuffer[1].Description) > 50 THEN BEGIN
                    InvPostingBuffer[1].Description := COPYSTR(InvPostingBuffer[1].Description, 1, 48);
                    InvPostingBuffer[1].Description := InvPostingBuffer[1].Description + '..';
                END;
                InvPostingBuffer[1]."Source Type" := PaymentLine."Account Type";
                InvPostingBuffer[1]."Source No." := PaymentLine."Account No.";
                InvPostingBuffer[1]."External Document No." := PaymentLine."External Document No.";
                InvPostingBuffer[1]."Dimension Set ID" := PaymentLine."Dimension Set ID";
                UpdtBuffer;
                IF (InvPostingBuffer[1].Amount >= 0) XOR InvPostingBuffer[1].Correction THEN
                    PaymentLine."Entry No. Debit" := InvPostingBuffer[1]."GL Entry No."
                ELSE
                    PaymentLine."Entry No. Credit" := InvPostingBuffer[1]."GL Entry No.";
                GenererInv;

            UNTIL StepLedger.NEXT = 0;
            //NoSeriesMgt.SaveNoState;
        END;
    end;

    procedure GenerEntries()
    var
        Difference: Decimal;
        Currency: Record 4;
        Text100: Label 'Rounding on ';
        TotalDebit: Decimal;
        TotalCredit: Decimal;
        PaymentLineTmp: Record 50866;
    begin
        GLsetup.GET;
        InvPostingBuffer[1].SETCURRENTKEY("GL Entry No.", "Account Type", "Account No.");
        InvPostingBuffer[1].ASCENDING(FALSE);

        IF InvPostingBuffer[1].FindLast() THEN
            //WITH PaymentHeader DO
                REPEAT
                    GenJnlLine.INIT;
                    GenJnlLine."Posting Date" := PaymentHeader."Posting Date";
                    GenJnlLine."Document Date" := PaymentHeader."Document Date";
                    GenJnlLine.Description := InvPostingBuffer[1].Description;
                    IF STRLEN(GenJnlLine.Description) > 50 THEN BEGIN
                        GenJnlLine.Description := COPYSTR(GenJnlLine.Description, 1, 48);
                        GenJnlLine.Description := GenJnlLine.Description + '..';
                    END;
                    IF InvPostingBuffer[1]."RS Code" <> '' THEN BEGIN
                        GenJnlLine."Reason Code" := InvPostingBuffer[1]."RS Code";
                        RecReasonCode.RESET;
                        RecReasonCode.SETRANGE(Code, GenJnlLine."Reason Code");
                        IF RecReasonCode.FindFirst THEN
                            IF GenJnlLine.Description = '' THEN
                                GenJnlLine.Description := RecReasonCode.Description;
                    END
                    ELSE
                        GenJnlLine."Reason Code" := Step."Reason Code";

                    GenJnlLine."Document Type" := InvPostingBuffer[1]."Document Type";
                    GenJnlLine."Document No." := InvPostingBuffer[1]."Document No.";
                    GenJnlLine."Account Type" := InvPostingBuffer[1]."Account Type";
                    GenJnlLine."Account No." := InvPostingBuffer[1]."Account No.";
                    GenJnlLine."System-Created Entry" := InvPostingBuffer[1]."System-Created Entry";
                    GenJnlLine."Currency Code" := InvPostingBuffer[1]."Currency Code";
                    GenJnlLine."Currency Factor" := InvPostingBuffer[1]."Currency Factor";
                    GenJnlLine.VALIDATE(Amount, InvPostingBuffer[1].Amount);
                    GenJnlLine.Correction := InvPostingBuffer[1].Correction;
                    IF PaymentHeader."Source Code" <> '' THEN BEGIN
                        TestSourceCode(PaymentHeader."Source Code");
                        GenJnlLine."Source Code" := PaymentHeader."Source Code";
                    END ELSE BEGIN
                        Step.TESTFIELD("Source Code");
                        TestSourceCode(Step."Source Code");
                        GenJnlLine."Source Code" := Step."Source Code";
                    END;
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
                    GenJnlPostLine.RunWithCheck(GenJnlLine);

                    IF (InvPostingBuffer[1]."RS Account No." <> '') AND (InvPostingBuffer[1]."RS Amount" <> 0) THEN BEGIN
                        GenJnlLine.INIT;
                        GenJnlLine."Posting Date" := PaymentHeader."Posting Date";
                        GenJnlLine."Document Date" := PaymentHeader."Document Date";
                        GroupeRetenu.RESET;
                        Desc := '';
                        IF GroupeRetenu.GET(0, PaymentLine."RS Code") THEN
                            Desc := FORMAT(GroupeRetenu."Type Retenue")
                        ELSE
                            IF GroupeRetenu.GET(1, PaymentLine."Guarantee RS Code") THEN
                                Desc := FORMAT(GroupeRetenu."Type Retenue")
                            ELSE
                                IF GroupeRetenu.GET(2, PaymentLine."RS Code") THEN
                                    Desc := FORMAT(GroupeRetenu."Type Retenue")
                                ELSE
                                    IF GroupeRetenu.GET(3, PaymentLine."RS Code") THEN
                                        Desc := FORMAT(GroupeRetenu."Type Retenue")
                                    ELSE
                                        IF GroupeRetenu.GET(4, PaymentLine."RS Code") THEN
                                            Desc := FORMAT(GroupeRetenu."Type Retenue");
                        GenJnlLine.Description := Desc;
                        GenJnlLine."Reason Code" := Step."Reason Code";
                        RecReasonCode.RESET;
                        RecReasonCode.SETRANGE(Code, GenJnlLine."Reason Code");
                        IF RecReasonCode.FindFirst THEN
                            IF GenJnlLine.Description = '' THEN
                                GenJnlLine.Description := RecReasonCode.Description;
                        GenJnlLine."Document Type" := InvPostingBuffer[1]."Document Type";
                        GenJnlLine."Document No." := InvPostingBuffer[1]."Document No.";
                        GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
                        GenJnlLine."Account No." := InvPostingBuffer[1]."RS Account No.";
                        GenJnlLine."System-Created Entry" := InvPostingBuffer[1]."System-Created Entry";
                        GenJnlLine."Currency Code" := InvPostingBuffer[1]."Currency Code";
                        GenJnlLine."Currency Factor" := InvPostingBuffer[1]."Currency Factor";
                        GenJnlLine.VALIDATE(Amount, InvPostingBuffer[1]."RS Amount");
                        GenJnlLine.Correction := InvPostingBuffer[1].Correction;
                        IF PaymentHeader."Source Code" <> '' THEN BEGIN
                            TestSourceCode(PaymentHeader."Source Code");
                            GenJnlLine."Source Code" := PaymentHeader."Source Code";
                        END ELSE BEGIN
                            Step.TESTFIELD("Source Code");
                            TestSourceCode(Step."Source Code");
                            GenJnlLine."Source Code" := Step."Source Code";
                        END;
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
                        IF (ROUND(GenJnlLine."Amount (LCY)", GLsetup."Amount Rounding Precision") <> 0) THEN
                            GenJnlPostLine.RunWithCheck(GenJnlLine);
                    END;

                    IF (InvPostingBuffer[1]."VAT Account No." <> '') AND (InvPostingBuffer[1]."RS VAT Amount" <> 0) THEN BEGIN
                        GenJnlLine.INIT;
                        GenJnlLine."Posting Date" := PaymentHeader."Posting Date";
                        GenJnlLine."Document Date" := PaymentHeader."Document Date";
                        GenJnlLine.Description := 'Retenue Sur T.V.A';
                        GenJnlLine."Reason Code" := Step."Reason Code";
                        GenJnlLine."Document Type" := InvPostingBuffer[1]."Document Type";
                        GenJnlLine."Document No." := InvPostingBuffer[1]."Document No.";
                        GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
                        GenJnlLine."Account No." := InvPostingBuffer[1]."VAT Account No.";
                        GenJnlLine."System-Created Entry" := InvPostingBuffer[1]."System-Created Entry";
                        GenJnlLine."Currency Code" := InvPostingBuffer[1]."Currency Code";
                        GenJnlLine."Currency Factor" := InvPostingBuffer[1]."Currency Factor";
                        GenJnlLine.VALIDATE(Amount, InvPostingBuffer[1]."RS VAT Amount");
                        GenJnlLine.Correction := InvPostingBuffer[1].Correction;

                        IF PaymentHeader."Source Code" <> '' THEN BEGIN
                            TestSourceCode(PaymentHeader."Source Code");
                            GenJnlLine."Source Code" := PaymentHeader."Source Code";
                        END ELSE BEGIN
                            Step.TESTFIELD("Source Code");
                            TestSourceCode(Step."Source Code");
                            GenJnlLine."Source Code" := Step."Source Code";
                        END;
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


                        IF (ROUND(GenJnlLine."Amount (LCY)", GLsetup."Amount Rounding Precision") <> 0) THEN
                            GenJnlPostLine.RunWithCheck(GenJnlLine);

                        IF PaymentHeader."Source Code" <> '' THEN BEGIN
                            TestSourceCode(PaymentHeader."Source Code");
                            GenJnlLine."Source Code" := PaymentHeader."Source Code";
                        END ELSE BEGIN
                            Step.TESTFIELD("Source Code");
                            TestSourceCode(Step."Source Code");
                            GenJnlLine."Source Code" := Step."Source Code";
                        END;
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
                        IF (ROUND(GenJnlLine."Amount (LCY)", GLsetup."Amount Rounding Precision") <> 0) THEN
                            GenJnlPostLine.RunWithCheck(GenJnlLine);

                        IF PaymentHeader."Source Code" <> '' THEN BEGIN
                            TestSourceCode(PaymentHeader."Source Code");
                            GenJnlLine."Source Code" := PaymentHeader."Source Code";
                        END ELSE BEGIN
                            Step.TESTFIELD("Source Code");
                            TestSourceCode(Step."Source Code");
                            GenJnlLine."Source Code" := Step."Source Code";
                        END;
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
                        IF (ROUND(GenJnlLine."Amount (LCY)", GLsetup."Amount Rounding Precision") <> 0) THEN
                            GenJnlPostLine.RunWithCheck(GenJnlLine);
                    END;



                    PaymentLine.RESET;
                    PaymentLine.SETRANGE("No.", PaymentHeader."No.");
                    PaymentLine.SETRANGE("Line No.");
                    IF GenJnlLine.Amount >= 0 THEN BEGIN
                        TotalDebit := TotalDebit + GenJnlLine."Amount (LCY)";
                        PaymentLine.SETRANGE("Entry No. Debit", InvPostingBuffer[1]."GL Entry No.");
                        StepLedger.GET(Step."Payment Class", Step."Line No.", StepLedger.Sign::Debit);
                        IF StepLedger."Memorize Entry" THEN
                            PaymentLine.MODIFYALL(PaymentLine."Entry No. Debit Memo", GenJnlLine."Entry No.");
                        PaymentLine.MODIFYALL("Entry No. Debit", GenJnlLine."Entry No.");
                    END ELSE BEGIN
                        TotalCredit := TotalCredit + ABS(GenJnlLine."Amount (LCY)");
                        PaymentLine.SETRANGE("Entry No. Credit", InvPostingBuffer[1]."GL Entry No.");
                        StepLedger.GET(Step."Payment Class", Step."Line No.", StepLedger.Sign::Credit);
                        IF StepLedger."Memorize Entry" THEN
                            PaymentLine.MODIFYALL(PaymentLine."Entry No. Credit Memo", GenJnlLine."Entry No.");
                        PaymentLine.MODIFYALL("Entry No. Credit", GenJnlLine."Entry No.");
                    END;
                    PaymentLineTmp.RESET;
                    PaymentLineTmp.SETRANGE("No.", PaymentHeader."No.");
                    PaymentLineTmp.SETRANGE("Line No.");
                    IF PaymentLineTmp.FindFirst THEN
                        REPEAT
                            IF (PaymentLineTmp."RS Amount" <> 0) AND
                               (StepLedger."Posting RS") THEN BEGIN
                                PaymentLineTmp."Validated RS Amount" := PaymentLineTmp."RS Amount";
                                PaymentLineTmp."Validated RS Amount LCY" := PaymentLineTmp."RS Amount LCY";
                                PaymentLineTmp."RS Amount" := 0;
                                PaymentLineTmp."RS Amount LCY" := 0;
                                PaymentLineTmp.MODIFY;
                            END;

                            IF (PaymentLineTmp."Validated RS Amount" <> 0) AND
                               (StepLedger."Cancel Posting RS") THEN BEGIN
                                PaymentLineTmp."RS Amount" := PaymentLineTmp."Validated RS Amount";
                                PaymentLineTmp."RS Amount LCY" := PaymentLineTmp."Validated RS Amount LCY";
                                PaymentLineTmp."Validated RS Amount" := 0;
                                PaymentLineTmp."Validated RS Amount LCY" := 0;
                                PaymentLineTmp.MODIFY;
                            END;

                            IF PaymentLine."RS VAT Amount" <> 0 THEN BEGIN
                                PaymentLine."Validated RS VAT Amount" := PaymentLine."RS VAT Amount";
                                PaymentLine."Validated RS VAT Amount LCY" := PaymentLine."RS VAT Amount LCY";
                                PaymentLine."RS VAT Amount" := 0;
                                PaymentLine."RS VAT Amount LCY" := 0;
                                PaymentLineTmp.MODIFY;
                            END;
                            IF PaymentLine."Commission Amount" <> 0 THEN BEGIN
                                PaymentLine."Validated Commission Amount" := PaymentLine."Commission Amount";
                                PaymentLine."Validated Commission Amt LCY" := PaymentLine."Commission Amount LCY";
                                PaymentLine."Commission Amount" := 0;
                                PaymentLine."Commission Amount LCY" := 0;
                                PaymentLineTmp.MODIFY;
                            END;
                            IF PaymentLine."Commission VAT Amount" <> 0 THEN BEGIN
                                PaymentLine."Validated VAt Amt Commission" := PaymentLine."Commission VAT Amount";
                                PaymentLine."Validated Commission Amt LCY" := PaymentLine."Commission VAT Amount LCY";
                                PaymentLine."Commission VAT Amount" := 0;
                                PaymentLine."Commission VAT Amount LCY" := 0;
                                PaymentLineTmp.MODIFY;
                            END;
                            IF PaymentLine."Guarantee RS Amount" <> 0 THEN BEGIN
                                PaymentLine."Validated Guarantee RS Amount" := PaymentLine."Guarantee RS Amount";
                                PaymentLine."Valid Guarantee RS Amount LCY" := PaymentLine."Guarantee RS Amount LCY";
                                PaymentLineTmp.MODIFY;
                            END;

                        UNTIL PaymentLineTmp.NEXT = 0;
            UNTIL InvPostingBuffer[1].NEXT(-1) = 0;

        IF HeaderAccountUsedGlobally THEN BEGIN
            Difference := TotalDebit - TotalCredit;
            IF Difference <> 0 THEN BEGIN
                GenJnlLine.INIT;
                GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
                Currency.GET(PaymentHeader."Currency Code");
                IF Difference < 0 THEN BEGIN
                    GenJnlLine."Account No." := Currency."Unrealized Losses Acc.";
                    StepLedger.GET(Step."Payment Class", Step."Line No.", StepLedger.Sign::Debit);
                    GenJnlLine.VALIDATE("Debit Amount", -Difference);
                END ELSE BEGIN
                    GenJnlLine."Account No." := Currency."Unrealized Gains Acc.";
                    StepLedger.GET(Step."Payment Class", Step."Line No.", StepLedger.Sign::Credit);
                    GenJnlLine.VALIDATE("Credit Amount", Difference);
                END;
                GenJnlLine."Posting Date" := PaymentHeader."Posting Date";
                GenJnlLine."Document No." := PaymentHeader."No.";
                GenJnlLine.Description := Text100 + STRSUBSTNO(StepLedger.Description,
                 PaymentHeader."Document Date", '', PaymentHeader."No.", '');
                IF STRLEN(GenJnlLine.Description) > 50 THEN BEGIN
                    GenJnlLine.Description := COPYSTR(GenJnlLine.Description, 1, 48);
                    GenJnlLine.Description := GenJnlLine.Description + '..';
                END;
                GenJnlLine."Shortcut Dimension 1 Code" := PaymentHeader."Shortcut Dimension 1 Code";
                GenJnlLine."Shortcut Dimension 2 Code" := PaymentHeader."Shortcut Dimension 2 Code";
                GenJnlLine."Dimension Set ID" := PaymentHeader."Dimension Set ID";
                GenJnlLine."Source Code" := PaymentHeader."Source Code";
                GenJnlLine."Reason Code" := Step."Reason Code";
                RecReasonCode.RESET;
                RecReasonCode.SETRANGE(Code, GenJnlLine."Reason Code");
                IF RecReasonCode.FindFirst THEN
                    IF GenJnlLine.Description = '' THEN
                        GenJnlLine.Description := RecReasonCode.Description;
                GenJnlLine."Document Date" := PaymentHeader."Document Date";
                GenJnlPostLine.RunWithCheck(GenJnlLine);
            END;
        END;

        InvPostingBuffer[1].DELETEALL;

    end;

    procedure TestSourceCode("Code": Code[10])
    var
        SourceCode: Record 230;
    begin
        IF NOT SourceCode.GET(Code) THEN
            ERROR(Text017, Code);
    end;

    local procedure CheckDim()
    begin
        PaymentLine."Line No." := 0;
        CheckDimComb(PaymentLine);
        PaymentLine.SETRANGE("No.", PaymentHeader."No.");
        IF PaymentLine.FINDSET THEN
            REPEAT
                CheckDimComb(PaymentLine);
            UNTIL PaymentLine.NEXT = 0;
    end;

    procedure SetPostingGroup()
    var
        PostingGroup: Code[10];
    begin

        IF PaymentLine."Account Type" = PaymentLine."Account Type"::Customer THEN
            IF ((StepLedger."Accounting Type" = StepLedger."Accounting Type"::"Payment Line Account") OR
                (StepLedger."Accounting Type" = StepLedger."Accounting Type"::"Associated G/L Account") OR
                (StepLedger."Accounting Type" = StepLedger."Accounting Type"::"Header Payment Account") OR
                ((StepLedger."Accounting Type" = StepLedger."Accounting Type"::"Setup Account") AND
                 (StepLedger."Account Type" = StepLedger."Account Type"::Customer)))
            THEN BEGIN
                IF PaymentLine."Posting Group" <> '' THEN
                    PostingGroup := PaymentLine."Posting Group"
                ELSE
                    IF StepLedger."Customer Posting Group" <> '' THEN
                        PostingGroup := StepLedger."Customer Posting Group"
                    ELSE BEGIN
                        Customer.GET(PaymentLine."Account No.");
                        PostingGroup := Customer."Customer Posting Group";
                    END;
                IF NOT CustomerPostingGroup.GET(PostingGroup) THEN
                    ERROR(Text012, PostingGroup);
                IF CustomerPostingGroup."Receivables Account" = '' THEN
                    ERROR(Text014, PostingGroup);
            END;

        IF PaymentLine."Account Type" = PaymentLine."Account Type"::Vendor THEN
            IF ((StepLedger."Accounting Type" = StepLedger."Accounting Type"::"Payment Line Account") OR
                (StepLedger."Accounting Type" = StepLedger."Accounting Type"::"Associated G/L Account") OR
                (StepLedger."Accounting Type" = StepLedger."Accounting Type"::"Header Payment Account") OR
                ((StepLedger."Accounting Type" = StepLedger."Accounting Type"::"Setup Account") AND
                 (StepLedger."Account Type" = StepLedger."Account Type"::Vendor)))
            THEN BEGIN
                IF PaymentLine."Posting Group" <> '' THEN
                    PostingGroup := PaymentLine."Posting Group"
                ELSE
                    IF StepLedger."Vendor Posting Group" <> '' THEN
                        PostingGroup := StepLedger."Vendor Posting Group"
                    ELSE BEGIN
                        Vendor.GET(PaymentLine."Account No.");
                        PostingGroup := Vendor."Vendor Posting Group";
                    END;
                IF NOT VendorPostingGroup.GET(PostingGroup) THEN
                    ERROR(Text012, PostingGroup);
                IF VendorPostingGroup."Payables Account" = '' THEN
                    ERROR(Text014, PostingGroup);
            END;
    end;

    procedure SetAccountNo()
    begin
        CASE StepLedger."Accounting Type" OF
            StepLedger."Accounting Type"::"Payment Line Account":
                BEGIN
                    InvPostingBuffer[1]."Account Type" := PaymentLine."Account Type";
                    InvPostingBuffer[1]."Account No." := PaymentLine."Account No.";
                    IF PaymentLine."Account Type" = PaymentLine."Account Type"::Customer THEN
                        InvPostingBuffer[1]."Posting Group" := CustomerPostingGroup.Code;
                    IF PaymentLine."Account Type" = PaymentLine."Account Type"::Vendor THEN
                        InvPostingBuffer[1]."Posting Group" := VendorPostingGroup.Code;
                    InvPostingBuffer[1]."Line No." := PaymentLine."Line No.";
                    DimMgt.UpdateGlobalDimFromDimSetID(PaymentLine."Dimension Set ID",
                      InvPostingBuffer[1]."Global Dimension 1 Code", InvPostingBuffer[1]."Global Dimension 2 Code");
                END;
            StepLedger."Accounting Type"::"Associated G/L Account":
                BEGIN
                    InvPostingBuffer[1]."Account Type" := InvPostingBuffer[1]."Account Type"::"G/L Account";
                    IF PaymentLine."Account Type" = PaymentLine."Account Type"::Customer THEN
                        InvPostingBuffer[1]."Account No." := CustomerPostingGroup."Receivables Account"
                    ELSE
                        InvPostingBuffer[1]."Account No." := VendorPostingGroup."Payables Account";
                    InvPostingBuffer[1]."Line No." := PaymentLine."Line No.";
                END;
            StepLedger."Accounting Type"::"Setup Account":
                BEGIN
                    InvPostingBuffer[1]."Account Type" := StepLedger."Account Type";
                    InvPostingBuffer[1]."Account No." := StepLedger."Account No.";
                    IF StepLedger."Account No." = '' THEN BEGIN
                        PaymentHeader.CALCFIELDS("Payment Class Name");
                        IF StepLedger.Sign = StepLedger.Sign::Debit THEN
                            ERROR(Text018, Step.Name, PaymentHeader."Payment Class Name");

                        ERROR(Text019, Step.Name, PaymentHeader."Payment Class Name");
                    END;
                    IF StepLedger."Account Type" = StepLedger."Account Type"::Customer THEN
                        InvPostingBuffer[1]."Posting Group" := StepLedger."Customer Posting Group"
                    ELSE
                        InvPostingBuffer[1]."Posting Group" := StepLedger."Vendor Posting Group";
                    InvPostingBuffer[1]."Line No." := PaymentLine."Line No.";
                END;
            StepLedger."Accounting Type"::"G/L Account / Month":
                BEGIN
                    InvPostingBuffer[1]."Account Type" := InvPostingBuffer[1]."Account Type"::"G/L Account";
                    N := DATE2DMY(PaymentLine."Due Date", 2);
                    IF N < 10 THEN
                        Suffix := '0' + FORMAT(N)
                    ELSE
                        Suffix := FORMAT(N);
                    InvPostingBuffer[1]."Account No." := StepLedger.Root + Suffix;
                    InvPostingBuffer[1]."Line No." := PaymentLine."Line No.";
                END;
            StepLedger."Accounting Type"::"G/L Account / Week":
                BEGIN
                    InvPostingBuffer[1]."Account Type" := InvPostingBuffer[1]."Account Type"::"G/L Account";
                    N := DATE2DWY(PaymentLine."Due Date", 2);
                    IF N < 10 THEN
                        Suffix := '0' + FORMAT(N)
                    ELSE
                        Suffix := FORMAT(N);
                    InvPostingBuffer[1]."Account No." := StepLedger.Root + Suffix;
                    InvPostingBuffer[1]."Line No." := PaymentLine."Line No.";
                END;
            StepLedger."Accounting Type"::"Bal. Account Previous Entry":
                BEGIN
                    IF (StepLedger.Sign = StepLedger.Sign::Debit) AND NOT (PaymentLine.Correction XOR Step.Correction) THEN BEGIN
                        InvPostingBuffer[1]."Account Type" := PaymentLine."Acc. Type Last Entry Credit";
                        InvPostingBuffer[1]."Account No." := PaymentLine."Acc. No. Last Entry Credit";
                        InvPostingBuffer[1]."Posting Group" := PaymentLine."P. Group Last Entry Credit";
                    END ELSE BEGIN
                        InvPostingBuffer[1]."Account Type" := PaymentLine."Acc. Type Last Entry Debit";
                        InvPostingBuffer[1]."Account No." := PaymentLine."Acc. No. Last Entry Debit";
                        InvPostingBuffer[1]."Posting Group" := PaymentLine."P. Group Last Entry Debit";
                    END;
                    InvPostingBuffer[1]."Line No." := PaymentLine."Line No.";
                END;
            StepLedger."Accounting Type"::"Header Payment Account":
                BEGIN
                    InvPostingBuffer[1]."Account Type" := PaymentHeader."Account Type";
                    InvPostingBuffer[1]."Account No." := PaymentHeader."Account No.";
                    IF PaymentHeader."Account No." = '' THEN
                        ERROR(Text020);
                    IF StepLedger."Detail Level" = StepLedger."Detail Level"::Account THEN
                        HeaderAccountUsedGlobally := TRUE;
                    InvPostingBuffer[1]."Line No." := 0;
                    DimMgt.UpdateGlobalDimFromDimSetID(PaymentHeader."Dimension Set ID",
                      InvPostingBuffer[1]."Global Dimension 1 Code", InvPostingBuffer[1]."Global Dimension 2 Code");
                END;
        END;
    end;

    local procedure CheckDimComb(PaymentLine2: Record 50866)
    begin
        IF PaymentLine."Line No." = 0 THEN
            IF NOT DimMgt.CheckDimIDComb(PaymentHeader."Dimension Set ID") THEN
                ERROR(
                  Text009,
                  PaymentHeader."No.", DimMgt.GetDimCombErr);

        IF PaymentLine."Line No." <> 0 THEN
            IF NOT DimMgt.CheckDimIDComb(PaymentLine2."Dimension Set ID") THEN
                ERROR(
                  Text010,
                  PaymentHeader."No.", PaymentLine2."Line No.", DimMgt.GetDimCombErr);
    end;

    var
        Text002: Label 'One or more acceptation codes are No.';
        Text003: Label 'One or more lines have an incorrect RIB code.';
        Text005: Label 'Ledger Posting';
        Text006: Label 'One or more due dates are not specified.';
        Text007: Label 'The action has been cancelled';
        Text008: Label 'The header RIB is not correct';
        Text009: Label 'The combination of dimensions used in Payment Header %1 is blocked. %2';
        Text010: Label 'The combination of dimensions used in Payment Header %, line no. %2 is blocked. %3';
        InvPostingBuffer: array[2] of Record 50864;
        CustomerPostingGroup: Record 92;
        VendorPostingGroup: Record 93;
        Customer: Record 18;
        Vendor: Record 23;
        N: Integer;
        Suffix: Text[2];
        CustLedgerEntry: Record 21;
        VendorLedgerEntry: Record 25;
        EntryTypeDebit: Enum Microsoft.Finance.GeneralLedger.Journal."Gen. Journal Account Type";
        EntryNoAccountDebit: Code[20];
        EntryPostGroupDebit: Code[10];
        EntryTypeCredit: Enum Microsoft.Finance.GeneralLedger.Journal."Gen. Journal Account Type";
        EntryNoAccountCredit: Code[20];
        EntryPostGroupCredit: Code[10];
        GenJnlLine: Record 81;
        GenJnlPostLine: Codeunit 12;
        PaymentLine: Record 50866;
        OldPaymentLine: Record 50866;
        StepLedger: Record 50863;
        Step: Record 50862;
        PaymentHeader: Record 50865;
        GLEntryNoTmp: Integer;
        DimMgt: Codeunit 408;
        Text011: Label 'XX';
        Text012: Label 'Customer Posting Group %1 does not exist.';
        Text014: Label 'You must enter a G/L account for customer posting group %1.';
        Text017: Label 'Source Code %1 does not exist.';
        HeaderAccountUsedGlobally: Boolean;
        Text018: Label 'You must specify a debit account number for step %1 of payment type %2.';
        Text019: Label 'You must specify a credit account number for step %1 of payment type %2.';
        Text020: Label 'You must specify an account number in the payment header.';
        PaymentClass: Record 50860;
        PayClass: Record 50861;
        NoSeriesMgt: Codeunit "No. Series";
        Statement: Record 50865;
        GLsetup: Record 98;
        GroupeRetenu: Record "WDC-ST Retained Group";
        Desc: Text[50];
        RecG_GroupeRetenue: Record "WDC-ST Retained Group";
        RecReasonCode: Record "WDC-ST Retained Group";
        "G/LAccount2": Record 15;
        Step1: Record 50862;
}