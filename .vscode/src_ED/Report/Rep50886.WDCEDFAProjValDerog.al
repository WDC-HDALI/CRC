report 50886 "WDC-ED FA Proj Val (Derog)"
{
    DefaultLayout = RDLC;
    RDLCLayout = './.vscode/src_ED/report/RDLC/FAProjValueDerogatory.rdlc';
    ApplicationArea = FixedAssets;
    captionML = ENU = 'Fixed Asset - Projected Value (Derogatory)', FRA = 'Immo. - Valeur projetée (Dérogatoire)';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Fixed Asset"; "Fixed Asset")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.", "FA Class Code", "FA Subclass Code", "Budgeted Asset";
            column(CompanyName; COMPANYPROPERTY.DisplayName)
            {
            }
            column(DeprBookText; DeprBookText)
            {
            }
            column(FixedAssetTabcaptFAFilter; TableCaption + ': ' + FAFilter)
            {
            }
            column(FAFilter; FAFilter)
            {
            }
            column(PrintDetails; PrintDetails)
            {
            }
            column(ProjectedDisposal; ProjectedDisposal)
            {
            }
            column(DeprBookUseCustom1Depr; DeprBook."Use Custom 1 Depreciation")
            {
            }
            column(DoProjectedDisposal; DoProjectedDisposal)
            {
            }
            column(GroupTotalsInt; GroupTotalsInt)
            {
            }
            column(IncludePostedFrom; Format(IncludePostedFrom))
            {
            }
            column(GroupCodeName; GroupCodeName)
            {
            }
            column(FANo; FANo)
            {
            }
            column(FADescription; FADescription)
            {
            }
            column(GroupHeadLine; GroupHeadLine)
            {
            }
            column(FixedAssetNo; "No.")
            {
            }
            column(Description_FixedAsset; Description)
            {
            }
            column(DeprText2; DeprText2)
            {
            }
            column(Text002GroupHeadLine; GroupTotalTxt + ': ' + GroupHeadLine)
            {
            }
            column(Custom1Text; Custom1Text)
            {
            }
            column(DeprCustom1Text; DeprCustom1Text)
            {
            }
            column(SalesPriceFieldname; SalesPriceFieldname)
            {
            }
            column(GainLossFieldname; GainLossFieldname)
            {
            }
            column(GroupAmounts3; GroupAmounts[3])
            {
                AutoFormatType = 1;
            }
            column(GroupAmounts4; GroupAmounts[4])
            {
                AutoFormatType = 1;
            }
            column(FAClassCode_FixedAsset; "FA Class Code")
            {
            }
            column(FASubclassCode_FixedAsset; "FA Subclass Code")
            {
            }
            column(GlobalDim1Code_FixedAsset; "Global Dimension 1 Code")
            {
            }
            column(GlobalDim2Code_FixedAsset; "Global Dimension 2 Code")
            {
            }
            column(FALocationCode_FixedAsset; "FA Location Code")
            {
            }
            column(CompofMainAss_FixedAsset; "Component of Main Asset")
            {
            }
            column(FAPostingGroup_FixedAsset; "FA Posting Group")
            {
            }
            column(CurrReportPAGENOCaption; PageNoLbl)
            {
            }
            column(FixedAssetProjectedValueCaption; FAProjectedValueLbl)
            {
            }
            column(FALedgerEntryFAPostingDateCaption; FAPostingDateLbl)
            {
            }
            column(BookValueCaption; BookValueLbl)
            {
            }
            column(DerogAssetsIncluded; DerogAssetsIncluded)
            {
            }
            column(HasDerogatorySetup; HasDerogatorySetup)
            {
            }
            column(FAPostingTypeCaption; FAPostingTypeLbl)
            {
            }
            column(NoofDepreciationDaysCaption; NoofDepreciationDaysLbl)
            {
            }
            column(AmtCaption; AmountLbl)
            {
            }
            column(DerogatoryAmountCaption; DerogatoryAmountLbl)
            {
            }
            column(DerogatoryBookValueCaption; DerogatoryBookValueLbl)
            {
            }
            column(DifferenceBookValueCaption; DifferenceBookValueLbl)
            {
            }
            dataitem("FA Ledger Entry"; "FA Ledger Entry")
            {
                DataItemTableView = SORTING("FA No.", "Depreciation Book Code", "FA Posting Date");
                column(FAPostingDt_FALedgerEntry; Format("FA Posting Date"))
                {
                }
                column(PostingDt_FALedgerEntry; "FA Posting Type")
                {
                    IncludeCaption = false;
                }
                column(Amount_FALedgerEntry; Amount)
                {
                    IncludeCaption = false;
                }
                column(FANo_FALedgerEntry; "FA No.")
                {
                }
                column(BookValue; BookValue)
                {
                    AutoFormatType = 1;
                }
                column(NoofDeprDays_FALedgEntry; "No. of Depreciation Days")
                {
                    IncludeCaption = false;
                }
                column(FALedgerEntryEntryNo; "Entry No.")
                {
                }
                column(PostedEntryCaption; PostedEntryLbl)
                {
                }
                column(FALedgerEntryDerogAmount; FALedgerEntryDerogAmount)
                {
                }
                column(FALedgerEntryDerogBookValue; FALedgerEntryDerogBookValue)
                {
                }
                column(FALedgerEntryDerogDiffBookValue; FALedgerEntryDerogDiffBookValue)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if "Part of Book Value" then begin
                        BookValue := BookValue + Amount;
                        if HasDerogatorySetup then begin
                            FALedgerEntryDerogAmount :=
                              Amount + GetFALedgerEntryDerogatoryAmount("Fixed Asset"."No.", DeprBookCode, "Document No.", "FA Posting Date");
                            FALedgerEntryDerogBookValue += FALedgerEntryDerogAmount;
                            FALedgerEntryDerogDiffBookValue := FALedgerEntryDerogBookValue - BookValue;
                        end;
                    end;
                    if "FA Posting Date" < IncludePostedFrom then
                        CurrReport.Skip();
                    EntryPrinted := true;
                end;

                trigger OnPreDataItem()
                begin
                    SetRange("FA No.", "Fixed Asset"."No.");
                    SetRange("Depreciation Book Code", DeprBookCode);
                    SetRange("Exclude Derogatory", false);
                    BookValue := 0;
                    FALedgerEntryDerogBookValue := 0;
                    if (IncludePostedFrom = 0D) or not PrintDetails then
                        CurrReport.Break();
                end;
            }
            dataitem(ProjectedDepreciation; "Integer")
            {
                DataItemTableView = SORTING(Number) WHERE(Number = FILTER(1 .. 1000000));
                column(DeprAmount; DeprAmount)
                {
                    AutoFormatType = 1;
                }
                column(EntryAmt1Custom1Amt; EntryAmounts[1] - Custom1Amount)
                {
                    AutoFormatType = 1;
                }
                column(FormatUntilDate; Format(UntilDate))
                {
                }
                column(DeprText; DeprText)
                {
                }
                column(NumberOfDays; NumberOfDays)
                {
                }
                column(No1_FixedAsset; "Fixed Asset"."No.")
                {
                }
                column(Custom1Text_ProjectedDepr; Custom1Text)
                {
                }
                column(Custom1NumberOfDays; Custom1NumberOfDays)
                {
                }
                column(Custom1Amount; Custom1Amount)
                {
                    AutoFormatType = 1;
                }
                column(EntryAmounts1; EntryAmounts[1])
                {
                    AutoFormatType = 1;
                }
                column(AssetAmounts1; AssetAmounts[1])
                {
                    AutoFormatType = 1;
                }
                column(Description1_FixedAsset; "Fixed Asset".Description)
                {
                }
                column(AssetAmounts2; AssetAmounts[2])
                {
                    AutoFormatType = 1;
                }
                column(AssetAmt1AssetAmt2; AssetAmounts[1] + AssetAmounts[2])
                {
                    AutoFormatType = 1;
                }
                column(DeprCustom1Text_ProjectedDepr; DeprCustom1Text)
                {
                }
                column(AssetAmounts3; AssetAmounts[3])
                {
                    AutoFormatType = 1;
                }
                column(AssetAmounts4; AssetAmounts[4])
                {
                    AutoFormatType = 1;
                }
                column(SalesPriceFieldname_ProjectedDepr; SalesPriceFieldname)
                {
                }
                column(GainLossFieldname_ProjectedDepr; GainLossFieldname)
                {
                }
                column(GroupAmounts_1; GroupAmounts[1])
                {
                }
                column(GroupTotalBookValue; GroupTotalBookValue)
                {
                }
                column(TotalBookValue_1; TotalBookValue[1])
                {
                }
                column(DerogAmount; DerogAmount)
                {
                    AutoFormatType = 1;
                }
                column(DerogBookValue; DerogBookValue)
                {
                    AutoFormatType = 1;
                }
                column(DerogDiffBookValue; DerogDiffBookValue)
                {
                }
                column(AssetDerogAmount; AssetDerogAmount)
                {
                    AutoFormatType = 1;
                }
                column(AssetDerogBookValue; AssetDerogBookValue)
                {
                }
                column(AssetDerogDiffBookValue; AssetDerogDiffBookValue)
                {
                }
                column(GroupDerogAmount; GroupDerogAmount)
                {
                }
                column(GroupDerogBookValue; GroupDerogBookValue)
                {
                }
                column(GroupDerogDiffBookValue; GroupDerogDiffBookValue)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if UntilDate >= EndingDate then
                        CurrReport.Break();
                    if Number = 1 then begin
                        CalculateFirstDeprAmount(Done);
                        DateFromProjection := DepreciationCalculation.Yesterday(DateFromProjection, Year365Days);
                        if FADeprBook."Book Value" <> 0 then
                            Done := Done or not EntryPrinted;
                    end else
                        CalculateSecondDeprAmount(Done);
                    if Done then
                        UpdateTotals
                    else
                        UpdateGroupTotals;

                    if Done then
                        if DoProjectedDisposal then
                            CalculateGainLoss;
                end;

                trigger OnPostDataItem()
                begin
                    if DoProjectedDisposal then begin
                        TotalAmounts[3] += AssetAmounts[3];
                        TotalAmounts[4] += AssetAmounts[4];
                    end;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                case GroupTotals of
                    GroupTotals::"FA Class":
                        NewValue := "FA Class Code";
                    GroupTotals::"FA Subclass":
                        NewValue := "FA Subclass Code";
                    GroupTotals::"FA Location":
                        NewValue := "FA Location Code";
                    GroupTotals::"Main Asset":
                        NewValue := "Component of Main Asset";
                    GroupTotals::"Global Dimension 1":
                        NewValue := "Global Dimension 1 Code";
                    GroupTotals::"Global Dimension 2":
                        NewValue := "Global Dimension 2 Code";
                    GroupTotals::"FA Posting Group":
                        NewValue := "FA Posting Group";
                end;

                if NewValue <> OldValue then begin
                    MakeGroupHeadLine;
                    InitGroupTotals;
                    OldValue := NewValue;
                end;

                if not FADeprBook.Get("No.", DeprBookCode) then
                    CurrReport.Skip();
                if SkipRecord then
                    CurrReport.Skip();

                HasDerogatorySetup := IsDerogatorySetup("No.");
                if HasDerogatorySetup then begin
                    DerogAssetsIncluded := true;
                    TotalDerogAssetsIncluded := true;
                end;

                if GroupTotals = GroupTotals::"FA Posting Group" then
                    if "FA Posting Group" <> FADeprBook."FA Posting Group" then
                        Error(HasBeenModifiedInFAErr, FieldCaption("FA Posting Group"), "No.");

                StartingDate := StartingDate2;
                EndingDate := EndingDate2;
                DoProjectedDisposal := false;
                EntryPrinted := false;
                if ProjectedDisposal and
                   (FADeprBook."Projected Disposal Date" > 0D) and
                   (FADeprBook."Projected Disposal Date" <= EndingDate)
                then begin
                    EndingDate := FADeprBook."Projected Disposal Date";
                    if StartingDate > EndingDate then
                        StartingDate := EndingDate;
                    DoProjectedDisposal := true;
                end;

                TransferValues;
            end;

            trigger OnPreDataItem()
            begin
                case GroupTotals of
                    GroupTotals::"FA Class":
                        SetCurrentKey("FA Class Code");
                    GroupTotals::"FA Subclass":
                        SetCurrentKey("FA Subclass Code");
                    GroupTotals::"FA Location":
                        SetCurrentKey("FA Location Code");
                    GroupTotals::"Main Asset":
                        SetCurrentKey("Component of Main Asset");
                    GroupTotals::"Global Dimension 1":
                        SetCurrentKey("Global Dimension 1 Code");
                    GroupTotals::"Global Dimension 2":
                        SetCurrentKey("Global Dimension 2 Code");
                    GroupTotals::"FA Posting Group":
                        SetCurrentKey("FA Posting Group");
                end;

                GroupTotalsInt := GroupTotals;
                MakeGroupHeadLine;
                InitGroupTotals;
            end;
        }
        dataitem(ProjectionTotal; "Integer")
        {
            DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
            column(TotalBookValue2; TotalBookValue[2])
            {
                AutoFormatType = 1;
            }
            column(TotalAmounts1; TotalAmounts[1])
            {
                AutoFormatType = 1;
            }
            column(DeprText2_ProjectionTotal; DeprText2)
            {
            }
            column(ProjectedDisposal_ProjectionTotal; ProjectedDisposal)
            {
            }
            column(DeprBookUseCustDepr_ProjectionTotal; DeprBook."Use Custom 1 Depreciation")
            {
            }
            column(Custom1Text_ProjectionTotal; Custom1Text)
            {
            }
            column(TotalAmounts2; TotalAmounts[2])
            {
                AutoFormatType = 1;
            }
            column(DeprCustom1Text_ProjectionTotal; DeprCustom1Text)
            {
            }
            column(TotalAmt1TotalAmt2; TotalAmounts[1] + TotalAmounts[2])
            {
                AutoFormatType = 1;
            }
            column(SalesPriceFieldname_ProjectionTotal; SalesPriceFieldname)
            {
            }
            column(GainLossFieldname_ProjectionTotal; GainLossFieldname)
            {
            }
            column(TotalAmounts3; TotalAmounts[3])
            {
                AutoFormatType = 1;
            }
            column(TotalAmounts4; TotalAmounts[4])
            {
                AutoFormatType = 1;
            }
            column(TotalCaption; TotalLbl)
            {
            }
            column(TotalDerogAmount; TotalDerogAmount)
            {
                AutoFormatType = 1;
            }
            column(TotalDerogBookValue; TotalDerogBookValue)
            {
            }
            column(TotalDerogDiffBookValue; TotalDerogDiffBookValue)
            {
            }
            column(TotalDerogAssetsIncluded; TotalDerogAssetsIncluded)
            {
            }
        }
        dataitem(Buffer; "Integer")
        {
            DataItemTableView = SORTING(Number) WHERE(Number = FILTER(1 ..));
            column(DeprBookText_Buffer; DeprBookText)
            {
            }
            column(Custom1TextText_Buffer; Custom1Text)
            {
            }
            column(GroupCodeName2; GroupCodeName2)
            {
            }
            column(FAPostingDate_FABufferProjection; Format(TempFABufferProjection."FA Posting Date"))
            {
            }
            column(Desc_FABufferProjection; TempFABufferProjection.Depreciation)
            {
            }
            column(Cust1_FABufferProjection; TempFABufferProjection."Custom 1")
            {
            }
            column(CodeName_FABufferProj; TempFABufferProjection."Code Name")
            {
            }
            column(ProjectedAmountsperDateCaption; ProjectedAmountsPerDateLbl)
            {
            }
            column(FABufferProjectionFAPostingDateCaption; FABufferProjectionFAPostingDateLbl)
            {
            }
            column(FABufferProjectionDepreciationCaption; FABufferProjectionDepreciationLbl)
            {
            }
            column(FixedAssetProjectedValueCaption_Buffer; FABufferProjectedValueLbl)
            {
            }

            trigger OnAfterGetRecord()
            begin
                if Number = 1 then begin
                    if not TempFABufferProjection.Find('-') then
                        CurrReport.Break();
                end else
                    if TempFABufferProjection.Next = 0 then
                        CurrReport.Break();
            end;

            trigger OnPreDataItem()
            begin
                if not PrintAmountsPerDate then
                    CurrReport.Break();
                TempFABufferProjection.Reset();
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
                    field(DepreciationBook; DeprBookCode)
                    {
                        ApplicationArea = FixedAssets;
                        captionML = ENU = 'Depreciation Book', FRA = 'Lois d''amortissement';
                        TableRelation = "Depreciation Book";

                        trigger OnValidate()
                        begin
                            UpdateReqForm;
                        end;
                    }
                    field(FirstDeprDate; StartingDate)
                    {
                        ApplicationArea = FixedAssets;
                        captionML = ENU = 'First Depreciation Date', FRA = 'Date premier amortissement';
                    }
                    field(LastDeprDate; EndingDate)
                    {
                        ApplicationArea = FixedAssets;
                        captionML = ENU = 'Last Depreciation Date', FRA = 'Date dernier amortissement';
                    }
                    field(NumberOfDays; PeriodLength)
                    {
                        ApplicationArea = FixedAssets;
                        BlankZero = true;
                        captionML = ENU = 'Number of Days', FRA = 'Nombre de jours';
                        Editable = NumberOfDaysCtrlEditable;
                        MinValue = 0;

                        trigger OnValidate()
                        begin
                            if PeriodLength > 0 then
                                UseAccountingPeriod := false;
                        end;
                    }
                    field(DaysInFirstPeriod; DaysInFirstPeriod)
                    {
                        ApplicationArea = FixedAssets;
                        BlankZero = true;
                        captionML = ENU = 'No. of Days in First Period', FRA = 'Nombre de jours dans première période';
                        MinValue = 0;
                    }
                    field(IncludePostedFrom; IncludePostedFrom)
                    {
                        ApplicationArea = FixedAssets;
                        captionML = ENU = 'Posted Entries From', FRA = 'Écritures enregistrées à partir du';
                    }
                    field(GroupTotals; GroupTotals)
                    {
                        ApplicationArea = FixedAssets;
                        captionML = ENU = 'Group Totals', FRA = 'Sous-totaux';
                        OptioncaptionML = ENU = ' ,FA Class,FA Subclass,FA Location,Main Asset,Global Dimension 1,Global Dimension 2,FA Posting Group', FRA = ' ,Classe immo.,Sous-classe immo.,Emplacement immo.,Immo. principale,Axe principal 1,Axe principal 2,Groupe compta. immo.';
                    }
                    field(CopyToGLBudgetName; BudgetNameCode)
                    {
                        ApplicationArea = Suite;
                        captionML = ENU = 'Copy to G/L Budget Name', FRA = 'Copier vers nom budget';
                        TableRelation = "G/L Budget Name";

                        trigger OnValidate()
                        begin
                            if BudgetNameCode = '' then
                                BalAccount := false;
                        end;
                    }
                    field(InsertBalAccount; BalAccount)
                    {
                        ApplicationArea = FixedAssets;
                        captionML = ENU = 'Insert Bal. Account', FRA = 'Insérer compte contrepartie';

                        trigger OnValidate()
                        begin
                            if BalAccount then
                                if BudgetNameCode = '' then
                                    Error(YouMustSpecifyErr, GLBudgetName.TableCaption);
                        end;
                    }
                    field(PrintPerFixedAsset; PrintDetails)
                    {
                        ApplicationArea = FixedAssets;
                        captionML = ENU = 'Print per Fixed Asset', FRA = 'Imprimer par immobilisation';
                    }
                    field(ProjectedDisposal; ProjectedDisposal)
                    {
                        ApplicationArea = FixedAssets;
                        captionML = ENU = 'Projected Disposal', FRA = 'Cession prévue';
                    }
                    field(PrintAmountsPerDate; PrintAmountsPerDate)
                    {
                        ApplicationArea = FixedAssets;
                        captionML = ENU = 'Print Amounts per Date', FRA = 'Imprimer montants par date';
                    }
                    field(UseAccountingPeriod; UseAccountingPeriod)
                    {
                        ApplicationArea = FixedAssets;
                        captionML = ENU = 'Use Accounting Period', FRA = 'Utiliser période comptable';

                        trigger OnValidate()
                        begin
                            if UseAccountingPeriod then
                                PeriodLength := 0;

                            UpdateReqForm;
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
            NumberOfDaysCtrlEditable := true;
        end;

        trigger OnOpenPage()
        begin
            GetFASetup;
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        DeprBook.Get(DeprBookCode);
        InitDerogatoryDeprBook(DerogDeprBookCode, DeprBookCode);
        Year365Days := DeprBook."Fiscal Year 365 Days";
        if GroupTotals = GroupTotals::"FA Posting Group" then
            FAGenReport.SetFAPostingGroup("Fixed Asset", DeprBook.Code);
        FAGenReport.AppendFAPostingFilter("Fixed Asset", StartingDate, EndingDate);
        FAFilter := "Fixed Asset".GetFilters;
        DeprBookText := StrSubstNo('%1%2 %3', DeprBook.TableCaption, ':', DeprBookCode);
        MakeGroupTotalText;
        ValidateDates;
        if PrintDetails then begin
            FANo := "Fixed Asset".FieldCaption("No.");
            FADescription := "Fixed Asset".FieldCaption(Description);
        end;
        if DeprBook."No. of Days in Fiscal Year" > 0 then
            DaysInFiscalYear := DeprBook."No. of Days in Fiscal Year"
        else
            DaysInFiscalYear := 360;
        if Year365Days then
            DaysInFiscalYear := 365;
        if PeriodLength = 0 then
            PeriodLength := DaysInFiscalYear;
        if (PeriodLength <= 5) or (PeriodLength > DaysInFiscalYear) then
            Error(NumberOfDaysMustNotBeGreaterThanErr, DaysInFiscalYear);
        FALedgEntry2."FA Posting Type" := FALedgEntry2."FA Posting Type"::Depreciation;
        DeprText := StrSubstNo('%1', FALedgEntry2."FA Posting Type");
        // FALedgEntry2."FA Posting Type" := FALedgEntry2."FA Posting Type"::Derogatory;  FIXME:
        if DeprBook."Use Custom 1 Depreciation" then begin
            DeprText2 := DeprText;
            FALedgEntry2."FA Posting Type" := FALedgEntry2."FA Posting Type"::"Custom 1";
            Custom1Text := StrSubstNo('%1', FALedgEntry2."FA Posting Type");
            DeprCustom1Text := StrSubstNo('%1 %2 %3', DeprText, '+', Custom1Text);
        end;
        SalesPriceFieldname := FADeprBook.FieldCaption("Projected Proceeds on Disposal");
        GainLossFieldname := ProjectedGainLossTxt;
    end;

    local procedure SkipRecord(): Boolean
    begin
        exit(
          "Fixed Asset".Inactive or
          (FADeprBook."Acquisition Date" = 0D) or
          (FADeprBook."Acquisition Date" > EndingDate) or
          (FADeprBook."Last Depreciation Date" > EndingDate) or
          (FADeprBook."Disposal Date" > 0D));
    end;

    local procedure TransferValues()
    begin
        // set base amount for the standard depreciation calculation (without Derogatory)
        FADeprBook.CalcFields("Book Value", Depreciation, "Custom 1", Derogatory);
        DateFromProjection := 0D;
        // if the asset has depreciations already, derogatory must be substracted from book value to avoid wrong derogatory calculation
        // no problem for standard assets because derogatory is then zero
        EntryAmounts[1] := FADeprBook."Book Value";
        if HasDerogatorySetup then
            EntryAmounts[1] -= FADeprBook.Derogatory;
        EntryAmounts[2] := FADeprBook."Custom 1";
        EntryAmounts[3] := DepreciationCalculation.DeprInFiscalYear("Fixed Asset"."No.", DeprBookCode, StartingDate);
        TotalBookValue[1] := TotalBookValue[1] + FADeprBook."Book Value";
        TotalBookValue[2] := TotalBookValue[2] + FADeprBook."Book Value";
        GroupTotalBookValue += FADeprBook."Book Value";

        TransferDerogatoryValues(FADeprBook."FA No.", EntryAmounts[1]);

        NewFiscalYear := FADateCalculation.GetFiscalYear(DeprBookCode, StartingDate);
        EndFiscalYear := FADateCalculation.CalculateDate(
            DepreciationCalculation.Yesterday(NewFiscalYear, Year365Days), DaysInFiscalYear, Year365Days);
        TempDeprDate := FADeprBook."Temp. Ending Date";

        if DeprBook."Use Custom 1 Depreciation" then
            Custom1DeprUntil := FADeprBook."Depr. Ending Date (Custom 1)"
        else
            Custom1DeprUntil := 0D;

        if Custom1DeprUntil > 0D then
            EntryAmounts[4] := GetDeprBasis;
        UntilDate := 0D;
        AssetAmounts[1] := 0;
        AssetAmounts[2] := 0;
        AssetAmounts[3] := 0;
        AssetAmounts[4] := 0;
    end;

    local procedure CalculateFirstDeprAmount(var Done: Boolean)
    var
        FirstTime: Boolean;
    begin
        FirstTime := true;
        UntilDate := StartingDate;
        repeat
            if not FirstTime then
                GetNextDate;
            FirstTime := false;
            CalculateDepr.Calculate(
              DeprAmount, Custom1Amount, NumberOfDays, Custom1NumberOfDays,
              "Fixed Asset"."No.", DeprBookCode, UntilDate, EntryAmounts, 0D, DaysInFirstPeriod);
            Done := (DeprAmount <> 0) or (Custom1Amount <> 0);
            CalculateDerogDepreciation(0D, DaysInFirstPeriod);
        until (UntilDate >= EndingDate) or Done;
        EntryAmounts[3] :=
          DepreciationCalculation.DeprInFiscalYear("Fixed Asset"."No.", DeprBookCode, UntilDate);
    end;

    local procedure CalculateSecondDeprAmount(var Done: Boolean)
    begin
        GetNextDate;
        CalculateDepr.Calculate(
          DeprAmount, Custom1Amount, NumberOfDays, Custom1NumberOfDays,
          "Fixed Asset"."No.", DeprBookCode, UntilDate, EntryAmounts, DateFromProjection, 0);
        Done := CalculationDone(
            (DeprAmount <> 0) or (Custom1Amount <> 0), DateFromProjection);
        CalculateDerogDepreciation(DateFromProjection, 0);
    end;

    local procedure GetNextDate()
    var
        UntilDate2: Date;
    begin
        UntilDate2 := GetPeriodEndingDate(UseAccountingPeriod, UntilDate, PeriodLength);
        if Custom1DeprUntil > 0D then
            if (UntilDate < Custom1DeprUntil) and (UntilDate2 > Custom1DeprUntil) then
                UntilDate2 := Custom1DeprUntil;

        if TempDeprDate > 0D then
            if (UntilDate < TempDeprDate) and (UntilDate2 > TempDeprDate) then
                UntilDate2 := TempDeprDate;

        if (UntilDate < EndFiscalYear) and (UntilDate2 > EndFiscalYear) then
            UntilDate2 := EndFiscalYear;

        if UntilDate = EndFiscalYear then begin
            EntryAmounts[3] := 0;
            NewFiscalYear := DepreciationCalculation.ToMorrow(EndFiscalYear, Year365Days);
            EndFiscalYear := FADateCalculation.CalculateDate(EndFiscalYear, DaysInFiscalYear, Year365Days);
        end;

        DateFromProjection := DepreciationCalculation.ToMorrow(UntilDate, Year365Days);
        UntilDate := UntilDate2;
        if UntilDate >= EndingDate then
            UntilDate := EndingDate;
    end;

    local procedure GetPeriodEndingDate(UseAccountingPeriod: Boolean; PeriodEndingDate: Date; var PeriodLength: Integer): Date
    var
        AccountingPeriod: Record "Accounting Period";
        UntilDate2: Date;
    begin
        if not UseAccountingPeriod then
            exit(FADateCalculation.CalculateDate(PeriodEndingDate, PeriodLength, Year365Days));
        AccountingPeriod.SetFilter(
          "Starting Date", '>=%1', DepreciationCalculation.ToMorrow(PeriodEndingDate, Year365Days) + 1);
        if AccountingPeriod.FindFirst then begin
            if Date2DMY(AccountingPeriod."Starting Date", 1) <> 31 then
                UntilDate2 := DepreciationCalculation.Yesterday(AccountingPeriod."Starting Date", Year365Days)
            else
                UntilDate2 := AccountingPeriod."Starting Date" - 1;
            PeriodLength :=
              DepreciationCalculation.DeprDays(
                DepreciationCalculation.ToMorrow(PeriodEndingDate, Year365Days), UntilDate2, Year365Days);
            if (PeriodLength <= 5) or (PeriodLength > DaysInFiscalYear) then
                PeriodLength := DaysInFiscalYear;
            exit(UntilDate2);
        end;
        if Year365Days then
            Error(YouMustCreateAccPeriodsErr, DepreciationCalculation.ToMorrow(EndingDate, Year365Days) + 1);
        exit(FADateCalculation.CalculateDate(PeriodEndingDate, PeriodLength, Year365Days));
    end;

    local procedure MakeGroupTotalText()
    begin
        case GroupTotals of
            GroupTotals::"FA Class":
                GroupCodeName := "Fixed Asset".FieldCaption("FA Class Code");
            GroupTotals::"FA Subclass":
                GroupCodeName := "Fixed Asset".FieldCaption("FA Subclass Code");
            GroupTotals::"FA Location":
                GroupCodeName := "Fixed Asset".FieldCaption("FA Location Code");
            GroupTotals::"Main Asset":
                GroupCodeName := "Fixed Asset".FieldCaption("Main Asset/Component");
            GroupTotals::"Global Dimension 1":
                GroupCodeName := "Fixed Asset".FieldCaption("Global Dimension 1 Code");
            GroupTotals::"Global Dimension 2":
                GroupCodeName := "Fixed Asset".FieldCaption("Global Dimension 2 Code");
            GroupTotals::"FA Posting Group":
                GroupCodeName := "Fixed Asset".FieldCaption("FA Posting Group");
        end;
        if GroupCodeName <> '' then begin
            GroupCodeName2 := GroupCodeName;
            if GroupTotals = GroupTotals::"Main Asset" then
                GroupCodeName2 := StrSubstNo('%1', SelectStr(GroupTotals + 1, GroupCodeNameTxt));
            GroupCodeName := StrSubstNo('%1%2 %3', GroupTotalsTxt, ':', GroupCodeName2);
        end;
    end;

    local procedure ValidateDates()
    begin
        FAGenReport.ValidateDeprDates(StartingDate, EndingDate);
        EndingDate2 := EndingDate;
        StartingDate2 := StartingDate;
    end;

    local procedure MakeGroupHeadLine()
    begin
        case GroupTotals of
            GroupTotals::"FA Class":
                GroupHeadLine := "Fixed Asset"."FA Class Code";
            GroupTotals::"FA Subclass":
                GroupHeadLine := "Fixed Asset"."FA Subclass Code";
            GroupTotals::"FA Location":
                GroupHeadLine := "Fixed Asset"."FA Location Code";
            GroupTotals::"Main Asset":
                begin
                    FA."Main Asset/Component" := FA."Main Asset/Component"::"Main Asset";
                    GroupHeadLine :=
                      StrSubstNo('%1 %2', FA."Main Asset/Component", "Fixed Asset"."Component of Main Asset");
                    if "Fixed Asset"."Component of Main Asset" = '' then
                        GroupHeadLine := StrSubstNo('%1%2', GroupHeadLine, '*****');
                end;
            GroupTotals::"Global Dimension 1":
                GroupHeadLine := "Fixed Asset"."Global Dimension 1 Code";
            GroupTotals::"Global Dimension 2":
                GroupHeadLine := "Fixed Asset"."Global Dimension 2 Code";
            GroupTotals::"FA Posting Group":
                GroupHeadLine := "Fixed Asset"."FA Posting Group";
        end;
        if GroupHeadLine = '' then
            GroupHeadLine := '*****';
    end;

    local procedure UpdateTotals()
    var
        BudgetDepreciation: Codeunit "Budget Depreciation";
        EntryNo: Integer;
        CodeName: Code[20];
    begin
        EntryAmounts[1] := EntryAmounts[1] + DeprAmount + Custom1Amount;
        if Custom1DeprUntil > 0D then
            if UntilDate <= Custom1DeprUntil then
                EntryAmounts[4] := EntryAmounts[4] + DeprAmount + Custom1Amount;
        EntryAmounts[2] := EntryAmounts[2] + Custom1Amount;
        EntryAmounts[3] := EntryAmounts[3] + DeprAmount + Custom1Amount;
        AssetAmounts[1] := AssetAmounts[1] + DeprAmount;
        AssetAmounts[2] := AssetAmounts[2] + Custom1Amount;
        GroupAmounts[1] := GroupAmounts[1] + DeprAmount;
        GroupAmounts[2] := GroupAmounts[2] + Custom1Amount;
        TotalAmounts[1] := TotalAmounts[1] + DeprAmount;
        TotalAmounts[2] := TotalAmounts[2] + Custom1Amount;
        TotalBookValue[1] := TotalBookValue[1] + DeprAmount + Custom1Amount;
        TotalBookValue[2] := TotalBookValue[2] + DeprAmount + Custom1Amount;
        GroupTotalBookValue += DeprAmount + Custom1Amount;
        UpdateDerogatoryTotals;

        if BudgetNameCode <> '' then
            BudgetDepreciation.CopyProjectedValueToBudget(
              FADeprBook, BudgetNameCode, UntilDate, DeprAmount, Custom1Amount, BalAccount);

        if (UntilDate > 0D) or PrintAmountsPerDate then
            TempFABufferProjection.Reset;
        if TempFABufferProjection.Find('+') then
            EntryNo := TempFABufferProjection."Entry No." + 1
        else
            EntryNo := 1;
        TempFABufferProjection.SetRange("FA Posting Date", UntilDate);
        if GroupTotals <> GroupTotals::" " then begin
            case GroupTotals of
                GroupTotals::"FA Class":
                    CodeName := "Fixed Asset"."FA Class Code";
                GroupTotals::"FA Subclass":
                    CodeName := "Fixed Asset"."FA Subclass Code";
                GroupTotals::"FA Location":
                    CodeName := "Fixed Asset"."FA Location Code";
                GroupTotals::"Main Asset":
                    CodeName := "Fixed Asset"."Component of Main Asset";
                GroupTotals::"Global Dimension 1":
                    CodeName := "Fixed Asset"."Global Dimension 1 Code";
                GroupTotals::"Global Dimension 2":
                    CodeName := "Fixed Asset"."Global Dimension 2 Code";
                GroupTotals::"FA Posting Group":
                    CodeName := "Fixed Asset"."FA Posting Group";
            end;
            TempFABufferProjection.SetRange("Code Name", CodeName);
        end;
        if not TempFABufferProjection.Find('=><') then begin
            TempFABufferProjection.Init;
            TempFABufferProjection."Code Name" := CodeName;
            TempFABufferProjection."FA Posting Date" := UntilDate;
            TempFABufferProjection."Entry No." := EntryNo;
            TempFABufferProjection.Depreciation := DeprAmount;
            TempFABufferProjection."Custom 1" := Custom1Amount;
            TempFABufferProjection.Insert;
        end else begin
            TempFABufferProjection.Depreciation := TempFABufferProjection.Depreciation + DeprAmount;
            TempFABufferProjection."Custom 1" := TempFABufferProjection."Custom 1" + Custom1Amount;
            TempFABufferProjection.Modify;
        end;
    end;

    local procedure InitGroupTotals()
    begin
        GroupAmounts[1] := 0;
        GroupAmounts[2] := 0;
        GroupAmounts[3] := 0;
        GroupAmounts[4] := 0;
        GroupTotalBookValue := 0;
        GroupDerogAmount := 0;
        if NotFirstGroupTotal then begin
            TotalBookValue[1] := 0;
            GroupDerogBookValue := 0;
            GroupDerogDiffBookValue := 0;
        end else begin
            TotalBookValue[1] := EntryAmounts[1];
            GroupDerogBookValue := AssetDerogBookValue;
            GroupDerogDiffBookValue := AssetDerogDiffBookValue;
        end;
        NotFirstGroupTotal := true;
        DerogAssetsIncluded := false;
    end;

    local procedure GetDeprBasis(): Decimal
    var
        FALedgEntry: Record "FA Ledger Entry";
    begin
        FALedgEntry.SetCurrentKey("FA No.", "Depreciation Book Code", "Part of Book Value", "FA Posting Date");
        FALedgEntry.SetRange("FA No.", "Fixed Asset"."No.");
        FALedgEntry.SetRange("Depreciation Book Code", DeprBookCode);
        FALedgEntry.SetRange("Part of Book Value", true);
        FALedgEntry.SetRange("FA Posting Date", 0D, Custom1DeprUntil);
        FALedgEntry.CalcSums(Amount);
        exit(FALedgEntry.Amount);
    end;

    local procedure CalculateGainLoss()
    var
        CalculateDisposal: Codeunit "Calculate Disposal";
        EntryAmounts: array[14] of Decimal;
        PrevAmount: array[2] of Decimal;
    begin
        PrevAmount[1] := AssetAmounts[3];
        PrevAmount[2] := AssetAmounts[4];

        CalculateDisposal.CalcGainLoss("Fixed Asset"."No.", DeprBookCode, EntryAmounts);
        AssetAmounts[3] := FADeprBook."Projected Proceeds on Disposal";
        if EntryAmounts[1] <> 0 then
            AssetAmounts[4] := EntryAmounts[1]
        else
            AssetAmounts[4] := EntryAmounts[2];
        AssetAmounts[4] :=
          AssetAmounts[4] + AssetAmounts[1] + AssetAmounts[2] - FADeprBook."Projected Proceeds on Disposal";

        GroupAmounts[3] += AssetAmounts[3] - PrevAmount[1];
        GroupAmounts[4] += AssetAmounts[4] - PrevAmount[2];
    end;

    local procedure CalculationDone(Done: Boolean; FirstDeprDate: Date): Boolean
    var
        TableDeprCalculation: Codeunit "Table Depr. Calculation";
    begin
        if Done or
           (FADeprBook."Depreciation Method" <> FADeprBook."Depreciation Method"::"User-Defined")
        then
            exit(Done);
        exit(
          TableDeprCalculation.GetTablePercent(
            DeprBookCode, FADeprBook."Depreciation Table Code",
            FADeprBook."First User-Defined Depr. Date", FirstDeprDate, UntilDate) = 0);
    end;

    local procedure UpdateReqForm()
    begin
        PageUpdateReqForm;
    end;

    local procedure PageUpdateReqForm()
    var
        DeprBook: Record "Depreciation Book";
    begin
        if DeprBookCode <> '' then
            DeprBook.Get(DeprBookCode);

        PeriodLength := 0;
        if DeprBook."Fiscal Year 365 Days" and not UseAccountingPeriod then
            PeriodLength := 365;
    end;

    procedure SetMandatoryFields(DepreciationBookCodeFrom: Code[10]; StartingDateFrom: Date; EndingDateFrom: Date)
    begin
        DeprBookCode := DepreciationBookCodeFrom;
        StartingDate := StartingDateFrom;
        EndingDate := EndingDateFrom;
    end;

    procedure SetPeriodFields(PeriodLengthFrom: Integer; DaysInFirstPeriodFrom: Integer; IncludePostedFromFrom: Date; UseAccountingPeriodFrom: Boolean)
    begin
        PeriodLength := PeriodLengthFrom;
        DaysInFirstPeriod := DaysInFirstPeriodFrom;
        IncludePostedFrom := IncludePostedFromFrom;
        UseAccountingPeriod := UseAccountingPeriodFrom;
    end;

    procedure SetTotalFields(GroupTotalsFrom: Option; PrintDetailsFrom: Boolean)
    begin
        GroupTotals := GroupTotalsFrom;
        PrintDetails := PrintDetailsFrom;
    end;

    procedure SetBudgetField(BudgetNameCodeFrom: Code[10]; BalAccountFrom: Boolean; ProjectedDisposalFrom: Boolean; PrintAmountsPerDateFrom: Boolean)
    begin
        BudgetNameCode := BudgetNameCodeFrom;
        BalAccount := BalAccountFrom;
        ProjectedDisposal := ProjectedDisposalFrom;
        PrintAmountsPerDate := PrintAmountsPerDateFrom;
    end;

    procedure GetFASetup()
    begin
        if DeprBookCode = '' then begin
            FASetup.Get();
            DeprBookCode := FASetup."Default Depr. Book";
        end;
        UpdateReqForm;
    end;

    local procedure UpdateGroupTotals()
    begin
        GroupAmounts[1] := GroupAmounts[1] + DeprAmount;
        TotalAmounts[1] := TotalAmounts[1] + DeprAmount;
        UpdateDerogatoryTotals;
    end;

    local procedure CalculateDerogDepreciation(DateFromProjection2: Date; DaysInFirstPeriod2: Integer)
    var
        DerogEntryAmounts: array[4] of Decimal;
    begin
        if not HasDerogatorySetup then
            exit;
        DerogEntryAmounts[1] := DerogBookValue;
        CalculateDepr.Calculate(
          DerogAmount, Custom1Amount, NumberOfDays, Custom1NumberOfDays,
          "Fixed Asset"."No.", DerogDeprBookCode, UntilDate, DerogEntryAmounts, DateFromProjection2, DaysInFirstPeriod2);
        DerogBookValue += DerogAmount;
        DerogDiffBookValue += DerogAmount - DeprAmount;
    end;

    local procedure UpdateDerogatoryTotals()
    begin
        if not HasDerogatorySetup then
            exit;
        AssetDerogAmount += DerogAmount;
        AssetDerogBookValue += DerogAmount;
        AssetDerogDiffBookValue += DerogAmount - DeprAmount;
        GroupDerogAmount += DerogAmount;
        GroupDerogBookValue += DerogAmount;
        GroupDerogDiffBookValue += DerogAmount - DeprAmount;
        TotalDerogAmount += DerogAmount;
        TotalDerogBookValue += DerogAmount;
        TotalDerogDiffBookValue += DerogAmount - DeprAmount;
    end;

    local procedure TransferDerogatoryValues(FANo: Code[20]; BookValue: Decimal)
    var
        FADepreciationBook: Record "FA Depreciation Book";
    begin
        if HasDerogatorySetup then begin
            FADepreciationBook.Get(FANo, DerogDeprBookCode);
            FADepreciationBook.CalcFields("Book Value");
            DerogBookValue := FADepreciationBook."Book Value";
            AssetDerogBookValue := FADepreciationBook."Book Value";
            GroupDerogBookValue += FADepreciationBook."Book Value";
            TotalDerogBookValue += FADepreciationBook."Book Value";
            DerogDiffBookValue := FADepreciationBook."Book Value" - BookValue;
            AssetDerogDiffBookValue := FADepreciationBook."Book Value" - BookValue;
            GroupDerogDiffBookValue += FADepreciationBook."Book Value" - BookValue;
            TotalDerogDiffBookValue += FADepreciationBook."Book Value" - BookValue;
        end else begin
            DerogBookValue := 0;
            AssetDerogBookValue := 0;
            DerogDiffBookValue := 0;
            AssetDerogDiffBookValue := 0;
        end;
        DerogAmount := 0;
        AssetDerogAmount := 0;
    end;

    local procedure InitDerogatoryDeprBook(var DerogDeprBookCode: Code[10]; DeprBookCode: Code[10])
    var
        DerogDepreciationBook: Record "Depreciation Book";
    begin
        TotalDerogAssetsIncluded := false;
        DerogDeprBookCode := '';
        DerogDepreciationBook.SetRange("Derogatory Calculation", DeprBookCode);
        if DerogDepreciationBook.FindFirst then
            DerogDeprBookCode := DerogDepreciationBook.Code;
    end;

    local procedure IsDerogatorySetup(FANo: Code[20]): Boolean
    var
        FADepreciationBook: Record "FA Depreciation Book";
    begin
        FADepreciationBook.SetRange("FA No.", FANo);
        FADepreciationBook.SetRange("Depreciation Book Code", DerogDeprBookCode);
        exit(not FADepreciationBook.IsEmpty);
    end;

    local procedure GetFALedgerEntryDerogatoryAmount(FANo: Code[20]; DeprBookCode: Code[10]; DocumentNo: Code[20]; FAPostingDate: Date): Decimal
    var
        FALedgerEntry: Record "FA Ledger Entry";
    begin
        FALedgerEntry.SetRange("FA No.", FANo);
        FALedgerEntry.SetRange("Depreciation Book Code", DeprBookCode);
        FALedgerEntry.SetRange("Part of Book Value", true);
        FALedgerEntry.SetRange("Document No.", DocumentNo);
        FALedgerEntry.SetRange("FA Posting Date", FAPostingDate);
        // SetRange("FA Posting Type", "FA Posting Type"::Derogatory);  FIXME:
        if FALedgerEntry.FindFirst then
            exit(FALedgerEntry.Amount);
        exit(0);
    end;

    var
        GLBudgetName: Record "G/L Budget Name";
        FASetup: Record "FA Setup";
        DeprBook: Record "Depreciation Book";
        FADeprBook: Record "FA Depreciation Book";
        FA: Record "Fixed Asset";
        FALedgEntry2: Record "FA Ledger Entry";
        TempFABufferProjection: Record "FA Buffer Projection" temporary;
        FAGenReport: Codeunit "FA General Report";
        CalculateDepr: Codeunit "Calculate Depreciation";
        FADateCalculation: Codeunit "FA Date Calculation";
        DepreciationCalculation: Codeunit "Depreciation Calculation";
        DeprBookCode: Code[10];
        DerogDeprBookCode: Code[10];
        FAFilter: Text;
        DeprBookText: Text[50];
        GroupCodeName: Text[50];
        GroupCodeName2: Text[50];
        GroupHeadLine: Text[50];
        DeprText: Text[50];
        DeprText2: Text[50];
        Custom1Text: Text[50];
        DeprCustom1Text: Text[50];
        IncludePostedFrom: Date;
        FANo: Text[50];
        FADescription: Text[100];
        GroupTotals: Option " ","FA Class","FA Subclass","FA Location","Main Asset","Global Dimension 1","Global Dimension 2","FA Posting Group";
        BookValue: Decimal;
        NewFiscalYear: Date;
        EndFiscalYear: Date;
        DaysInFiscalYear: Integer;
        Custom1DeprUntil: Date;
        PeriodLength: Integer;
        UseAccountingPeriod: Boolean;
        StartingDate: Date;
        StartingDate2: Date;
        EndingDate: Date;
        EndingDate2: Date;
        PrintAmountsPerDate: Boolean;
        UntilDate: Date;
        PrintDetails: Boolean;
        EntryAmounts: array[4] of Decimal;
        AssetAmounts: array[4] of Decimal;
        GroupAmounts: array[4] of Decimal;
        TotalAmounts: array[4] of Decimal;
        TotalBookValue: array[2] of Decimal;
        GroupTotalBookValue: Decimal;
        DateFromProjection: Date;
        DeprAmount: Decimal;
        Custom1Amount: Decimal;
        NumberOfDays: Integer;
        Custom1NumberOfDays: Integer;
        DaysInFirstPeriod: Integer;
        Done: Boolean;
        NotFirstGroupTotal: Boolean;
        SalesPriceFieldname: Text[80];
        GainLossFieldname: Text[50];
        ProjectedDisposal: Boolean;
        DoProjectedDisposal: Boolean;
        EntryPrinted: Boolean;
        BudgetNameCode: Code[10];
        OldValue: Code[20];
        NewValue: Code[20];
        BalAccount: Boolean;
        TempDeprDate: Date;
        GroupTotalsInt: Integer;
        Year365Days: Boolean;
        FALedgerEntryDerogAmount: Decimal;
        FALedgerEntryDerogBookValue: Decimal;
        FALedgerEntryDerogDiffBookValue: Decimal;
        DerogAmount: Decimal;
        DerogBookValue: Decimal;
        DerogDiffBookValue: Decimal;
        AssetDerogAmount: Decimal;
        AssetDerogBookValue: Decimal;
        AssetDerogDiffBookValue: Decimal;
        GroupDerogAmount: Decimal;
        GroupDerogBookValue: Decimal;
        GroupDerogDiffBookValue: Decimal;
        TotalDerogAmount: Decimal;
        TotalDerogBookValue: Decimal;
        TotalDerogDiffBookValue: Decimal;
        HasDerogatorySetup: Boolean;
        DerogAssetsIncluded: Boolean;
        TotalDerogAssetsIncluded: Boolean;
        NumberOfDaysCtrlEditable: Boolean;
        NumberOfDaysMustNotBeGreaterThanErr: TextConst ENU = 'Number of Days must not be greater than %1 or less than 5.',
                                                       FRA = 'Le nombre de jours ne doit pas être supérieur à %1 ou inférieur à 5.',
                                                       Comment = '1 - Number of days in fiscal year';
        ProjectedGainLossTxt: TextConst ENU = 'Projected Gain/Loss',
                                        FRA = 'Gains/Pertes prévu(e)s';
        GroupTotalTxt: TextConst ENU = 'Group Total',
                                 FRA = 'Sous-total';
        GroupTotalsTxt: TextConst ENU = 'Group Totals',
                                  FRA = 'Sous-totaux';
        HasBeenModifiedInFAErr: TextConst ENU = '%1 has been modified in fixed asset %2.',
                                          FRA = '%1 a été modifié(e) dans l''immobilisation %2.',
                                          Comment = '1 - FA Posting Group caption; 2- FA No.';
        GroupCodeNameTxt: TextConst ENU = ' ,FA Class,FA Subclass,FA Location,Main Asset,Global Dimension 1,Global Dimension 2,FA Posting Group',
                                    FRA = ' ,Classe immo.,Sous-classe immo.,Emplacement immo.,Immo. principale,Axe principal 1,Axe principal 2,Groupe compta. immo.';
        YouMustSpecifyErr: TextConst ENU = 'You must specify %1.',
                                     FRA = 'Vous devez spécifier une valeur %1.',
                                     Comment = '1 - G/L Budget Name caption';
        YouMustCreateAccPeriodsErr: TextConst ENU = 'You must create accounting periods until %1 to use 365 days depreciation and ''Use Accounting Periods''.',
                                              FRA = 'Vous devez créer des périodes comptables jusqu''au %1 pour utiliser un amortissement sur 365 jours et l''option « Utiliser périodes comptables ».',
                                              Comment = '1 - Date';
        PageNoLbl: TextConst ENU = 'Page',
                             FRA = 'Page';
        FAProjectedValueLbl: TextConst ENU = 'Fixed Asset - Projected Value (Derogatory)',
                                       FRA = 'mmo. - Valeur projetée (Dérogatoire)';
        FAPostingDateLbl: TextConst ENU = 'FA Posting Date',
                                    FRA = 'Date compta. immo.';
        BookValueLbl: TextConst ENU = 'Book Value',
                                FRA = 'Valeur comptable';
        PostedEntryLbl: TextConst ENU = 'Posted Entry',
                                  FRA = 'Écriture validée';
        TotalLbl: TextConst ENU = 'Total',
                            FRA = 'Total';
        ProjectedAmountsPerDateLbl: TextConst ENU = 'Projected Amounts per Date',
                                              FRA = 'Montants projetés par date';
        FABufferProjectionFAPostingDateLbl: TextConst ENU = 'FA Posting Date',
                                                      FRA = 'Date compta. immo.';
        FABufferProjectionDepreciationLbl: TextConst ENU = 'Depreciation',
                                                     FRA = 'Amortissement';
        FABufferProjectedValueLbl: TextConst ENU = 'Fixed Asset - Projected Value (Derogatory)',
                                             FRA = 'Immo. - Valeur projetée (Dérogatoire)';
        FAPostingTypeLbl: TextConst ENU = 'FA Posting Type',
                                    FRA = 'Type compta. immo.';
        NoofDepreciationDaysLbl: TextConst ENU = 'No. Of Depreciation Days',
                                           FRA = 'Nbre jours amort.';
        AmountLbl: TextConst ENU = 'Amount',
                             FRA = 'Montant';
        DerogatoryAmountLbl: TextConst ENU = 'Amount (Derogatory Book)',
                                       FRA = 'Montant (Loi dérogatoire)';
        DerogatoryBookValueLbl: TextConst ENU = 'Book Value (Derogatory Book)',
                                          FRA = 'Valeur comptable (Loi dérogatoire)';
        DifferenceBookValueLbl: TextConst ENU = 'Difference (Book Value)',
                                          FRA = 'Différence (Valeur comptable)';
}

