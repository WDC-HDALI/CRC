tableextension 54000 "WDC-ST Customer Posting Group" extends "Customer Posting Group"
{

    fields
    {
        field(54000; "Stamp Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Stamp Amount', FRA = 'Montant timbre';
        }
        field(54001; "Apply Fiscal Stamp"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Apply the stamp', FRA = 'Appliquer timbre';
        }
        field(54002; "Fiscal Stamp Account No."; Code[20])
        {
            CaptionML = ENU = 'Fiscal Stamp Account No.', FRA = 'N° Compte Timbre Fiscal';
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
    }
}