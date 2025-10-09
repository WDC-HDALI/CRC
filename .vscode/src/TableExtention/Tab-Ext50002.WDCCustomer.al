namespace CRC.CRC;

using Microsoft.Sales.Customer;
using System.Security.User;
using Microsoft.Sales.Receivables;
using Microsoft.Sales.History;
using Microsoft.Sales.Document;

tableextension 50002 "WDC Customer" extends Customer
{


    fields
    {
        field(50000; Report; Decimal)
        {
            CaptionML = ENU = 'Report', FRA = 'Report';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" where("Customer No." = field("No."),
                                                                                "Posting Date" = field("Start Year Filter"),
                                                                                 "Currency Code" = field("Currency Filter")));
        }
        field(50001; Debit; Decimal)
        {
            CaptionML = ENU = 'Debit ', FRA = 'Débit';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("Detailed Cust. Ledg. Entry"."Debit Amount (LCY)" where("Customer No." = field("No."),
                                                                                 "Entry Type" = const("Initial Entry"),
                                                                                 "Debit Amount (LCY)" = filter('<>0'),
                                                                                 "Document Type" = filter(Invoice | "Credit Memo"),
                                                                                 "Currency Code" = field("Currency Filter")));
        }
        field(50002; Credit; Decimal)
        {
            CaptionML = ENU = 'Credit', FRA = 'Crédit';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("Detailed Cust. Ledg. Entry"."Credit Amount (LCY)" where("Customer No." = field("No."),
                                                                                  "Entry Type" = const("Initial Entry"),
                                                                                  "Credit Amount (LCY)" = filter('<>0'),
                                                                                  "Currency Code" = field("Currency Filter")));
        }

        field(54004; "Draft Not Due"; Decimal)
        {
            CaptionML = ENU = 'Draft Not Due', FRA = 'Traites non échus';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("Detailed Cust. Ledg. Entry"."Credit Amount" where("Payment Slip Type" = Const(Draft),
                                                           "Initial Entry Due Date" = field("Due Date Filter"),
                                                           "Customer No." = field("No."),
                                                           "Document Type" = filter(Payment),
                                                           "Entry Type" = const("Initial Entry")));
        }
        field(54005; "Unpaid in progress"; Decimal)
        {
            CaptionML = ENU = 'Unpaid in progress', FRA = 'Impayés en cours';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("Detailed Cust. Ledg. Entry"."Debit Amount" where("Payment Slip Type" = filter(Draft | Cheque),
                                                           //"Posting Date" = field("Date Filter"),
                                                           "Customer No." = field("No."),
                                                           "Entry Type" = const("Initial Entry"),
                                                           "Applied Cust. Ledger Entry No." = filter(0),
                                                           "Document Type" = const(" ")));
        }

        field(54006; "Historics Unpaid"; Decimal)
        {
            CaptionML = ENU = 'Historics Unpaid', FRA = 'Historiques Impayés';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("Detailed Cust. Ledg. Entry"."Debit Amount" where("Payment Slip Type" = filter(Draft | Cheque),
                                                           "Customer No." = field("No."),
                                                           "Entry Type" = const("Initial Entry"),
                                                           "Document Type" = const(" ")));
        }

        field(50007; "Open Debit"; Decimal)
        {
            CaptionML = ENU = 'Open Debit', FRA = 'Débit';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("Detailed Cust. Ledg. Entry"."Debit Amount (LCY)" where("Customer No." = field("No."),
                                                                                 "Entry Type" = const("Initial Entry"),
                                                                                 "Debit Amount (LCY)" = filter('<>0'),
                                                                                 "Applied Cust. Ledger Entry No." = filter(0),
                                                                                 "Currency Code" = field("Currency Filter")));
        }
        field(50008; "Open Credit"; Decimal)
        {
            CaptionML = ENU = 'Open Credit', FRA = 'Crédit';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("Detailed Cust. Ledg. Entry"."Credit Amount (LCY)" where("Customer No." = field("No."),
                                                                                  "Entry Type" = const("Initial Entry"),
                                                                                  "Credit Amount (LCY)" = filter('<>0'),
                                                                                  "Applied Cust. Ledger Entry No." = filter(0),
                                                                                  "Currency Code" = field("Currency Filter")));
        }

        field(50009; "Total Shipment"; Decimal)
        {
            CaptionML = ENU = 'Total Shipment', FRA = 'Total BL Not Invoiced';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("Sales Line"."Shipped Not Invoiced (LCY)" where("Sell-to Customer No." = field("No."),
                                                                                  "Shipped Not Invoiced (LCY)" = filter(<> 0)));
        }
        field(50010; "Start Year Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(50013; "Due Date Filter"; Date)
        {
            CaptionML = ENU = 'Due Date Filter', FRA = 'Filtre date d''échéance';
            FieldClass = FlowFilter;
        }


    }
    trigger OnInsert()
    begin
        rec.Blocked := rec.Blocked::All;
    end;
}

