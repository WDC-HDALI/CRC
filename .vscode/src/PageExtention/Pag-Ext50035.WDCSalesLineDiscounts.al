pageextension 50035 "WDC Sales Line Discounts" extends "Sales Line Discounts"
{
    layout
    {
        addafter("Line Discount %")
        {
            field("Discount Ceiling %"; Rec."Discount Ceiling %")
            {
                ApplicationArea = all;
            }


        }
    }
}