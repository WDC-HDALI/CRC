pageextension 50101 "WDC Posted Transfer Shpt Line" extends "Posted Transfer Shpt. Subform"
{
    layout
    {
        addafter(Quantity)
        {
            field("Last Direct Cost"; rec."Last Direct Cost")
            {
                ApplicationArea = All;
                ToolTip = 'Displays the last direct cost of the item.';
            }
        }
    }
}
