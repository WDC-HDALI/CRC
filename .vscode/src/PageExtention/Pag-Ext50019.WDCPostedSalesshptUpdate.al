pageextension 50019 "WDC Posted Sales shpt Update" extends "Posted Sales Shipment - Update"
//*****************Documentation*************************
//wdc01  WDC.FS  06/01/2026 add New fields
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

        addafter("Shipping Agent Code")
        {
            //<<wdc01
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
            field("Truck No."; Rec."Truck No.")
            {
                ApplicationArea = All;
                Editable = true;
            }
            field("Driver Name"; Rec."Driver Name")
            {
                ApplicationArea = All;
                Editable = true;
            }
            //>>wdc01
        }

    }
}