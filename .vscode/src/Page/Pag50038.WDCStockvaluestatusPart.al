namespace CRC.CRC;

using Microsoft.Inventory.Item;

page 50038 "WDC Stock value status Part"
{
    ApplicationArea = All;
    CaptionML = ENU = 'Stock value status', FRA = 'Etat valeur stock';
    PageType = ListPart;
    SourceTable = Item;
    SourceTableView = SORTING("No.") WHERE(Type = const(Inventory));
    UsageCategory = Lists;
    CardPageId = "Item Card";
    Editable = true;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                Editable = false;
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field(Inventory; Rec.Inventory)
                {
                    ApplicationArea = All;
                }
                field("Last Direct Cost"; Rec."Last Direct Cost")
                {
                    ApplicationArea = All;
                }
                field("Stock Value"; StockValue)
                {
                    CaptionML = ENU = 'Stock Value', FRA = 'Valeur stock';
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        StockValue := 0;
        rec.CalcFields(Inventory);
        StockValue := Rec.Inventory * Rec."Last Direct Cost";
    end;

    procedure UpdateFilterCurrentPage(pItemNo: Code[20]; pCategoryCode: Code[20]; pSubCategoryCode: Code[20])
    begin
        Rec.SetFilter("No.", pItemNo);
        Rec.SetFilter("Item Category Code", pCategoryCode);
        Rec.SetFilter(SubCategorie, pSubCategoryCode);
        CurrPage.Update(false);
    end;

    var
        StockValue: Decimal;

}
