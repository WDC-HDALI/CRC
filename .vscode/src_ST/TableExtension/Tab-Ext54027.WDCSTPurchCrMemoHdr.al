tableextension 54027 "WDC-ST Purch. Cr. Memo Hdr." extends "Purch. Cr. Memo Hdr."
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
    }

}