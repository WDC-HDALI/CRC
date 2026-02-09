//*********************Documentation************************
//WDC01  WDC.HG  29/05/2025   Show field "PaymentStatut"
pageextension 50006 "WDC CustLegEntry" extends "Customer Ledger Entries"
{

    layout
    {
        moveafter("Payment Method Code"; "Customer No.")
        moveafter("Document No."; "Payment Method Code")

        //WDC01
        addafter("Payment Method Code")
        {
            field("Debit Amount_"; Rec."Debit Amount")
            {
                ApplicationArea = All;
            }
            field("Credit Amount_"; Rec."Credit Amount")
            {
                ApplicationArea = All;
            }
            field(Amount_; Rec.Amount)
            {
                ApplicationArea = All;
            }
            field("Remaining Amount_"; Rec."Remaining Amount")
            {
                ApplicationArea = All;
            }
            field("Payment Reference"; Rec."Payment Reference")
            {
                ApplicationArea = all;
            }
            field("Bank Name"; Rec."Bank Name")
            {
                ApplicationArea = all;
            }
            field(PaymentStatut; Rec.PaymentStatut)
            {
                ApplicationArea = all;
            }
        }

        modify("Original Amount")
        {
            Visible = false;
        }
        modify("Amount (LCY)")
        {
            Visible = false;
        }
        modify("Remaining Amt. (LCY)")
        {
            Visible = false;
        }
        modify("Original Amt. (LCY)")
        {
            Visible = false;
        }
        modify("Debit Amount (LCY)")
        {
            Visible = false;
        }
        modify("Credit Amount (LCY)")
        {
            Visible = false;
        }
        modify("Sales (LCY)")
        {
            Visible = false;
        }

        modify("Original Pmt. Disc. Possible")
        {
            Visible = false;
        }
        modify("Currency Code")
        {
            Visible = false;
        }
        modify("Pmt. Disc. Tolerance Date")
        {
            Visible = false;
        }
        modify("Pmt. Discount Date")
        {
            Visible = false;
        }
        modify("Document Date")
        {
            Visible = false;
        }
        modify("Promised Pay Date")
        {
            Visible = false;
        }
        modify("Remaining Pmt. Disc. Possible")
        {
            Visible = false;
        }
        modify("Max. Payment Tolerance")
        {
            Visible = false;
        }
        modify("Dispute Status")
        {
            Visible = false;
        }
        modify("Message to Recipient")
        {
            Visible = false;
        }
        modify("Exported to Payment File")
        {
            Visible = false;
        }
        modify("On Hold")
        {
            Visible = false;
        }


        //>>WDC01
    }
    trigger OnAfterGetRecord()
    var
        lCusttLedgEntr: Report "WDC Upd Cust name Det Cust_Led";


    begin

        // lCusttLedgEntr.UpdateCustLedgEntri(rec."Entry No.");
        // CurrPage.Update(false);

    end;

}