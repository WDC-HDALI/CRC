report 50842 "WDC-ED G/L Account Statement"
{
    DefaultLayout = RDLC;
    RDLCLayout = './.vscode/src_ED/report/RDLC/GLAccountStatement.rdl';
    ApplicationArea = All;
    captionML = ENU = 'G/L Account Statement', FRA = 'Relevé de compte général';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("G/L Account"; "G/L Account")
        {
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.";
            column(TodayFormatted; Format(Today, 0, 4))
            {
            }
            column(CompanyName; COMPANYPROPERTY.DisplayName)
            {
            }
            column(PrintedByText; StrSubstNo(Text001, ''))
            {
            }
            column(GLAccTableCaptionFilter; "G/L Account".TableCaption + ' : ' + Filter)
            {
            }
            column(ApplicationStatus; StrSubstNo(Text005, SelectStr(ApplicationStatus + 1, Text006)))
            {
            }
            column(EvaluationDateStr; StrSubstNo(Text004, EvaluationDateStr))
            {
            }
            column(Name_GLAcc; "G/L Account".Name)
            {
            }
            column(No_GLAcc; "G/L Account"."No.")
            {
            }
            column(DebitAmount_GLAcc; "G/L Entry"."Debit Amount")
            {
            }
            column(CreditAmount_GLAcc; "G/L Entry"."Credit Amount")
            {
            }
            column(GLEntryDebitAmtCreditAmt; "G/L Entry"."Debit Amount" - "G/L Entry"."Credit Amount")
            {
            }
            column(TotalDebit; TotalDebit)
            {
            }
            column(TotalCredit; TotalCredit)
            {
            }
            column(TotalBalance; TotalBalance)
            {
            }
            column(GLBaljustificationCaption; GLBaljustificationCaptionLbl)
            {
            }
            column(LetterCaption; LetterCaptionLbl)
            {
            }
            column(BalanceCaption; BalanceCaptionLbl)
            {
            }
            column(CreditCaption; CreditCaptionLbl)
            {
            }
            column(DebitCaption; DebitCaptionLbl)
            {
            }
            column(ExtDocNoCaption; ExtDocNoCaptionLbl)
            {
            }
            column(DocumentNoCaption; DocumentNoCaptionLbl)
            {
            }
            column(SourceCodeCaption; SourceCodeCaptionLbl)
            {
            }
            column(PostingDateCaption; PostingDateCaptionLbl)
            {
            }
            column(DescriptionCaption; DescriptionCaptionLbl)
            {
            }
            column(GrandTotalCaption; GrandTotalCaptionLbl)
            {
            }
            dataitem("G/L Entry"; "G/L Entry")
            {
                DataItemLink = "G/L Account No." = FIELD("No.");
                DataItemTableView = SORTING("G/L Account No.", "Posting Date");
                column(DebitAmount_GLEntry; "Debit Amount")
                {
                }
                column(Letter_GLEntry; Letter)
                {
                }
                column(CreditAmount_GLEntry; "Credit Amount")
                {
                }
                column(PostingDate_Formatted; Format("Posting Date"))
                {
                }
                column(Description_GLEntry; Description)
                {
                }
                column(SourceCode_GLEntry; "Source Code")
                {
                }
                column(DocumentNo_GLEntry; "Document No.")
                {
                }
                column(ExtDocNo_GLEntry; "External Document No.")
                {
                }
                column(Balance_GLEntry; Balance)
                {
                    AutoCalcField = false;
                }
                column(PostingDate; "Posting Date")
                {
                }
                column(DebitAmtCreditAmt; "Debit Amount" - "Credit Amount")
                {
                }
                column(TotalOfAccGLAccNo; StrSubstNo(Text003, "G/L Account"."No."))
                {
                }
                column(EntryNo_GLEntry; "Entry No.")
                {
                }
                column(GLAccountNo_GLEntry; "G/L Account No.")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    TotalDebit := TotalDebit + "Debit Amount";
                    TotalCredit := TotalCredit + "Credit Amount";
                    TotalBalance := TotalBalance + "Debit Amount" - "Credit Amount";

                    if EvaluationDate <> 0D then
                        case ApplicationStatus of
                            ApplicationStatus::Applied:
                                if ((Letter <> UpperCase(Letter)) or (Letter = '')) or
                                   ("Letter Date" > EvaluationDate)
                                then
                                    CurrReport.Skip();
                            ApplicationStatus::"Not Applied":
                                if ((Letter = UpperCase(Letter)) and (Letter <> '')) and
                                   ("Letter Date" < EvaluationDate)
                                then
                                    CurrReport.Skip();
                        end
                    else
                        case ApplicationStatus of
                            ApplicationStatus::Applied:
                                if (Letter <> UpperCase(Letter)) or (Letter = '') then
                                    CurrReport.Skip();
                            ApplicationStatus::"Not Applied":
                                if (Letter = UpperCase(Letter)) and (Letter <> '') then
                                    CurrReport.Skip();
                        end;

                    Balance := Balance + "G/L Entry"."Debit Amount" - "G/L Entry"."Credit Amount";
                end;

                trigger OnPreDataItem()
                begin
                    if EvaluationDate <> 0D then
                        SetFilter("Posting Date", '<=%1', EvaluationDate);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                Balance := 0;
            end;

            trigger OnPreDataItem()
            begin
                EvaluationDateStr := Format(EvaluationDate);
                if EvaluationDate = 0D then
                    EvaluationDateStr := '';
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
                    field(EvaluationDate; EvaluationDate)
                    {
                        ApplicationArea = All;
                        captionML = ENU = 'Evaluation Date', FRA = 'Date d''évaluation';
                    }
                    field(GLEntries; ApplicationStatus)
                    {
                        ApplicationArea = All;
                        captionML = ENU = 'G/L Entries', FRA = 'Écritures comptables';
                        OptionCaptionMl = ENU = 'All,Applied,Not Applied', FRA = 'Tous,Lettrés,Non lettrés';
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

    trigger OnPreReport()
    begin
        Filter := "G/L Account".GetFilters;
        EvaluationDateStr := '';
    end;

    var
        "Filter": Text;
        EvaluationDateStr: Text;
        ApplicationStatus: Option All,Applied,"Not Applied";
        EvaluationDate: Date;
        Balance: Decimal;
        TotalDebit: Decimal;
        TotalCredit: Decimal;
        TotalBalance: Decimal;
        Text001: TextConst ENU = 'Printed by %1',
                           FRA = 'Imprimé par %1';
        Text002: TextConst ENU = 'Page %1',
                           FRA = 'Page %1';
        Text003: TextConst ENU = 'Total of account %1',
                           FRA = 'Total du compte %1';
        Text004: TextConst ENU = 'Evaluation date : %1',
                           FRA = 'Date d''évaluation : %1';
        Text005: TextConst ENU = 'G/L entries : %1',
                           FRA = 'Écritures comptables : %1';
        Text006: TextConst ENU = 'All,Applied,Not Applied',
                           FRA = 'Tous,Lettrés,Non lettrés';
        GLBaljustificationCaptionLbl: TextConst ENU = 'G/L balance justification',
                                                FRA = 'Relevé de solde par compte';
        LetterCaptionLbl: TextConst ENU = 'Letter',
                                    FRA = 'Lettre';
        BalanceCaptionLbl: TextConst ENU = 'Balance',
                                     FRA = 'Solde';
        CreditCaptionLbl: TextConst ENU = 'Credit',
                                    FRA = 'Crédit';
        DebitCaptionLbl: TextConst ENU = 'Debit',
                                   FRA = 'Débit';
        ExtDocNoCaptionLbl: TextConst ENU = 'External Document No.',
                                      FRA = 'N° doc. extern';
        DocumentNoCaptionLbl: TextConst ENU = 'Document No.',
                                        FRA = 'N° du document';
        SourceCodeCaptionLbl: TextConst ENU = 'Source Code',
                                        FRA = 'Code journal';
        PostingDateCaptionLbl: TextConst ENU = 'Posting Date',
                                         FRA = 'Date comptabilisation';
        DescriptionCaptionLbl: TextConst ENU = 'Description',
                                         FRA = 'Description';
        GrandTotalCaptionLbl: TextConst ENU = 'Grand Total',
                                        FRA = 'Total général';
}

