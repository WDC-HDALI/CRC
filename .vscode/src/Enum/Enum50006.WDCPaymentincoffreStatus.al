namespace CRC.CRC;

enum 50006 "WDC Payment in coffre Status"
{
    Extensible = true;
    AssignmentCompatibility = true;

    value(0; Open)
    {
        CaptionML = ENU = 'Open', FRA = 'Ouvert';
    }
    value(1; Released)
    {
        CaptionML = ENU = 'Released', FRA = 'Lancée';
    }
    value(2; Paied)
    {
        CaptionML = ENU = 'Paied', FRA = 'Payé';
    }

}