tableextension 50211 "WDC-TF Purch. Rcpt. Header" extends "Purch. Rcpt. Header"
{
    fields
    {
        field(50200; "Transit Folder No."; Code[20])
        {
            CaptionML = ENU = 'Transit Folder No.', FRA = 'N° dossier import';
            DataClassification = ToBeClassified;
            TableRelation = "WDC-TF Transit Folder";
            Editable = false;
        }
    }
}
