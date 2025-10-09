enum 54000 "WDC-ST Payment Slip Type"
{
    Extensible = true;
    value(0; " ")
    {
        CaptionML = ENU = ' ', FRA = ' ';
    }
    value(1; Cheque)
    {
        CaptionML = ENU = 'Cheque', FRA = 'Chèque';
    }
    value(2; Cash)
    {
        CaptionML = ENU = 'Cash', FRA = 'Espèce';
    }
    value(3; Draft)
    {
        CaptionML = ENU = 'Draft', FRA = 'Traite';
    }
    value(4; Transfer)
    {
        CaptionML = ENU = 'Transfer', FRA = 'Virement';
    }
    value(5; "Credit Letter")
    {
        CaptionML = ENU = 'Credit Letter', FRA = 'Lettre de crédit';
    }
    value(6; TPE)
    {
        CaptionML = ENU = 'TPE', FRA = 'TPE';
    }
    value(7; RS)
    {
        CaptionML = ENU = 'RS', FRA = 'RS';
    }
    value(8; Other)
    {
        CaptionML = ENU = 'Other', FRA = 'Autre';
    }
}