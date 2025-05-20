pageextension 54004 "WDC-ST Sales Invoice" extends "Sales Invoice"
{
    layout
    {
        addlast(Control200)
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