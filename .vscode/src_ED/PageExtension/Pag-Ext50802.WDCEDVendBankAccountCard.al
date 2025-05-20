pageextension 50802 "WDC-ED Vend. Bank Account Card" extends "Vendor Bank Account Card"
{
    layout
    {
        addlast(General)
        {

            field("Agency Code"; Rec."Agency Code")
            {
                ApplicationArea = All;
            }
            field("RIB Key"; Rec."RIB Key")
            {
                ApplicationArea = All;
            }
            field("RIB Checked"; Rec."RIB Checked")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
    }
}