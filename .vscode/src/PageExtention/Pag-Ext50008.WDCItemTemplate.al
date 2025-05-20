pageextension 50008 "WDC Item Template" extends "Item Templ. Card"
{
    layout
    {
        addafter("Item Category Code")
        {
            field(SubCategorie; Rec.SubCategorie)
            {
                ApplicationArea = all;
            }
        }
    }
}
