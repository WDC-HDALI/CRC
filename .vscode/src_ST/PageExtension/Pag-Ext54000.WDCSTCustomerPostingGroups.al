Pageextension 54000 "WDC-ST Customer Posting Groups" extends "Customer Posting Groups"
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
            field(applyStamp; Rec."Apply Fiscal Stamp")
            {
                ApplicationArea = All;
            }
        }
    }
}