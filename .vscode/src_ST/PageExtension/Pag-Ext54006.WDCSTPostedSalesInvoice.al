Pageextension 54006 "WDC-ST Posted Sales Invoice" extends "Posted Sales Invoice"
{
    layout
    {
        addlast("Invoice Details")
        {
            field("Stamp Amount"; Rec."Stamp Amount")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Apply Fiscal Stamp"; Rec."Apply Fiscal Stamp")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
    }
}