tableextension 50206 "WDC-TF Purch. & Payables Setup" extends "Purchases & Payables Setup"
{
    fields
    {
        field(50200; "Transit Folder Nos."; Code[20])
        {
            CaptionML = ENU = 'Transit Folder Nos.', FRA = 'N° Souche dossier import';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
    }
}
