codeunit 54006 "WDC-ST Fiscal Year FiscalClose"
{
    procedure CheckFiscalYearStatus(PeriodRange: Text[30]): Text[30]
    var
        AccountingPeriod: Record "Accounting Period";
        Date: Record Date;
    begin
        Date.SetRange("Period Type", Date."Period Type"::Date);
        Date.SetFilter("Period Start", PeriodRange);
        Date.FindLast;
        AccountingPeriod.SetFilter("Starting Date", '<=%1', Date."Period Start");
        AccountingPeriod.SetRange("New Fiscal Year", true);
        AccountingPeriod.FindLast;
        if AccountingPeriod."Fiscally Closed" then
            exit(Text009);

        exit(Text010);
    end;

    var

        Text009: Label 'Fiscally Closed';
        Text010: Label 'Fiscally Open';

}

