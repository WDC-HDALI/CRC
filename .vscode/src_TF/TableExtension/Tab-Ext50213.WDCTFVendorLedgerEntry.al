tableextension 50213 "WDC-TF Vendor Ledger Entry" extends "Vendor Ledger Entry"
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
