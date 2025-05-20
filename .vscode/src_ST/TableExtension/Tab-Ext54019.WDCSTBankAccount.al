tableextension 54019 "WDC-ST Bank Account" extends "Bank Account"
{
    fields
    {
        field(54000; "Source Code"; Code[20])
        {
            CaptionML = ENU = 'Source Code', FRA = 'Code Origine';
            DataClassification = ToBeClassified;
            TableRelation = "Source Code";
        }
        field(54001; "Caisse Type"; Enum "WDC-ST Caisse Type")
        {
            CaptionML = ENU = 'Caisse Type', FRA = 'Type Caisse';
            DataClassification = ToBeClassified;
        }
        field(54002; "Modèle chèques"; Enum "WDC-ST Cheque Model")
        {
            CaptionML = ENU = 'Cheque Model', FRA = 'Modèle Chèques';
            DataClassification = ToBeClassified;
        }
        field(54003; "Nb Lines Deposit Pay. Slip"; Integer)
        {
            CaptionML = ENU = 'Nb Lines Deposit Pay. Slip', FRA = 'Nb ligne bord. versement';
            DataClassification = ToBeClassified;
        }
    }
}

