pageextension 54009 "WDC-ST Purchase Invoice" extends "Purchase Invoice"
{
    layout
    {
        addlast(General)
        {
            field("Stamp Amount"; Rec."Stamp Amount")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Apply Fiscal Stamp"; Rec."Apply Fiscal Stamp")
            {
                ApplicationArea = All;

            }
        }
    }
}