namespace CRC.CRC;

using Microsoft.Warehouse.Setup;
using Microsoft.Inventory.Item;

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
        addafter(InventoryField)
        {
            field("Sold Qty not Delivered"; Rec."Sold Qty not Delivered")
            {
                ApplicationArea = All;
            }
        }
    }
}
