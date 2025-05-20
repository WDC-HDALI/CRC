pageextension 54005 "WDC-ST Sales Credit Memo" extends "Sales Credit Memo"
{
    layout
    {
        addlast("Credit Memo Details")
        {
            field("Apply Fiscal Stamp"; Rec."Apply Fiscal Stamp")
            {
                ApplicationArea = All;
            }
            field("Stamp Amount"; Rec."Stamp Amount")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
    }
}