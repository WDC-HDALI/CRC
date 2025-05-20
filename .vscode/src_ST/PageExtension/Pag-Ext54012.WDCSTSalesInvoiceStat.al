pageextension 54012 "WDC-ST Sales Invoice Stat." extends "Sales Invoice Statistics"
{
    layout
    {
        addlast(General)
        {

            field("Stamp Amount"; Rec."Stamp Amount")
            {
                ApplicationArea = All;
            }
        }

    }

    actions
    {
    }
}