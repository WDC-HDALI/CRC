pageextension 50062 "WDC Posted Purch. Receipts" extends "Posted Purchase Receipts"
{
    layout
    {
        addafter("No.")
        {
            field("Posting Date_"; Rec."Posting Date")
            {
                ApplicationArea = all;
            }

        }
        addafter("Buy-from Vendor Name")
        {

            field(Note; Rec.Note)
            {
                ApplicationArea = all;
            }
            field("Order No."; Rec."Order No.")
            {
                ApplicationArea = all;
            }
            field("Bill in advance"; Rec."Bill in advance")
            {
                ApplicationArea = all;
            }
        }
        modify("Location Code")
        {
            Visible = false;
        }
        modify("No. Printed")
        {
            Visible = false;
        }
    }
    trigger OnOpenPage()
    begin
        rec.SetCurrentKey("Posting Date")
    end;
}
