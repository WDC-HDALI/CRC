pageextension 54016 "WDC-ST General Ledger Setup" extends "General Ledger Setup"
{
    layout
    {

        addlast(General)
        {
            field("Min RS Amount LCY"; Rec."Min RS Amount LCY")
            {
                ApplicationArea = all;
            }
        }



    }

}


