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
        field(50006; "Unpaid"; Boolean)
        {
            CaptionML = ENU = 'Unpaid', FRA = 'Impayé';
            DataClassification = ToBeClassified;
        }

        field(50007; "Unpaid is Encaissed"; Boolean)
        {
            CaptionML = ENU = 'Unpaid Is Encaissed', FRA = 'Impayé encaissé';
            DataClassification = ToBeClassified;
        }
        field(50008; "Unpaid Enc. Reference"; Code[50])
        {
            CaptionML = ENU = 'Unpaid Enc. Reference', FRA = 'Référence Impayé Encaissé';
        }
        field(50009; "Unpaid Before GoLive"; Boolean)
        {
            CaptionML = ENU = 'Unpaid Before GoLive', FRA = 'Impayé avant démarrage système';
            DataClassification = ToBeClassified;
        }
    }

}