
pageextension 50816 "WDC-ED FA Ledger Entries" extends "FA Ledger Entries"
{
    layout
    {
        addlast(Control1)
        {
            field("Exclude Derogatory"; Rec."Exclude Derogatory")
            {
                ApplicationArea = All;
            }

        }
    }

    actions
    {
    }
}