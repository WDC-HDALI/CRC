enum 54010 "WDC-ST Payment Slip Profil"
{
    CaptionML = ENU = 'Payment Slip Profil', FRA = 'Profil Bordereau';

    value(0; " ")
    {
        CaptionML = ENU = ' ', FRA = ' ';
    }

    value(1; Cashier)
    {
        CaptionML = ENU = 'Cashier', FRA = 'Caissier';
    }

    value(2; Financial)
    {
        CaptionML = ENU = 'Financial', FRA = 'Financier';
    }

    value(3; Accountant)
    {
        CaptionML = ENU = 'Accountant', FRA = 'Comptable';
    }

    value(4; "Admin Payment Slip")
    {
        CaptionML = ENU = 'Admin Payment Slip', FRA = 'Admin Bordereau';
    }
}