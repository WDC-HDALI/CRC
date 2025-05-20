tableextension 54024 "WDC-ST Payment Step" extends "WDC-ED Payment Step"
{

    fields
    {
        field(54000; "Mandatory Header Bank"; Boolean)
        {
            CaptionML = ENU = 'Mandatory Header Bank', FRA = 'Banque Entête Obligatoire';
            DataClassification = ToBeClassified;

        }

        field(54002; "Mandatory Reason Code"; Boolean)
        {
            CaptionML = ENU = 'Mandatory Reason Code', FRA = 'Code Motif Obligatoire';
            DataClassification = ToBeClassified;

        }
        field(54003; "Cash Balance Check"; Boolean)
        {
            CaptionML = ENU = 'Cash Balance Check', FRA = 'Controle Solde Caisse';
            DataClassification = ToBeClassified;
        }
        field(54004; "Mandatory Ext. Doc No."; Boolean)
        {
            CaptionML = ENU = 'Mandatory Ext. Doc No.', FRA = 'N° Document Externe Obligatoire';
            DataClassification = ToBeClassified;
        }
        field(54005; "Mandatory Bank Line"; Boolean)
        {
            CaptionML = ENU = 'Mandatory Bank Line', FRA = 'Ligne Banque Obligatoire';
            DataClassification = ToBeClassified;
        }
        field(54006; "Mandatory Drawer"; Boolean)
        {
            CaptionML = ENU = 'Mandatory Drawer', FRA = 'Tireur Obligatoire';
            DataClassification = ToBeClassified;

        }
        field(54007; "Mandatory Draw"; Boolean)
        {
            CaptionML = ENU = 'Mandatory Draw', FRA = 'Tiré Obligatoire';
            DataClassification = ToBeClassified;

        }
        field(54009; "Origin Payment Slip"; Boolean)
        {
            CaptionML = ENU = 'Origin Payment Slip', FRA = 'Bordereau Origine';
            DataClassification = ToBeClassified;

        }

    }
}

