pageextension 50212 "WDC-TF Posted Purch. Invoice" extends "Posted Purchase Invoice"
{
    layout
    {
        addafter("Order No.")
        {
            field("Transit Folder No."; Rec."Transit Folder No.")
            {
                ApplicationArea = all;
            }
        }
    }
}
