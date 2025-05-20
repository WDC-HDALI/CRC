enum 54007 "WDC-ST Payment Justificatifs"
{
    CaptionML = ENU = 'Payment Justificatifs', FRA = 'Justificatifs de Paiement';

    value(0; " ")
    {
        CaptionML = ENU = ' ', FRA = ' ';
    }

    value(1; Invoice)
    {
        CaptionML = ENU = 'Invoice', FRA = 'Facture';
    }

    value(2; "Mission Order")
    {
        CaptionML = ENU = 'Mission Order', FRA = 'Ordre de mission';
    }
}