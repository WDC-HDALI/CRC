tableextension 54003 "WDC-ST Sales Invoice Header" extends "Sales Invoice Header"
{
    fields
    {
        field(54000; "Apply Fiscal Stamp"; Boolean)
        {
            CaptionML = ENU = 'Apply Fiscal Stamp', FRA = 'Appliquer timbre fiscal';
            DataClassification = ToBeClassified;

        }
        field(54001; "Stamp Amount"; Decimal)
        {
            CaptionML = ENU = 'Stamp Amount', FRA = 'Montant timbre fiscal';
            DataClassification = ToBeClassified;
        }
        field(54100; "Date Filter"; Date)
        {
            CaptionML = ENU = 'Date Filter', FRA = 'Filtre de date';
            FieldClass = FlowFilter;
        }

    }

}