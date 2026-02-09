pageextension 50031 "WDC Customer Lookup" extends "Customer Lookup"
{
    layout
    {
        modify("Responsibility Center")
        {
            Visible = false;
        }
        modify("Location Code")
        {
            Visible = false;
        }
        modify(Blocked)
        {
            Visible = true;
            ApplicationArea = All;
        }
        modify(Contact)
        {
            Visible = false;
        }
        MoveAfter(Name; "Credit Limit (LCY)")
    }
}