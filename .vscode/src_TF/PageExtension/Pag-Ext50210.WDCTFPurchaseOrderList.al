pageextension 50210 "WDC-TF Purchase Order List" extends "Purchase Order List"
{
    layout
    {
        addafter("Posting Description")
        {
            field("Transit Folder No."; Rec."Transit Folder No.")
            {
                ApplicationArea = all;
            }
        }
    }
}
