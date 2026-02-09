tableextension 50029 "WDC Sales Line Discount" extends "Sales Line Discount"
{
    fields
    {
        field(50000; "Discount Ceiling %"; Decimal)
        {
            CaptionML = ENU = 'Discount Ceiling %', FRA = '% plafond remise';
            DataClassification = ToBeClassified;
        }
    }
}