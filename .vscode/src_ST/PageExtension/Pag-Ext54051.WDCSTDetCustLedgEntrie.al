//*********************Documentation************************
//WDC01  WDC.HG  29/05/2025   Show field "PaymentStatut"
pageextension 54051 "WDC-ST Det. Cust. Ledg. Entrie" extends "Detailed Cust. Ledg. Entries"
{

    layout
    {

        addafter("Currency Code")
        {
            field("Payment Slip Type"; Rec."Payment Slip Type")
            {
                ApplicationArea = all;
            }

        }
        //<<WDC02
        addafter("Customer No.")
        {
            field("Customer Name"; Rec."Customer Name")
            {
                ApplicationArea = all;

            }

        }
    }

    //>>wdc02
}