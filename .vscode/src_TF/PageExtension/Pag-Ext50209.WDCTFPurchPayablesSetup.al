pageextension 50209 "WDC-TF Purch. & Payables Setup" extends "Purchases & Payables Setup"
{
    layout
    {
        addafter("Posted Prepmt. Cr. Memo Nos.")
        {
            field("Transit Folder No."; Rec."Transit Folder Nos.")
            {
                ApplicationArea = all;
            }
        }
    }
}
