namespace CRC.CRC;

using Microsoft.Inventory.Item;

page 50037 "WDC Stock value status"
{
    ApplicationArea = All;
    CaptionML = ENU = 'Stock value status', FRA = 'Etat valeur stock';
    PageType = Document;
    UsageCategory = Lists;
    Editable = true;
    layout
    {
        area(Content)
        {
            group(Options)
            {
                Editable = true;
                CaptionML = ENU = 'Filters', FRA = 'Filtres';
                field(CodeFilter; CodeFilter)
                {
                    CaptionML = ENU = 'Item No.', FRA = 'No. d''article';
                    ApplicationArea = All;
                    TableRelation = Item;
                    trigger OnValidate()
                    begin
                        TotalValue := 0;
                        CurrPage.StockValuePart.page.UpdateFilterCurrentPage(CodeFilter, CategoryCodeFilter, SubCategoryCodeFilter);
                        UpdateTotalValue();
                        CurrPage.Update(false);
                    end;
                }
                field(CategoryCodeFilter; CategoryCodeFilter)
                {
                    CaptionML = ENU = 'Category Code', FRA = 'Code catégorie';
                    ApplicationArea = All;
                    TableRelation = "Item Category";
                    trigger OnValidate()
                    begin
                        TotalValue := 0;
                        CurrPage.StockValuePart.page.UpdateFilterCurrentPage(CodeFilter, CategoryCodeFilter, SubCategoryCodeFilter);
                        UpdateTotalValue();
                        CurrPage.Update(false);
                    end;
                }
                field(SubCategoryCodeFilter; SubCategoryCodeFilter)
                {
                    CaptionML = ENU = 'Subcategory Code', FRA = 'Code sous-catégorie';
                    ApplicationArea = All;
                    TableRelation = "WDC SubCategory Item";
                    trigger OnLookup(Var Text: Text): Boolean
                    var
                        WDCSubCategoryItemPage: Page "WDC SubCategory Item Dialog";
                        WDCSubCategory: Record "WDC SubCategory Item";
                    begin
                        WDCSubCategory.reset;
                        if CategoryCodeFilter <> '' then
                            WDCSubCategory.SetRange("Item Category Code", CategoryCodeFilter);
                        WDCSubCategoryItemPage.SetTableView(WDCSubCategory);
                        WDCSubCategoryItemPage.Editable(False);
                        if WDCSubCategoryItemPage.RunModal() = Action::OK then begin
                            WDCSubCategoryItemPage.GETRECORD(WDCSubCategory);
                            SubCategoryCodeFilter := WDCSubCategory.Code;
                        end;

                        TotalValue := 0;
                        CurrPage.StockValuePart.page.UpdateFilterCurrentPage(CodeFilter, CategoryCodeFilter, SubCategoryCodeFilter);
                        UpdateTotalValue();
                        CurrPage.Update(false);
                    end;

                    trigger OnValidate()
                    begin
                        TotalValue := 0;
                        CurrPage.StockValuePart.page.UpdateFilterCurrentPage(CodeFilter, CategoryCodeFilter, SubCategoryCodeFilter);
                        UpdateTotalValue();
                        CurrPage.Update(false);
                    end;
                }
                field(TotalValue; TotalValue)
                {
                    CaptionML = ENU = 'Total Stock Value', FRA = 'Valeur stock totale';
                    ApplicationArea = All;
                    Editable = false;
                    Style = Strong;

                }
            }
            part(StockValuePart; "WDC Stock Value Status Part")
            {
                ApplicationArea = All;
            }
        }
    }
    trigger OnOpenPage()
    begin
        UpdateTotalValue();
    end;

    procedure UpdateTotalValue()
    var
        lItem: Record Item;
    begin
        TotalValue := 0;
        lItem.reset;
        lItem.SetCurrentKey(Type);
        lItem.SetRange(Type, lItem.Type::Inventory);
        lItem.SetFilter("No.", CodeFilter);
        lItem.SetFilter("Item Category Code", CategoryCodeFilter);
        lItem.SetFilter(SubCategorie, SubCategoryCodeFilter);
        if lItem.FindSet() then
            repeat
                lItem.CalcFields(Inventory);
                TotalValue += lItem.Inventory * lItem."Last Direct Cost";
                CurrPage.Update(false);
            until lItem.Next() = 0;
    end;

    var
        DescriptionFilter: Text[100];
        CodeFilter: Code[20];
        CategoryCodeFilter: Code[20];
        SubCategoryCodeFilter: Code[20];
        StockValue: Decimal;
        TotalValue: Decimal;

}
