namespace CRC.CRC;

using Microsoft.Sales.Document;
using Microsoft.Purchases.History;
using Microsoft.Sales.History;

tableextension 50019 "WDC Sales Cr.Memo Header" extends "Sales Cr.Memo Header"
{
    fields
    {
        //   field(50000; Créé dans le sales shipment header)

        field(50001; "Invoiced Order No."; Code[20])
        {
            CaptionML = ENU = 'Invoiced Order No.', FRA = 'N° commande facturée';
            DataClassification = ToBeClassified;
        }
        // field(50009; Canceled; Boolean) //Reservéééééé

        //field(50010; "Replacment Invoice No."; Code[20]) //Reservéééééé
    }
}
