namespace CRC.CRC;

using Microsoft.Inventory.Document;
//*****************Documentation**********************
//WDC01  HG  16/05/2025  Create current object
pageextension 50027 "WDC InvtShipmentSubform" extends "Invt. Shipment Subform"
{

    layout
    {
        addafter(Amount)
        {
            field("Line Discount %"; Rec."Line Discount %")
            {
                ApplicationArea = all;
                trigger OnValidate()
                begin
                    CurrPage.update(true);
                end;
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
            Visible = false;
        }
        modify("Item No.")
        {
            trigger OnAfterValidate()
            begin
                CurrPage.Update();
            end;
        }
        modify("Unit Amount")
        {
            CaptionML = ENU = 'Unit Amount HT', FRA = 'Montant unitaire HT';
            trigger OnAfterValidate()
            begin
                CurrPage.Update();
            end;

        }
        modify("Amount")
        {
            trigger OnAfterValidate()
            begin
                CurrPage.Update();
            end;
        }
        modify("Quantity")
        {
            trigger OnAfterValidate()
            begin
                CurrPage.Update();
            end;
        }
        moveafter(Description; "Unit of Measure Code")

    }


}
