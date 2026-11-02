namespace CRC.CRC;

enum 50004 "WDC Tax Document Type"
{
    Extensible = true;
    value(0; "Sales Invoice")
    {
        CaptionML = ENU = 'Sales Invoice', FRA = 'Facture Vente';
    }


    value(1; "Sales Credit Memo")
    {
        CaptionML = ENU = 'Sales Credit Memo', FRA = 'Avoir Vente';
    }
    value(3; "Purchase Invoice")
    {
        CaptionML = ENU = 'Purchase Invoice', FRA = 'Facture Achat';
    }

    value(4; "Purchase Credit Memo")
    {
        CaptionML = ENU = 'Purchase Credit Memo', FRA = 'Avoir Achat';
    }

}
