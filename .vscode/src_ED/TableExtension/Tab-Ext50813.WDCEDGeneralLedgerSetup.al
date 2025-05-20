tableextension 50813 "WDC-ED General Ledger Setup" extends "General Ledger Setup"
{
    fields
    {
        field(50800; "Posting Allowed From"; Date)
        {
            CalcFormula = Min("Accounting Period"."Starting Date" WHERE("Fiscally Closed" = FILTER(false)));
            CaptionML = ENU = 'Posting Allowed From', FRA = 'Début validation autorisée';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50801; "Posting Allowed To"; Date)
        {
            CalcFormula = Max("Accounting Period"."Starting Date" WHERE("New Fiscal Year" = FILTER(true),
                                                                         "Fiscally Closed" = FILTER(false)));
            CaptionML = ENU = 'Posting Allowed To', FRA = 'Fin validation autorisée';
            Editable = false;
            FieldClass = FlowField;
        }

    }

}