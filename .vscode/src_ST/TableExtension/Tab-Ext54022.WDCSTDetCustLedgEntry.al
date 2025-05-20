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


    }


}