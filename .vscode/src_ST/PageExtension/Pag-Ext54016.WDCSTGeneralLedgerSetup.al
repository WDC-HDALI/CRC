pageextension 54016 "WDC-ST General Ledger Setup" extends "General Ledger Setup"
{
    layout
    {

        addlast(General)
        {
            field("Default RS"; Rec."Default RS")
            {
                ApplicationArea = all;
            }
        }



    }

}


