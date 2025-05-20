table 50870 "WDC-ED Payment Address"
{
    CaptionML = ENU = 'Payment Address', FRA = 'Adresse de règlement';
    DrillDownPageID = "WDC-ED Payment Addresses";
    LookupPageID = "WDC-ED Payment Addresses";

    fields
    {
        field(1; "Account Type"; enum "Gen. Journal Account Type")
        {
            CaptionML = ENU = 'Account Type', FRA = 'Type compte';
        }
        field(2; "Account No."; Code[20])
        {
            CaptionML = ENU = 'Account No.', FRA = 'N° compte';
            TableRelation = IF ("Account Type" = CONST(Customer)) Customer
            ELSE
            IF ("Account Type" = CONST(Vendor)) Vendor;
        }
        field(3; "Code"; Code[10])
        {
            CaptionML = ENU = 'Code', FRA = 'Code';
        }
        field(4; Name; Text[50])
        {
            CaptionML = ENU = 'Name', FRA = 'Nom';

            trigger OnValidate()
            begin
                if ("Search Name" = UpperCase(xRec.Name)) or ("Search Name" = '') then
                    "Search Name" := Name;
            end;
        }
        field(5; "Search Name"; Code[50])
        {
            CaptionML = ENU = 'Search Name', FRA = 'Nom de recherche';
        }
        field(6; "Name 2"; Text[50])
        {
            CaptionML = ENU = 'Name 2', FRA = 'Nom 2';
        }
        field(7; Address; Text[50])
        {
            CaptionML = ENU = 'Address', FRA = 'Adresse';
        }
        field(8; "Address 2"; Text[50])
        {
            CaptionML = ENU = 'Address 2', FRA = 'Adresse (2ème ligne)';
        }
        field(9; "Post Code"; Code[20])
        {
            CaptionML = ENU = 'Post Code', FRA = 'Code postal';
            TableRelation = IF ("Country/Region Code" = CONST('')) "Post Code"
            ELSE
            IF ("Country/Region Code" = FILTER(<> '')) "Post Code" WHERE("Country/Region Code" = FIELD("Country/Region Code"));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                PostCode.ValidatePostCode(City, "Post Code", County, "Country/Region Code", (CurrFieldNo <> 0) and GuiAllowed);
            end;
        }
        field(10; City; Text[30])
        {
            CaptionML = ENU = 'City', FRA = 'Ville';
            TableRelation = IF ("Country/Region Code" = CONST('')) "Post Code".City
            ELSE
            IF ("Country/Region Code" = FILTER(<> '')) "Post Code".City WHERE("Country/Region Code" = FIELD("Country/Region Code"));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                PostCode.ValidatePostCode(City, "Post Code", County, "Country/Region Code", (CurrFieldNo <> 0) and GuiAllowed);
            end;
        }
        field(11; Contact; Text[50])
        {
            CaptionML = ENU = 'Contact', FRA = 'Contact';
        }
        field(12; "Country/Region Code"; Code[10])
        {
            CaptionML = ENU = 'Country/Region Code', FRA = 'Code pays/région';
            TableRelation = "Country/Region";
        }
        field(13; County; Text[30])
        {
            CaptionML = ENU = 'County', FRA = 'Région';
        }
        field(20; "Default Value"; Boolean)
        {
            CaptionML = ENU = 'Default Value', FRA = 'Valeur par défaut';

            trigger OnValidate()
            var
                PaymentAddress: Record "WDC-ED Payment Address";
            begin
                if "Default Value" then begin
                    PaymentAddress.SetRange("Account Type", "Account Type");
                    PaymentAddress.SetRange("Account No.", "Account No.");
                    PaymentAddress.SetFilter(Code, '<>%1', Code);
                    PaymentAddress.ModifyAll("Default Value", false, false);
                end;
            end;
        }
    }

    keys
    {
        key(Key1; "Account Type", "Account No.", "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        PostCode: Record "Post Code";
}

