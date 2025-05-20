tableextension 50201 "WDC-TF Purch. Cr. Memo Line" extends "Purch. Cr. Memo Line"
{
    fields
    {
        field(50200; "Transit Folder No."; Code[20])
        {
            CaptionML = ENU = 'Transit Folder No.', FRA = 'N° dossier import';
            FieldClass = FlowField;
            CalcFormula = lookup("Purch. Cr. Memo Hdr."."Transit Folder No." where("No." = field("Document No.")));
            TableRelation = "WDC-TF Transit Folder";
            Editable = false;
        }
    }
}
