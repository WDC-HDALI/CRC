page 50043 "WDC SubCategory Item Dialog"
{
    ApplicationArea = All;
    CaptionML = ENU = 'Sub-Category', FRA = 'Sous-catégorie article';
    PageType = StandardDialog;
    SourceTable = "WDC SubCategory Item";
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
