//****************Documentation**********************


tableextension 50034 "WDC Location" extends "Location"
{
    fields
    {
        field(50000; "Customer Mandatory"; Boolean)
        {
            CaptionML = ENU = 'Customer Mandatory', FRA = 'Client obligatoire';
            DataClassification = ToBeClassified;
        }
    }
}