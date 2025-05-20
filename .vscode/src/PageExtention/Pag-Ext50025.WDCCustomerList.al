pageextension 50025 "WDC Customer List" extends "Customer List"
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

        addafter(Name)
        {
            field(Address; Rec.Address)
            {
                ApplicationArea = All;
            }
            field(City; Rec.City)
            {
                ApplicationArea = All;
            }



        }
        MoveAfter(Name; "Credit Limit (LCY)")
    }
}