
enum 50905 "WDC-ED Action Type"
{
    Extensible = true;
    value(0; None)
    {
        CaptionML = ENU = 'None', FRA = 'Aucun';
    }
    value(1; Ledger)
    {
        CaptionML = ENU = 'Ledger', FRA = 'Comptabilisation';
    }
    value(2; Report)
    {
        CaptionML = ENU = 'Report', FRA = 'État';
    }
    value(3; File)
    {
        CaptionML = ENU = 'File', FRA = 'Fichier';
    }
    value(4; "Create New Document")
    {
        CaptionML = ENU = 'Create New Document', FRA = 'Création document';
    }
    value(5; "Cancel File")
    {
        CaptionML = ENU = 'Cancel File', FRA = 'Annulé fichier';
    }
}
