report 50812 "WDC-ED Fixed Asset-Prof. Tax"
{
    DefaultLayout = RDLC;
    RDLCLayout = './.vscode/src_ED/report/RDLC/FixedAssetProfessionalTax.rdlc';
    ApplicationArea = FixedAssets;
    captionML = ENU = 'Professional Tax', FRA = 'Taxe professionnelle';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Fixed Asset"; "Fixed Asset")
        {
            RequestFilterFields = "No.", "FA Class Code", "FA Subclass Code", "Professional Tax";
            column(MainTextTitle; MainTextTitle)
            {
            }
            column(CompanyName; COMPANYPROPERTY.DisplayName)
            {
            }
            column(TodayFormatted; Format(Today, 0, 4))
            {
            }
            column(DeprBookText; DeprBookText)
            {
            }
            column(FixedAssetCaptionFAFilter; "Fixed Asset".TableCaption + ': ' + FAFilter)
            {
            }
            column(FAFilter; FAFilter)
            {
            }
            column(TextTitle1; TextTitle[1])
            {
            }
            column(GroupCodeName; GroupCodeName)
            {
            }
            column(FANo; FANo)
            {
            }
            column(FADesc; FADescription)
            {
            }
            column(AcquisitionCostCaption; AcquisitionCostCaptionlLbl)
            {
            }
            column(RentingValueCaption; RentingValueCaptionLbl)
            {
            }
            column(PerctgProfessionalTaxCaption; PerctgProfessionalTaxCaptionLbl)
            {
            }
            column(GroupTitle; GroupTitle)
            {
            }
            column(No_FixedAsset; "No.")
            {
            }
            column(Desc_FixedAsset; Description)
            {
            }
            column(Amts1; Amounts[1])
            {
                AutoFormatType = 1;
            }
            column(Amts2; Amounts[2])
            {
                AutoFormatType = 1;
            }
            column(FormatDate1; Format(Date[1]))
            {
            }
            column(SetSalesMark; SetSalesMark)
            {
            }
            column(PercentageTaxProfessionalTax; PercentageTax["Professional Tax" + 1])
            {
                AutoFormatType = 1;
            }
            column(GroupTotalsNo; GroupTotalsNo)
            {
            }
            column(PrintDetails; PrintDetails)
            {
            }
            column(GroupAmts1; GroupAmounts[1])
            {
                AutoFormatType = 1;
            }
            column(GroupAmts2; GroupAmounts[2])
            {
                AutoFormatType = 1;
            }
            column(SubTotalGroupTitle; Text012 + ': ' + GroupTitle)
            {
            }
            column(TotalAmts1; TotalAmounts[1])
            {
                AutoFormatType = 1;
            }
            column(TotalAmts2; TotalAmounts[2])
            {
                AutoFormatType = 1;
            }
            column(FASubclassCode_FixedAsset; "FA Subclass Code")
            {
            }
            column(FAClassCode_FixedAsset; "FA Class Code")
            {
            }
            column(GlobalDim1Code_FixedAsset; "Global Dimension 1 Code")
            {
            }
            column(GlobalDim2Code_FixedAsset; "Global Dimension 2 Code")
            {
            }
            column(CompOfMainAsset_FixedAsset; "Component of Main Asset")
            {
            }
            column(FALocCode_FixedAsset; "FA Location Code")
            {
            }
            column(PageNoCaption; PageNoCaptionLbl)
            {
            }
            column(TotalCaption; TotalCaptionLbl)
            {
            }

            trigger OnAfterGetRecord()
            begin
                if not FADeprBook.Get("No.", DeprBookCode) then
                    CurrReport.Skip();
                if SkipRecord then
                    CurrReport.Skip();

                Date[1] :=
                  FAGenReport.GetLastDate(
                    "No.", DateTypeNo1, EndingDate, DeprBookCode, false);
                Date[2] :=
                  FAGenReport.GetLastDate(
                    "No.", DateTypeNo2, EndingDate, DeprBookCode, false);

                BeforeAmount := 0;
                EndingAmount := 0;

                if SetAmountToZero(PostingTypeNo1, Period1) then
                    Amounts[1] := 0
                else
                    Amounts[1] :=
                      FAGenReport.CalcFAPostedAmount(
                        "No.", PostingTypeNo1, Period1, StartingDate, EndingDate,
                        DeprBookCode, BeforeAmount, EndingAmount, false, false);

                if SetAmountToZero(PostingTypeNo2, Period2) then
                    Amounts[2] := 0
                else
                    Amounts[2] :=
                      FAGenReport.CalcFAPostedAmount(
                        "No.", PostingTypeNo2, Period2, StartingDate, EndingDate,
                        DeprBookCode, BeforeAmount, EndingAmount, false, false);

                if SetAmountToZero(PostingTypeNo3, Period3) then
                    Amounts[3] := 0
                else
                    Amounts[3] :=
                      FAGenReport.CalcFAPostedAmount(
                        "No.", PostingTypeNo3, Period3, StartingDate, EndingDate,
                        DeprBookCode, BeforeAmount, EndingAmount, false, false);

                Amounts[2] := Round(Amounts[2] * PercentageTax["Professional Tax" + 1] / 100);
                for i := 1 to 3 do
                    GroupAmounts[i] := 0;
                MakeGroupHeadLine;
                for i := 1 to 3 do begin
                    GroupAmounts[i] := GroupAmounts[i] + Amounts[i];
                    TotalAmounts[i] := TotalAmounts[i] + Amounts[i];
                end;
            end;

            trigger OnPreDataItem()
            begin
                case GroupTotals of
                    GroupTotals::"FA Class":
                        SetCurrentKey("FA Class Code");
                    GroupTotals::"FA Subclass":
                        SetCurrentKey("FA Subclass Code");
                    GroupTotals::"Main Asset":
                        SetCurrentKey("Component of Main Asset");
                    GroupTotals::"Global Dimension 1":
                        SetCurrentKey("Global Dimension 1 Code");
                    GroupTotals::"FA Location":
                        SetCurrentKey("FA Location Code");
                    GroupTotals::"Global Dimension 2":
                        SetCurrentKey("Global Dimension 2 Code");
                end;
                FAPostingType.CreateTypes;
                FADateType.CreateTypes;

                DateType1 := FADeprBook.FieldCaption("Acquisition Date");

                PostingType1 := FADeprBook.FieldCaption("Acquisition Cost");
                PostingType2 := FADeprBook.FieldCaption("Acquisition Cost");
                Period1 := Period1::"at Ending Date";
                Period2 := Period1::"at Ending Date";

                CheckDateType(DateType1, DateTypeNo1);
                CheckDateType('', DateTypeNo2);

                CheckPostingType(PostingType1, PostingTypeNo1);
                CheckPostingType(PostingType2, PostingTypeNo2);
                CheckPostingType('', PostingTypeNo3);
                MakeGroupTotalText;
                FAGenReport.ValidateDates(StartingDate, EndingDate);
                MakeDateHeadLine;
                MakeAmountHeadLine(3, PostingType1, PostingTypeNo1, Period1);
                MakeAmountHeadLine(4, PostingType2, PostingTypeNo2, Period2);
                MakeAmountHeadLine(5, '', PostingTypeNo3, Period3);
            end;
        }
    }

    requestpage
    {
        Permissions = TableData "FA Setup" = r;
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    captionML = ENU = 'Options', FRA = 'Options';
                    field(DepreciationBooks; DeprBookCode)
                    {
                        ApplicationArea = FixedAssets;
                        captionML = ENU = 'Depreciation Books', FRA = 'Lois d''amortissement';
                        TableRelation = "Depreciation Book";
                    }
                    field(StartingDate; StartingDate)
                    {
                        ApplicationArea = FixedAssets;
                        captionML = ENU = 'Starting Date', FRA = 'Date début';
                    }
                    field(EndDate; EndingDate)
                    {
                        ApplicationArea = FixedAssets;
                        captionML = ENU = 'End Date', FRA = 'Date fin';
                    }
                    field(GroupTotals; GroupTotals)
                    {
                        ApplicationArea = FixedAssets;
                        captionML = ENU = 'Group Totals', FRA = 'Sous-totaux';
                        OptioncaptionML = ENU = ' ,FA Class,FA Subclass,FA Location,Main Asset,Global Dimension 1,Global Dimension 2', FRA = ' ,Classe immo.,Sous-classe immo.,Emplacement immo.,Immo. principale,Axe principal 1,Axe principal 2';
                    }
                    field(PrintPerFixedAsset; PrintDetails)
                    {
                        ApplicationArea = FixedAssets;
                        captionML = ENU = 'Print per Fixed Asset', FRA = 'Imprimer par immobilisation';
                    }
                    field(FixedAssetMoreThan30years1; PercentageTax[2])
                    {
                        ApplicationArea = FixedAssets;
                        BlankZero = true;
                        captionML = ENU = 'Fixed Asset >30 years 1', FRA = 'Immobilisation >30 années 1';
                        MaxValue = 100;
                        MinValue = 0;
                    }
                    field(FixedAssetMoreThan30years2; PercentageTax[3])
                    {
                        ApplicationArea = FixedAssets;
                        BlankZero = true;
                        captionML = ENU = 'Fixed Asset >30 years 2', FRA = 'Immobilisation >30 années 2';
                        MaxValue = 100;
                        MinValue = 0;
                    }
                    field(FixedAssetLessThan30years; PercentageTax[4])
                    {
                        ApplicationArea = FixedAssets;
                        BlankZero = true;
                        captionML = ENU = 'Fixed Asset <30 years', FRA = 'Immobilisation <30 années';
                        MaxValue = 100;
                        MinValue = 0;
                    }
                    label(Control7)
                    {
                        ApplicationArea = FixedAssets;
                        captionClass = Text19021992;
                        ShowCaption = false;
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            if DeprBookCode = '' then begin
                FASetup.Get();
                DeprBookCode := FASetup."Default Depr. Book";
            end;
            FAPostingType.CreateTypes;
            FADateType.CreateTypes;
            PercentageTax[2] := 8;
            PercentageTax[3] := 9;
            PercentageTax[4] := 16;
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        GroupTotalsNo := GroupTotals;
        DeprBook.Get(DeprBookCode);
        FAGenReport.AppendFAPostingFilter("Fixed Asset", StartingDate, EndingDate);
        FAFilter := "Fixed Asset".GetFilters;
        MainTextTitle := Text001;
        DeprBookText := StrSubstNo('%1%2 %3', DeprBook.TableCaption, ':', DeprBookCode);
        if PrintDetails then begin
            FANo := "Fixed Asset".FieldCaption("No.");
            FADescription := "Fixed Asset".FieldCaption(Description);
        end;
    end;

    local procedure SkipRecord(): Boolean
    begin
        AcquisitionDate := FADeprBook."Acquisition Date";
        DisposalDate := FADeprBook."Disposal Date";

        if "Fixed Asset".Inactive then
            exit(true);
        if AcquisitionDate = 0D then
            exit(true);
        if (AcquisitionDate > EndingDate) and (EndingDate > 0D) then
            exit(true);

        if (DisposalDate > 0D) and (DisposalDate < StartingDate) then
            exit(true);
        exit(false);
    end;

    local procedure SetSalesMark(): Text[30]
    begin
        if DisposalDate > 0D then
            if (EndingDate = 0D) or (DisposalDate <= EndingDate) then
                exit(Text006);
        exit('');
    end;

    local procedure MakeGroupTotalText()
    begin
        case GroupTotals of
            GroupTotals::"FA Class":
                GroupCodeName := "Fixed Asset".FieldCaption("FA Class Code");
            GroupTotals::"FA Subclass":
                GroupCodeName := "Fixed Asset".FieldCaption("FA Subclass Code");
            GroupTotals::"Main Asset":
                GroupCodeName := "Fixed Asset".FieldCaption("Main Asset/Component");
            GroupTotals::"Global Dimension 1":
                GroupCodeName := "Fixed Asset".FieldCaption("Global Dimension 1 Code");
            GroupTotals::"FA Location":
                GroupCodeName := "Fixed Asset".FieldCaption("FA Location Code");
            GroupTotals::"Global Dimension 2":
                GroupCodeName := "Fixed Asset".FieldCaption("Global Dimension 2 Code");
        end;
        if GroupCodeName <> '' then
            GroupCodeName := StrSubstNo(Text003, GroupCodeName);
    end;

    local procedure MakeDateHeadLine()
    begin
        if not PrintDetails then
            exit;
        TextTitle[1] := DateType1;
    end;

    local procedure MakeAmountHeadLine(i: Integer; PostingType: Text; PostingTypeNo: Integer; Period: Option "before Starting Date","Net Change","at Ending Date")
    begin
        if PostingTypeNo = 0 then
            exit;
        case PostingTypeNo of
            FADeprBook.FieldNo("Proceeds on Disposal"),
          FADeprBook.FieldNo("Gain/Loss"):
                if Period <> Period::"at Ending Date" then begin
                    Period := Period::"at Ending Date";
                    Error(
                      Text004,
                      FADeprBook.FieldCaption("Proceeds on Disposal"),
                      FADeprBook.FieldCaption("Gain/Loss"),
                      Period);
                end;
        end;
        if Period = Period::"before Starting Date" then
            if StartingDate < 00010101D then
                Error(
                  Text005, Period);

        TextTitle[i] := StrSubstNo('%1 %2', PostingType, Period);
    end;

    local procedure MakeGroupHeadLine()
    begin
        case GroupTotals of
            GroupTotals::"FA Class":
                GroupTitle := "Fixed Asset"."FA Class Code";
            GroupTotals::"FA Subclass":
                GroupTitle := "Fixed Asset"."FA Subclass Code";
            GroupTotals::"Main Asset":
                begin
                    GroupTitle := StrSubstNo('%1 %2', GroupTotals, "Fixed Asset"."Component of Main Asset");
                    if "Fixed Asset"."Component of Main Asset" = '' then
                        GroupTitle := GroupTitle + '*****';
                end;
            GroupTotals::"Global Dimension 1":
                GroupTitle := "Fixed Asset"."Global Dimension 1 Code";
            GroupTotals::"FA Location":
                GroupTitle := "Fixed Asset"."FA Location Code";
            GroupTotals::"Global Dimension 2":
                GroupTitle := "Fixed Asset"."Global Dimension 2 Code";
        end;
        if GroupTitle = '' then
            GroupTitle := Text013;
    end;

    local procedure SetAmountToZero(PostingTypeNo: Integer; Period: Option "before Starting Date","Net Change","at Ending Date"): Boolean
    begin
        case PostingTypeNo of
            FADeprBook.FieldNo("Proceeds on Disposal"),
          FADeprBook.FieldNo("Gain/Loss"):
                exit(false);
        end;
        if (Period = Period::"at Ending Date") and (SetSalesMark <> '') then
            exit(true);
        exit(false);
    end;

    local procedure CheckDateType(DateType: Text; var DateTypeNo: Integer)
    begin
        DateTypeNo := 0;
        if DateType = '' then
            exit;
        FADateType.SetRange("FA Entry", true);
        if FADateType.FindSet then
            repeat
                TypeExist := DateType = FADateType."FA Date Type Name";
                if TypeExist then
                    DateTypeNo := FADateType."FA Date Type No.";
            until (FADateType.Next = 0) or TypeExist;

        if not TypeExist then
            Error(Text007, DateType);
    end;

    local procedure CheckPostingType(PostingType: Text; var PostingTypeNo: Integer)
    begin
        PostingTypeNo := 0;
        if PostingType = '' then
            exit;
        FAPostingType.SetRange("FA Entry", true);
        if FAPostingType.FindSet then
            repeat
                TypeExist := PostingType = FAPostingType."FA Posting Type Name";
                if TypeExist then
                    PostingTypeNo := FAPostingType."FA Posting Type No.";
            until (FAPostingType.Next = 0) or TypeExist;
        if not TypeExist then
            Error(Text008, PostingType);
    end;

    var
        FASetup: Record "FA Setup";
        DeprBook: Record "Depreciation Book";
        FADeprBook: Record "FA Depreciation Book";
        FAPostingType: Record "FA Posting Type";
        FADateType: Record "FA Date Type";
        FAGenReport: Codeunit "FA General Report";
        FAFilter: Text;
        MainTextTitle: Text;
        DeprBookText: Text;
        GroupCodeName: Text;
        GroupTitle: Text;
        FANo: Text;
        FADescription: Text;
        GroupTotals: Option " ","FA Class","FA Subclass","FA Location","Main Asset","Global Dimension 1","Global Dimension 2";
        GroupAmounts: array[3] of Decimal;
        TotalAmounts: array[3] of Decimal;
        TextTitle: array[5] of Text;
        Amounts: array[3] of Decimal;
        Date: array[2] of Date;
        i: Integer;
        Period1: Option "before Starting Date","Net Change","at Ending Date";
        Period2: Option "before Starting Date","Net Change","at Ending Date";
        Period3: Option "before Starting Date","Net Change","at Ending Date";
        PostingType1: Text;
        PostingType2: Text;
        PostingTypeNo1: Integer;
        PostingTypeNo2: Integer;
        PostingTypeNo3: Integer;
        DateType1: Text;
        DateTypeNo1: Integer;
        DateTypeNo2: Integer;
        StartingDate: Date;
        EndingDate: Date;
        DeprBookCode: Code[10];
        PrintDetails: Boolean;
        BeforeAmount: Decimal;
        EndingAmount: Decimal;
        AcquisitionDate: Date;
        DisposalDate: Date;
        TypeExist: Boolean;
        GroupTotalsNo: Integer;
        PercentageTax: array[4] of Decimal;
        Text001: TextConst ENU = 'Fixed Assets - Professional Tax',
                           FRA = 'Immobilisations - Impôt professionnel';
        Text003: TextConst ENU = 'Subtotals : %1',
                           FRA = 'Sous-totaux : %1';
        Text004: TextConst ENU = '%1 and %2 must be defined only with the option %3.',
                           FRA = '%1 et %2 doivent être définis uniquement avec l''option %3.';
        Text005: TextConst ENU = 'The starting date must be defined only when the option %1 is used.',
                           FRA = 'La date de début doit être définie uniquement lorsque l''option %1 est utilisée.';
        Text006: TextConst ENU = 'Sold',
                           FRA = 'Vendu';
        Text007: TextConst ENU = 'Date type %1 is not a valid option.',
                           FRA = 'Le type date %1 n''est pas une option valide.';
        Text008: TextConst ENU = 'Posting type %1 is not a valid option.',
                           FRA = 'Le type d''affichage %1 n''est pas une option valide.';
        Text012: TextConst ENU = 'Subtotal',
                           FRA = 'Sous-total';
        Text013: TextConst ENU = 'no global dimension',
                           FRA = 'pas de dimension mondiale';
        Text19021992: TextConst ENU = 'Percentage',
                                FRA = 'pourcentage';
        AcquisitionCostCaptionlLbl: TextConst ENU = 'Acquisition Cost',
                                              FRA = 'coût d''acquisition';
        RentingValueCaptionLbl: TextConst ENU = 'Renting Value',
                                          FRA = 'Valeur locative';
        PerctgProfessionalTaxCaptionLbl: TextConst ENU = '% Professional Tax',
                                                   FRA = '% Professional Tax';
        PageNoCaptionLbl: TextConst ENU = 'Page',
                                    FRA = 'Page';
        TotalCaptionLbl: TextConst ENU = 'Total',
                           FRA = 'Total';
}

