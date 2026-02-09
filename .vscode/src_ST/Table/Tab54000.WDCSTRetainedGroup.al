table 54000 "WDC-ST Retained Group"
{
    DrillDownPageID = "WDC-ST Retained Group";
    LookupPageID = "WDC-ST Retained Group";

    fields
    {
        field(1; "Code"; Code[20])
        {
            CaptionML = ENU = 'Code', FRA = 'Code';
        }
        field(2; Description; Text[100])
        {
            CaptionML = ENU = 'Description', FRA = 'Description';
        }
        field(3; "Retention %"; Decimal)
        {
            CaptionML = ENU = 'Retention %', FRA = '% Retenue';
            DecimalPlaces = 2 : 2;
        }
        field(4; "Retention Account No."; Code[20])
        {
            CaptionML = ENU = 'Retention Account No.', FRA = 'N° Compte Retenue';
            TableRelation = "G/L Account";
        }
        field(5; "Type Retenue"; Option)
        {
            CaptionML = ENU = 'Retention Type', FRA = 'Type Retenue';
            OptionCaption = 'à la source,de garantie';
            OptionMembers = "à la source","de garantie";
        }

        field(6; Active; Boolean)
        {
            CaptionML = ENU = 'Active', FRA = 'Actif';
            DataClassification = ToBeClassified;
        }
        field(7; "RS Type"; Enum "WDC-ST RS Type")
        {
            CaptionML = ENU = 'RS Type', FRA = 'Type RS';
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Type Retenue", "Code")
        {
            Clustered = true;
        }
        key(Key2; "Code")
        {
        }
    }

}

