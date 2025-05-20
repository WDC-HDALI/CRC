enum 50201 "WDC-TF Dossier Import Status"
{
    Extensible = true;

    value(0; Open)
    {
        captionML = ENU = 'Open', FRA = 'Ouvert';
    }
    value(1; "Goods Receipt")
    {
        captionML = ENU = 'Goods received', FRA = 'Marchandise reçue';
    }
    value(2; Invoiced)
    {
        captionML = ENU = 'Invoiced', FRA = 'Facturé';
    }
    value(3; Closed)
    {
        captionML = ENU = 'Closed', FRA = 'Clôturé';
    }
}
