table 50866 "WDC-ED Payment Line"
{
    CaptionML = ENU = 'Payment Line', FRA = 'Ligne bordereau';
    DrillDownPageID = "WDC-ED Payment Lines List";
    LookupPageID = "WDC-ED Payment Lines List";

    fields
    {
        field(1; "No."; Code[20])
        {
            CaptionML = ENU = 'No.', FRA = 'N°';
            TableRelation = "WDC-ED Payment Header";
        }
        field(2; "Line No."; Integer)
        {
            CaptionML = ENU = 'Line No.', FRA = 'N° ligne';
        }
        field(3; Amount; Decimal)
        {
            CaptionML = ENU = 'Amount', FRA = 'Montant';

            trigger OnValidate()
            var
                CurrExchRate: Record "Currency Exchange Rate";
            begin
                if ((Amount > 0) and (not Correction)) or
                   ((Amount < 0) and Correction)
                then begin
                    "Debit Amount" := Amount;
                    "Credit Amount" := 0
                end else begin
                    "Debit Amount" := 0;
                    "Credit Amount" := -Amount;
                end;
                if "Currency Code" = '' then
                    "Amount (LCY)" := Amount
                else
                    "Amount (LCY)" := Round(
                        CurrExchRate.ExchangeAmtFCYToLCY(
                          "Posting Date", "Currency Code",
                          Amount, "Currency Factor"));
                if Amount <> xRec.Amount then;//FIXME:
            end;
        }
        field(4; "Account Type"; enum "Gen. Journal Account Type")
        {
            CaptionML = ENU = 'Account Type', FRA = 'Type compte';
            ValuesAllowed = Vendor, Customer, "G/L Account", "Bank Account";
            trigger OnValidate()
            begin
                UpdateEntry(false);
            end;
        }
        field(5; "Account No."; Code[20])
        {
            CaptionML = ENU = 'Account No.', FRA = 'N° compte';
            TableRelation = IF ("Account Type" = CONST("G/L Account")) "G/L Account"
            ELSE
            IF ("Account Type" = CONST(Customer)) Customer
            ELSE
            IF ("Account Type" = CONST(Vendor)) Vendor
            ELSE
            IF ("Account Type" = CONST("Bank Account")) "Bank Account"
            ELSE
            IF ("Account Type" = CONST("Fixed Asset")) "Fixed Asset";

            trigger OnValidate()
            begin
                UpdateEntry(false);
            end;
        }
        field(6; "Posting Group"; Code[20])
        {
            CaptionML = ENU = 'Posting Group', FRA = 'Groupe comptabilisation';
            Editable = false;
            TableRelation = IF ("Account Type" = CONST(Customer)) "Customer Posting Group"
            ELSE
            IF ("Account Type" = CONST(Vendor)) "Vendor Posting Group"
            ELSE
            IF ("Account Type" = CONST("Fixed Asset")) "FA Posting Group";
        }
        field(7; "Copied To No."; Code[20])
        {
            CaptionML = ENU = 'Copied To No.', FRA = 'N° destination';
        }
        field(8; "Copied To Line"; Integer)
        {
            CaptionML = ENU = 'Copied To Line', FRA = 'Ligne destination';
        }
        field(9; "Due Date"; Date)
        {
            CaptionML = ENU = 'Due Date', FRA = 'Date d''échéance';
        }
        field(10; "Acc. Type Last Entry Debit"; enum "Gen. Journal Account Type")
        {
            CaptionML = ENU = 'Acc. Type Last Entry Debit', FRA = 'Type compte écr. préc. débit';
            Editable = false;
        }
        field(11; "Acc. No. Last Entry Debit"; Code[20])
        {
            CaptionML = ENU = 'Acc. No. Last Entry Debit', FRA = 'N° cpte écr. préc. débit';
            Editable = false;
            TableRelation = IF ("Acc. Type Last Entry Debit" = CONST("G/L Account")) "G/L Account"
            ELSE
            IF ("Acc. Type Last Entry Debit" = CONST(Customer)) Customer
            ELSE
            IF ("Acc. Type Last Entry Debit" = CONST(Vendor)) Vendor
            ELSE
            IF ("Acc. Type Last Entry Debit" = CONST("Bank Account")) "Bank Account"
            ELSE
            IF ("Acc. Type Last Entry Debit" = CONST("Fixed Asset")) "Fixed Asset";
        }
        field(12; "Acc. Type Last Entry Credit"; enum "Gen. Journal Account Type")
        {
            CaptionML = ENU = 'Acc. Type Last Entry Credit', FRA = 'Type compte écr. préc. crédit';
            Editable = false;
        }
        field(13; "Acc. No. Last Entry Credit"; Code[20])
        {
            CaptionML = ENU = 'Acc. No. Last Entry Credit', FRA = 'N° compte écr. préc. crédit';
            Editable = false;
            TableRelation = IF ("Acc. Type Last Entry Credit" = CONST("G/L Account")) "G/L Account"
            ELSE
            IF ("Acc. Type Last Entry Credit" = CONST(Customer)) Customer
            ELSE
            IF ("Acc. Type Last Entry Credit" = CONST(Vendor)) Vendor
            ELSE
            IF ("Acc. Type Last Entry Credit" = CONST("Bank Account")) "Bank Account"
            ELSE
            IF ("Acc. Type Last Entry Credit" = CONST("Fixed Asset")) "Fixed Asset";
        }
        field(14; "P. Group Last Entry Debit"; Code[20])
        {
            CaptionML = ENU = 'P. Group Last Entry Debit', FRA = 'Groupe compta. écr. préc. débit';
            Editable = false;
        }
        field(15; "P. Group Last Entry Credit"; Code[20])
        {
            CaptionML = ENU = 'P. Group Last Entry Credit', FRA = 'Groupe compta. écr. préc. crédit';
            Editable = false;
        }
        field(16; "Payment Class"; Text[30])
        {
            CaptionML = ENU = 'Payment Class', FRA = 'Type de règlement';
            TableRelation = "WDC-ED Payment Class";
        }
        field(17; "Status No."; Integer)
        {
            CaptionML = ENU = 'Status No.', FRA = 'N° statut';
            Editable = false;
            TableRelation = "WDC-ED Payment Status"."Line No." WHERE("Payment Class" = FIELD("Payment Class"));

            trigger OnValidate()
            var
                PaymentStatus: Record "WDC-ED Payment Status";
            begin
                PaymentStatus.Get("Payment Class", "Status No.");
                "Payment in Progress" := PaymentStatus."Payment in Progress";
            end;
        }
        field(18; "Status Name"; Text[50])
        {
            CalcFormula = Lookup("WDC-ED Payment Status".Name WHERE("Payment Class" = FIELD("Payment Class"),
                                                              "Line No." = FIELD("Status No.")));
            CaptionML = ENU = 'Status Name', FRA = 'Nom statut';
            Editable = false;
            FieldClass = FlowField;
        }
        field(19; IsCopy; Boolean)
        {
            CaptionML = ENU = 'IsCopy', FRA = 'Copie';
        }
        field(20; "Currency Code"; Code[10])
        {
            CaptionML = ENU = 'Currency Code', FRA = 'Code devise';
            TableRelation = Currency;
        }
        field(21; "Entry No. Debit"; Integer)
        {
            CaptionML = ENU = 'Entry No. Debit', FRA = 'N° écriture débit';
            Editable = false;
        }
        field(22; "Entry No. Credit"; Integer)
        {
            CaptionML = ENU = 'Entry No. Credit', FRA = 'N° écriture crédit';
            Editable = false;
        }
        field(23; "Entry No. Debit Memo"; Integer)
        {
            CaptionML = ENU = 'Entry No. Debit Memo', FRA = 'N° écriture avoir débit';
            Editable = false;
        }
        field(24; "Entry No. Credit Memo"; Integer)
        {
            CaptionML = ENU = 'Entry No. Credit Memo', FRA = 'N° écriture avoir crédit';
            Editable = false;
        }
        field(25; "Bank Account Code"; Code[20])
        {
            CaptionML = ENU = 'Bank Account Code', FRA = 'Code compte bancaire';
            TableRelation = IF ("Account Type" = CONST(Customer)) "Customer Bank Account".Code WHERE("Customer No." = FIELD("Account No."))
            ELSE
            IF ("Account Type" = CONST(Vendor)) "Vendor Bank Account".Code WHERE("Vendor No." = FIELD("Account No."));

            trigger OnValidate()
            var

            begin
                if "Bank Account Code" <> '' then begin
                    if "Account Type" = "Account Type"::Customer then begin
                        CustomerBank.Get("Account No.", "Bank Account Code");
                        "Bank Branch No." := CustomerBank."Bank Branch No.";
                        "Bank Account No." := CustomerBank."Bank Account No.";
                        IBAN := CustomerBank.IBAN;
                        "SWIFT Code" := CustomerBank."SWIFT Code";
                        "Agency Code" := CustomerBank."Agency Code";
                        "Bank Account Name" := CustomerBank.Name;
                        "RIB Key" := CustomerBank."RIB Key";
                        //"RIB Checked" := RibKey.Check("Bank Branch No.", "Agency Code", "Bank Account No.", "RIB Key");
                        "Bank City" := CustomerBank.City;
                    end else
                        if "Account Type" = "Account Type"::Vendor then begin
                            VendorBank.Get("Account No.", "Bank Account Code");
                            "Bank Branch No." := VendorBank."Bank Branch No.";
                            "Bank Account No." := VendorBank."Bank Account No.";
                            IBAN := VendorBank.IBAN;
                            "Agency Code" := VendorBank."Agency Code";
                            "Bank Account Name" := VendorBank.Name;
                            "RIB Key" := VendorBank."RIB Key";
                            //"RIB Checked" := RibKey.Check("Bank Branch No.", "Agency Code", "Bank Account No.", "RIB Key");
                            "Bank City" := VendorBank.City;
                        end;
                end else
                    InitBankAccount;
            end;
        }
        field(26; "Bank Branch No."; Text[20])
        {
            CaptionML = ENU = 'Bank Branch No.', FRA = 'Code établissement';
            trigger OnValidate()
            begin
                //"RIB Checked" := RibKey.Check("Bank Branch No.", "Agency Code", "Bank Account No.", "RIB Key");
            end;
        }
        field(27; "Bank Account No."; Text[30])
        {
            CaptionML = ENU = 'Bank Account No.', FRA = 'N° compte bancaire';

            trigger OnValidate()
            begin
                //"RIB Checked" := RibKey.Check("Bank Branch No.", "Agency Code", "Bank Account No.", "RIB Key");
            end;
        }
        field(28; "Agency Code"; Text[5])
        {
            CaptionML = ENU = 'Agency Code', FRA = 'Code agence';

            trigger OnValidate()
            begin
                //"RIB Checked" := RibKey.Check("Bank Branch No.", "Agency Code", "Bank Account No.", "RIB Key");
            end;
        }
        field(29; "RIB Key"; Integer)
        {
            CaptionML = ENU = 'RIB Key', FRA = 'Clé RIB';

            trigger OnValidate()
            begin
                //"RIB Checked" := RibKey.Check("Bank Branch No.", "Agency Code", "Bank Account No.", "RIB Key");
            end;
        }
        // field(30; "RIB Checked"; Boolean)
        // {
        //     CaptionML = ENU = 'RIB Checked', FRA = 'Vérification RIB';
        //     Editable = false;
        // }
        field(31; "Acceptation Code"; Option)
        {
            CaptionML = ENU = 'Acceptation Code', FRA = 'Code acceptation';
            InitValue = No;
            OptionCaptionML = ENU = 'LCR,No,BOR,LCR NA', FRA = 'LCR,No,BOR,LCR NA';
            OptionMembers = LCR,No,BOR,"LCR NA";
        }
        field(32; "Document No."; Code[20])
        {
            CaptionML = ENU = 'Document No.', FRA = 'N° document';
        }
        field(33; "Debit Amount"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            BlankZero = true;
            CaptionML = ENU = 'Debit Amount', FRA = 'Montant débit';

            trigger OnValidate()
            begin
                GetCurrency;
                "Debit Amount" := Round("Debit Amount", Currency."Amount Rounding Precision");
                Correction := "Debit Amount" < 0;
                Validate(Amount, "Debit Amount");
            end;
        }
        field(34; "Credit Amount"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            BlankZero = true;
            CaptionML = ENU = 'Credit Amount', FRA = 'Montant crédit';

            trigger OnValidate()
            begin
                GetCurrency;
                "Credit Amount" := Round("Credit Amount", Currency."Amount Rounding Precision");
                Correction := "Credit Amount" < 0;
                Validate(Amount, -"Credit Amount");
            end;
        }
        field(35; "Applies-to ID"; Code[50])
        {
            CaptionML = ENU = 'Applies-to ID', FRA = 'ID lettrage';
        }
        field(36; "Currency Factor"; Decimal)
        {
            CaptionML = ENU = 'Currency Factor', FRA = 'Facteur devise';
            DecimalPlaces = 0 : 15;
        }
        field(37; Posted; Boolean)
        {
            CaptionML = ENU = 'Posted', FRA = 'Validé';
        }
        field(38; Correction; Boolean)
        {
            CaptionML = ENU = 'Correction', FRA = 'Correction';
            trigger OnValidate()
            begin
                Validate(Amount);
            end;
        }
        field(39; "Bank Account Name"; Text[100])
        {
            CaptionML = ENU = 'Bank Account Name', FRA = 'Nom compte bancaire';
        }
        field(40; "Payment Address Code"; Code[10])
        {
            CaptionML = ENU = 'Payment Address Code', FRA = 'Code adresse de règlement';
            TableRelation = "WDC-ED Payment Address".Code WHERE("Account Type" = FIELD("Account Type"),
                                                          "Account No." = FIELD("Account No."));
        }
        field(41; "Applies-to Doc. Type"; Enum "Gen. Journal Document Type")
        {
            CaptionML = ENU = 'Applies-to Doc. Type', FRA = 'Type doc. lettrage';
            Editable = false;
        }
        field(42; "Applies-to Doc. No."; Code[20])
        {
            CaptionML = ENU = 'Applies-to Doc. No.', FRA = 'N° doc. lettrage';
            Editable = false;
        }
        field(43; "External Document No."; Code[35])
        {
            CaptionML = ENU = 'External Document No.', FRA = 'N° doc. externe';
        }
        field(44; "Amount (LCY)"; Decimal)
        {
            CaptionML = ENU = 'Amount (LCY)', FRA = 'Montant DS';
            Editable = false;
        }
        field(45; "Drawee Reference"; Text[10])
        {
            CaptionML = ENU = 'Drawee Reference', FRA = 'Référence tiré';
        }
        field(46; "Bank City"; Text[30])
        {
            CaptionML = ENU = 'Bank City', FRA = 'Ville banque';
        }
        field(47; Marked; Boolean)
        {
            CaptionML = ENU = 'Marked', FRA = 'Marqué';
            Editable = false;
        }
        field(48; "Posting Date"; Date)
        {
            CaptionML = ENU = 'Posting Date', FRA = 'Date comptabilisation';
            Editable = false;
        }
        field(50; "Payment in Progress"; Boolean)
        {
            CaptionML = ENU = 'Payment in Progress', FRA = 'Paiement en cours';
            Editable = false;
        }
        field(51; "Created from No."; Code[20])
        {
            CaptionML = ENU = 'Created from No.', FRA = 'Créé à partir du n°';
        }
        field(55; IBAN; Code[50])
        {
            CaptionML = ENU = 'IBAN', FRA = 'N° compte international (IBAN)';

            trigger OnValidate()
            var
                CompanyInfo: Record "Company Information";
            begin
                CompanyInfo.CheckIBAN(IBAN);
            end;
        }
        field(56; "SWIFT Code"; Code[20])
        {
            CaptionML = ENU = 'SWIFT Code', FRA = 'Code SWIFT';
        }
        field(291; "Has Payment Export Error"; Boolean)
        {
            CalcFormula = Exist("Payment Jnl. Export Error Text" WHERE("Document No." = FIELD("No."),
                                                                        "Journal Line No." = FIELD("Line No.")));
            CaptionML = ENU = 'Has Payment Export Error', FRA = 'Présente erreur exportation paiement';
            Editable = false;
            FieldClass = FlowField;
        }
        field(480; "Dimension Set ID"; Integer)
        {
            CaptionML = ENU = 'Dimension Set ID', FRA = 'D ensemble de dimensions';
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup()
            begin
                ShowDimensions;
            end;
        }
    }

    keys
    {
        key(Key1; "No.", "Line No.")
        {
            Clustered = true;
            SumIndexFields = Amount;
        }
        key(Key2; "Copied To No.", "Copied To Line")
        {
        }
        key(Key3; "Account Type", "Account No.", "Copied To Line", "Payment in Progress")
        {
            SumIndexFields = "Amount (LCY)";
        }
        key(Key4; "No.", "Account No.", "Bank Branch No.", "Agency Code", "Bank Account No.", "Payment Address Code")
        {
        }
        key(Key5; "Posting Date", "Document No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        PaymentApply: Codeunit "WDC-ED Payment-Apply";
    begin
        if "Copied To No." <> '' then
            Error(Text001);
        PaymentApply.DeleteApply(Rec);
        DeletePaymentFileErrors;
    end;

    trigger OnInsert()
    var
        Statement: Record "WDC-ED Payment Header";
    begin
        Statement.Get("No.");
        Statement.TestField("File Export Completed", false);
        "Payment Class" := Statement."Payment Class";
        if (Statement."Currency Code" <> "Currency Code") and IsCopy then
            Error(Text000);
        "Currency Code" := Statement."Currency Code";
        "Currency Factor" := Statement."Currency Factor";
        "Posting Date" := Statement."Posting Date";
        Validate(Amount);
        Validate("Status No.");
        PaymentClass.Get(Statement."Payment Class");
        if PaymentClass."Line No. Series" = '' then
            "Document No." := Statement."No."
        else
            if "Document No." = '' then
                "Document No." := NoSeriesMgt.GetNextNo(PaymentClass."Line No. Series", "Posting Date", false);
        UpdateEntry(true);
    end;

    trigger OnModify()
    begin
        ModifyCheck;
    end;

    local procedure AddDocumentNoToList(var List: Text; DocumentNo: Code[35]; LenToCut: Integer)
    var
        Delimiter: Text[2];
        PrevLen: Integer;
    begin
        PrevLen := StrLen(List);
        if PrevLen <> 0 then
            Delimiter := ', ';
        List += Delimiter + DocumentNo;
        if (PrevLen <= LenToCut) and (StrLen(List) > LenToCut) then
            List := CopyStr(List, 1, PrevLen) + PadStr('', LenToCut - PrevLen) + CopyStr(List, PrevLen + StrLen(Delimiter) + 1);
    end;

    procedure SetUpNewLine(LastGenJnlLine: Record "WDC-ED Payment Line"; BottomLine: Boolean)
    var
        Statement: Record "WDC-ED Payment Header";
    begin
        "Account Type" := LastGenJnlLine."Account Type";
        if "No." <> '' then begin
            Statement.Get("No.");
            PaymentClass.Get(Statement."Payment Class");
            if PaymentClass."Line No. Series" = '' then
                "Document No." := Statement."No."
            else
                if "Document No." = '' then
                    if BottomLine then
                        "Document No." := IncStr(LastGenJnlLine."Document No.")
                    else
                        "Document No." := NoSeriesMgt.GetNextNo(PaymentClass."Line No. Series", "Posting Date", false);
        end;
        "Due Date" := Statement."Posting Date";
    end;

    procedure ShowDimensions()
    begin
        "Dimension Set ID" :=
          DimMgt.EditDimensionSet("Dimension Set ID", StrSubstNo('%1 %2 %3', TableCaption, "No.", "Line No."));
    end;

    procedure GetAppliedDocNoList(LenToCut: Integer) List: Text
    var
        CustLedgEntry: Record "Cust. Ledger Entry";
        VendLedgEntry: Record "Vendor Ledger Entry";
        DocumentNo: Code[35];
    begin
        if ("Applies-to Doc. No." = '') and ("Applies-to ID" = '') then
            exit('');
        case "Account Type" of
            "Account Type"::Customer:
                begin
                    CustLedgEntry.SetRange("Customer No.", "Account No.");
                    if "Applies-to Doc. No." <> '' then begin
                        CustLedgEntry.SetRange("Document Type", "Applies-to Doc. Type");
                        CustLedgEntry.SetRange("Document No.", "Applies-to Doc. No.");
                    end else
                        CustLedgEntry.SetRange("Applies-to ID", "Applies-to ID");
                    if CustLedgEntry.FindSet then
                        repeat
                            AddDocumentNoToList(List, CustLedgEntry."Document No.", LenToCut);
                        until CustLedgEntry.Next = 0;
                end;
            "Account Type"::Vendor:
                begin
                    VendLedgEntry.SetRange("Vendor No.", "Account No.");
                    if "Applies-to Doc. No." <> '' then begin
                        VendLedgEntry.SetRange("Document Type", "Applies-to Doc. Type");
                        VendLedgEntry.SetRange("Document No.", "Applies-to Doc. No.");
                    end else
                        VendLedgEntry.SetRange("Applies-to ID", "Applies-to ID");
                    if VendLedgEntry.FindSet then
                        repeat
                            if VendLedgEntry."External Document No." = '' then
                                DocumentNo := VendLedgEntry."Document No."
                            else
                                DocumentNo := VendLedgEntry."External Document No.";
                            AddDocumentNoToList(List, DocumentNo, LenToCut);
                        until VendLedgEntry.Next = 0;
                end;
            else
                exit('');
        end;
        exit(List);
    end;

    procedure GetAppliesToDocCustLedgEntry(var CustLedgEntry: Record "Cust. Ledger Entry")
    begin
        if "Account Type" <> "Account Type"::Customer then
            exit;

        CustLedgEntry.SetRange("Customer No.", "Account No.");
        CustLedgEntry.SetRange(Open, true);
        if "Applies-to Doc. No." <> '' then begin
            CustLedgEntry.SetRange("Document Type", "Applies-to Doc. Type");
            CustLedgEntry.SetRange("Document No.", "Applies-to Doc. No.");
            if CustLedgEntry.FindFirst then;
        end else
            if "Applies-to ID" <> '' then begin
                CustLedgEntry.SetRange("Applies-to ID", "Applies-to ID");
                if CustLedgEntry.FindSet then;
            end;
    end;

    procedure GetCurrency()
    var
        Header: Record "WDC-ED Payment Header";
    begin
        Header.Get("No.");
        if Header."Currency Code" = '' then begin
            Clear(Currency);
            Currency.InitRoundingPrecision;
        end else
            Currency.Get(Header."Currency Code");
    end;

    procedure InitBankAccount()
    begin
        "Bank Account Code" := '';
        "Bank Branch No." := '';
        "Bank Account No." := '';
        "Agency Code" := '';
        "RIB Key" := 0;
        //"RIB Checked" := false;
        "Bank Account Name" := '';
        "Bank City" := '';
        IBAN := '';
        "SWIFT Code" := '';
    end;

    procedure DimensionSetup()
    var
        DimManagt: Codeunit DimensionManagement;
    begin
        if "Line No." <> 0 then begin
            Clear(DefaultDimension);
            DefaultDimension.SetRange("Table ID", DimManagt.TypeToTableID1("Account Type".AsInteger()));
            DimensionCreate;
        end;
    end;

    procedure DimensionCreate()
    var
        TempDimSetEntry: Record "Dimension Set Entry" temporary;
        DimSetEntry: Record "Dimension Set Entry";
        DimValue: Record "Dimension Value";
        PaymentHeader: Record "WDC-ED Payment Header";
    begin
        DefaultDimension.SetRange("No.", "Account No.");
        DefaultDimension.SetFilter("Dimension Value Code", '<>%1', '');
        if DefaultDimension.Find('-') then
            repeat
                DimValue.Get(DefaultDimension."Dimension Code", DefaultDimension."Dimension Value Code");
                TempDimSetEntry."Dimension Code" := DimValue."Dimension Code";
                TempDimSetEntry."Dimension Value Code" := DimValue.Code;
                TempDimSetEntry."Dimension Value ID" := DimValue."Dimension Value ID";
                TempDimSetEntry.Insert();
            until DefaultDimension.Next = 0;

        PaymentHeader.SetRange("No.", "No.");
        PaymentHeader.FindFirst;

        DimSetEntry.SetRange("Dimension Set ID", PaymentHeader."Dimension Set ID");
        if DimSetEntry.FindSet then
            repeat
                TempDimSetEntry := DimSetEntry;
                TempDimSetEntry."Dimension Set ID" := 0;
                if not TempDimSetEntry.Modify then
                    TempDimSetEntry.Insert();
            until DimSetEntry.Next = 0;

        "Dimension Set ID" := DimMgt.GetDimensionSetID(TempDimSetEntry);
    end;

    procedure DeletePaymentFileErrors()
    var
        GenJnlLine: Record "Gen. Journal Line";
    begin
        GenJnlLine."Journal Template Name" := '';
        GenJnlLine."Journal Batch Name" := Format(DATABASE::"WDC-ED Payment Header");
        GenJnlLine."Document No." := "No.";
        GenJnlLine."Line No." := "Line No.";
        GenJnlLine.DeletePaymentFileErrors;
    end;


    procedure UpdateDueDate(DocumentDate: Date)
    var
        PaymentTerms: Record "Payment Terms";
        PaymentHeader: Record "WDC-ED Payment Header";
    begin
        if "Status No." > 0 then
            exit;
        if DocumentDate = 0D then begin
            PaymentHeader.Get("No.");
            DocumentDate := PaymentHeader."Posting Date";
            if DocumentDate = 0D then
                exit;
        end;
        Clear(PaymentTerms);
        if "Account Type" = "Account Type"::Customer then begin
            if "Account No." <> '' then begin
                Customer.Get("Account No.");
                if not PaymentTerms.Get(Customer."Payment Terms Code") then
                    "Due Date" := PaymentHeader."Posting Date";
            end
        end else
            if "Account Type" = "Account Type"::Vendor then
                if "Account No." <> '' then begin
                    Vendor.Get("Account No.");
                    if not PaymentTerms.Get(Vendor."Payment Terms Code") then
                        "Due Date" := PaymentHeader."Posting Date";
                end;
        if PaymentTerms.Code <> '' then
            "Due Date" := CalcDate(PaymentTerms."Due Date Calculation", DocumentDate);
    end;

    procedure UpdateEntry(InsertRecord: Boolean)
    var
        PaymentAddress: Record "WDC-ED Payment Address";
        GLAccount: Record "G/L Account";
        BankAccount: Record "Bank Account";
        FixedAsset: Record "Fixed Asset";
    begin
        if (xRec."Line No." <> 0) and ("Account Type" <> xRec."Account Type") then begin
            if not InsertRecord then begin
                "Account No." := '';
                InitBankAccount;
                "Due Date" := 0D;
            end;
            "Dimension Set ID" := 0;
        end;
        if "Account No." = '' then begin
            InitBankAccount;
            "Due Date" := 0D;
            "Dimension Set ID" := 0;
            exit;
        end;
        if (xRec."Line No." = "Line No.") and (xRec."Account No." <> '') and ("Account No." <> xRec."Account No.") then begin
            InitBankAccount;
            "Dimension Set ID" := 0;
        end;
        if (xRec."Line No." = "Line No.") and (xRec."Account Type" = "Account Type") and (xRec."Account No." = "Account No.") then
            exit;
        case "Account Type" of
            "Account Type"::"G/L Account":
                begin
                    GLAccount.Get("Account No.");
                    GLAccount.TestField("Account Type", GLAccount."Account Type"::Posting);
                    GLAccount.TestField(Blocked, false);
                end;
            "Account Type"::Customer:
                begin
                    Customer.Get("Account No.");
                    if Customer."Privacy Blocked" then
                        Customer.FieldError("Privacy Blocked");

                    if Customer.Blocked in [Customer.Blocked::All] then
                        Customer.FieldError(Blocked);
                    if "Bank Account Code" = '' then
                        if Customer."Preferred Bank Account Code" <> '' then
                            Validate("Bank Account Code", Customer."Preferred Bank Account Code");
                    if not InsertRecord then
                        UpdateDueDate(0D);
                end;
            "Account Type"::Vendor:
                begin
                    Vendor.Get("Account No.");
                    Vendor.TestField(Blocked, Vendor.Blocked::" ");
                    Vendor.TestField("Privacy Blocked", false);
                    if "Bank Account Code" = '' then
                        if Vendor."Preferred Bank Account Code" <> '' then
                            Validate("Bank Account Code", Vendor."Preferred Bank Account Code");
                    if not InsertRecord then
                        UpdateDueDate(0D);
                end;
            "Account Type"::"Bank Account":
                begin
                    BankAccount.Get("Account No.");
                    BankAccount.TestField(Blocked, false);
                end;
            "Account Type"::"Fixed Asset":
                begin
                    FixedAsset.Get("Account No.");
                    FixedAsset.TestField(Blocked, false);
                end;
        end;
        DimensionSetup;
        PaymentAddress.SetRange("Account Type", "Account Type");
        PaymentAddress.SetRange("Account No.", "Account No.");
        PaymentAddress.SetRange("Default Value", true);
        if PaymentAddress.FindFirst then
            "Payment Address Code" := PaymentAddress.Code
        else
            "Payment Address Code" := '';
    end;

    procedure ModifyCheck()
    begin
        if Posted then
            Error(Text002);
    end;

    var
        Currency: Record Currency;
        CustomerBank: Record "Customer Bank Account";
        VendorBank: Record "Vendor Bank Account";
        PaymentClass: Record "WDC-ED Payment Class";
        Customer: Record Customer;
        Vendor: Record Vendor;
        DefaultDimension: Record "Default Dimension";
        RibKey: Codeunit "WDC-ED RIB Key";
        NoSeriesMgt: Codeunit "No. Series";
        PaymentToleranceMgt: Codeunit "Payment Tolerance Management";
        DimMgt: Codeunit DimensionManagement;
        Text000: TextConst ENU = 'You cannot use different currencies on the same payment header.',
                           FRA = 'Vous ne pouvez pas utiliser différentes devises sur le même bordereau.';
        Text001: TextConst ENU = 'You cannot delete this payment line.',
                           FRA = 'Vous ne pouvez pas supprimer cette ligne de paiement.';
        Text002: TextConst ENU = 'You cannot modify this payment line.',
                           FRA = 'Vous ne pouvez pas modifier cette ligne de paiement.';
        BankAccErr: TextConst ENU = 'You must use customer bank account, %1, which you specified in the selected direct debit mandate.',
                              FRA = 'Vous devez utiliser le compte bancaire du client, %1, que vous avez spécifié dans le mandat de prélèvement sélectionné.';
}

