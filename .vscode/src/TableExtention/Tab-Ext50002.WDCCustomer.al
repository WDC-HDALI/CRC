namespace CRC.CRC;

using Microsoft.Sales.Customer;
using System.Security.User;
using Microsoft.Sales.Receivables;
using Microsoft.Sales.History;
using Microsoft.Sales.Document;
//*************Documentation***************************
//wdc01  WDC.FS  23/12/2025: Existant Customer Name and VAT Registration No.  Couldn't be added.
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
                                                                                "Currency Code" = field("Currency Filter"),
                                                                                "Posting Date" = field("Start Year Filter")));
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
                                                                                 "Currency Code" = field("Currency Filter"),
                                                                                 "Posting Date" = field("Start Date Filter")));
        }
        field(50002; Credit; Decimal)
        {
            CaptionML = ENU = 'Credit', FRA = 'Crédit';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("Detailed Cust. Ledg. Entry"."Credit Amount (LCY)" where("Customer No." = field("No."),
                                                                                 "Entry Type" = const("Initial Entry"),
                                                                                  Unpaid = filter(false),
                                                                                  "Credit Amount (LCY)" = filter('<>0'),
                                                                                  "Currency Code" = field("Currency Filter"),
                                                                                  "Posting Date" = field("Start Date Filter")));
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
        // field(54005; "Unpaid in progress"; Decimal)
        // {
        //     CaptionML = ENU = 'Unpaid in progress', FRA = 'Impayés en cours';
        //     FieldClass = FlowField;
        //     Editable = false;
        //     CalcFormula = sum("Detailed Cust. Ledg. Entry"."Debit Amount" where("Payment Slip Type" = filter(Draft | Cheque),
        //                                                    //"Posting Date" = field("Date Filter"),
        //                                                    "Customer No." = field("No."),
        //                                                    "Entry Type" = const("Initial Entry"),
        //                                                    "Applied Cust. Ledger Entry No." = filter(0),
        //                                                    "Document Type" = const(" ")));
        // }

        // field(54006; "Historics Unpaid"; Decimal)
        // {
        //     CaptionML = ENU = 'Historics Unpaid', FRA = 'Historiques Impayés';
        //     FieldClass = FlowField;
        //     Editable = false;
        //     CalcFormula = sum("Detailed Cust. Ledg. Entry"."Debit Amount" where("Payment Slip Type" = filter(Draft | Cheque),
        //                                                    "Customer No." = field("No."),
        //                                                    "Entry Type" = const("Initial Entry"),
        //                                                    "Document Type" = const(" ")));
        // }


        field(54005; "Unpaid in progress"; Decimal)
        {
            CaptionML = ENU = 'Unpaid in progress', FRA = 'Impayés en cours';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("Detailed Cust. Ledg. Entry"."Credit Amount (LCY)" where("Payment Slip Type" = filter(Draft | Cheque),
                                                           "Customer No." = field("No."),
                                                           "Document Type" = filter(Payment),
                                                           "Entry Type" = const("Initial Entry"),
                                                            Unpaid = filter(true),
                                                           "Unpaid is Encaissed" = const(false)));
        }
        field(54006; "Historics Unpaid"; Decimal)
        {
            CaptionML = ENU = 'Historics Unpaid', FRA = 'Historiques Impayés';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("Detailed Cust. Ledg. Entry"."Credit Amount (LCY)" where("Payment Slip Type" = filter(Draft | Cheque),
                                                           "Customer No." = field("No."),
                                                           "Document Type" = filter(Payment),
                                                           "Entry Type" = const("Initial Entry"),
                                                           Unpaid = filter(true),
                                                           "Unpaid is Encaissed" = const(true)));
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
            CaptionML = ENU = 'Total Shipment', FRA = 'BL non facturés';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("Sales Line"."Shipped Not Invoiced (LCY)" where("Sell-to Customer No." = field("No."),
                                                                              "Shipped Not Invoiced (LCY)" = filter(<> 0),
                                                                              "Posting Date" = field("Start Date Filter")));//WDC.CHG 26/02/2026
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

        field(50014; "Last Payment Amount"; Decimal)
        {
            CaptionML = ENU = 'Last Payment Amount', FRA = 'Dernier paiement';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = max("Detailed Cust. Ledg. Entry"."Credit Amount (LCY)" where("Customer No." = field("No."),
                                                                                "Document Type" = filter("Payment"),
                                                                                "Entry Type" = filter("Initial Entry")));
        }
        field(50015; "Last Payment Date"; Date)
        {
            CaptionML = ENU = 'Last Payment Date', FRA = 'Date dernier paiement';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = max("Detailed Cust. Ledg. Entry"."Posting Date" where("Customer No." = field("No."),
                                                                                "Document Type" = filter("Payment"),
                                                                                "Entry Type" = filter("Initial Entry")));
        }
        //<<WDC.CHG 26/02/2026 
        field(50016; "Balance (LCY) Amount"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" where("Customer No." = field("No."),
                                                                                 "Initial Entry Global Dim. 1" = field("Global Dimension 1 Filter"),
                                                                                 "Initial Entry Global Dim. 2" = field("Global Dimension 2 Filter"),
                                                                                 "Currency Code" = field("Currency Filter"),
                                                                                 "Posting Date" = field("Start Date Filter")));//WDC.CHG 26/02/2026;
            Caption = 'Balance (LCY)amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50017; "Start Date Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(54018; "Unpaid Before GoLive"; Decimal)
        {
            CaptionML = ENU = 'Unpaid Before GoLive', FRA = 'Impayés avant démarrage système';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = SUM("Detailed Cust. Ledg. Entry"."Debit Amount (LCY)" where("Payment Slip Type" = filter(Draft | Cheque),
                                                           "Customer No." = field("No."),
                                                           "Entry Type" = const("Initial Entry"),
                                                            "Unpaid Before GoLive" = filter(true)));
        }
        field(50019; "Payment In Coffre"; Decimal)
        {
            CaptionML = ENU = 'Payments In Coffre', FRA = 'Paiments en coffre';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = SUM("WDC Payment In Coffre"."Payment Amount" where("Customer No." = field("No."),
                                                                              Status = const(Released)));
        }
        //>>WDC.CHG 26/02/2026

        // field(50014; "Due Date Filter for balance"; Date)
        // {
        //     CaptionML = ENU = 'Due Date Filter', FRA = 'Filtre date d''échéance';
        //     FieldClass = FlowFilter;
        // }

        // field(50015; "WDC Balance (LCY)"; Decimal)
        // {
        //     AutoFormatType = 1;
        //     CalcFormula = sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" where("Customer No." = field("No."),
        //                                                                          "Initial Entry Global Dim. 1" = field("Global Dimension 1 Filter"),
        //                                                                          "Initial Entry Global Dim. 2" = field("Global Dimension 2 Filter"),
        //                                                                          "Currency Code" = field("Currency Filter"),
        //                                                                          "Initial Entry Due Date" = FIELD("Due Date Filter for balance")
        //                                                                          ));
        //     CaptionML = ENU = 'Balance (LCY)', FRA = 'Solde DS';
        //     Editable = false;
        //     FieldClass = FlowField;
        //     ToolTip = 'Specifies the payment amount that the customer owes for completed sales. This value is also known as the customer''s balance.';
        // }
        //<<wdc01
        modify(Name)
        {
            trigger OnAfterValidate()
            var
                Customer: Record Customer;
                Text001: Label 'Un client avec le nom "%1" existe déjà (Client N° %2).';
            begin
                Customer.Reset();
                Customer.SetFilter("No.", '<>%1', Rec."No.");
                if Customer.FindFirst() then begin
                    repeat
                        IF UpperCase(Customer.Name) = UpperCase(Rec.Name) THEN
                            Error(Text001, Rec.Name, Customer."No.");
                    until Customer.next() = 0;
                end;
            end;
        }
        modify("VAT Registration No.")
        {
            trigger OnAfterValidate()
            var
                Customer: Record Customer;
                Text001: Label 'Un client avec N° identif. intracomm. "%1" existe déjà (Client N° %2).';
            begin
                Customer.Reset();
                Customer.SetFilter("No.", '<>%1', Rec."No.");
                if Customer.FindFirst() then begin
                    repeat
                        IF UpperCase(Customer."VAT Registration No.") = UpperCase(Rec."VAT Registration No.") THEN
                            Error(Text001, Rec."VAT Registration No.", Customer."No.");
                    until Customer.next() = 0;
                end;
            end;
        }
        //>>wdc01


    }


    trigger OnInsert()

    begin
        rec.Blocked := rec.Blocked::All;

    end;
}

