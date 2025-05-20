pageextension 50808 "WDC-ED Customer Card" extends "Customer Card"
{
    layout
    {
        addafter(Payments)
        {

            field("Payment in progress (LCY)"; Rec."Payment in progress (LCY)")
            {
                ApplicationArea = All;
            }
            field("Exclude from Payment Reporting"; Rec."Exclude from Payment Reporting")
            {
                ApplicationArea = All;
            }
        }

    }

    actions
    {
    }
}
