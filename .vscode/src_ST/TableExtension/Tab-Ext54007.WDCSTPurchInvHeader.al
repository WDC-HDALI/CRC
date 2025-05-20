tableextension 54007 "WDC-ST Purch. Inv. Header" extends "Purch. Inv. Header"
{
    fields
    {
        field(54001; "Stamp Amount"; Decimal)
        {
            CaptionML = ENU = 'Stamp Amount', FRA = 'Montant timbre fiscal';
            DataClassification = ToBeClassified;
        }
    }

}