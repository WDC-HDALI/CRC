pageextension 50064 "WDC Pstd Sales CR Memo. - Upda" extends "Pstd. Sales Cr. Memo - Update"
{
    layout
    {
        addafter("Posting Date")
        {
            field("Salesperson Code"; Rec."Salesperson Code")
            {
                ApplicationArea = all;

            }
        }
        modify("Sell-to Customer Name")
        {
            Editable = true;
        }
        modify("Shipping Agent Code")
        {
            Visible = false;
        }
        modify("Shipping Agent Service Code")
        {
            Visible = false;
        }

    }
}