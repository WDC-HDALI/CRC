namespace MESSEM.MESSEM;

enum 50910 "WDC-ED Document Type"
{
    Extensible = true;
    value(0; " ")
    {
        CaptionML = ENU = ' ', FRA = ' ';
    }
    value(1; "Payment")
    {
        CaptionML = ENU = 'Payment', FRA = 'Paiement';
    }
    value(2; "Invoice")
    {
        CaptionML = ENU = 'Invoice', FRA = 'Facture';
    }
    value(3; "Credit Memo")
    {
        CaptionML = ENU = 'Credit Memo', FRA = 'Avoir';
    }
    value(4; "Finance Charge Memo")
    {
        CaptionML = ENU = 'Finance Charge Memo', FRA = 'Intérêts';
    }
    value(5; "Reminder")
    {
        CaptionML = ENU = 'Reminder', FRA = 'Relance';
    }
    value(6; "Refund")
    {
        CaptionML = ENU = 'Refund', FRA = 'Remboursement';
    }
}
