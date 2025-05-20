table 50867 "WDC-ED Payment Header Archive"
{
    CaptionML = ENU = 'Payment Header Archive', FRA = 'En-tête bordereau';
    DrillDownPageID = "WDC-ED Pay. Slip List Archive";
    LookupPageID = "WDC-ED Pay. Slip List Archive";

    fields
    {
        field(1; "No."; Code[20])
        {
            CaptionML = ENU = 'No.', FRA = 'N°';
        }
        field(2; "Currency Code"; Code[10])
        {
            CaptionML = ENU = 'Currency Code', FRA = 'Code devise';
            TableRelation = Currency;
        }
        field(3; "Currency Factor"; Decimal)
        {
            CaptionML = ENU = 'Currency Factor', FRA = 'Facteur devise';
            DecimalPlaces = 0 : 15;
        }
        field(4; "Posting Date"; Date)
        {
            CaptionML = ENU = 'Posting Date', FRA = 'Date comptabilisation';
        }
        field(5; "Document Date"; Date)
        {
            CaptionML = ENU = 'Document Date', FRA = 'Date document';
        }
        field(6; "Payment Class"; Text[30])
        {
            CaptionML = ENU = 'Payment Class', FRA = 'Type de règlement';
            TableRelation = "WDC-ED Payment Class";
        }
        field(7; "Status No."; Integer)
        {
            CaptionML = ENU = 'Status No.', FRA = 'N° statut';
            TableRelation = "WDC-ED Payment Status"."Line No." WHERE("Payment Class" = FIELD("Payment Class"));
        }
        field(8; "Status Name"; Text[50])
        {
            CalcFormula = Lookup("WDC-ED Payment Status".Name WHERE("Payment Class" = FIELD("Payment Class"),
                                                              "Line No." = FIELD("Status No.")));
            CaptionML = ENU = 'Status Name', FRA = 'Nom statut';
            Editable = false;
            FieldClass = FlowField;
        }
        field(9; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            CaptionML = ENU = 'Shortcut Dimension 1 Code', FRA = 'Code raccourci axe 1';
        }
        field(10; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            CaptionML = ENU = 'Shortcut Dimension 2 Code', FRA = 'Code raccourci axe 2';
        }
        field(11; "Payment Class Name"; Text[100])
        {
            CalcFormula = Lookup("WDC-ED Payment Class".Name WHERE(Code = FIELD("Payment Class")));
            CaptionML = ENU = 'Payment Class Name', FRA = 'Nom type de règlement';
            Editable = false;
            FieldClass = FlowField;
        }
        field(12; "No. Series"; Code[20])
        {
            CaptionML = ENU = 'No. Series', FRA = 'Souches de n°';
        }
        field(13; "Source Code"; Code[10])
        {
            CaptionML = ENU = 'Source Code', FRA = 'Code journal';
            TableRelation = "Source Code";
        }
        field(14; "Account Type"; enum "Gen. Journal Account Type")
        {
            CaptionML = ENU = 'Account Type', FRA = 'Type compte';
        }
        field(15; "Account No."; Code[20])
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
        field(16; "Amount (LCY)"; Decimal)
        {
            CalcFormula = Sum("WDC-ED Payment Line Archive"."Amount (LCY)" WHERE("No." = FIELD("No.")));
            CaptionML = ENU = 'Amount (LCY)', FRA = 'Montant DS';
            Editable = false;
            FieldClass = FlowField;
        }
        field(17; Amount; Decimal)
        {
            CalcFormula = Sum("WDC-ED Payment Line Archive".Amount WHERE("No." = FIELD("No.")));
            CaptionML = ENU = 'Amount', FRA = 'Montant';
            Editable = false;
            FieldClass = FlowField;
        }
        field(18; "Bank Branch No."; Text[20])
        {
            CaptionML = ENU = 'Bank Branch No.', FRA = 'Code établissement';
        }
        field(19; "Bank Account No."; Text[30])
        {
            CaptionML = ENU = 'Bank Account No.', FRA = 'N° compte bancaire';
        }
        field(20; "Agency Code"; Text[20])
        {
            CaptionML = ENU = 'Agency Code', FRA = 'Code agence';
        }
        field(21; "RIB Key"; Integer)
        {
            CaptionML = ENU = 'RIB Key', FRA = 'Clé RIB';
        }
        field(22; "RIB Checked"; Boolean)
        {
            CaptionML = ENU = 'RIB Checked', FRA = 'Vérification RIB';
            Editable = false;
        }
        field(23; "Bank Name"; Text[100])
        {
            CaptionML = ENU = 'Bank Name', FRA = 'Nom de la banque';
        }
        field(24; "Bank Post Code"; Code[20])
        {
            CaptionML = ENU = 'Bank Post Code', FRA = 'Code postal banque';
            TableRelation = "Post Code";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(25; "Bank City"; Text[30])
        {
            CaptionML = ENU = 'Bank City', FRA = 'Ville banque';
        }
        field(26; "Bank Name 2"; Text[50])
        {
            CaptionML = ENU = 'Bank Name 2', FRA = 'Nom 2 banque';
        }
        field(27; "Bank Address"; Text[100])
        {
            CaptionML = ENU = 'Bank Address', FRA = 'Adresse banque';
        }
        field(28; "Bank Address 2"; Text[50])
        {
            CaptionML = ENU = 'Bank Address 2', FRA = 'Adresse banque (2ème ligne)';
        }
        field(29; "Bank Contact"; Text[100])
        {
            CaptionML = ENU = 'Bank Contact', FRA = 'Contact banque';
        }
        field(30; "Bank County"; Text[30])
        {
            CaptionML = ENU = 'Bank County', FRA = 'Région banque';
        }
        field(31; "Bank Country/Region Code"; Code[10])
        {
            CaptionML = ENU = 'Bank Country/Region Code', FRA = 'Code pays/région banque';
            TableRelation = "Country/Region";
        }
        field(32; "National Issuer No."; Code[6])
        {
            CaptionML = ENU = 'National Issuer No.', FRA = 'N° émetteur national';
            Numeric = true;
        }
        field(50; IBAN; Code[50])
        {
            CaptionML = ENU = 'IBAN', FRA = 'N° compte bancaire international';

            trigger OnValidate()
            var
                CompanyInfo: Record "Company Information";
            begin
                CompanyInfo.CheckIBAN(IBAN);
            end;
        }
        field(51; "SWIFT Code"; Code[20])
        {
            CaptionML = ENU = 'SWIFT Code', FRA = 'Code SWIFT';
        }
        field(480; "Dimension Set ID"; Integer)
        {
            CaptionML = ENU = 'Dimension Set ID', FRA = 'ID ensemble de dimensions';
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
        key(Key1; "No.")
        {
            Clustered = true;
        }
        key(Key2; "Posting Date")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "No.")
        {
        }
    }


    procedure ShowDimensions()
    var
        DimMgt: Codeunit DimensionManagement;
    begin
        DimMgt.ShowDimensionSet("Dimension Set ID", StrSubstNo('%1 %2', TableCaption, "No."));
    end;
}

