//WDC01  WDC.HG  02/06/2025  Add New Action 
//wdc02  WDC.FS  18/06/2025 Hide Some Fields
//WDC03  WDC.HG  09/07/2025  show new fields 
pageextension 50040 "WDC Posted Sales Invoices" extends "Posted Sales Invoices"
{

    layout
    {   //<<WDC03

        addlast(Control1)
        {


            field(SystemCreatedAt; Rec.SystemCreatedAt)
            {
                ApplicationArea = all;
                Editable = false;
            }
        }
        //>>WDC03
        moveafter("Remaining Amount"; "Posting Date")
        moveafter("Remaining Amount"; "Due Date")
        addafter("Amount Including VAT")
        {
            field("Cash Payment"; Rec."Cash Payment")
            {
                ApplicationArea = All;
                DecimalPlaces = 0 : 5;
            }

            field("Cheque Payment"; Rec."Cheque Payment")
            {
                ApplicationArea = All;
                DecimalPlaces = 0 : 5;
            }
            field("Draft Payment"; Rec."Draft Payment")
            {
                ApplicationArea = All;
                DecimalPlaces = 0 : 5;
            }
            field("Transfer Payment"; Rec."Transfer Payment")
            {
                ApplicationArea = All;
                DecimalPlaces = 0 : 5;
            }
            field("RS Amount"; Rec."RS Amount")
            {
                ApplicationArea = All;
                DecimalPlaces = 0 : 5;
            }
            field("Cr. Memo Amount"; Rec."Cr. Memo Amount")
            {
                ApplicationArea = All;
                DecimalPlaces = 0 : 5;
            }
        }
        modify("Posting Date")
        {
            Visible = True;
        }
        modify("Shipping Agent Code")
        {
            Visible = false;
        }

        //<<wdc02
        modify("Bill-to Contact")
        {
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



        modify("Document Date")
        {
            Visible = false;
        }

        modify("Currency Code")
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

        modify("Bill-to Name")
        {
            Visible = false;
        }


        modify("Ship-to Name")
        {
            Visible = false;
        }
        modify("Shipment Method Code")
        {
            Visible = false;
        }

        modify("Ship-to Code")
        {
            Visible = false;
        }


        modify("Ship-to post Code")
        {
            Visible = false;
        }
        modify("Ship-to Country/Region Code")
        {
            Visible = false;
        }

        modify("Sell-to Post Code")
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


        modify("Bill-to Post Code")
        {

            Visible = false;
        }


        modify("Bill-to Country/Region Code")
        {

            Visible = false;
        }

        //>>wdc02


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

    trigger OnAfterGetRecord()
    begin
        CurrPage.Update(false);
    end;

    trigger OnOpenPage()
    begin
        rec.SetCurrentKey("Posting Date");
    end;

}