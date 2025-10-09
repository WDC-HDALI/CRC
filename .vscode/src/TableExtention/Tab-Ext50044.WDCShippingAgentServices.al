namespace CRC.CRC;

using Microsoft.Foundation.Shipping;

tableextension 50044 "WDC Shipping Agent Services" extends "Shipping Agent Services"
{
    fields
    {
        field(50000; "Company Transporter"; Boolean)
        {
            CaptionML = ENU = 'Company Transporter', FRA = 'Transporteur de l''entreprise';
            DataClassification = ToBeClassified;
        }
    }
}
