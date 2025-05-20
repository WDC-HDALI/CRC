report 50815 "WDC-ED Bank Account Journal"
{
    DefaultLayout = RDLC;
    RDLCLayout = './.vscode/src_ED/report/RDLC/BankAccountJournal.rdlc';
    ApplicationArea = All;
    captionML = ENU = 'Bank Account Journal', FRA = 'Journal comptes bancaires';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(Date; Date)
        {
            DataItemTableView = SORTING("Period Type", "Period Start");
            PrintOnlyIfDetail = true;
            RequestFilterFields = "Period Type", "Period Start";
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(COMPANYNAME; COMPANYPROPERTY.DisplayName)
            {
            }
            column(STRSUBSTNO_Text006_USERID_; StrSubstNo(Text006, UserId))
            {
            }
            column(STRSUBSTNO_Text007____; StrSubstNo(Text007, ''))
            {
            }
            column(STRSUBSTNO_Text006____; StrSubstNo(Text006, ''))
            {
            }
            column(Bank_Account_Ledger_Entry__TABLECAPTION__________Filter; "Bank Account Ledger Entry".TableCaption + ': ' + Filter)
            {
            }
            column("Filter"; Filter)
            {
            }
            column(SourceCode_TABLECAPTION__________Filter2; SourceCode.TableCaption + ': ' + Filter2)
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
            column(Date_Period_Type; "Period Type")
            {
            }
            column(Date_Period_Start; "Period Start")
            {
            }
            column(Bank_Account_JournalCaption; Bank_Account_JournalCaptionLbl)
            {
            }
            column(Posting_DateCaption; Posting_DateCaptionLbl)
            {
            }
            column(Document_No_Caption; Document_No_CaptionLbl)
            {
            }
            column(Bank_Account_No_Caption; Bank_Account_No_CaptionLbl)
            {
            }
            column(DescriptionCaption; DescriptionCaptionLbl)
            {
            }
            column(Currency_CodeCaption; Currency_CodeCaptionLbl)
            {
            }
            column(DebitCaption; DebitCaptionLbl)
            {
            }
            column(CreditCaption; CreditCaptionLbl)
            {
            }
            column(Debit__LCY_Caption; Debit__LCY_CaptionLbl)
            {
            }
            column(Credit__LCY_Caption; Credit__LCY_CaptionLbl)
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
                column(Date__Period_Name_; Date."Period Name")
                {
                }
                column(DateRecNo; DateRecNo)
                {
                }
                column(SourceCode_Code; Code)
                {
                }
                column(SourceCode_Description; Description)
                {
                }
                column(PeriodTypeNo; PeriodTypeNo)
                {
                }
                dataitem("Bank Account Ledger Entry"; "Bank Account Ledger Entry")
                {
                    DataItemLink = "Source Code" = FIELD(Code);
                    DataItemTableView = SORTING("Document Type", "Bank Account No.", "Posting Date");
                    column(SourceCode2_Code; SourceCode2.Code)
                    {
                    }
                    column(SourceCode2_Description; SourceCode2.Description)
                    {
                    }
                    column(Bank_Account_Ledger_Entry__Debit_Amount__LCY__; "Debit Amount (LCY)")
                    {
                    }
                    column(Bank_Account_Ledger_Entry__Credit_Amount__LCY__; "Credit Amount (LCY)")
                    {
                    }
                    column(Bank_Account_Ledger_Entry__Posting_Date_; Format("Posting Date"))
                    {
                    }
                    column(Bank_Account_Ledger_Entry__Document_No__; "Document No.")
                    {
                    }
                    column(Bank_Account_Ledger_Entry__Bank_Account_No__; "Bank Account No.")
                    {
                    }
                    column(Bank_Account_Ledger_Entry_Description; Description)
                    {
                    }
                    column(Bank_Account_Ledger_Entry__Currency_Code_; "Currency Code")
                    {
                    }
                    column(Bank_Account_Ledger_Entry__Debit_Amount_; "Debit Amount")
                    {
                    }
                    column(Bank_Account_Ledger_Entry__Credit_Amount_; "Credit Amount")
                    {
                    }
                    column(Bank_Account_Ledger_Entry__Debit_Amount__LCY___Control1120081; "Debit Amount (LCY)")
                    {
                    }
                    column(Bank_Account_Ledger_Entry__Credit_Amount__LCY___Control1120084; "Credit Amount (LCY)")
                    {
                    }
                    column(SourceCode2_Code_Control1120086; SourceCode2.Code)
                    {
                    }
                    column(SourceCode2_Description_Control1120088; SourceCode2.Description)
                    {
                    }
                    column(Bank_Account_Ledger_Entry__Debit_Amount__LCY___Control1120092; "Debit Amount (LCY)")
                    {
                    }
                    column(Bank_Account_Ledger_Entry__Credit_Amount__LCY___Control1120094; "Credit Amount (LCY)")
                    {
                    }
                    column(SourceCode2_Code_Control1120096; SourceCode2.Code)
                    {
                    }
                    column(SourceCode2_Description_Control1120098; SourceCode2.Description)
                    {
                    }
                    column(Bank_Account_Ledger_Entry__Debit_Amount__LCY___Control1120102; "Debit Amount (LCY)")
                    {
                    }
                    column(Bank_Account_Ledger_Entry__Credit_Amount__LCY___Control1120104; "Credit Amount (LCY)")
                    {
                    }
                    column(Bank_Account_Ledger_Entry_Entry_No_; "Entry No.")
                    {
                    }
                    column(Bank_Account_Ledger_Entry_Source_Code; "Source Code")
                    {
                    }
                    column(TotalCaption; TotalCaptionLbl)
                    {
                    }
                    column(TotalCaption_Control1120090; TotalCaption_Control1120090Lbl)
                    {
                    }
                    column(TotalCaption_Control1120100; TotalCaption_Control1120100Lbl)
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
        Bank_Account_JournalCaptionLbl: TextConst ENU = 'Bank Account Journal',
                                                  FRA = 'Journal comptes bancaires';
        Posting_DateCaptionLbl: TextConst ENU = 'Posting Date',
                                          FRA = 'Date comptabilisation';
        Document_No_CaptionLbl: TextConst ENU = 'Document No.',
                                          FRA = 'N° du document';
        Bank_Account_No_CaptionLbl: TextConst ENU = 'Bank Account No.',
                                              FRA = 'N° compte bancaire client';
        DescriptionCaptionLbl: TextConst ENU = 'Description',
                                         FRA = 'Description';
        Currency_CodeCaptionLbl: TextConst ENU = 'Currency Code',
                                           FRA = 'Code devise';
        DebitCaptionLbl: TextConst ENU = 'Debit',
                                   FRA = 'Débit';
        CreditCaptionLbl: TextConst ENU = 'Credit',
                                    FRA = 'Crédit';
        Debit__LCY_CaptionLbl: TextConst ENU = 'Debit (LCY)',
                                         FRA = 'Débit (LCY)';
        Credit__LCY_CaptionLbl: TextConst ENU = 'Credit (LCY)',
                                          FRA = 'Crédit (LCY)';
        Grand_Total__CaptionLbl: TextConst ENU = 'Grand Total :',
                                           FRA = 'Total général :';
        TotalCaptionLbl: TextConst ENU = 'Total',
                                   FRA = 'Total';
        TotalCaption_Control1120090Lbl: TextConst ENU = 'Total',
                                                  FRA = 'Total';
        TotalCaption_Control1120100Lbl: TextConst ENU = 'Total',
                                                  FRA = 'Total';
}

