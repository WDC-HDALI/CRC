pageextension 50202 "WDC-TF Purchase Invoice" extends "Purchase Invoice"
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
