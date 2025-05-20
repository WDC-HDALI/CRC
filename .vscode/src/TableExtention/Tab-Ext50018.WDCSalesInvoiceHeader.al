namespace CRC.CRC;

using Microsoft.Sales.Document;
using Microsoft.Sales.History;

tableextension 50018 "WDC Sales Invoice Header" extends "Sales Invoice Header"
{
    fields
    {
        //   field(50000; Créé dans le sales shipment header)

        field(50001; "Invoiced Order No."; Code[20])
        {
            CaptionML = ENU = 'Invoiced Order No.', FRA = 'N° commande facturée';
            DataClassification = ToBeClassified;
        }
    }
}
