enum 54009 "WDC-ST Line Account Type"
{
    CaptionML = ENU = 'Line Account Type', FRA = 'Type Compte Ligne';

    value(0; " ")
    {
        CaptionML = ENU = ' ', FRA = ' ';
    }

    value(1; "Expense Cash")
    {
        CaptionML = ENU = 'Expense Cash', FRA = 'Caisse dépense';
    }

    value(2; "Income Cash")
    {
        CaptionML = ENU = 'Income Cash', FRA = 'Caisse recette';
    }

    value(3; "Local Vendor")
    {
        CaptionML = ENU = 'Local Vendor', FRA = 'Fournisseur local';
    }

    value(4; "Foreign Vendor")
    {
        CaptionML = ENU = 'Foreign Vendor', FRA = 'Fournisseur étranger';
    }

    value(5; Employee)
    {
        CaptionML = ENU = 'Employee', FRA = 'Salarié';
    }
}