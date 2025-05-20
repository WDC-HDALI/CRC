tableextension 50217 "WDC-TF Gen. Journal Line" extends "Gen. Journal Line"
{
    fields
    {
        field(50200; "Transit Folder No."; Code[20])
        {
            CaptionML = ENU = 'Transit Folder No.', FRA = 'N° Dossier';
            DataClassification = ToBeClassified;
            Editable = true;
        }
    }
}
