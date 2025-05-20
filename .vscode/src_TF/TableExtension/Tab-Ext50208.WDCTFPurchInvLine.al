tableextension 50208 "WDC-TF Purch. Inv. Line" extends "Purch. Inv. Line"
{
    fields
    {
        field(50200; "Transit Folder No."; Code[20])
        {
            CaptionML = ENU = 'Transit Folder No.', FRA = 'N° dossier import';
            FieldClass = FlowField;
            CalcFormula = lookup("Purch. Inv. Header"."Transit Folder No." where("No." = field("Document No.")));
            TableRelation = "WDC-TF Transit Folder";
        }
    }
}
