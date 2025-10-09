namespace CRC.CRC;

using Microsoft.Purchases.Document;

pageextension 50052 "WDC Purchase Credit Memo" extends "Purchase Credit Memo"
{
    layout
    {
        modify("Payment Method Code")
        {
            Editable = false;
        }
    }
    trigger OnOpenPage()
    begin
        rec.SetCurrentKey("Posting Date");
    end;
}
