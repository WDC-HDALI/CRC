table 50868 "WDC-ED Payment Line Archive"
{
    CaptionML = ENU = 'Payment Line Archive', FRA = 'Ligne bordereau';
    DrillDownPageID = "WDC-ED Pay. Lines Archive List";
    LookupPageID = "WDC-ED Pay. Lines Archive List";

    fields
    {
        field(1; "No."; Code[20])
        {
            CaptionML = ENU = 'No.', FRA = 'N°';
            TableRelation = "WDC-ED Payment Header Archive";
        }
        field(2; "Line No."; Integer)
        {
            CaptionML = ENU = 'Line No.', FRA = 'N° ligne';
        }
        field(3; Amount; Decimal)
        {
            CaptionML = ENU = 'Amount', FRA = 'Montant';
        }
        field(4; "Account Type"; enum "Gen. Journal Account Type")
        {
            CaptionML = ENU = 'Account Type', FRA = 'Type compte';
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
        }
        field(6; "Posting Group"; Code[20])
        {
            CaptionML = ENU = 'Posting Group', FRA = 'Groupe comptabilisation';
            Editable = true;
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
        }
        field(26; "Bank Branch No."; Text[20])
        {
            CaptionML = ENU = 'Bank Branch No.', FRA = 'Code établissement';
        }
        field(27; "Bank Account No."; Text[30])
        {
            CaptionML = ENU = 'Bank Account No.', FRA = 'N° compte bancaire';
        }
        field(28; "Agency Code"; Text[5])
        {
            CaptionML = ENU = 'Agency Code', FRA = 'Code agence';
        }
        field(29; "RIB Key"; Integer)
        {
            CaptionML = ENU = 'RIB Key', FRA = 'Clé RIB';
        }
        field(30; "RIB Checked"; Boolean)
        {
            CaptionML = ENU = 'RIB Checked', FRA = 'Vérification RIB';
            Editable = false;
        }
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
        }
        field(34; "Credit Amount"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            BlankZero = true;
            CaptionML = ENU = 'Credit Amount', FRA = 'Montant crédit';
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
        field(41; "Applies-to Doc. Type"; Option)
        {
            CaptionML = ENU = 'Applies-to Doc. Type', FRA = 'Type doc. lettrage';
            Editable = false;
            OptionCaptionML = ENU = ' ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder',
                              FRA = ' ,Paiement,Facture,Avoir,Intérêts,Relance';
            OptionMembers = " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder;
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
        }
        field(45; "Drawee Reference"; Text[10])
        {
            CaptionML = ENU = 'Drawee Reference', FRA = 'Référence tiré';
        }
        field(46; "Bank City"; Text[30])
        {
            CaptionML = ENU = 'Bank City', FRA = 'Ville banque';
        }
        field(48; "Posting Date"; Date)
        {
            CaptionML = ENU = 'Posting Date', FRA = 'Date comptabilisation';
        }
        field(50; "Payment in Progress"; Boolean)
        {
            CaptionML = ENU = 'Payment in Progress', FRA = 'Paiement en cours';
            Editable = false;
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
            SumIndexFields = Amount, "Amount (LCY)";
        }
        key(Key2; "Posting Date", "Document No.")
        {
        }
    }

    fieldgroups
    {
    }


    procedure ShowDimensions()
    var
        DimMgt: Codeunit DimensionManagement;
    begin
        DimMgt.ShowDimensionSet("Dimension Set ID", StrSubstNo('%1 %2 %3', TableCaption, "No.", "Line No."));
    end;
}

