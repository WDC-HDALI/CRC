pageextension 50020 "WDC Posted Sales Inv. - Update" extends "Posted Sales Inv. - Update"
//*****************Documentation*************************
//wdc01  WDC.FS  06/01/2026 add New fields
{
    layout
    {
        addafter("Posting Date")
        {
            field("Salesperson Code"; Rec."Salesperson Code")
            {
                ApplicationArea = all;
                Editable = SalesPersonIsEditable;

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
            //<<wdc01
            //field(ShippingAgentCode; Rec."Shipping Agent Code")
            //{
            //  CaptionML = FRA = 'N° camion';
            //ApplicationArea = All;
            //}
            //field(ShippingAgentServiceCode; Rec."Shipping Agent Service Code")
            //{
            //  CaptionML = FRA = 'Code chauffeur';
            // ApplicationArea = All;
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
    trigger OnOpenPage()
    var
    Begin
        UserSetup.Get(UserId());
        SalesPersonIsEditable := UserSetup."Allow Salesperson Edit";
    End;

    var
        SalesPersonIsEditable: Boolean;
        UserSetup: Record "User Setup";
}