tableextension 54001 "WDC-ST Sales Header" extends "Sales Header"
{
    fields
    {
        field(54000; "Apply Fiscal Stamp"; Boolean)
        {
            CaptionML = ENU = 'Apply the stamp', FRA = 'Appliquer timbre fiscal';
            DataClassification = ToBeClassified;
            Editable = false;
            trigger OnValidate()
            var
                lCustomerPostingGroup: Record "Customer Posting Group";
            begin
                IF "Apply Fiscal Stamp" = FALSE THEN
                    "Stamp Amount" := 0
                ELSE BEGIN
                    lCustomerPostingGroup.GET("Customer Posting Group");
                    IF lCustomerPostingGroup."Apply Fiscal Stamp" THEN
                        "Stamp Amount" := lCustomerPostingGroup."Stamp Amount";
                END
            end;
        }
        field(54001; "Stamp Amount"; Decimal)
        {
            CaptionML = ENU = 'Stamp Amount', FRA = 'Montant timbre';
            DataClassification = ToBeClassified;
            Editable = false;
        }

        field(54004; "% Prep. Amount"; Decimal)
        {
            CaptionML = ENU = '% Prep. Amount', FRA = '% Prep. Montant';
            DataClassification = ToBeClassified;
            MaxValue = 100;
            MinValue = 0;
            trigger OnValidate()
            begin
                TESTFIELD(Status, Status::Open);
                CALCFIELDS("Amount Including VAT");
                "Prep. Amount" := ROUND((("Amount Including VAT" + "Stamp Amount") * "% Prep. Amount" / 100), 0.001, '=');
            end;
        }
        field(54005; "Prep. Amount"; Decimal)
        {
            CaptionML = ENU = 'Prep. Amount', FRA = 'Montant Prep.';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                TESTFIELD(Status, Status::Open);
                CALCFIELDS("Amount Including VAT");
                "% Prep. Amount" := ROUND(("Prep. Amount" / ("Amount Including VAT" + "Stamp Amount")), 0.001, '=') * 100;
            end;
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