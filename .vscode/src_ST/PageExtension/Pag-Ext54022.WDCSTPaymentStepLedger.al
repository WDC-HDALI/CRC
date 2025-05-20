pageextension 54022 "WDC-ST Payment Step Ledger" extends "WDC-ED Payment Step Ledger"
{
    layout
    {
        addlast(Control1)
        {
            field("Posting RS"; Rec."Posting RS")
            {
                ApplicationArea = All;
            }
            field("VAT %"; Rec."VAT %")
            {
                ApplicationArea = All;
            }
            field("Posting RS On VAT"; Rec."Posting RS On VAT")
            {
                ApplicationArea = All;
            }
            field("Cancel Posting RS"; Rec."Cancel Posting RS")
            {
                ApplicationArea = All;
            }
            field("RS Account No."; Rec."RS Account No.")
            {
                ApplicationArea = All;
            }
            field("Commission Account No."; Rec."Commission Account No.")
            {
                ApplicationArea = All;
            }
            field("Commission VAT Account No."; Rec."Commission VAT Account No.")
            {
                ApplicationArea = All;
            }
            field("RS On Guarantee"; Rec."RS On Guarantee")
            {
                ApplicationArea = All;
            }
        }
    }
}