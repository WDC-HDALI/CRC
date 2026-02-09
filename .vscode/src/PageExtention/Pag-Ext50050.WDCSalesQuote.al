//****************Documentation**********************
//wdc01  WDC.FS  18/06/2025 Hide Some Fields
pageextension 50050 "WDC Sales Quote" extends "Sales Quote"
{
    layout
    {

        addafter("Sell-to Post Code")
        {
            field("Sell-to Phone No."; Rec."Sell-to Phone No.")
            {
                ApplicationArea = all;
            }
            field("VAT Registration No."; Rec."VAT Registration No.")
            {
                ApplicationArea = all;
            }
        }
        modify("Sell-to Customer No.")
        {
            ShowMandatory = true;
        }
        modify("Sell-to Customer Name")
        {
            ShowMandatory = true;
        }
        modify("Sell-to Address")
        {
            ShowMandatory = true;
        }
        modify("Shipping Agent Code")
        {
            Visible = false;
        }
        modify("Shipping Agent Service Code")
        {
            Visible = false;
        }
        modify("Prices Including VAT")
        {
            Visible = false;
        }
        //<<wdc01
        modify("Bill-to Contact")
        {
            Visible = false;
        }
        modify(SellToMobilePhoneNo)
        {
            Editable = True;
            Visible = false;
        }
        modify(SellToPhoneNo)
        {
            Editable = True;
            Visible = false;
        }
        modify("Sell-to Contact")
        {
            Visible = false;
        }
        modify("Ship-to Contact")
        {
            Visible = false;
        }
        modify("Sell-to Country/Region Code")
        {
            Visible = false;
        }

        modify("Order Date")
        {
            Visible = false;
        }
        modify("Due Date")
        {
            Visible = false;
        }
        modify("Your Reference")
        {
            Visible = false;
        }
        modify("opportunity No.")
        {
            Visible = false;
        }
        modify("Responsibility Center")
        {
            Visible = false;
        }
        modify("Assigned User ID")
        {
            Visible = false;
        }
        modify("Sell-to County")
        {
            Visible = false;
        }
        modify("Sell-to Address 2")
        {
            Visible = false;
        }
        modify("No. of Archived Versions")
        {
            Visible = false;
        }
        modify("Document Date")
        {
            Visible = false;
        }
        modify("Work Description")
        {
            Visible = false;
        }
        modify("Currency Code")
        {
            Visible = false;
        }
        modify("Company bank account Code")
        {
            Visible = false;
        }

        modify("EU 3-Party Trade")
        {
            Visible = false;
        }
        modify("SelectedPayments")
        {
            Visible = false;
        }
        modify("Shortcut Dimension 1 Code")
        {
            Visible = false;
        }
        modify("Shortcut Dimension 2 Code")
        {
            Visible = false;
        }
        modify("Payment Discount %")
        {
            Visible = false;
        }
        modify("pmt. Discount Date")
        {
            Visible = false;
        }

        modify("ShippingOptions")
        {
            Visible = false;
        }

        modify("Sell-to Contact No.")
        {
            Visible = false;
        }
        modify("Foreign Trade")
        {
            Visible = false;
        }

        modify("Ship-to Phone No.")
        {
            Visible = false;
        }
        modify("Campaign No.")
        {
            Visible = false;
        }

        modify("Package Tracking No.")
        {
            Visible = false;
        }
        modify("BillToOptions")
        {
            Visible = false;
        }
        modify("Location Code")
        {
            Visible = false;
        }
        modify("Shipment Date")
        {
            Visible = false;
        }

        modify("Payment Method Code")
        {

            Visible = false;
        }
        //>>wdc01
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

    }


}