//****************Documentation**********************

pageextension 50044 "WDC Location Card" extends "Location Card"
{
    layout
    {
        addafter("Use As In-Transit")
        {
            field("Customer Mandatory"; Rec."Customer Mandatory")
            {
                ApplicationArea = all;
            }

        }
    }
}