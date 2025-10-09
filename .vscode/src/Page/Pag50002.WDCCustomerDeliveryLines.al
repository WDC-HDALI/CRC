namespace CRC.CRC;

page 50035 "WDC Customer Delivery Lines"
{
    ApplicationArea = All;
    Caption = 'Customer Delivery Lines';
    PageType = List;
    SourceTable = "WDC Customer Shipment Lines";
    InsertAllowed = false;
    UsageCategory = Administration;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                CaptionML = ENU = 'General', FRA = 'Général';
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Description"; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Quantity"; Rec.Quantity)
                {
                    ApplicationArea = All;
                }
                field("Unit of Measure"; Rec."Unit of Measure")
                {

                    ApplicationArea = All;
                }
                field("Qty to Ship"; Rec."Qty to Ship")
                {
                    ApplicationArea = All;
                    Editable = Rec.Quantity > Rec."Qty Shipped";
                }
                field("Qty Shipped"; Rec."Qty Shipped")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
