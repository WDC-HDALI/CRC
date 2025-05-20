tableextension 50204 "WDC-TF Value Entry" extends "Value Entry"
{
    fields
    {
        field(50200; "Transit Folder No."; Code[20])
        {
            CaptionML = ENU = 'Transit Folder No.', FRA = 'N° dossier import';
            DataClassification = ToBeClassified;
            Editable = true;
        }
    }
}
