enum 54005 "WDC-ST Payment Amount Type"
{
    CaptionML = ENU = 'Payment Type', FRA = 'Type paiement';

    value(0; Paiement)
    {
        CaptionML = ENU = 'Payment', FRA = 'Paiement';
    }
    value(1; Avance)
    {
        CaptionML = ENU = 'Advance', FRA = 'Avance';
    }
}