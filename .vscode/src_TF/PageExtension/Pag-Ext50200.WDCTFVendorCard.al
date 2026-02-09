pageextension 50200 "WDC-TF Vendor Card" extends "Vendor Card"
{
    layout
    {
        addafter(Blocked)
        {
            field("Foreign Vendor"; Rec."Foreign Vendor")
            {
                ApplicationArea = all;
            }

        }
    }
}
