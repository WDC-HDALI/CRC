report 50804 "WDC-ED G/L Detail Trial Bal."
{
    DefaultLayout = RDLC;
    RDLCLayout = './.vscode/src_ED/report/RDLC/GLDetailTrialBalance.rdl';
    ApplicationArea = All;
    captionML = ENU = 'G/L Detail Trial Balance', FRA = 'Grand livre comptes généraux';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("G/L Account"; "G/L Account")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.", "Date Filter";
            column(COMPANYNAME; COMPANYPROPERTY.DisplayName)
            {
            }
            column(STRSUBSTNO_Text004_PreviousStartDate_; StrSubstNo(Text004, PreviousStartDate))
            {
            }
            column(PageCaption; StrSubstNo(Text005, ' '))
            {
            }
            column(UserCaption; StrSubstNo(Text003, ''))
            {
            }
            column(GLAccountTABLECAPTIONAndFilter; "G/L Account".TableCaption + ': ' + Filter)
            {
            }
            column("Filter"; Filter)
            {
            }
            column(FiscalYearStatusText; FiscalYearStatusText)
            {
            }
            column(No_GLAccount; "No.")
            {
            }
            column(Name_GLAccount; Name)
            {
            }
            column(DebitAmount_GLAccount; "G/L Account"."Debit Amount")
            {
            }
            column(CreditAmount_GLAccount; "G/L Account"."Credit Amount")
            {
            }
            column(STRSUBSTNO_Text006_PreviousEndDate_; StrSubstNo(Text006, PreviousEndDate))
            {
            }
            column(DebitAmount_GLAccount2; GLAccount2."Debit Amount")
            {
            }
            column(CreditAmount_GLAccount2; GLAccount2."Credit Amount")
            {
            }
            column(STRSUBSTNO_Text006_EndDate_; StrSubstNo(Text006, EndDate))
            {
            }
            column(ShowBodyGLAccount; ShowBodyGLAccount)
            {
            }
            // column(G_L_Account_G_L_Entry_Type_Filter; gl"G/L Entry Type Filter" )
            // {
            // }
            column(G_L_Account_Global_Dimension_1_Filter; "Global Dimension 1 Filter")
            {
            }
            column(G_L_Account_Global_Dimension_2_Filter; "Global Dimension 2 Filter")
            {
            }
            column(G_L_Detail_Trial_BalanceCaption; G_L_Detail_Trial_BalanceCaptionLbl)
            {
            }
            column(Posting_DateCaption; Posting_DateCaptionLbl)
            {
            }
            column(Source_CodeCaption; Source_CodeCaptionLbl)
            {
            }
            column(Document_No_Caption; Document_No_CaptionLbl)
            {
            }
            column(External_Document_No_Caption; External_Document_No_CaptionLbl)
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
            column(BalanceCaption; BalanceCaptionLbl)
            {
            }
            column(Grand_TotalCaption; Grand_TotalCaptionLbl)
            {
            }
            dataitem(Date; Date)
            {
                DataItemTableView = SORTING("Period Type");
                PrintOnlyIfDetail = true;
                column(STRSUBSTNO_Text007_EndDate_; StrSubstNo(Text007, EndDate))
                {
                }
                column(Date_PeriodNo; Date."Period No.")
                {
                }
                column(PostingYear; Date2DMY("G/L Entry"."Posting Date", 3))
                {
                }
                column(Date_Period_Type; "Period Type")
                {
                }
                column(Total_Date_RangeCaption; Total_Date_RangeCaptionLbl)
                {
                }
                dataitem("G/L Entry"; "G/L Entry")
                {
                    DataItemLink = "G/L Account No." = FIELD("No."), "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"), "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter");
                    DataItemLinkReference = "G/L Account";
                    DataItemTableView = SORTING("G/L Account No.");
                    column(DebitAmount_GLEntry; "G/L Entry"."Debit Amount")
                    {
                    }
                    column(CreditAmount_GLEntry; "G/L Entry"."Credit Amount")
                    {
                    }
                    column(PostingDate_GLEntry; Format("Posting Date"))
                    {
                    }
                    column(SourceCode_GLEntry; "Source Code")
                    {
                    }
                    column(DocumentNo_GLEntry; "Document No.")
                    {
                    }
                    column(ExternalDocumentNo_GLEntry; "External Document No.")
                    {
                    }
                    column(Description_GLEntry; Description)
                    {
                    }
                    column(Balance; Balance)
                    {
                    }
                    column(EntryNo_GLEntry; "G/L Entry"."Entry No.")
                    {
                    }
                    column(Date_PeriodType_PeriodName; Text008 + ' ' + Format(Date."Period Type") + ' ' + Date."Period Name")
                    {
                    }
                    column(TotalByInt; TotalByInt)
                    {
                    }



                    trigger OnAfterGetRecord()
                    begin
                        if ("Debit Amount" = 0) and
                           ("Credit Amount" = 0)
                        then
                            CurrReport.Skip();
                        Balance := Balance + "Debit Amount" - "Credit Amount";
                    end;

                    trigger OnPreDataItem()
                    begin
                        if DocNumSort then
                            SetCurrentKey("G/L Account No.", "Document No.", "Posting Date");
                        SetRange("Posting Date", Date."Period Start", Date."Period End");
                    end;
                }

                trigger OnPreDataItem()
                begin
                    SetRange("Period Type", TotalBy);
                    SetRange("Period Start", StartDate, ClosingDate(EndDate));
                    Balance := GLAccount2.Balance;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                GLAccount2.Copy("G/L Account");
                if GLAccount2."Income/Balance" = 0 then
                    GLAccount2.SetRange("Date Filter", PreviousStartDate, PreviousEndDate)
                else
                    GLAccount2.SetRange("Date Filter", 0D, PreviousEndDate);
                GLAccount2.CalcFields("Debit Amount", "Credit Amount");
                GLAccount2.Balance := GLAccount2."Debit Amount" - GLAccount2."Credit Amount";
                if "Income/Balance" = 0 then
                    SetRange("Date Filter", StartDate, EndDate)
                else
                    SetRange("Date Filter", 0D, EndDate);
                CalcFields("Debit Amount", "Credit Amount");
                if ("Debit Amount" = 0) and ("Credit Amount" = 0) then
                    CurrReport.Skip();

                ShowBodyGLAccount :=
                  ((GLAccount2."Debit Amount" = "Debit Amount") and (GLAccount2."Credit Amount" = "Credit Amount")) or ("Account Type".AsInteger() <> 0);
            end;

            trigger OnPreDataItem()
            begin
                if GetFilter("Date Filter") = '' then
                    Error(Text001, FieldCaption("Date Filter"));
                if CopyStr(GetFilter("Date Filter"), 1, 1) = '.' then
                    Error(Text002);
                StartDate := GetRangeMin("Date Filter");
                Period.SetRange("Period Start", StartDate);
                case TotalBy of
                    TotalBy::" ":
                        Period.SetRange("Period Type", Period."Period Type"::Date);
                    TotalBy::Week:
                        Period.SetRange("Period Type", Period."Period Type"::Week);
                    TotalBy::Month:
                        Period.SetRange("Period Type", Period."Period Type"::Month);
                    TotalBy::Quarter:
                        Period.SetRange("Period Type", Period."Period Type"::Quarter);
                    TotalBy::Year:
                        Period.SetRange("Period Type", Period."Period Type"::Year);
                end;
                if not Period.FindFirst then
                    Error(Text010, StartDate, Period.GetFilter("Period Type"));
                PreviousEndDate := ClosingDate(StartDate - 1);
                DateFilterCalc.CreateFiscalYearFilter(TextDate, TextDate, StartDate, 0);
                TextDate := ConvertStr(TextDate, '.', ',');
                DateFilterCalc.VerifiyDateFilter(TextDate);
                TextDate := CopyStr(TextDate, 1, 8);
                Evaluate(PreviousStartDate, TextDate);
                if CopyStr(GetFilter("Date Filter"), StrLen(GetFilter("Date Filter")), 1) = '.' then
                    EndDate := 0D
                else
                    EndDate := GetRangeMax("Date Filter");
                Clear(Period);
                Period.SetRange("Period End", ClosingDate(EndDate));
                case TotalBy of
                    TotalBy::" ":
                        Period.SetRange("Period Type", Period."Period Type"::Date);
                    TotalBy::Week:
                        Period.SetRange("Period Type", Period."Period Type"::Week);
                    TotalBy::Month:
                        Period.SetRange("Period Type", Period."Period Type"::Month);
                    TotalBy::Quarter:
                        Period.SetRange("Period Type", Period."Period Type"::Quarter);
                    TotalBy::Year:
                        Period.SetRange("Period Type", Period."Period Type"::Year);
                end;
                if not Period.FindFirst then
                    Error(Text011, EndDate, Period.GetFilter("Period Type"));
                FiscalYearStatusText := StrSubstNo(Text012, FiscalYearFiscalClose.CheckFiscalYearStatus(GetFilter("Date Filter")));

                TotalByInt := TotalBy;
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    captionML = ENU = 'Options', FRA = 'Options';
                    field(SummarizeBy; TotalBy)
                    {
                        ApplicationArea = All;
                        captionML = ENU = 'Summarize by', FRA = 'Totaliser par';
                        OptionCaptionML = ENU = ' ,Week,Month,Quarter,Year', FRA = ' ,Semaine,Mois,Trimestre,Année';
                    }
                    field(SortedByDocumentNo; DocNumSort)
                    {
                        ApplicationArea = All;
                        captionML = ENU = 'Sorted by Document No.', FRA = 'Trié par n° document';
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnInitReport()
    begin
        TotalBy := TotalBy::Month
    end;

    trigger OnPreReport()
    begin
        Filter := "G/L Account".GetFilters;
    end;

    var
        GLAccount2: Record "G/L Account";
        Period: Record Date;
        FiscalYearFiscalClose: Codeunit "WDC-ED Fiscal Year-FiscalClose";
        // DateFilterCalc: Codeunit "DateFilter-Calc";
        DateFilterCalc: Codeunit "WDC-ED DateFilter-Calc Delta";
        StartDate: Date;
        EndDate: Date;
        PreviousStartDate: Date;
        PreviousEndDate: Date;
        TextDate: Text[30];
        Balance: Decimal;
        TotalBy: Option " ",Week,Month,Quarter,Year;
        DocNumSort: Boolean;
        ShowBodyGLAccount: Boolean;
        "Filter": Text;
        TotalByInt: Integer;
        Text001: TextConst ENU = 'You must fill in the %1 field.',
                           FRA = 'Vous devez renseigner le champ %1.';
        Text002: TextConst ENU = 'You must specify a Starting Date.',
                           FRA = 'Vous devez spécifier une date de début.';
        Text003: TextConst ENU = 'Printed by %1',
                           FRA = 'Imprimé par %1';
        Text004: TextConst ENU = 'Fiscal Year Start Date : %1',
                           FRA = 'Début exercice comptable : %';
        Text005: TextConst ENU = 'Page %1',
                           FRA = 'Page %1';
        Text006: TextConst ENU = 'Balance at %1 ',
                           FRA = 'Solde au %1 ';
        Text007: TextConst ENU = 'Balance at %1',
                           FRA = 'Solde au %1';
        Text008: TextConst ENU = 'Total',
                           FRA = 'Total';
        Text010: TextConst ENU = 'The selected starting date %1 is not the start of a %2.',
                           FRA = 'La date de début choisie (%1) ne correspond pas au début de %2.';
        Text011: TextConst ENU = 'The selected ending date %1 is not the end of a %2.',
                           FRA = 'La date de fin choisie (%1) ne correspond pas à la fin de %2.';
        FiscalYearStatusText: Text;
        Text012: TextConst ENU = 'Fiscal-Year Status: %1',
                           FRA = 'Statut de l''exercice comptable : %1';
        G_L_Detail_Trial_BalanceCaptionLbl: TextConst ENU = 'G/L Detail Trial Balance',
                                                      FRA = 'Grand livre comptes généraux';
        Posting_DateCaptionLbl: TextConst ENU = 'Posting Date',
                                          FRA = 'Date comptabilisation';
        Source_CodeCaptionLbl: TextConst ENU = 'Source Code',
                                         FRA = 'Code journal';
        Document_No_CaptionLbl: TextConst ENU = 'Document No.',
                                          FRA = 'N° du document';
        External_Document_No_CaptionLbl: TextConst ENU = 'External Document No.',
                                                   FRA = 'N° doc. externe';
        DescriptionCaptionLbl: TextConst ENU = 'Description',
                                         FRA = 'Description';
        DebitCaptionLbl: TextConst ENU = 'Debit',
                                   FRA = 'Débit';
        CreditCaptionLbl: TextConst ENU = 'Credit',
                                    FRA = 'Crédit';
        BalanceCaptionLbl: TextConst ENU = 'Balance',
                                     FRA = 'Solde';
        Grand_TotalCaptionLbl: TextConst ENU = 'Grand Total',
                                         FRA = 'Total général';
        Total_Date_RangeCaptionLbl: TextConst ENU = 'Total Date Range',
                                              FRA = 'Total plage de dates';
}

