pageextension 54015 "WDC-ST Item Card" extends "Item Card"
{
    layout
    {

        addlast("Costs & Posting")
        {

            field("Tax Group Code1"; Rec."Tax Group Code")
            {
                ApplicationArea = All;
            }

        }

    }
}

