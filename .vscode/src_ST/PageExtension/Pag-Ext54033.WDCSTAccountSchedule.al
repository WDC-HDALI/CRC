pageextension 54033 "WDC-ST Account Schedule" extends "Account Schedule"
{
    layout
    {
        addafter("Amount Type")
        {
            field("Debitor totalization"; Rec."Debitor totalization")
            {
                ApplicationArea = All;
            }
            field("Creditor totalization"; Rec."Creditor totalization")
            {
                ApplicationArea = All;
            }
        }

    }




}





