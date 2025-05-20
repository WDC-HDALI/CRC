tableextension 54008 "WDC-ST-ST Customer" extends "Customer"
{
    fields
    {
        field(54000; "CIN"; Code[8])
        {
            CaptionML = ENU = 'CIN', FRA = 'CIN';
            DataClassification = CustomerContent;

        }
    }

}