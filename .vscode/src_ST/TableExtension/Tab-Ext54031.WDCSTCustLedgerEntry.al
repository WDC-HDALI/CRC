tableextension 54031 "WDC-ST Cust. Ledger Entry" extends "Cust. Ledger Entry"
{
    fields
    {
        field(54075; "Payment Slip Type"; Enum "WDC-ST Payment Slip Type")
        {
            CaptionML = ENU = 'Payment Slip Type', FRA = 'Type paiement';
            Editable = false;
        }
        field(54076; "Payment Terms Code"; Code[10])
        {
            CaptionML = ENU = 'Payment Terms Code', FRA = 'Code Conditions Paiement';
            TableRelation = "Payment Terms";
        }
    }
}