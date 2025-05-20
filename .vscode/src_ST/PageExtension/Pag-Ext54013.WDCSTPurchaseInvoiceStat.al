pageextension 54013 "WDC-ST Purchase Invoice Stat." extends "Purchase Invoice Statistics"
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
}