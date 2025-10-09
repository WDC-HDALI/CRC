//*********************Documentation************************
//WDC01  WDC.HG  29/05/2025   Add field "PaymentStatut"
tableextension 50005 "WDC Cust. Ledger Entry" extends "Cust. Ledger Entry"
{
    fields
    {
        field(50000; "Initial Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50001; "Initial Document No."; code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50002; Lettrage; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        //<<WDC01
        field(50003; PaymentStatut; enum "WDC Payment Statut")
        {
            CaptionML = ENU = 'Payment Statut', FRA = 'Statut de paiement';

        }
        field(50004; IsInserted; Boolean)
        {
            CaptionML = ENU = 'Is Selected', FRA = 'sélectionnée';

        }
        field(50005; "Bank Name"; code[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Bank Name', FRA = 'Nom banque';
        }

        //>>WDC01

    }
}