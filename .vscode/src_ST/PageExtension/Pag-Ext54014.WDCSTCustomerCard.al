pageextension 54014 "WDC-ST Customer Card" extends "Customer Card"
{
    layout
    {

        addlast(General)
        {
            field(CIN; Rec.CIN)
            {
                ApplicationArea = All;
            }
        }
    }

}


