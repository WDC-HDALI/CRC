tableextension 54018 "WDC-ST Payment Class" extends "WDC-ED Payment Class"
{
    fields
    {
        field(54001; "Header Account Type"; Enum "WDC-ST Header Account Type")
        {
            CaptionML = ENU = 'Header Account Type', FRA = 'Type compte Entête';
            DataClassification = ToBeClassified;
        }
        field(54002; Observation; Text[100])
        {
            CaptionML = ENU = 'Observation', FRA = 'Observation';
            DataClassification = ToBeClassified;
        }
        field(54003; "Payment Method Code"; Code[10])
        {
            CaptionML = ENU = 'Payment Method Code', FRA = 'Code mode règlement';
            DataClassification = ToBeClassified;
            TableRelation = "Payment Method".Code;
        }
        field(54004; "Payment Methode Type"; Enum "WDC-ST Payment Slip Type")
        {
            CaptionML = ENU = 'Payment Methode Type', FRA = 'Type paiement';
            DataClassification = ToBeClassified;
        }
        field(54009; "Small expense"; Boolean)
        {
            CaptionML = ENU = 'Small expense', FRA = 'Petite dépense';
            DataClassification = ToBeClassified;
        }
        field(54010; "ED Type"; Enum "WDC-ST ED Type")
        {
            CaptionML = ENU = 'ED Type', FRA = 'Type ED';
            DataClassification = ToBeClassified;
        }
        field(54011; "Default Caisse"; Enum "WDC-ST Caisse Type")
        {
            CaptionML = ENU = 'Default Caisse', FRA = 'Caisse par défaut';
            DataClassification = ToBeClassified;
        }
        field(54012; "Line Account Type"; Enum "WDC-ST Line Account Type")
        {
            CaptionML = ENU = 'Line Account Type', FRA = 'Type compte ligne';
            DataClassification = ToBeClassified;
        }

    }
}

