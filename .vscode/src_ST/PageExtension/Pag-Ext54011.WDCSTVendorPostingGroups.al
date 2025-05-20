pageextension 54011 "WDC-ST Vendor Posting Groups" extends "Vendor Posting Groups"
{
    layout
    {
        addlast(Control1)
        {

            field("Stamp Amount"; Rec."Stamp Amount")
            {
                ApplicationArea = All;
            }
            field("Fiscal Stamp Account No."; Rec."Fiscal Stamp Account No.")
            {
                ApplicationArea = All;
            }
            field("Apply Fiscal Stamp"; Rec."Apply Fiscal Stamp")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
    }
}