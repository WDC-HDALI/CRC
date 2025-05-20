pageextension 50204 "WDC-TF User Setup" extends "User Setup"
{
    layout
    {
        addafter("Email")
        {
            field("Transit Folder No."; Rec."Allow Open Transit Folder")
            {
                ApplicationArea = all;
            }
        }
    }
}
