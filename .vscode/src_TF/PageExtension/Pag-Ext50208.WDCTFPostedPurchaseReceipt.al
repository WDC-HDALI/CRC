pageextension 50208 "WDC-TF Posted Purchase Receipt" extends "Posted Purchase Receipt"
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
    var
        pap: Page 5740;
        cc: Codeunit "TransferOrder-Post (Yes/No)";
}
