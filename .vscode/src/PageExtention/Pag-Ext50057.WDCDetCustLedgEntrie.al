//*********************Documentation************************
//WDC01  WDC.HG  29/05/2025   Show field "PaymentStatut"
//wdc02  WDC.FS  20/06/2025   Show field "Customer Name" in Detailed Customer Ledger Entries
pageextension 50057 "WDC- Det. Cust. Ledg. Entrie" extends "Detailed Cust. Ledg. Entries"
{

    layout
    {
        movebefore("Entry No."; "Cust. Ledger Entry No.")
        movebefore("Entry No."; Amount)
        addbefore(Amount)
        {
            field("Bank Name"; Rec."Bank Name")
            {
                ApplicationArea = all;
                CaptionML = ENU = 'Bank Name', FRA = 'Nom de la banque';
            }
            field("Payment Reference"; Rec."Payment Reference")
            {
                ApplicationArea = all;
                CaptionML = ENU = 'Payment Reference', FRA = 'Référence de paiement';
            }

        }
        modify("Debit Amount")
        {
            Visible = true;
        }

        modify("Credit Amount")
        {
            Visible = true;
        }
        modify("Cust. Ledger Entry No.")
        {
            Visible = false;
        }
        modify("Currency Code")
        {
            Visible = false;
        }

        modify("Amount (LCY)")
        {
            Visible = false;
        }

    }
    trigger OnAfterGetRecord()
    var

        lUpdateCustName: report "WDC Upd Cust name Det Cust_Led";
    begin

        Clear(lUpdateCustName);
        lUpdateCustName.UpdateDetCustLedgEntri(rec."Entry No.");
        CurrPage.Update(false);
    end;
    //>>wdc02
}