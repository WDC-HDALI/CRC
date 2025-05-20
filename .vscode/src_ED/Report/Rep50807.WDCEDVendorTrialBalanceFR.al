report 50807 "WDC-ED Vendor Trial Balance FR"
{
    DefaultLayout = RDLC;
    RDLCLayout = './.vscode/src_ED/report/RDLC/VendorTrialBalanceFR.rdlc';
    ApplicationArea = All;
    captionML = ENU = 'Vendor Trial Balance', FRA = 'Balance fournisseurs';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(Vendor; Vendor)
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
            column(PageCaption; StrSubstNo(Text005, ' '))
            {
            }
            column(PrintedByCaption; StrSubstNo(Text003, ''))
            {
            }
            column(Vendor_TABLECAPTION__________Filter; Vendor.TableCaption + ': ' + Filter)
            {
            }
            column("Filter"; Filter)
            {
            }
            column(Vendor__No__; "No.")
            {
            }
            column(Vendor_Name; Name)
            {
            }
            column(PreviousDebitAmountLCY_PreviousCreditAmountLCY; PreviousDebitAmountLCY - PreviousCreditAmountLCY)
            {
            }
            column(PreviousCreditAmountLCY_PreviousDebitAmountLCY; PreviousCreditAmountLCY - PreviousDebitAmountLCY)
            {
            }
            column(PeriodDebitAmountLCY; PeriodDebitAmountLCY)
            {
            }
            column(PeriodCreditAmountLCY; PeriodCreditAmountLCY)
            {
            }
            column(PreviousDebitAmountLCY_PeriodDebitAmountLCY___PreviousCreditAmountLCY_PeriodCreditAmountLCY_; (PreviousDebitAmountLCY + PeriodDebitAmountLCY) - (PreviousCreditAmountLCY + PeriodCreditAmountLCY))
            {
            }
            column(PreviousCreditAmountLCY_PeriodCreditAmountLCY___PreviousDebitAmountLCY_PeriodDebitAmountLCY_; (PreviousCreditAmountLCY + PeriodCreditAmountLCY) - (PreviousDebitAmountLCY + PeriodDebitAmountLCY))
            {
            }
            column(PreviousDebitAmountLCY_PreviousCreditAmountLCY_Control1120069; PreviousDebitAmountLCY - PreviousCreditAmountLCY)
            {
            }
            column(PreviousCreditAmountLCY_PreviousDebitAmountLCY_Control1120072; PreviousCreditAmountLCY - PreviousDebitAmountLCY)
            {
            }
            column(PeriodDebitAmountLCY_Control1120075; PeriodDebitAmountLCY)
            {
            }
            column(PeriodCreditAmountLCY_Control1120078; PeriodCreditAmountLCY)
            {
            }
            column(PreviousDebitAmountLCY_PeriodDebitAmountLCY___PreviousCreditAmountLCY_PeriodCreditAmountLCY__Control1120081; (PreviousDebitAmountLCY + PeriodDebitAmountLCY) - (PreviousCreditAmountLCY + PeriodCreditAmountLCY))
            {
            }
            column(PreviousCreditAmountLCY_PeriodCreditAmountLCY___PreviousDebitAmountLCY_PeriodDebitAmountLCY__Control1120084; (PreviousCreditAmountLCY + PeriodCreditAmountLCY) - (PreviousDebitAmountLCY + PeriodDebitAmountLCY))
            {
            }
            column(Vendor_Trial_BalanceCaption; Vendor_Trial_BalanceCaptionLbl)
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
                PreviousDebitAmountLCY := 0;
                PreviousCreditAmountLCY := 0;
                PeriodDebitAmountLCY := 0;
                PeriodCreditAmountLCY := 0;

                VendLedgEntry.SetCurrentKey("Vendor No.", "Posting Date", "Entry Type", "Initial Entry Global Dim. 1", "Initial Entry Global Dim. 2",
                  "Currency Code");
                VendLedgEntry.SetRange("Vendor No.", "No.");
                if Vendor.GetFilter("Global Dimension 1 Filter") <> '' then
                    VendLedgEntry.SetRange("Initial Entry Global Dim. 1", Vendor.GetFilter("Global Dimension 1 Filter"));
                if Vendor.GetFilter("Global Dimension 2 Filter") <> '' then
                    VendLedgEntry.SetRange("Initial Entry Global Dim. 2", Vendor.GetFilter("Global Dimension 2 Filter"));
                if Vendor.GetFilter("Currency Filter") <> '' then
                    VendLedgEntry.SetRange("Currency Code", Vendor.GetFilter("Currency Filter"));
                VendLedgEntry.SetRange("Posting Date", 0D, PreviousEndDate);
                VendLedgEntry.SetFilter("Entry Type", '<>%1', VendLedgEntry."Entry Type"::Application);
                if VendLedgEntry.FindSet then
                    repeat
                        PreviousDebitAmountLCY += VendLedgEntry."Debit Amount (LCY)";
                        PreviousCreditAmountLCY += VendLedgEntry."Credit Amount (LCY)";
                    until VendLedgEntry.Next = 0;
                VendLedgEntry.SetRange("Posting Date", StartDate, EndDate);
                if VendLedgEntry.FindSet then
                    repeat
                        PeriodDebitAmountLCY += VendLedgEntry."Debit Amount (LCY)";
                        PeriodCreditAmountLCY += VendLedgEntry."Credit Amount (LCY)";
                    until VendLedgEntry.Next = 0;

                if not PrintVendWithoutBalance and (PeriodDebitAmountLCY = 0) and (PeriodCreditAmountLCY = 0) and
                   (PreviousDebitAmountLCY = 0) and (PreviousCreditAmountLCY = 0)
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
                if CopyStr(GetFilter("Date Filter"), StrLen(GetFilter("Date Filter")), 1) = '.' then
                    EndDate := 0D
                else
                    EndDate := GetRangeMax("Date Filter");
                Clear(PreviousDebitAmountLCY);
                Clear(PreviousCreditAmountLCY);
                Clear(PeriodDebitAmountLCY);
                Clear(PeriodCreditAmountLCY);
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
                    field(PrintVendorsWithoutBalance; PrintVendWithoutBalance)
                    {
                        ApplicationArea = All;
                        captionML = ENU = 'Print Vendors without Balance', FRA = 'Imprimer fournisseurs sans solde';
                        MultiLine = true;
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
        Filter := Vendor.GetFilters;
    end;

    var
        VendLedgEntry: Record "Detailed Vendor Ledg. Entry";
        // FiltreDateCalc: Codeunit "DateFilter-Calc";
        FiltreDateCalc: Codeunit "WDC-ED DateFilter-Calc Delta";
        StartDate: Date;
        EndDate: Date;
        PreviousStartDate: Date;
        PreviousEndDate: Date;
        TextDate: Text;
        PrintVendWithoutBalance: Boolean;
        "Filter": Text;
        PreviousDebitAmountLCY: Decimal;
        PreviousCreditAmountLCY: Decimal;
        PeriodDebitAmountLCY: Decimal;
        PeriodCreditAmountLCY: Decimal;
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
        Vendor_Trial_BalanceCaptionLbl: TextConst ENU = 'Vendor Trial Balance',
                                                  FRA = 'Balance fournisseurs';
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

