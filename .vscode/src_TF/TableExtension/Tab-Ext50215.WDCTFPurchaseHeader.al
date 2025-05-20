tableextension 50215 "WDC-TF Purchase Header" extends "Purchase Header"
{
    fields
    {

        field(50200; "Transit Folder No."; code[20])
        {
            TableRelation = "WDC-TF Transit Folder"."No." where(Statut = filter(<> Closed));
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Transit Folder No.', FRA = 'N° dossier import';
        }
    }
}
