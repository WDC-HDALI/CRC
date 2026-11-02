namespace CRC.CRC;

using Microsoft.Purchases.Document;
using System.Security.User;
using Microsoft.Purchases.History;

pageextension 50052 "WDC Purchase Credit Memo" extends "Purchase Credit Memo"
{
    layout
    {
        modify("Payment Method Code")
        {
            Editable = false;
        }
    }

}
