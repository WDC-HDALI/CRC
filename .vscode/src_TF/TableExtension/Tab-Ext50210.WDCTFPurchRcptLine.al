tableextension 50210 "WDC-TF Purch. Rcpt. Line" extends "Purch. Rcpt. Line"
{
    fields
    {
        field(50200; "Transit Folder No."; Code[20])
        {
            CaptionML = ENU = 'Transit Folder No.', FRA = 'N° dossier import';
            FieldClass = FlowField;
            CalcFormula = lookup("Purch. Rcpt. Header"."Transit Folder No." where("No." = field("Document No.")));
            TableRelation = "WDC-TF Transit Folder";
        }
        field(50201; "Tariff No."; code[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Tariff No.', FRA = 'Code NGP';
        }
        field(50202; "NGP Value"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'NGP Value', FRA = 'Valeur NGP';
        }
        field(50203; "Line NGP Value"; Integer)
        {
            CaptionML = ENU = 'Line NGP Value', FRA = 'Valeur NGP Ligne';
            DataClassification = ToBeClassified;
        }
        field(50204; Width; Decimal)
        {
            CaptionML = ENU = 'Width', FRA = 'Largeur';
            DataClassification = ToBeClassified;
        }
    }
}
