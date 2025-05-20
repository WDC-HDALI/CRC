report 50800 "WDC-ED G/L Journal"
{
    DefaultLayout = RDLC;
    RDLCLayout = './.vscode/src_ED/report/RDLC/GLJournal.rdl';
    ApplicationArea = All;
    CaptionML = ENU = 'G/L Journal', FRA = 'Journal général';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(Date; Date)
        {
            DataItemTableView = SORTING("Period Type", "Period Start") WHERE("Period Type" = CONST(Month));
            PrintOnlyIfDetail = true;
            RequestFilterFields = "Period Start";
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(COMPANYNAME; COMPANYPROPERTY.DisplayName)
            {
            }
            column(STRSUBSTNO_Text003_USERID_; StrSubstNo(Text003, UserId))
            {
            }
            column(PageCaption; StrSubstNo(Text004, ' '))
            {
            }
            column(UserCaption; StrSubstNo(Text003, ''))
            {
            }
            column(G_L_Entry__TABLECAPTION__________Filter; "G/L Entry".TableCaption + ': ' + Filter)
            {
            }
            column("Filter"; Filter)
            {
            }
            column(Hidden; Hidden)
            {
            }
            column(FiscalYearStatusText; FiscalYearStatusText)
            {
            }
            column(DebitTotal; DebitTotal)
            {
            }
            column(CreditTotal; CreditTotal)
            {
            }
            column(Date_Period_Type; "Period Type")
            {
            }
            column(Date_Period_Start; "Period Start")
            {
            }
            column(G_L_JournalCaption; G_L_JournalCaptionLbl)
            {
            }
            column(CodeCaption; CodeCaptionLbl)
            {
            }
            column(DescriptionCaption; DescriptionCaptionLbl)
            {
            }
            column(DebitCaption; DebitCaptionLbl)
            {
            }
            column(CreditCaption; CreditCaptionLbl)
            {
            }
            column(Grand_Total__Caption; Grand_Total__CaptionLbl)
            {
            }
            dataitem(SourceCode; "Source Code")
            {
                DataItemTableView = SORTING(Code);
                PrintOnlyIfDetail = true;
                RequestFilterFields = "Code";
                column(Date__Period_Type_; Date."Period Type")
                {
                }
                column(Date__Period_Name__________FORMAT_Year_; Date."Period Name" + ' ' + Format(Year))
                {
                }
                column(SourceCode_Code; Code)
                {
                }
                dataitem("G/L Entry"; "G/L Entry")
                {
                    DataItemLink = "Source Code" = FIELD(Code);
                    DataItemTableView = SORTING("Source Code", "Posting Date");
                    column(SourceCode_Code_Control1120032; SourceCode.Code)
                    {
                    }
                    column(SourceCode_Description; SourceCode.Description)
                    {
                    }
                    column(G_L_Entry__Debit_Amount_; "Debit Amount")
                    {
                    }
                    column(G_L_Entry__Credit_Amount_; "Credit Amount")
                    {
                    }
                    column(G_L_Entry_Entry_No_; "Entry No.")
                    {
                    }
                    column(G_L_Entry_Document_No_; "Document No.")
                    {
                    }
                    column(G_L_Entry_Source_Code; "Source Code")
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        DebitTotal := DebitTotal + "Debit Amount";
                        CreditTotal := CreditTotal + "Credit Amount";
                    end;

                    trigger OnPreDataItem()
                    begin
                        SetRange("Posting Date", Date."Period Start", Date."Period End");
                    end;
                }
            }

            trigger OnAfterGetRecord()
            begin
                Year := Date2DMY("Period End", 3);
            end;

            trigger OnPreDataItem()
            begin
                Hidden := false;
                if GetFilter("Period Start") = '' then
                    Error(Text001, FieldCaption("Period Start"));
                if CopyStr(GetFilter("Period Start"), 1, 1) = '.' then
                    Error(Text002);
                StartDate := GetRangeMin("Period Start");
                DateFilterCalc.VerifMonthPeriod(GetFilter("Period Start"));
                DateFilterCalc.CreateFiscalYearFilter(TextDate, TextDate, StartDate, 0);
                TextDate := ConvertStr(TextDate, '.', ',');
                DateFilterCalc.VerifiyDateFilter(TextDate);
                TextDate := CopyStr(TextDate, 1, 8);
                Evaluate(PreviousStartDate, TextDate);
                if CopyStr(GetFilter("Period Start"), StrLen(GetFilter("Period Start")), 1) = '.' then
                    EndDate := 0D
                else
                    EndDate := GetRangeMax("Period Start");
                if EndDate = StartDate then
                    EndDate := DateFilterCalc.ReturnEndingPeriod(StartDate, Date."Period Type"::Month);
                FiscalYearStatusText := StrSubstNo(Text005, FiscalYearFiscalClose.CheckFiscalYearStatus(GetFilter("Period Start")));
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        Filter := Date.GetFilters;
    end;

    procedure VerifMonthPeriod("Filter": Text[30])
    var
        Date: Record Date;
        FilterDate: Date;
        FilterPos: Integer;
    begin
        if CopyStr(Filter, StrLen(Filter) - 1, 2) = '..' then
            exit;
        // Begin Check
        FilterPos := StrPos(Filter, '..');

        if FilterPos = 0 then
            Error(DateInsteadOfPeriodErr);

        Evaluate(FilterDate, CopyStr(Filter, 1, FilterPos - 1));
        Date.SetRange("Period Type", Date."Period Type"::Month);
        Date.SetRange(Date."Period Start", FilterDate);
        if not Date.Find('-') then
            Error(Text10801);

        Date.Reset();
        // Ending check
        if FilterPos <> 0 then begin
            Evaluate(FilterDate, CopyStr(Filter, FilterPos + 2, 8));
            Date.SetRange("Period Type", Date."Period Type"::Month);
            Date.SetRange(Date."Period End", ClosingDate(FilterDate));
            if not Date.Find('-') then
                Error(Text10802);
        end;
    end;

    var
        Text001: TextConst ENU = 'You must fill in the %1 field.',
                           FRA = 'Vous devez renseigner le champ %1.';
        Text002: TextConst ENU = 'You must specify a Starting Date.',
                           FRA = 'Vous devez spécifier une date de début.';
        Text003: TextConst ENU = 'Printed by %1',
                           FRA = 'Imprimé par %1';
        Text004: TextConst ENU = 'Page %1',
                           FRA = 'Page %1';
        // DateFilterCalc: Codeunit "DateFilter-Calc";
        DateFilterCalc: Codeunit "WDC-ED DateFilter-Calc Delta";

        FiscalYearFiscalClose: Codeunit "WDC-ED Fiscal Year-FiscalClose";
        StartDate: Date;
        EndDate: Date;
        PreviousStartDate: Date;
        TextDate: Text[30];
        DebitTotal: Decimal;
        CreditTotal: Decimal;
        "Filter": Text;
        Year: Integer;
        Text005: TextConst ENU = 'Fiscal-Year Status: %1',
                           FRA = 'Statut de l''exercice comptable : %1';
        Hidden: Boolean;
        G_L_JournalCaptionLbl: TextConst ENU = 'G/L Journal',
                                         FRA = 'Journal général';
        CodeCaptionLbl: TextConst ENU = 'Code',
                                  FRA = 'Code';
        DescriptionCaptionLbl: TextConst ENU = 'Description',
                                         FRA = 'Description';
        DebitCaptionLbl: TextConst ENU = 'Debit',
                                   FRA = 'Débit';
        CreditCaptionLbl: TextConst ENU = 'Credit',
                                    FRA = 'Crédit';
        Grand_Total__CaptionLbl: TextConst ENU = 'Grand Total :',
                                           FRA = 'Total général :';
        FiscalYearStatusText: Text;
        Text10801: TextConst ENU = 'The starting date must be the first day of a month.',
                             FRA = 'La date de début doit être le premier jour du mois.';
        Text10802: TextConst ENU = 'The ending date must be the last day of a month.',
                             FRA = 'La date de fin doit correspondre au dernier jour du mois.';
        DateInsteadOfPeriodErr: TextConst ENU = 'You must enter a date interval, such as 01.01.24..31.01.24.',
                                          FRA = 'Vous devez entrer un intervalle de temps, par exemple 01.01.24..31.01.24.';

}

