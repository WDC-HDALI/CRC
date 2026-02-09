namespace CRC.CRC;

using Microsoft.Purchases.Document;
using System.Security.User;

pageextension 50041 WDCPurchaseOrder extends "Purchase Order"
{
    layout
    {
        addlast("Shipping and Payment")
        {
            group(ShippingInformations)
            {
                CaptionML = FRA = 'détails d''expédition ';
                field("Truck No."; Rec."Truck No.")
                {
                    ApplicationArea = all;
                }
                field("Shipping Agent No."; Rec."Shipping Agent No.")
                {
                    ApplicationArea = all;
                }
            }
        }
        modify("Ship-to Contact")
        {
            Visible = false;

        }
        modify("Ship-to Address 2")
        {
            Visible = false;

        }
        modify("Ship-to Country/Region Code")
        {
            Visible = false;

        }
        modify(Prepayment)
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
        modify("VAT Bus. Posting Group")
        {
            Editable = false;
        }

        modify("Creditor No.")
        {
            Visible = false;
        }
        modify("Foreign Trade")
        {
            Visible = false;
        }
    }
}
