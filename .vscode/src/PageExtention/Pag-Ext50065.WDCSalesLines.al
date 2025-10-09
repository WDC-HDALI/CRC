namespace CRC.CRC;

using Microsoft.Sales.Document;

pageextension 50065 "WDC Sales Lines" extends "Sales Lines"
{
    layout
    {
        addafter("Line Amount")
        {
            field("Location Item Inventory"; Rec."Location Item Inventory")
            {
                ApplicationArea = all;
            }
        }
    }

}
