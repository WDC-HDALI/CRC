tableextension 50209 "WDC-TF Purch. Inv. Header" extends "Purch. Inv. Header"
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
