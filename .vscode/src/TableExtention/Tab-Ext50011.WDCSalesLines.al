namespace CRC.CRC;

using Microsoft.Sales.Document;

tableextension 50011 "WDC Sales Lines" extends "Sales Line"
{
    fields
    {
        field(50000; "Assoc. Transport Line No."; Integer)
        {
            CaptionML = ENU = 'Assoc. Transport Line No.', FRA = 'N° ligne Transport associée';
            DataClassification = ToBeClassified;
        }
        field(50001; "Assoc. Royality Line No."; Integer)
        {
            CaptionML = ENU = 'Assoc. Royality Line No.', FRA = 'N° ligne Redevance associée';
            DataClassification = ToBeClassified;
        }
    }
}
