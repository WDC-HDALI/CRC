tableextension 50203 "WDC-TF Item Charge Assi (Pur)" extends "Item Charge Assignment (Purch)"
{
    fields
    {
        field(50200; "Transit Folder No."; Code[20])
        {
            CaptionML = ENU = 'Transit Folder No.', FRA = 'N° dossier import';
            DataClassification = ToBeClassified;
            TableRelation = "WDC-TF Transit Folder";
        }
        field(50201; "Applies-to Doc. Line NGP"; Decimal)
        {
            CaptionML = ENU = 'Applies-to Doc. Line NGP', FRA = 'Doc. lettrage NGP  ligne';
            DataClassification = ToBeClassified;
            AutoFormatType = 1;
        }
    }
}
