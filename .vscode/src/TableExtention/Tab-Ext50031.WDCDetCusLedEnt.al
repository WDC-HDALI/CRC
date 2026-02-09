//****************Documentation**********************
//wdc01  WDC.FS  20/06/2025 Add fields
tableextension 50031 "WDC Det. Cust. Ledg. Entry" extends "Detailed Cust. Ledg. Entry"
{
    fields
    {

        //<<wdc01
        field(50001; "Customer Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Customer Name', FRA = 'Nom client';
            // FieldClass = FlowField;
            // CalcFormula = lookup("Sales Invoice Header"."Sell-to Customer Name" where("Cust. Ledger Entry No." = field("Cust. Ledger Entry No.")));
            Editable = false;
        }
        //>>wdc01
        field(50002; "Payment Reference"; Code[50])
        {
            CaptionML = ENU = 'Payment Reference', FRA = 'Référence paiement';
            FieldClass = FlowField;
            CalcFormula = lookup("Cust. Ledger Entry"."Payment Reference" where("Entry No." = field("Cust. Ledger Entry No.")));
            Editable = false;
        }
        field(50003; "Bank Name"; Text[100])
        {
            CaptionML = ENU = 'Bank Name', FRA = 'Nom banque';
            FieldClass = FlowField;
            CalcFormula = lookup("Cust. Ledger Entry"."Bank Name" where("Entry No." = field("Cust. Ledger Entry No.")));
            Editable = false;
        }
    }


}