pageextension 50206 "WDC-TF Posted Purch. Rcpt. Sub" extends "Posted Purchase Rcpt. Subform"
{
    layout
    {
        addafter("ShortcutDimCode[8]")
        {
            field("Transit Folder No."; Rec."Transit Folder No.")
            {
                ApplicationArea = all;
            }
        }
    }
}
