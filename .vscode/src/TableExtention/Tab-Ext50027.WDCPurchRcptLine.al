//**************Documentation**************
// WDC.FS 09/06/2025: Add fields
tableextension 50027 "WDC Purch. Rcpt. Line" extends "Purch. Rcpt. Line"
{
    fields
    {
        field(50000; "Unité de réception"; Code[20])
        {
            CaptionML = ENU = 'Receiving Unit', FRA = 'Unité de réception';
            DataClassification = ToBeClassified;
            TableRelation = "Unit of Measure";

        }
        field(50001; "Qté de réception"; Integer)
        {
            CaptionML = ENU = 'Receiving Qty', FRA = 'Qté de réception';
            DataClassification = ToBeClassified;
        }

    }
}
