//*****************Documentation*************************
//wdc01  WDC.HG  03/07/2025 add New field Destination
//wdc02  WDC.FS  06/01/2026 add New fields
pageextension 50014 "WDC Posted Sales Shpt" extends "Posted Sales Shipment"
{
    layout
    {
        modify("Shipping Agent Code")
        {
            Visible = false;
        }
        modify("Shipping Agent Service Code")
        {
            Visible = false;
        }

        addafter("Shipment Method Code")
        {
            //field(ShippingAgentCode; Rec."Shipping Agent Code")
            //{
            //    CaptionML = FRA = 'N° camion';
            //    ApplicationArea = All;
            //}
            //field(ShippingAgentServiceCode; Rec."Shipping Agent Service Code")
            //{
            //    CaptionML = FRA = 'Code chauffeur';
            //    ApplicationArea = All;
            //}
            //<<wdc02
            field("Truck No."; Rec."Truck No.")
            {
                ApplicationArea = All;
            }
            field("Driver Name"; Rec."Driver Name")
            {
                ApplicationArea = All;
            }
            //>>wdc02
        }
        //<<WDC01
        addafter("Shipping Agent Service Code")
        {
            field(DestinationAddress; Rec.DestinationAddress)
            {
                ApplicationArea = all;
            }

        }
        //<<WDC01
    }
}