report 50037 "WDC CA By Category"
{
    ApplicationArea = All;
    CaptionML = ENU = 'Sales By Category', FRA = 'CA par famille';
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = './.vscode/src/Report/RDLC/CAByCategory.rdl';
    dataset
    {


        dataItem("Payment Tracking Buffer"; "Payment Tracking Buffer")
        {
            DataItemTableView = sorting("Posting Date", "Item Category Code", "Sub Category", "Item No.");
            column(No_; "Payment Tracking Buffer"."Item No.")
            {

            }
            column(Description; "Payment Tracking Buffer"."Item Description")
            {

            }
            column(Item_Category_Code; "Payment Tracking Buffer"."Item Category Code")
            {

            }
            column(SubCategorie; "Payment Tracking Buffer"."Sub Category")
            {

            }
            column(Quantity; "Payment Tracking Buffer".Quantity)
            {
            }
            column(CA; "Payment Tracking Buffer"."Amount Excl. VAT")
            {
            }
            column(CompanyCity; companyinfo.City)
            {
            }
            column(CompanyName; CompanyInfo."Name")
            {
            }
            column(CompanyPostCod; companyinfo."Post Code")
            {
            }
            column(CompanyAdress; companyinfo.Address)
            {
            }
            column(CompanyPicture; CompanyInfo.Picture)
            {
            }
            column(CompanyPhoneNo; CompanyInfo."Phone No.")
            {
            }
            column(FiltersText; FiltersText)
            {
            }


            trigger OnPreDataItem()
            begin
                if (StartDate <> 0D) and (EndingDate <> 0D) then
                    "Payment Tracking Buffer".SetRange("Posting Date", StartDate, EndingDate);

                if ItemNo <> '' then
                    "Payment Tracking Buffer".SetFilter("Item No.", ItemNo);
                if ItemCategoryCode <> '' then
                    "Payment Tracking Buffer".SetFilter("Item Category Code", ItemCategoryCode);
                if SubCategorie <> '' then
                    "Payment Tracking Buffer".SetFilter("Sub Category", SubCategorie);

                FiltersText := "Payment Tracking Buffer".GetFilters();
            end;
        }

    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    CaptionML = ENG = 'Filter', FRA = 'Filtrer par';
                    field(StartDate; StartDate)
                    {
                        ApplicationArea = all;
                        CaptionML = ENG = 'Start Date', FRA = 'Date début';
                        trigger OnValidate()
                        var
                            Err001: TextConst ENG = 'Starting date must be less then ending date',
                                              FRA = 'Date début doit être inférieur à la date fin ';
                        begin
                            if (StartDate > EndingDate) and (EndingDate <> 0D) then
                                Error(Err001);
                        end;
                    }
                    field(EndingDate; EndingDate)
                    {
                        ApplicationArea = ALL;
                        CaptionML = ENG = 'End Date', FRA = 'Date fin';
                        trigger OnValidate()
                        var
                            Err001: TextConst ENG = 'Ending date must be greater then starting date', FRA = 'Date Fin doit être supérieur à date début ';
                        begin
                            if (StartDate > EndingDate) and (StartDate <> 0D) then
                                Error(Err001);
                        end;
                    }
                    field(ItemCategoryCode; ItemCategoryCode)
                    {
                        ApplicationArea = ALL;
                        CaptionML = ENG = 'Famille', FRA = 'Famille';
                        TableRelation = "Item Category".code;
                    }
                    field(SubCategorie; SubCategorie)
                    {
                        ApplicationArea = ALL;
                        CaptionML = ENG = 'SubCategorie', FRA = 'Sous-Famille';
                        trigger OnLookup(Var Text: Text): Boolean
                        var
                            WDCSubCategoryItemPage: Page "WDC SubCategory Item";
                            WDCSubCategory: Record "WDC SubCategory Item";
                        begin
                            WDCSubCategory.reset;
                            WDCSubCategory.SetRange("Item Category Code", ItemCategoryCode);
                            WDCSubCategoryItemPage.SetTableView(WDCSubCategory);
                            WDCSubCategoryItemPage.Editable(False);
                            if WDCSubCategoryItemPage.RunModal() = Action::OK then begin
                                WDCSubCategoryItemPage.GETRECORD(WDCSubCategory);
                                SubCategorie := WDCSubCategory.Code;
                            end;
                        end;
                    }
                    field(ItemNo; ItemNo)
                    {
                        ApplicationArea = ALL;
                        CaptionML = ENG = 'Item No.', FRA = 'N° article';
                        TableRelation = Item."No.";
                    }
                }
            }
        }
    }
    trigger OnInitReport()
    begin
        CompanyInfo.Get();
        CompanyInfo.CalcFields(Picture);
    end;

    var
        ItemNo: Code[20];
        ItemCategoryCode: Code[20];
        SubCategorie: Code[50];
        StartDate: Date;
        EndingDate: Date;
        CompanyInfo: record "Company Information";
        CA: Decimal;
        Quantity: Decimal;
        FiltersText: Text;
}