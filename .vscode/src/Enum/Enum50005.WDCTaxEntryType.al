namespace CRC.CRC;

enum 50005 "WDC Tax Entry Type"
{
    Extensible = true;

    value(0; "Sales")
    {
        CaptionML = ENU = 'Sales', FRA = 'Vente';
    }

    value(1; "Purchase")
    {
        CaptionML = ENU = 'Purchase', FRA = 'Achat';
    }

}
