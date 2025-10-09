namespace CRC.CRC;

enum 50002 "WDC Payment Statut"
{
    Extensible = true;
    AssignmentCompatibility = true;
    value(0; " ")
    {
        CaptionML = ENU = ' ', FRA = ' ';
    }

    value(1; PayementToCollect)
    {
        CaptionML = ENU = 'payment to be collected', FRA = 'paiement à encaisser';
    }


    value(2; "Bank payment")
    {
        CaptionML = ENU = 'Bank payment', FRA = 'Paiement en banque';
    }

}
