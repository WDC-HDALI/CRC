namespace CRC.CRC;

using Microsoft.Warehouse.Setup;
using Microsoft.Foundation.NoSeries;

tableextension 50001 "WDC Warehouse Setup" extends "Warehouse Setup"
{
    fields
    {
        field(50000; "Customer Shipment Nos."; Code[20])
        {
            CaptionML = ENU = 'Customer Shipment Nos.', FRA = 'N° expédition client';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
    }
}
