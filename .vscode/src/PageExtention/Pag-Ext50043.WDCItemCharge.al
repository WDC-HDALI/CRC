//****************Documentation**********************

pageextension 50043 "WDC Item Charges" extends "Item Charges"
{
    layout
    {
        addafter("Description")
        {
            field("Not Editable in Sales Line"; Rec."Not Editable in Sales Line")
            {
                ApplicationArea = all;
            }

        }
    }
}