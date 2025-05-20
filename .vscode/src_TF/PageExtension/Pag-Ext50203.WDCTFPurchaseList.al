pageextension 50203 "WDC-TF Purchase List" extends "Purchase List"
{
    layout
    {
        addafter("Pay-to Post Code")
        {
            field("Transit Folder No."; Rec."Transit Folder No.")
            {
                ApplicationArea = all;
            }
        }
    }
}
