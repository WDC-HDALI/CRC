page 50007 "WDC SubCategory Item"
{
    ApplicationArea = All;
    CaptionML = ENU = 'Sub-Category', FRA = 'Sous-catégorie article';
    PageType = List;
    SourceTable = "WDC SubCategory Item";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {

                // field("Item Category Code"; Rec."Item Category Code")
                // {
                //     ApplicationArea = all;
                // }

                field(Code; Rec.Code)
                {
                    ApplicationArea = all;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                }
            }
        }

    }

}
