
enum 54006 "WDC-ST Payment Object"
{
    CaptionML = ENU = 'Payment Object', FRA = 'Objet de Paiement';

    value(0; " ")
    {
        CaptionML = ENU = ' ', FRA = ' ';
    }

    value(1; Travel)
    {
        CaptionML = ENU = 'Travel', FRA = 'Déplacement';
    }

    value(2; Advance)
    {
        CaptionML = ENU = 'Advance', FRA = 'Avance';
    }

    value(3; Loan)
    {
        CaptionML = ENU = 'Loan', FRA = 'Prêt';
    }

    value(4; "Invoice Payment")
    {
        CaptionML = ENU = 'Invoice Payment', FRA = 'Réglement facture';
    }

    value(5; Miscellaneous)
    {
        CaptionML = ENU = 'Miscellaneous', FRA = 'Divers';
    }
}