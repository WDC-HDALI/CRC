namespace CRC.CRC;

using Microsoft.Bank.BankAccount;

pageextension 54048 "WDC-ST Payment Methods" extends "Payment Methods"
{
    layout
    {
        addbefore(Code)
        {
            field("Payment Type"; Rec."Payment Type")
            {
                ApplicationArea = All;
            }
        }
        addafter("Bal. Account No.")
        {
            field(Unpaid; Rec.Unpaid)
            {
                ApplicationArea = All;
            }

            field("Posting Group"; Rec."Posting Group")
            {

                ApplicationArea = All;
            }
        }
    }
}
