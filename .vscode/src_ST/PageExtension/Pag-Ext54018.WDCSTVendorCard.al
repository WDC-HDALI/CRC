pageextension 54018 "WDC-ST Vendor Card" extends "Vendor Card"
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

        addlast("Invoicing")
        {
            field("RS Code"; Rec."RS Code")
            {
                ApplicationArea = All;
            }

        }
    }

}


