pageextension 50801 "WDC-ED Cust. Bank Account Card" extends "Customer Bank Account Card"
{
    layout
    {
        addlast(General)
        {

            field("RIB Checked"; Rec."RIB Checked")
            {
                ApplicationArea = All;
            }
            field("RIB Key"; Rec."RIB Key")
            {
                ApplicationArea = All;
            }
            field("Agency Code"; Rec."Agency Code")
            {
                ApplicationArea = All;
            }
        }

    }

    actions
    {
    }
}