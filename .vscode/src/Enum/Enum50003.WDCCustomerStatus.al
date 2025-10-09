namespace CRC.CRC;

enum 50003 "WDC Customer Status"
{
    Extensible = true;

    value(0; "Waiting Approval")
    {
        CaptionML = ENU = 'Waiting Approval', FRA = 'En attente d''approbation';
    }


    value(1; "Approved")
    {
        CaptionML = ENU = 'Approved', FRA = 'Approuvé';
    }

}
