namespace CRC.CRC;

page 50002 "WDC Customer Delivery Lines"
{
    ApplicationArea = All;
    CaptionML = ENU = 'Customer Delivery Lines', FRA = 'Lignes livraison client';
    PageType = ListPart;
    SourceTable = "WDC Customer Shipment Lines";
    InsertAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                CaptionML = ENU = 'General', FRA = 'Général';
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
