pageextension 50201 "WDC-TF Purchase Order" extends "Purchase Order"
{
    layout
    {
        addafter(Status)
        {
            field("Transit Folder No."; Rec."Transit Folder No.")
            {
                ApplicationArea = all;
            }
        }
    }
}
