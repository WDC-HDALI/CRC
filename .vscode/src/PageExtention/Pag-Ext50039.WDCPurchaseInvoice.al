namespace CRC.CRC;

using Microsoft.Purchases.Document;
using System.Security.User;
using Microsoft.Purchases.History;

pageextension 50039 "WDC Purchase Invoice" extends "Purchase Invoice"
{
    layout
    {
        modify("Payment Method Code")
        {
            Editable = false;
        }
    }

}
