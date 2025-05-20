report 50809 "WDC-ED Bank Acc. Trial Balance"
{
    DefaultLayout = RDLC;
    RDLCLayout = './.vscode/src_ED/report/RDLC/BankAccountTrialBalance.rdl';
    ApplicationArea = All;
    captionML = ENU = 'Bank Account Trial Balance', FRA = 'Balance comptes bancaires';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Bank Account"; "Bank Account")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.", "Search Name", "Date Filter";
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(COMPANYNAME; COMPANYPROPERTY.DisplayName)
            {
            }
            column(STRSUBSTNO_Text003_USERID_; StrSubstNo(Text003, UserId))
            {
            }
            column(STRSUBSTNO_Text004_PreviousStartDate_; StrSubstNo(Text004, PreviousStartDate))
            {
            }
            column(STRSUBSTNO_Text005_____; StrSubstNo(Text005, ' '))
            {
            }
            column(PrintedByCaption; StrSubstNo(Text003, ''))
            {
            }
            column(Bank_Account__TABLECAPTION__________Filter; "Bank Account".TableCaption + ': ' + Filter)
            {
            }
            column("Filter"; Filter)
            {
            }
            column(Bank_Account__No__; "No.")
            {
            }
            column(Bank_Account_Name; Name)
            {
            }
            column(BankAccount2__Debit_Amount__LCY_____BankAccount2__Credit_Amount__LCY__; BankAccount2."Debit Amount (LCY)" - BankAccount2."Credit Amount (LCY)")
            {
            }
            column(BankAccount2__Credit_Amount__LCY_____BankAccount2__Debit_Amount__LCY__; BankAccount2."Credit Amount (LCY)" - BankAccount2."Debit Amount (LCY)")
            {
            }
            column(Bank_Account__Debit_Amount__LCY__; "Debit Amount (LCY)")
            {
            }
            column(Bank_Account__Credit_Amount__LCY__; "Credit Amount (LCY)")
            {
            }
            column(BankAccount2__Debit_Amount__LCY______Debit_Amount__LCY_____BankAccount2__Credit_Amount__LCY______Credit_Amount__LCY__; BankAccount2."Debit Amount (LCY)" + "Debit Amount (LCY)" - BankAccount2."Credit Amount (LCY)" - "Credit Amount (LCY)")
            {
            }
            column(BankAccount2__Credit_Amount__LCY______Credit_Amount__LCY_____BankAccount2__Debit_Amount__LCY______Debit_Amount__LCY__; BankAccount2."Credit Amount (LCY)" + "Credit Amount (LCY)" - BankAccount2."Debit Amount (LCY)" - "Debit Amount (LCY)")
            {
            }
            column(BankAccount2__Debit_Amount__LCY_____BankAccount2__Credit_Amount__LCY___Control1120069; BankAccount2."Debit Amount (LCY)" - BankAccount2."Credit Amount (LCY)")
            {
            }
            column(BankAccount2__Credit_Amount__LCY_____BankAccount2__Debit_Amount__LCY___Control1120072; BankAccount2."Credit Amount (LCY)" - BankAccount2."Debit Amount (LCY)")
            {
            }
            column(Bank_Account__Debit_Amount__LCY___Control1120075; "Debit Amount (LCY)")
            {
            }
            column(Bank_Account__Credit_Amount__LCY___Control1120078; "Credit Amount (LCY)")
            {
            }
            column(BankAccount2__Debit_Amount__LCY_Control1120081; BankAccount2."Debit Amount (LCY)" + "Debit Amount (LCY)" - BankAccount2."Credit Amount (LCY)" - "Credit Amount (LCY)")
            {
            }
            column(BankAccount2__Credit_Amount__LCY_Control1120084; BankAccount2."Credit Amount (LCY)" + "Credit Amount (LCY)" - BankAccount2."Debit Amount (LCY)" - "Debit Amount (LCY)")
            {
            }
            column(Bank_Account_Trial_BalanceCaption; Bank_Account_Trial_BalanceCaptionLbl)
            {
            }
            column(No_Caption; No_CaptionLbl)
            {
            }
            column(NameCaption; NameCaptionLbl)
            {
            }
            column(Balance_at_Starting_DateCaption; Balance_at_Starting_DateCaptionLbl)
            {
            }
            column(Balance_Date_RangeCaption; Balance_Date_RangeCaptionLbl)
            {
            }
            column(Balance_at_Ending_dateCaption; Balance_at_Ending_dateCaptionLbl)
            {
            }
            column(DebitCaption; DebitCaptionLbl)
            {
            }
            column(CreditCaption; CreditCaptionLbl)
            {
            }
            column(DebitCaption_Control1120030; DebitCaption_Control1120030Lbl)
            {
            }
            column(CreditCaption_Control1120032; CreditCaption_Control1120032Lbl)
            {
            }
            column(DebitCaption_Control1120034; DebitCaption_Control1120034Lbl)
            {
            }
            column(CreditCaption_Control1120036; CreditCaption_Control1120036Lbl)
            {
            }
            column(Grand_totalCaption; Grand_totalCaptionLbl)
            {
            }

            trigger OnAfterGetRecord()
            begin
                BankAccount2 := "Bank Account";
                BankAccount2.SetRange("Date Filter", 0D, PreviousEndDate);
                BankAccount2.CalcFields("Debit Amount (LCY)", "Credit Amount (LCY)");
                if not PrintBanksWithoutBalance and
                   (BankAccount2."Debit Amount (LCY)" = 0) and
                   ("Debit Amount (LCY)" = 0) and
                   (BankAccount2."Credit Amount (LCY)" = 0) and
                   ("Credit Amount (LCY)" = 0)
                then
                    CurrReport.Skip();
            end;

            trigger OnPreDataItem()
            begin
                if GetFilter("Date Filter") = '' then
                    Error(Text001, FieldCaption("Date Filter"));
                if CopyStr(GetFilter("Date Filter"), 1, 1) = '.' then
                    Error(Text002);
                StartDate := GetRangeMin("Date Filter");
                PreviousEndDate := ClosingDate(StartDate - 1);
                FiltreDateCalc.CreateFiscalYearFilter(TextDate, TextDate, StartDate, 0);
                TextDate := ConvertStr(TextDate, '.', ',');
                FiltreDateCalc.VerifiyDateFilter(TextDate);
                TextDate := CopyStr(TextDate, 1, 8);
                Evaluate(PreviousStartDate, TextDate);
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
                    field(PrintBanksWithoutBalance; PrintBanksWithoutBalance)
                    {
                        ApplicationArea = All;
                        captionML = ENU = 'Print Banks without Balance', FRA = 'Imprimer banques sans solde';
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
        Filter := "Bank Account".GetFilters;
    end;

    var
        BankAccount2: Record "Bank Account";
        // FiltreDateCalc: Codeunit "DateFilter-Calc";
        FiltreDateCalc: Codeunit "WDC-ED DateFilter-Calc Delta";
        StartDate: Date;
        PreviousStartDate: Date;
        PreviousEndDate: Date;
        TextDate: Text;
        PrintBanksWithoutBalance: Boolean;
        "Filter": Text;
        Text001: TextConst ENU = 'You must fill in the %1 field.',
                           FRA = 'Vous devez renseigner le champ %1.';
        Text002: TextConst ENU = 'You must specify a Starting Date.',
                           FRA = 'Vous devez spécifier une date de début.';
        Text003: TextConst ENU = 'Printed by %1',
                           FRA = 'Imprimé par %1';
        Text004: TextConst ENU = 'Fiscal Year Start Date : %1',
                           FRA = 'Début exercice comptable : %1';
        Text005: TextConst ENU = 'Page %1',
                           FRA = 'Page %1';
        Bank_Account_Trial_BalanceCaptionLbl: TextConst ENU = 'Bank Account Trial Balance',
                                                        FRA = 'Balance comptes bancaires';
        No_CaptionLbl: TextConst ENU = 'No.',
                                 FRA = 'N°';
        NameCaptionLbl: TextConst ENU = 'Name',
                                  FRA = 'Nom';
        Balance_at_Starting_DateCaptionLbl: TextConst ENU = 'Balance at Starting Date',
                                                      FRA = 'Solde à la date de début';
        Balance_Date_RangeCaptionLbl: TextConst ENU = 'Balance Date Range',
                                                FRA = 'Solde plage de dates';
        Balance_at_Ending_dateCaptionLbl: TextConst ENU = 'Balance at Ending date',
                                                    FRA = 'Solde à la date de fin';
        DebitCaptionLbl: TextConst ENU = 'Debit',
                                   FRA = 'Débit';
        CreditCaptionLbl: TextConst ENU = 'Credit',
                                    FRA = 'Crédit';
        DebitCaption_Control1120030Lbl: TextConst ENU = 'Debit',
                                                  FRA = 'Débit';
        CreditCaption_Control1120032Lbl: TextConst ENU = 'Credit',
                                                   FRA = 'Crédit';
        DebitCaption_Control1120034Lbl: TextConst ENU = 'Debit',
                                                  FRA = 'Débit';
        CreditCaption_Control1120036Lbl: TextConst ENU = 'Credit',
                                                   FRA = 'Crédit';
        Grand_totalCaptionLbl: TextConst ENU = 'Grand total',
                                         FRA = 'Total général';
}

