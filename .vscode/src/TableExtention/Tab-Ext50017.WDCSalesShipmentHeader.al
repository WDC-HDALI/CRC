namespace CRC.CRC;

using Microsoft.Sales.History;

tableextension 50017 "WDC Sales Shipment Header" extends "Sales Shipment Header"
{
    fields
    {
        field(50000; "Partially Delivered"; Boolean)
        {
            CaptionML = ENU = 'Partially Delivered', FRA = 'Partiellement livrée';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = exist("Sales Shipment Line" where("Document No." = field("No."),
            "Remain. Qty to Delivery" = filter(<> 0)));
        }
        field(50001; "Invoiced Order No."; Code[20])
        {
            CaptionML = ENU = 'Invoiced Order No.', FRA = 'N° commande facturée';
            DataClassification = ToBeClassified;
        }
    }
}
