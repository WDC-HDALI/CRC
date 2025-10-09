namespace CRC.CRC;

using Microsoft.Warehouse.Setup;
using Microsoft.Inventory.Item;
//****************Documentation**********************
//wdc01  WDC.FS  19/06/2025 Hide Some Fields
pageextension 50004 "WDC Item List" extends "Item List"
{
    layout
    {
        modify("Created From Nonstock Item")
        {
            Visible = false;
        }
        modify("Substitutes Exist")
        {
            Visible = false;
        }
        modify("Stockkeeping Unit Exists")
        {
            Visible = false;
        }
        modify("Assembly BOM")
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
        //<<wdc01
        modify("Vendor No.")
        {
            Visible = false;
        }
        modify("unit Cost")
        {
            Visible = false;
        }
        modify("Default Deferral Template Code")
        {
            Visible = false;
        }
        modify("Cost is Adjusted")
        {
            Visible = false;
        }
        //>>wdc01
        addafter(InventoryField)
        {
            field("Sold Qty not Delivered"; Rec."Sold Qty not Delivered")
            {
                ApplicationArea = All;
            }
        }

    }
}
