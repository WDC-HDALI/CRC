report 50801 "WDC-ED Journals"
{
    DefaultLayout = RDLC;
    RDLCLayout = './.vscode/src_ED/report/RDLC/Journals.rdlc';
    ApplicationArea = All;
    CaptionML = ENU = 'Journals', FRA = 'Journal';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(Date; Date)
        {
            DataItemTableView = SORTING("Period Type", "Period Start");
            PrintOnlyIfDetail = true;
            RequestFilterFields = "Period Type", "Period Start";
            column(Title; Title)
            {
            }
            column(COMPANYNAME; COMPANYPROPERTY.DisplayName)
            {
            }
            column(STRSUBSTNO_Text006____; StrSubstNo(Text006, ''))
            {
            }
            column(STRSUBSTNO_Text007____; StrSubstNo(Text007, ''))
            {
            }
            column(Text012; StrSubstNo(Text012, ''))
            {
            }
            column(GLEntry2_TABLECAPTION__________Filter; GLEntry2.TableCaption + ': ' + Filter)
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
            column(SourceCode_TABLECAPTION__________Filter2; SourceCode.TableCaption + ': ' + Filter2)
            {
            }
            column(Filter2; Filter2)
            {
            }
            column(DisplayEntries; DisplayEntries)
            {
            }
            column(SortingByNo; SortingByNo)
            {
            }
            column(DateRecNo; DateRecNo)
            {
            }
            column(DisplayCentral; DisplayCentral)
            {
            }
            column(DebitTotal; DebitTotal)
            {
            }
            column(CreditTotal; CreditTotal)
            {
            }
            column(Posting_DateCaption; Posting_DateCaptionLbl)
            {
            }
            column(Document_No_Caption; Document_No_CaptionLbl)
            {
            }
            column(External_Document_No_Caption; External_Document_No_CaptionLbl)
            {
            }
            column(G_L_Account_No_Caption; G_L_Account_No_CaptionLbl)
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
                column(Date__Period_Name____YearString; Date."Period Name" + YearString)
                {
                }
                column(PeriodTypeNo; PeriodTypeNo)
                {
                }
                column(SourceCode_Code; Code)
                {
                }
                column(SourceCode_Description; Description)
                {
                }
                dataitem("G/L Entry"; "G/L Entry")
                {
                    DataItemLink = "Source Code" = FIELD(Code);
                    DataItemTableView = SORTING("Source Code", "Posting Date");
                    column(SourceCode2_Code; SourceCode2.Code)
                    {
                    }
                    column(SourceCode2_Description; SourceCode2.Description)
                    {
                    }
                    column(G_L_Entry__Debit_Amount_; "Debit Amount")
                    {
                    }
                    column(G_L_Entry__Credit_Amount_; "Credit Amount")
                    {
                    }
                    column(G_L_Entry__Posting_Date_; Format("Posting Date"))
                    {
                    }
                    column(G_L_Entry__Document_No__; "Document No.")
                    {
                    }
                    column(G_L_Entry__External_Document_No__; "External Document No.")
                    {
                    }
                    column(G_L_Entry__G_L_Account_No__; "G/L Account No.")
                    {
                    }
                    column(G_L_Entry_Description; Description)
                    {
                    }
                    column(STRSUBSTNO_Text008_FIELDCAPTION__Document_No_____Document_No___; StrSubstNo(Text008, FieldCaption("Document No."), "Document No."))
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        if DisplayEntries then begin
                            DebitTotal := DebitTotal + "Debit Amount";
                            CreditTotal := CreditTotal + "Credit Amount";
                        end;
                    end;

                    trigger OnPostDataItem()
                    begin
                        if Date."Period Type" = Date."Period Type"::Date then
                            Finished := true;
                    end;

                    trigger OnPreDataItem()
                    begin
                        if not DisplayEntries then
                            CurrReport.Break();

                        if DisplayEntries then
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
                dataitem("G/L Account"; "G/L Account")
                {
                    DataItemTableView = SORTING("No.");
                    PrintOnlyIfDetail = true;
                    column(SourceCode2_Code_Control1120096; SourceCode2.Code)
                    {
                    }
                    column(SourceCode2_Description_Control1120098; SourceCode2.Description)
                    {
                    }
                    column(GLEntry2__Debit_Amount_; GLEntry2."Debit Amount")
                    {
                    }
                    column(GLEntry2__Credit_Amount_; GLEntry2."Credit Amount")
                    {
                    }
                    column(G_L_Account___No__; "No.")
                    {
                    }
                    dataitem(GLEntry2; "G/L Entry")
                    {
                        DataItemTableView = SORTING("G/L Account No.", "Posting Date", "Source Code");
                        column(G_L_Account__Name; "G/L Account".Name)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            if not DisplayEntries then begin
                                DebitTotal := DebitTotal + "Debit Amount";
                                CreditTotal := CreditTotal + "Credit Amount";
                            end;
                        end;

                        trigger OnPostDataItem()
                        begin
                            if Date."Period Type" = Date."Period Type"::Date then
                                Finished := true;
                        end;

                        trigger OnPreDataItem()
                        begin
                            SetCurrentKey("G/L Account No.", "Posting Date", "Source Code");
                            SetRange("G/L Account No.", "G/L Account"."No.");
                            if Date."Period Type" <> Date."Period Type"::Date then
                                SetRange("Posting Date", Date."Period Start", Date."Period End")
                            else
                                SetRange("Posting Date", StartDate, EndDate);
                            SetRange("Source Code", SourceCode.Code);
                        end;
                    }

                    trigger OnPreDataItem()
                    begin
                        if not DisplayCentral then
                            CurrReport.Break();
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    SourceCode2 := SourceCode;
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
                PeriodTypeNo := "Period Type";
                DateRecNo += 1;
            end;

            trigger OnPreDataItem()
            var
                Period: Record Date;
            begin
                Hidden := false;

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
                    Error(Text009, StartDate, GetFilter("Period Type"));
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
                    EndDate := DateFilterCalc.ReturnEndingPeriod(StartDate, Date.GetRangeMin("Period Type"));
                Clear(Period);
                CopyFilter("Period Type", Period."Period Type");
                Period.SetRange("Period End", ClosingDate(EndDate));
                if not Period.FindFirst then
                    Error(Text010, EndDate, GetFilter("Period Type"));
                FiscalYearStatusText := StrSubstNo(Text011, FiscalYearFiscalClose.CheckFiscalYearStatus(GetFilter("Period Start")));

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
                    CaptionML = ENU = 'Options', FRA = 'Options';
                    field(Journals; Display)
                    {
                        ApplicationArea = All;
                        CaptionML = ENU = 'Display', FRA = 'Afficher';
                        OptionCaptionML = ENU = 'Journals,Centralized Journals,Journals and Centralization', FRA = 'Feuilles,Centralisation des feuilles,Feuilles et centralisation';

                        trigger OnValidate()
                        begin
                            PageRefresh;
                        end;
                    }
                    field("Posting Date"; SortingBy)
                    {
                        ApplicationArea = All;
                        CaptionML = ENU = 'Sorted by', FRA = 'Trié par';
                        OptionCaptionML = ENU = 'Posting Date,Document No.', FRA = 'Date comptabilisation,N° document';

                        trigger OnValidate()
                        begin
                            if SortingBy = SortingBy::"Document No." then
                                if not DocumentNoVisible then
                                    Error(Text666, SortingBy);
                            if SortingBy = SortingBy::"Posting Date" then
                                if not PostingDateVisible then
                                    Error(Text666, SortingBy);
                        end;
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnInit()
        begin
            DocumentNoVisible := true;
            PostingDateVisible := true;
        end;

        trigger OnOpenPage()
        begin
            PageRefresh;
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        Filter := Date.GetFilters;
        Filter2 := SourceCode.GetFilters;

        case Display of
            Display::Journals:
                begin
                    DisplayEntries := true;
                    Title := Text001
                end;
            Display::"Centralized Journals":
                begin
                    DisplayCentral := true;
                    Title := Text002
                end;
            Display::"Journals and Centralization":
                begin
                    DisplayEntries := true;
                    DisplayCentral := true;
                    Title := Text003
                end;
        end;
        SortingByNo := SortingBy;
    end;



    local procedure PageRefresh()
    begin
        PostingDateVisible := (Display = Display::Journals) or (Display = Display::"Journals and Centralization");
        DocumentNoVisible := (Display = Display::Journals) or (Display = Display::"Journals and Centralization");
    end;

    var
        SourceCode2: Record "Source Code";
        // DateFilterCalc: Codeunit "DateFilter-Calc";
        DateFilterCalc: Codeunit "WDC-ED DateFilter-Calc Delta";
        FiscalYearFiscalClose: Codeunit "WDC-ED Fiscal Year-FiscalClose";
        StartDate: Date;
        EndDate: Date;
        PreviousStartDate: Date;
        TextDate: Text[30];
        DebitTotal: Decimal;
        CreditTotal: Decimal;
        Filter2: Text;
        Title: Text;
        SortingBy: Option "Posting Date","Document No.";
        Display: Option Journals,"Centralized Journals","Journals and Centralization";
        DisplayEntries: Boolean;
        DisplayCentral: Boolean;
        "Filter": Text;
        Year: Integer;
        YearString: Text;
        Finished: Boolean;
        FiscalYearStatusText: Text;
        Text012: TextConst ENU = '';
        PeriodTypeNo: Integer;
        SortingByNo: Integer;
        DateRecNo: Integer;
        Hidden: Boolean;
        PostingDateVisible: Boolean;
        DocumentNoVisible: Boolean;
        Text001: TextConst ENU = 'Journals',
                           FRA = 'Journal';
        Text002: TextConst ENU = 'Centralized journals',
                           FRA = 'Centralisation des feuilles';
        Text003: TextConst ENU = 'Journals and Centralization',
                           FRA = 'Feuilles avec centralisation';
        Text004: TextConst ENU = 'You must fill in the %1 field.',
                           FRA = 'Vous devez renseigner le champ %1.';
        Text005: TextConst ENU = 'You must specify a Starting Date.',
                           FRA = 'Vous devez spécifier une date de début.';
        Text006: TextConst ENU = 'Printed by %1',
                           FRA = 'Imprimé par %1';
        Text007: TextConst ENU = 'Page %1',
                           FRA = 'Page %1';
        Text008: TextConst ENU = 'Total %1 %2',
                           FRA = 'Total %1 %2';
        Text666: TextConst ENU = '%1 is not a valid selection.',
                           FRA = '%1 n''est pas une sélection valide.';
        Posting_DateCaptionLbl: TextConst ENU = 'Posting Date',
                                          FRA = 'Date comptabilisation';
        Document_No_CaptionLbl: TextConst ENU = 'Document No.',
                                          FRA = 'N° du document';
        External_Document_No_CaptionLbl: TextConst ENU = 'External Document No.',
                                                   FRA = 'N° doc. externe';
        G_L_Account_No_CaptionLbl: TextConst ENU = 'G/L Account No.',
                                             FRA = 'N° compte général';
        DescriptionCaptionLbl: TextConst ENU = 'Description',
                                         FRA = 'Description';
        DebitCaptionLbl: TextConst ENU = 'Debit',
                                   FRA = 'Débit';
        CreditCaptionLbl: TextConst ENU = 'Credit',
                                    FRA = 'Crédit';
        Text011: TextConst ENU = 'Fiscal-Year Status: %1',
                           FRA = 'Statut de l''exercice comptable : %1';
        Grand_Total__CaptionLbl: TextConst ENU = 'Grand Total :',
                                           FRA = 'Total général :';
        Text009: TextConst ENU = 'The selected starting date %1 is not the start of a %2.',
                           FRA = 'La date de début choisie (%1) ne correspond pas au début de %2.';
        Text010: TextConst ENU = 'The selected ending date %1 is not the end of a %2.',
                           FRA = 'La date de fin choisie (%1) ne correspond pas à la fin de %2.';
}

