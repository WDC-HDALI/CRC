enum 54008 "WDC-ST Caisse Type"
{
    CaptionML = ENU = 'Caisse Type', FRA = 'Type Caisse';

    value(0; " ")
    {
        CaptionML = ENU = ' ', FRA = ' ';
    }

    value(1; Expense)
    {
        CaptionML = ENU = 'Expense', FRA = 'Dépense';
    }

    value(2; Income)
    {
        CaptionML = ENU = 'Income', FRA = 'Recette';
    }
}