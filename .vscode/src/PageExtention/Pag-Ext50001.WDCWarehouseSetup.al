namespace CRC.CRC;

using Microsoft.Warehouse.Setup;

pageextension 50001 "WDC Warehouse Setup" extends "Warehouse Setup"
{
    layout
    {
        addlast(Numbering)
        {
            field("Customer Shipment Nos."; Rec."Customer Shipment Nos.")
            {
                ApplicationArea = All;
            }
        }
    }
}
