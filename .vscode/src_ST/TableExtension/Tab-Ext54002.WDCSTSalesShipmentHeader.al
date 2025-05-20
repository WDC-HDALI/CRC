tableextension 54002 "WDC-ST Sales Shipment Header" extends "Sales Shipment Header"
{
    fields
    {
        field(54000; "Apply Fiscal Stamp"; Boolean)
        {
            CaptionML = ENU = 'Apply Fiscal Stamp', FRA = 'Appliquer timbre fiscal';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(54001; "Stamp Amount"; Decimal)
        {
            CaptionML = ENU = 'Stamp Amount', FRA = 'Montant timbre fiscal';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(54004; "% Prep. Amount"; Decimal)
        {
            CaptionML = ENU = '% Prep. Amount', FRA = '% Prep. Montant';
            DataClassification = ToBeClassified;
            MaxValue = 100;
            MinValue = 0;
        }
        field(54005; "Prep. Amount"; Decimal)
        {
            CaptionML = ENU = 'Prep. Amount', FRA = 'Montant Prep.';
            DataClassification = ToBeClassified;
        }
        field(54006; "Payment Amount (LCY)"; Decimal)
        {
            CaptionML = ENU = 'Payment Amount (LCY)', FRA = 'Montant paiement (LCY)';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = - Sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" WHERE("Commande No." = FIELD("No.")));

        }
    }
}