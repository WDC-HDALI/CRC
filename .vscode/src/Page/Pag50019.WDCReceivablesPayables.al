//************Documentation**********************

// WDC.IM : 01/03/2026 : Add filter by start date - End date
page 50019 "WDC Receivables-Payables"
{
    ApplicationArea = Suite;
    CaptionML = ENU = 'Receivables-Payables', FRA = 'Engagements';
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = ListPlus;
    SaveValues = true;
    SourceTable = "General Ledger Setup";
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            group(Options)
            {
                Caption = 'Options';
                //<<WDC.IM
                field(StartFilterDate; StartFilterDate)
                {
                    ApplicationArea = Suite;
                    Caption = 'Date début';

                    trigger OnValidate()
                    begin
                        if (EndFilterDate <> 0D) and (StartFilterDate > EndFilterDate) then
                            Error('La date début ne peut pas être supérieure à la date fin.');
                        if StartFilterDate <> 0D then
                            ReceivablesPayablesBuffer.SetFilter("Period Start", '>=%1', StartFilterDate)
                        else
                            ReceivablesPayablesBuffer.SetFilter("Period Start", '');
                        UpdateSubForm();

                    end;
                }
                field(EndFilterDate; EndFilterDate)
                {
                    ApplicationArea = Suite;
                    Caption = 'Date fin';

                    trigger OnValidate()
                    begin
                        if (StartFilterDate <> 0D) and (EndFilterDate < StartFilterDate) then
                            Error('La date fin ne peut pas être inférieure à la date début.');
                        if EndFilterDate <> 0D then
                            ReceivablesPayablesBuffer.SetRange("Period Start", StartFilterDate, EndFilterDate)
                        else
                            ReceivablesPayablesBuffer.SetFilter("Period Start", '');
                        UpdateSubForm();
                    end;
                }
                //>>WDC.IM
                field(PeriodType; PeriodType)
                {
                    ApplicationArea = Suite;
                    Caption = 'View by';
                    ToolTip = 'Specifies by which period amounts are displayed.';

                    trigger OnValidate()
                    begin
                        if PeriodType = PeriodType::"Accounting Period" then
                            PeriodPeriodTypeOnValidate();
                        if PeriodType = PeriodType::Year then
                            YearPeriodTypeOnValidate();
                        if PeriodType = PeriodType::Quarter then
                            QuarterPeriodTypeOnValidate();
                        if PeriodType = PeriodType::Month then
                            MonthPeriodTypeOnValidate();
                        if PeriodType = PeriodType::Week then
                            WeekPeriodTypeOnValidate();
                        if PeriodType = PeriodType::Day then
                            DayPeriodTypeOnValidate();
                    end;
                }
                field(AmountType; AmountType)
                {
                    ApplicationArea = Suite;
                    Caption = 'View as';
                    ToolTip = 'Specifies how amounts are displayed. Net Change: The net change in the balance for the selected period. Balance at Date: The balance as of the last day in the selected period.';

                    trigger OnValidate()
                    begin
                        if AmountType = AmountType::"Balance at Date" then
                            BalanceatDateAmountTypeOnValid();
                        if AmountType = AmountType::"Net Change" then
                            NetChangeAmountTypeOnValidate();
                    end;
                }
                field(VendorNo; VendorNo)
                {
                    ApplicationArea = Suite;
                    CaptionML = ENU = 'Vendor No.', FRA = 'No. fournisseur';
                    TableRelation = Vendor."No.";
                    trigger OnValidate()
                    var
                        Vendor: Record Vendor;
                    begin
                        VendorName := '';
                        if Vendor.Get(VendorNo) then
                            VendorName := Vendor.Name;
                        UpdateSubForm();
                    end;
                }
                field(VendorName; VendorName)
                {
                    ApplicationArea = Suite;
                    CaptionML = ENU = 'Vendor Name', FRA = 'Nom fournisseur';
                    Editable = false;
                }
            }
            part(ReceivPayablesLinesNew; "WDC Receivables-Payables Lines")
            {
                ApplicationArea = Suite;
            }
        }
    }

    trigger OnOpenPage()
    begin
        startFilterDate := 0D;
        endFilterDate := 0D;
        VendorNo := '';
        VendorName := '';
        UpdateSubForm();
    end;

    trigger OnAfterGetRecord()
    begin
        UpdateSubForm();
    end;

    var
        PeriodType: Enum "Analysis Period Type";
        AmountType: Enum "Analysis Amount Type";
        VendorNo: Code[20];
        VendorName: Text[100];
        StartFilterDate: Date;
        EndFilterDate: Date;
        ReceivablesPayablesBuffer: Record "Receivables-Payables Buffer" temporary; //WDC.IM

    local procedure UpdateSubForm()
    begin
        CurrPage.ReceivPayablesLinesNew.PAGE.SetLines(Rec, PeriodType, AmountType, VendorNo);
        CurrPage.ReceivPayablesLinesNew.Page.SetTableView(ReceivablesPayablesBuffer);//WDC.IM
    end;

    local procedure DayPeriodTypeOnPush()
    begin
        UpdateSubForm();
    end;

    local procedure WeekPeriodTypeOnPush()
    begin
        UpdateSubForm();
    end;

    local procedure MonthPeriodTypeOnPush()
    begin
        UpdateSubForm();
    end;

    local procedure QuarterPeriodTypeOnPush()
    begin
        UpdateSubForm();
    end;

    local procedure YearPeriodTypeOnPush()
    begin
        UpdateSubForm();
    end;

    local procedure PeriodPeriodTypeOnPush()
    begin
        UpdateSubForm();
    end;

    local procedure NetChangeAmountTypeOnPush()
    begin
        UpdateSubForm();
    end;

    local procedure BalanceatDateAmountTypeOnPush()
    begin
        UpdateSubForm();
    end;

    local procedure DayPeriodTypeOnValidate()
    begin
        DayPeriodTypeOnPush();
    end;

    local procedure WeekPeriodTypeOnValidate()
    begin
        WeekPeriodTypeOnPush();
    end;

    local procedure MonthPeriodTypeOnValidate()
    begin
        MonthPeriodTypeOnPush();
    end;

    local procedure QuarterPeriodTypeOnValidate()
    begin
        QuarterPeriodTypeOnPush();
    end;

    local procedure YearPeriodTypeOnValidate()
    begin
        YearPeriodTypeOnPush();
    end;

    local procedure PeriodPeriodTypeOnValidate()
    begin
        PeriodPeriodTypeOnPush();
    end;

    local procedure NetChangeAmountTypeOnValidate()
    begin
        NetChangeAmountTypeOnPush();
    end;

    local procedure BalanceatDateAmountTypeOnValid()
    begin
        BalanceatDateAmountTypeOnPush();
    end;
}

