namespace CRC.CRC;

using Microsoft.Sales.Document;

tableextension 50016 "WDC Sales Header" extends "Sales Header"
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
