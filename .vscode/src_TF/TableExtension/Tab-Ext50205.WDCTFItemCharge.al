tableextension 50205 "WDC-TF Item Charge" extends "Item Charge"
{
    fields
    {
        field(50200; "Dossier Import"; Boolean)
        {
            Caption = 'Dossier Import';
            DataClassification = ToBeClassified;
        }
        field(50201; Assignable; Boolean)
        {
            CaptionML = ENU = 'Assignable', FRA = 'Affectable';
            DataClassification = ToBeClassified;
        }
        field(50202; "Folder filter"; Code[20])
        {
            CaptionML = ENU = 'Folder filter', FRA = 'Filtre Dossier';
            FieldClass = FlowFilter;
        }
        field(50203; "Invoiced Charge"; Decimal)
        {
            CaptionML = ENU = 'Invoiced Charge', FRA = 'Frais Facturés';
            FieldClass = FlowField;
            CalcFormula = Sum("Value Entry"."Cost Amount (Actual)" WHERE("Item Charge No." = FIELD("No."), "Transit Folder No." = FIELD("Folder filter")));
        }

    }
}
