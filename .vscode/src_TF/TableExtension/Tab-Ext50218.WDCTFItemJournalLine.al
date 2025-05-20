tableextension 50218 "WDC-TF Item Journal Line" extends "Item Journal Line"
{
    fields
    {
        field(50200; "Transit Folder No."; Code[20])
        {
            CaptionML = ENU = 'Transit Folder No.', FRA = 'N° dossier import';
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }
}
