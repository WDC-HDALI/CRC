namespace CRC.CRC;

enum 50001 "WDC Customer Delivery Status"
{
    Extensible = true;
    AssignmentCompatibility = true;

    value(0; Open)
    {
        CaptionML = ENU = 'Open', FRA = 'Ouvert';
    }


    value(1; "Partially delivered")
    {
        CaptionML = ENU = 'Partially delivered', FRA = 'Livrée partiellement';
    }
    value(2; "Tottaly delivered")
    {
        CaptionML = ENU = 'Tottaly delivered', FRA = 'Totalement livré';
    }

}