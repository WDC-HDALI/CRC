
pageextension 50815 "WDC-ED G/L Account Card" extends "G/L Account Card"
{
    layout
    {
        addlast(General)
        {
            field("Detailed Balance"; Rec."Detailed Balance")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
    }
}