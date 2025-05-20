pageextension 54010 "WDC-ST Purchase Credit Memo" extends "Purchase Credit Memo"
{
    layout
    {
        addlast("Invoice Details")
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