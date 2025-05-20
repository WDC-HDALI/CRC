tableextension 54012 "WDC-ST Vendor" extends "Vendor"
{
    fields
    {

        field(54001; "RS Code"; Code[20])
        {
            CaptionML = ENU = 'RS Code', FRA = 'Code RS';
            TableRelation = "WDC-ST Retained Group".Code;
            DataClassification = CustomerContent;

        }
        field(54002; "Exempt RS"; Boolean)
        {
            CaptionML = ENU = 'Exempt RS', FRA = 'Exonoré RS';
            DataClassification = CustomerContent;

        }
        field(54003; "CIN"; Code[8])
        {
            CaptionML = ENU = 'CIN', FRA = 'CIN';
            DataClassification = CustomerContent;

        }
    }

}