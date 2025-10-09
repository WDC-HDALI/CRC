tableextension 54033 "WDC-ST Vendor Ledger Entry" extends "Vendor Ledger Entry"
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