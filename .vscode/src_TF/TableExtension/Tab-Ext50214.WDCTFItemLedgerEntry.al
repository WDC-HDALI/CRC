tableextension 50214 "WDC-TF Item Ledger Entry" extends "Item Ledger Entry"
{
    fields
    {
        field(50200; "Transit Folder No."; Code[20])
        {
            CaptionML = ENU = 'Transit Folder No.', FRA = 'N° dossier import';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50201; "Item Charge Filter"; Code[20])
        {
            CaptionML = ENU = 'Item Charge Filter', FRA = 'Filtre frais article';
            FieldClass = FlowFilter;
        }
    }
}
