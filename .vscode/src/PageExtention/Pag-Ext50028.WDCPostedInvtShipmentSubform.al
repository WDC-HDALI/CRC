namespace CRC.CRC;
using Microsoft.Inventory.History;
//*****************Documentation**********************
//WDC01  HG  19/05/2025  Create current object
pageextension 50028 WDCPostedInvtShipmentSubform extends "Posted Invt. Shipment Subform"
{
    layout
    {
        addafter(Amount)
        {
            field("Line Discount %"; Rec."Line Discount %")
            {
                ApplicationArea = all;
            }
            field("Line Amount HT"; Rec."Line Amount HT")
            {
                ApplicationArea = All;
            }

            field("VAT %"; Rec."VAT %")
            {
                ApplicationArea = all;
                visible = false;
            }
            field("Amount Including VAT"; Rec."Amount Including VAT")
            {
                ApplicationArea = all;
                visible = false;
            }
            field("Line VAT Amount"; Rec."Line VAT Amount")
            {
                ApplicationArea = all;
                visible = false;
            }

        }
        modify("Unit Cost")
        {
            visible = false;
        }
        modify("Unit Amount")
        {
            CaptionML = ENU = 'Unit Amount HT', FRA = 'Montant unitaire HT';
        }
        moveafter(Description; "Unit of Measure Code")


    }

}
