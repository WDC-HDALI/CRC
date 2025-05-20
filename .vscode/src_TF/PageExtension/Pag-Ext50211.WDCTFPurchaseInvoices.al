pageextension 50211 "WDC-TF Purchase Invoices" extends "Purchase Invoices"
{
    layout
    {
        addafter(Amount)
        {
            field("Transit Folder No."; Rec."Transit Folder No.")
            {
                ApplicationArea = all;
            }
        }
    }
}
