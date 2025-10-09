namespace CRC.CRC;

using Microsoft.Sales.History;

page 50002 "WDC Upd Sales Shipment Line"
{
    ApplicationArea = All;
    Caption = 'WDC Upd Sales Shipment Line';
    PageType = List;
    SourceTable = "Sales Shipment Line";
    UsageCategory = Lists;
    Permissions = tabledata "Sales Shipment Line" = rimd;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                }
                field("Order No."; Rec."Order No.")
                {
                    ApplicationArea = All;
                }
                field("Order Line No."; Rec."Order Line No.")
                {
                    ApplicationArea = All;
                }
                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                    ApplicationArea = All;
                }
                field("Qty. Shipped Not Invoiced"; Rec."Qty. Shipped Not Invoiced")
                {
                    ApplicationArea = All;
                }
                field("Remain. Qty to Delivery"; Rec."Remain. Qty to Delivery")
                {
                    ApplicationArea = All;
                    Editable = true;
                }
            }
        }
    }
}
