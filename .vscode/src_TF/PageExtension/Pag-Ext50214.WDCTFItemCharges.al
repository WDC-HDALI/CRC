//****************Documentation**********************

pageextension 50214 "WDC-TF Item Charges" extends "Item Charges"
{
    layout
    {
        addafter("Description")
        {
            field("Mandatory Transit Folder No."; Rec."Mandatory Transit Folder No.")
            {
                ApplicationArea = all;
            }

        }
    }
}