namespace CRC.CRC;

using Microsoft.Sales.History;

tableextension 50012 "WDC Sales Shipment Line" extends "Sales Shipment Line"
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
        field(50900; "Qty Totally Delivered"; Boolean)
        {
            CaptionML = ENU = 'Qty Totally Delivered', FRA = 'Qté totalement livrée';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50901; "Real Delivered Qty"; Decimal)
        {
            CaptionML = ENU = 'Real Delivered Qty', FRA = 'Qté réellement livrée';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(50902; "Remain. Qty to Delivery"; Decimal)
        {
            CaptionML = ENU = 'Remain. Qty to Delivery', FRA = 'Qté reste à livrer';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
    }
    keys
    {
        key("Remain. Qty to Delivery"; "Qty Totally Delivered")
        {
        }
    }
}
