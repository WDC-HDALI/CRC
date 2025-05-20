tableextension 54006 "WDC-ST Vendor Posting Group" extends "Vendor Posting Group"
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
        field(54002; "Fiscal Stamp Account No."; Code[20])
        {
            CaptionML = ENU = 'Fiscal Stamp Account No.', FRA = 'N° compte timbre fiscal';
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";

        }
    }

}