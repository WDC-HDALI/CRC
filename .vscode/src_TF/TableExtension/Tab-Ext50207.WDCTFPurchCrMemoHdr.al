tableextension 50207 "WDC-TF Purch. Cr. Memo Hdr." extends "Purch. Cr. Memo Hdr."
{
    fields
    {
        field(50200; "Transit Folder No."; Code[20])
        {
            CaptionML = ENU = 'Transit Folder No.', FRA = 'N° dossier import';
            DataClassification = ToBeClassified;
            TableRelation = "WDC-TF Transit Folder";
            Editable = False;
        }
    }
}
