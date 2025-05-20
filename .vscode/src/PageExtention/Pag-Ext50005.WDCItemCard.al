namespace CRC.CRC;

using Microsoft.Warehouse.Setup;
using Microsoft.Inventory.Item;

pageextension 50005 "WDC Item Card" extends "Item Card"
{
    layout
    {
        modify("Created From Nonstock Item")
        {
            Visible = false;
        }
        modify("Stockkeeping Unit Exists")
        {
            Visible = false;
        }
        modify("Production BOM No.")
        {
            Visible = false;
        }
        modify("Routing No.")
        {
            Visible = false;
        }
        addafter(Inventory)
        {
            field("Sold Qty not Delivered"; Rec."Sold Qty not Delivered")
            {
                ApplicationArea = All;
            }
        }
        addafter("Base Unit of Measure")
        {
            field("Qty per Package"; Rec."Qty per Package")
            {
                ApplicationArea = All;
            }
        }
        addafter("Item Category Code")
        {
            field(SubCategorie; Rec.SubCategorie)
            {
                ApplicationArea = all;
            }
            field("Transport Item"; Rec."Transport Item")
            {
                ApplicationArea = All;
            }
            field("Associed Transport Item No."; Rec."Associed Transport Item No.")
            {
                ApplicationArea = All;
            }
            field("Transport Unit Price LCY"; Rec."Transport Unit Price LCY")
            {
                ApplicationArea = All;
            }
            field("Associated Royalty"; Rec."Associated Royalty")
            {
                ApplicationArea = All;
            }
            field("Royalty Unit Price LCY"; Rec."Royalty Unit Price LCY")
            {
                ApplicationArea = All;
            }
        }


    }

}
