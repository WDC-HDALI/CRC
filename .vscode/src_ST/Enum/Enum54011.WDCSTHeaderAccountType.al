enum 54011 "WDC-ST Header Account Type"
{
    CaptionML = ENU = 'Header Account Type', FRA = 'Type de compte Entête';

    value(0; "G/L Account")
    {
        CaptionML = ENU = 'G/L Account', FRA = 'Compte G/L';
    }

    value(1; Customer)
    {
        CaptionML = ENU = 'Customer', FRA = 'Client';
    }

    value(2; Vendor)
    {
        CaptionML = ENU = 'Vendor', FRA = 'Fournisseur';
    }

    value(3; "Bank Account")
    {
        CaptionML = ENU = 'Bank Account', FRA = 'Compte Bancaire';
    }

    value(4; "Fixed Asset")
    {
        CaptionML = ENU = 'Fixed Asset', FRA = 'Immobilisation';
    }
}