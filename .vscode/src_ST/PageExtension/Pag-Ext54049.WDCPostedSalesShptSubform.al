namespace CRC.CRC;

using Microsoft.Sales.History;

pageextension 54049 "WDC Posted Sales Shpt. Subform" extends "Posted Sales Shpt. Subform"
{
    layout
    {
        addafter("Quantity Invoiced")
        {
            field("Remain. Qty to Delivery"; Rec."Remain. Qty to Delivery")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Real Delivered Qty"; Rec."Real Delivered Qty")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
    }
}
