tableextension 54010 "WDC-ST General Ledger Setup" extends "General Ledger Setup"
{
    fields
    {
        field(54000; "Min RS Amount LCY"; Decimal)
        {
            CaptionML = ENU = 'Min RS Amount LCY', FRA = 'Montant retenue DS minimum';
            DataClassification = ToBeClassified;
        }
    }
}