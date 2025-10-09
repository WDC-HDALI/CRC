pageextension 50020 "WDC Posted Sales Inv. - Update" extends "Posted Sales Inv. - Update"
{
    layout
    {
        addafter("Posting Date")
        {
            field("Salesperson Code"; Rec."Salesperson Code")
            {
                ApplicationArea = all;

            }
        }
        modify("Sell-to Customer Name")
        {
            Editable = true;
        }
        // addafter("Sell-to Customer Name")
        // {
        //     field("Bill-to Name"; Rec."Bill-to Name")
        //     {
        //         ApplicationArea = all;
        //     }
        // }
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

    }
}