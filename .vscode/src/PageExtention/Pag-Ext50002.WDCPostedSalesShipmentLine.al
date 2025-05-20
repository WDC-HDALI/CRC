pageextension 50002 "WDC Posted Sales Shipment Line" extends "Posted Sales Shipment Lines"
{
    layout
    {
        addafter(Quantity)
        {
            field("Real Delivered Qty"; Rec."Real Delivered Qty")
            {
                BlankZero = true;
                ApplicationArea = All;
            }
            field("Remain. Qty to Delivery"; Rec."Remain. Qty to Delivery")
            {
                BlankZero = true;
                ApplicationArea = All;
            }
        }
    }
}