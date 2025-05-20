report 50814 "WDC-ED Vendor Journal"
{
    DefaultLayout = RDLC;
    RDLCLayout = './.vscode/src_ED/report/RDLC/VendorJournal.rdlc';
    ApplicationArea = All;
    captionML = ENU = 'Vendor Journal', FRA = 'Journal comptes fournisseurs';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(Date; Date)
        {
            DataItemTableView = SORTING("Period Type", "Period Start");
            PrintOnlyIfDetail = true;
            RequestFilterFields = "Period Type", "Period Start";
            column(TodayFormatted; Format(Today, 0, 4))
            {
            }
            column(CompanyName; COMPANYPROPERTY.DisplayName)
            {
            }
            column("Page"; StrSubstNo(Text007, ''))
            {
            }
            column(PrintedBy; StrSubstNo(Text006, ''))
            {
            }
            column(VendLedgEntryTableCaptionFilter; "Vendor Ledger Entry".TableCaption + ': ' + Filter)
            {
            }
            column("Filter"; Filter)
            {
            }
            column(SourceCodeTableCaptionFilter2; SourceCode.TableCaption + ': ' + Filter2)
            {
            }
            column(Filter2; Filter2)
            {
            }
            column(DebitTotal; DebitTotal)
            {
            }
            column(CreditTotal; CreditTotal)
            {
            }
            column(PeriodType_Date; "Period Type")
            {
            }
            column(PeriodStart_Date; "Period Start")
            {
            }
            column(VendorJnlCaption; VendorJnlCaptionLbl)
            {
            }
            column(PostingDateCaption; PostingDateCaptionLbl)
            {
            }
            column(DocNoCaption; DocNoCaptionLbl)
            {
            }
            column(VendorNoCaption; VendorNoCaptionLbl)
            {
            }
            column(DueDateCaption; DueDateCaptionLbl)
            {
            }
            column(PmtDiscDateCaption; PmtDiscDateCaptionLbl)
            {
            }
            column(PmtDiscRcdLCYCaption; PmtDiscRcdLCYCaptionLbl)
            {
            }
            column(DescCaption; DescCaptionLbl)
            {
            }
            column(CurrCodeCaption; CurrCodeCaptionLbl)
            {
            }
            column(DebitCaption; DebitCaptionLbl)
            {
            }
            column(CreditCaption; CreditCaptionLbl)
            {
            }
            column(DebitLCYCaption; DebitLCYCaptionLbl)
            {
            }
            column(CreditLCYCaption; CreditLCYCaptionLbl)
            {
            }
            column(GrandTotalCaption; GrandTotalCaptionLbl)
            {
            }
            dataitem(SourceCode; "Source Code")
            {
                DataItemTableView = SORTING(Code);
                PrintOnlyIfDetail = true;
                RequestFilterFields = "Code";
                column(DatePeriodType; Date."Period Type")
                {
                }
                column(DatePeriodNameYearString; Date."Period Name" + YearString)
                {
                }
                column(DateRecNo; DateRecNo)
                {
                }
                column(Code_SourceCode; Code)
                {
                }
                column(Desc_SourceCode; Description)
                {
                }
                column(PeriodTypeNo; PeriodTypeNo)
                {
                }
                dataitem("Vendor Ledger Entry"; "Vendor Ledger Entry")
                {
                    DataItemLink = "Source Code" = FIELD(Code);
                    DataItemTableView = SORTING("Document Type", "Vendor No.", "Posting Date", "Currency Code");
                    column(SourceCode2Code; SourceCode2.Code)
                    {
                    }
                    column(SourceCode2Desc; SourceCode2.Description)
                    {
                    }
                    column(DebitAmtLCY_VendLedgEntry; "Debit Amount (LCY)")
                    {
                    }
                    column(CreditAmtLCY_VendLedgEntry; "Credit Amount (LCY)")
                    {
                    }
                    column(PostingDateFormatted_VendLedgEntry; Format("Posting Date"))
                    {
                    }
                    column(DocNo_VendLedgEntry; "Document No.")
                    {
                    }
                    column(VendorNo_VendLedgEntry; "Vendor No.")
                    {
                    }
                    column(DueDateFormatted_VendLedgEntry; Format("Due Date"))
                    {
                    }
                    column(PmtDiscountDateFormatted_VendLedgEntry; Format("Pmt. Discount Date"))
                    {
                    }
                    column(PmtDiscRcdLCY_VendLedgEntry; "Pmt. Disc. Rcd.(LCY)")
                    {
                    }
                    column(Desc_VendLedgEntry; Description)
                    {
                    }
                    column(CurrCode_VendLedgEntry; "Currency Code")
                    {
                    }
                    column(DebitAmt_VendLedgEntry; "Debit Amount")
                    {
                    }
                    column(CreditAmt_VendLedgEntry; "Credit Amount")
                    {
                    }
                    column(EntryNo_VendLedgEntry; "Entry No.")
                    {
                    }
                    column(SourceCode_VendLedgEntry; "Source Code")
                    {
                    }
                    column(TotalCaption; TotalCaptionLbl)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        DebitTotal := DebitTotal + "Debit Amount (LCY)";
                        CreditTotal := CreditTotal + "Credit Amount (LCY)";
                    end;

                    trigger OnPostDataItem()
                    begin
                        if Date."Period Type" = Date."Period Type"::Date then
                            Finished := true;
                    end;

                    trigger OnPreDataItem()
                    begin
                        case SortingBy of
                            SortingBy::"Posting Date":
                                SetCurrentKey("Source Code", "Posting Date", "Document No.");
                            SortingBy::"Document No.":
                                SetCurrentKey("Source Code", "Document No.", "Posting Date");
                        end;

                        if StartDate > Date."Period Start" then
                            Date."Period Start" := StartDate;
                        if EndDate < Date."Period End" then
                            Date."Period End" := EndDate;
                        if Date."Period Type" <> Date."Period Type"::Date then
                            SetRange("Posting Date", Date."Period Start", Date."Period End")
                        else
                            SetRange("Posting Date", StartDate, EndDate);
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    SourceCode2 := SourceCode;
                    PeriodTypeNo := Date."Period Type";
                end;
            }

            trigger OnAfterGetRecord()
            begin
                YearString := '';
                if Date."Period Type" <> Date."Period Type"::Year then begin
                    Year := Date2DMY("Period End", 3);
                    YearString := ' ' + Format(Year);
                end;
                if Finished then
                    CurrReport.Break();
                DateRecNo += 1;
            end;

            trigger OnPreDataItem()
            var
                Period: Record Date;
            begin
                if GetFilter("Period Type") = '' then
                    Error(Text004, FieldCaption("Period Type"));
                if GetFilter("Period Start") = '' then
                    Error(Text004, FieldCaption("Period Start"));
                if CopyStr(GetFilter("Period Start"), 1, 1) = '.' then
                    Error(Text005);
                StartDate := GetRangeMin("Period Start");
                CopyFilter("Period Type", Period."Period Type");
                Period.SetRange("Period Start", StartDate);
                if not Period.FindFirst then
                    Error(Text008, StartDate, GetFilter("Period Type"));
                FiltreDateCalc.CreateFiscalYearFilter(TextDate, TextDate, StartDate, 0);
                TextDate := ConvertStr(TextDate, '.', ',');
                FiltreDateCalc.VerifiyDateFilter(TextDate);
                TextDate := CopyStr(TextDate, 1, 8);
                Evaluate(PreviousStartDate, TextDate);
                if CopyStr(GetFilter("Period Start"), StrLen(GetFilter("Period Start")), 1) = '.' then
                    EndDate := 0D
                else
                    EndDate := GetRangeMax("Period Start");
                if EndDate = StartDate then
                    EndDate := FiltreDateCalc.ReturnEndingPeriod(StartDate, Date.GetRangeMin("Period Type"));
                Clear(Period);
                CopyFilter("Period Type", Period."Period Type");
                Period.SetRange("Period End", ClosingDate(EndDate));
                if not Period.FindFirst then
                    Error(Text009, EndDate, GetFilter("Period Type"));
                DateRecNo := 0;
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
                    field("Posting Date"; SortingBy)
                    {
                        ApplicationArea = All;
                        captionML = ENU = 'Sorted by', FRA = 'Trié par';
                        OptionCaptionML = ENU = 'Posting Date,Document No.', FRA = 'Date comptabilisation,N° document';
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
        Filter := Date.GetFilters;
        Filter2 := SourceCode.GetFilters;
    end;

    var
        SourceCode2: Record "Source Code";
        // FiltreDateCalc: Codeunit "DateFilter-Calc";
        FiltreDateCalc: Codeunit "WDC-ED DateFilter-Calc Delta";
        StartDate: Date;
        EndDate: Date;
        PreviousStartDate: Date;
        TextDate: Text;
        DebitTotal: Decimal;
        CreditTotal: Decimal;
        Filter2: Text;
        SortingBy: Option "Posting Date","Document No.";
        "Filter": Text;
        Year: Integer;
        YearString: Text;
        Finished: Boolean;
        PeriodTypeNo: Integer;
        DateRecNo: Integer;
        Text004: TextConst ENU = 'You must fill in the %1 field.',
                           FRA = 'Vous devez renseigner le champ %1';
        Text005: TextConst ENU = 'You must specify a Starting Date.',
                           FRA = 'Vous devez spécifier une date de début.';
        Text006: TextConst ENU = 'Printed by %1',
                           FRA = 'Imprimé par %1';
        Text007: TextConst ENU = 'Page %1',
                           FRA = 'Page %1';
        Text008: TextConst ENU = 'The selected starting date %1 is not the start of a %2.',
                           FRA = 'La date de début choisie (%1) ne correspond pas au début de %2.';
        Text009: TextConst ENU = 'The selected ending date %1 is not the end of a %2.',
                           FRA = 'La date de fin choisie (%1) ne correspond pas à la fin de %2.';
        VendorJnlCaptionLbl: TextConst ENU = 'Vendor Journal',
                                       FRA = 'Journal comptes fournisseurs';
        PostingDateCaptionLbl: TextConst ENU = 'Posting Date',
                                         FRA = 'Date comptabilisation';
        DocNoCaptionLbl: TextConst ENU = 'Document No.',
                                   FRA = 'N° du document';
        VendorNoCaptionLbl: TextConst ENU = 'Vendor No.',
                                      FRA = 'N° fournisseur';
        DueDateCaptionLbl: TextConst ENU = 'Due Date',
                                     FRA = 'Date d''échéance';
        PmtDiscDateCaptionLbl: TextConst ENU = 'Pmt. Discount Date',
                                         FRA = 'Date remise payment';
        PmtDiscRcdLCYCaptionLbl: TextConst ENU = 'Pmt. Disc. Rcd.(LCY)',
                                           FRA = 'Remise payment réçu (LCY)';
        DescCaptionLbl: TextConst ENU = 'Description',
                                  FRA = 'Description';
        CurrCodeCaptionLbl: TextConst ENU = 'Currency Code',
                                      FRA = 'Code devise';
        DebitCaptionLbl: TextConst ENU = 'Debit',
                                   FRA = 'Débit';
        CreditCaptionLbl: TextConst ENU = 'Credit',
                                    FRA = 'Crédit';
        DebitLCYCaptionLbl: TextConst ENU = 'Debit (LCY)',
                                      FRA = 'Débit (LCY)';
        CreditLCYCaptionLbl: TextConst ENU = 'Credit (LCY)',
                                       FRA = 'Crédit (LCY)';
        GrandTotalCaptionLbl: TextConst ENU = 'Grand Total :',
                                        FRA = 'Total général :';
        TotalCaptionLbl: TextConst ENU = 'Total',
                                   FRA = 'Total';
}

