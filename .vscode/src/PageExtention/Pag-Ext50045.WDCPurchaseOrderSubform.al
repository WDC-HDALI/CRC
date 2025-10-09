namespace CRC.CRC;

using Microsoft.Purchases.Document;
using System.Security.User;
//***************Documentation*************************
//WDC01  WDC.HG  25/06/2025  Create Current Object

pageextension 50045 "WDC Purchase Order Subform" extends "Purchase Order Subform"
{
    layout
    {
        modify("Unit Cost (LCY)")
        {
            Visible = DisplayCost;
        }
        modify("Line Amount")
        {
            Visible = DisplayCost;
        }
        modify("Direct Unit Cost")
        {
            Visible = DisplayCost;
        }
        modify(AmountBeforeDiscount)
        {
            Visible = DisplayCost;
        }
        modify("Invoice Discount Amount")
        {
            Visible = DisplayCost;
        }
        modify("Invoice Disc. Pct.")
        {
            Visible = DisplayCost;
        }
        modify("Total Amount Excl. VAT")
        {
            Visible = DisplayCost;
        }
        modify("Total VAT Amount")
        {
            Visible = DisplayCost;
        }
        modify("Total Amount Incl. VAT")
        {
            Visible = DisplayCost;
        }
        modify("Bin Code")
        {
            Visible = false;
        }
    }

    trigger OnOpenPage()
    var
        usersetup: record "User Setup";
    begin
        usersetup.reset();
        if usersetup.get(UserId) then
            DisplayCost := usersetup."Display Purchase Cost";
    end;

    var
        DisplayCost: Boolean;
}
