namespace CRC.CRC;

using Microsoft.Purchases.History;
using Microsoft.Warehouse.Document;

pageextension 50058 "WDC Warehouse Receipt" extends "Warehouse Receipt"
{
    layout
    {
        addafter("Sorting Method")
        {
            field(Note; Rec.Note)
            {
                MultiLine = true;
                ApplicationArea = all;
            }
        }
    }
}
