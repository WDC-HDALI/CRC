tableextension 50220 "WDC-TF Detail Vendo Ledg.Entry" extends "Detailed Vendor Ledg. Entry"
{
    fields
    {
        field(50200; "Transit Folder No."; Code[20])
        {
            CaptionML = ENU = 'Transit Folder No.', FRA = 'N° dossier';
            DataClassification = ToBeClassified;
            TableRelation = "WDC-TF Transit Folder";
            Editable = true;
        }
    }
}

