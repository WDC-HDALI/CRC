tableextension 54022 "WDC-ST Det. Cust. Ledg. Entry" extends "Detailed Cust. Ledg. Entry"
{
    fields
    {
        field(54000; "Commande No."; Code[20])
        {
            DataClassification = CustomerContent;
            CaptionML = ENU = 'Order No.', FRA = 'No. commande';
        }
        field(54001; "Invoice No."; code[20])
        {
            DataClassification = CustomerContent;
            CaptionML = ENU = 'Invoice No.', FRA = 'N° Facture';
        }
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