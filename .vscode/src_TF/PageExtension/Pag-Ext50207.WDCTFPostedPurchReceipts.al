pageextension 50207 "WDC-TF Posted Purch. Receipts" extends "Posted Purchase Receipts"
{
    layout
    {
        addafter("Shipment Method Code")
        {
            field("Transit Folder No."; Rec."Transit Folder No.")
            {
                ApplicationArea = all;
            }
        }
    }
}
