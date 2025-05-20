pageextension 50024 "WDC Sales Quote Subform" extends "Sales Quote Subform"
{
    layout
    {
        modify("Qty. to Assemble to Order")
        {
            Visible = false;
        }
        modify("Substitution Available")
        {
            Visible = false;
        }
        modify("Qty. Assigned")
        {
            Visible = false;
        }
        modify("Qty. to Assign")
        {
            Visible = false;
        }
        moveafter("Line Discount %"; "Line Discount Amount")
        moveafter("Line Discount %"; "Line Amount")
    }
}