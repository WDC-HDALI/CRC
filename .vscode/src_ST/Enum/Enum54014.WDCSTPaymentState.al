enum 54014 "WDC-ST Payment State"
{
    CaptionML = ENU = 'Payment State', FRA = 'Etat Paiement';

    value(0; Aucune)
    {
        CaptionML = ENU = 'None', FRA = 'Aucune';
    }

    value(1; Remis)
    {
        CaptionML = ENU = 'Submitted', FRA = 'Remis';
    }

    value(2; "Non Remis")
    {
        CaptionML = ENU = 'Not Submitted', FRA = 'Non Remis';
    }
}