pageextension 50213 "WDC-TF Posted Purch. Invoices" extends "Posted Purchase Invoices"
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
