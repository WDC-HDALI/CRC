enum 54013 "WDC-ST Payment Situation"
{
    CaptionML = ENU = 'Payment Situation', FRA = 'Situation de Paiement';

    value(0; " ")
    {
        CaptionML = ENU = ' ', FRA = ' ';
    }

    value(1; "En coffre")
    {
        CaptionML = ENU = 'In Safe', FRA = 'En coffre';
    }

    value(2; Encaissement)
    {
        CaptionML = ENU = 'Collection', FRA = 'Encaissement';
    }

    value(3; Escompte)
    {
        CaptionML = ENU = 'Discount', FRA = 'Escompte';
    }

    value(4; "Impayé")
    {
        CaptionML = ENU = 'Unpaid', FRA = 'Impayé';
    }

    value(5; Garantie)
    {
        CaptionML = ENU = 'Guarantee', FRA = 'Garantie';
    }

    value(6; Caution)
    {
        CaptionML = ENU = 'Deposit', FRA = 'Caution';
    }
}