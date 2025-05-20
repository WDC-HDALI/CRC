tableextension 54010 "WDC-ST General Ledger Setup" extends "General Ledger Setup"
{
    fields
    {
        field(54000; "Default RS"; Code[20])
        {
            CaptionML = ENU = 'Default RS', FRA = 'RS par défaut';
            DataClassification = CustomerContent;
            TableRelation = "WDC-ST Retained Group".Code;
        }
    }

}