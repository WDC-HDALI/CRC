namespace CRC.CRC;

using Microsoft.Sales.Document;
using Microsoft.Sales.Receivables;
using Microsoft.Sales.History;

tableextension 50018 "WDC Sales Invoice Header" extends "Sales Invoice Header"
{
    fields
    {
        //   field(50000; Créé dans le sales shipment header)

        field(50001; "Invoiced Order No."; Code[20])
        {
            CaptionML = ENU = 'Invoiced Order No.', FRA = 'N° commande facturée';
            DataClassification = ToBeClassified;
        }
        field(50002; "Cheque Payment"; Decimal)
        {
            CaptionML = ENU = 'Cheque Payment', FRA = 'Règlement Chèque';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("Detailed Cust. Ledg. Entry"."Credit Amount (LCY)" where("Payment Slip Type" = Const(Cheque),
                                                           "Cust. Ledger Entry No." = field("Cust. Ledger Entry No."),
                                                           "Entry Type" = const(Application)));
        }
        field(50003; "Draft Payment"; Decimal)
        {
            CaptionML = ENU = 'Draft Payment', FRA = 'Règlement Traite';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("Detailed Cust. Ledg. Entry"."Credit Amount (LCY)" where("Payment Slip Type" = Const(Draft),
                                                           "Cust. Ledger Entry No." = field("Cust. Ledger Entry No."),
                                                           "Entry Type" = const(Application)));
        }
        field(50004; "Cash Payment"; Decimal)
        {
            CaptionML = ENU = 'Cash Payment', FRA = 'Règlement Espèces';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("Detailed Cust. Ledg. Entry"."Credit Amount (LCY)" where("Payment Slip Type" = Const(Cash),
                                                           "Cust. Ledger Entry No." = field("Cust. Ledger Entry No."),
                                                           "Entry Type" = const(Application)));
        }
        field(50005; "Transfer Payment"; Decimal)
        {
            CaptionML = ENU = 'Transfer Payment', FRA = 'Règlement Virement';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("Detailed Cust. Ledg. Entry"."Credit Amount (LCY)" where("Payment Slip Type" = Const(Transfer),
                                                           "Cust. Ledger Entry No." = field("Cust. Ledger Entry No."),
                                                           "Entry Type" = const(Application)));
        }
        field(50006; "RS Amount"; Decimal)
        {
            CaptionML = ENU = 'RS Amount', FRA = 'Montant RS';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("Detailed Cust. Ledg. Entry"."Credit Amount (LCY)" where("Payment Slip Type" = Const(RS),
                                                           "Cust. Ledger Entry No." = field("Cust. Ledger Entry No."),
                                                           "Entry Type" = const(Application)));
        }

        field(50007; "Cr. Memo Amount"; Decimal)
        {
            CaptionML = ENU = 'Cr. Memo Amount', FRA = 'Montant Avoir';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("Detailed Cust. Ledg. Entry"."Credit Amount (LCY)" where("Document Type" = Filter(Invoice | "Credit Memo"),
                                                          "Cust. Ledger Entry No." = field("Cust. Ledger Entry No."),
                                                           "Entry Type" = const(Application)));
        }

        field(50008; "Invoice Amount Including Stamp"; Decimal)
        {
            CaptionML = ENU = 'Invoice Amount Including Stamp', FRA = 'Montant facture TTC';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" where("Entry Type" = const("Initial Entry"),
                                                           "Document Type" = const("Invoice"),
                                                           "Document No." = field("No.")));
        }

        field(50009; Canceled; Boolean)
        {
            Captionml = ENU = 'Canceled', FRA = 'Annulé';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50010; "Replacment Invoice No."; Code[20])
        {
            CaptionML = ENU = 'Replacment Invoice No.', FRA = 'N° facture remplaçante';
            DataClassification = ToBeClassified;
            Editable = false;
        }

    }
}
