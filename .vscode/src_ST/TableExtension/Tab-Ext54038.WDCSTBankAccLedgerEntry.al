tableextension 54038 "WDC-ST Bank Acc. Ledger Entry" extends "Bank Account Ledger Entry"
{
    fields
    {
        field(54075; "Payment Slip Type"; Enum "WDC-ST Payment Slip Type")
        {
            CaptionML = ENU = 'Payment Slip Type', FRA = 'Type paiement';
            Editable = false;
        }
    }
}