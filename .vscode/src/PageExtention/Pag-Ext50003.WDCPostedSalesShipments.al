pageextension 50003 "WDC Posted Sales Shipments" extends "Posted Sales Shipments"
{
    layout
    {
        modify("Shipping Agent Code")
        {
            ShowCaption = false;
        }
        modify("Shipping Agent Service Code")
        {
            ShowCaption = false;
        }

        addafter("Shipment Method Code")
        {
            field(ShippingAgentCode; Rec."Shipping Agent Code")
            {
                CaptionML = FRA = 'N° camion';
                ApplicationArea = All;
            }
            field(ShippingAgentServiceCode; Rec."Shipping Agent Service Code")
            {
                CaptionML = FRA = 'Code chauffeur';
                ApplicationArea = All;
            }
        }
        addbefore("Currency Code")
        {
            field("Partially Delivered"; Rec."Partially Delivered")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
    }
}