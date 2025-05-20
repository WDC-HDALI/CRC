namespace MESSEM.MESSEM;

enum 50907 "WDC-ED Accounting Type"
{
    Extensible = true;
    value(0; "Payment Line Account")
    {
        CaptionML = ENU = 'Payment Line Account', FRA = 'Compte ligne paiement';
    }
    value(1; "Associated G/L Account")
    {
        CaptionML = ENU = 'Associated G/L Account', FRA = 'Compte général associé';
    }
    value(2; "Setup Account")
    {
        CaptionML = ENU = 'Setup Account', FRA = 'Compte paramétré';
    }
    value(3; "G/L Account / Month")
    {
        CaptionML = ENU = 'G/L Account / Month', FRA = 'Compte général par mois échéance';
    }
    value(4; "G/L Account / Week")
    {
        CaptionML = ENU = 'G/L Account / Week', FRA = 'Compte général par semaine échéance';
    }
    value(5; "Bal. Account Previous Entry")
    {
        CaptionML = ENU = 'Bal. Account Previous Entry', FRA = 'Extourne écriture précédente';
    }
    value(6; "Header Payment Account")
    {
        CaptionML = ENU = 'Header Payment Account', FRA = 'Compte en-tête';
    }
}

