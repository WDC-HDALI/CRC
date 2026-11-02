namespace CRC.CRC;

using Microsoft.Purchases.Vendor;
using Microsoft.Purchases.Document;
using Microsoft.Purchases.Payables;
//******************Documentation***********************
//WDC01  WDC.HG  12/08/2025  Create current object : update vendor card to show historics and recpt not invoiced detailes
tableextension 50043 "WDC Vendor" extends Vendor
{
    fields
    {
        field(50000; VendorPayment; Decimal)
        {
            CaptionML = ENU = 'Payments', FRA = 'Paiements';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("Detailed Vendor Ledg. Entry"."Debit Amount (LCY)" where("Vendor No." = field("No."),
                                                                                 "Entry Type" = const("Initial Entry"),
                                                                                 "Debit Amount (LCY)" = filter(<> 0),
                                                                                 "Currency Code" = field("Currency Filter"),
                                                                                 "Posting Date" = field("Start Date Filter")));//WDC.CHG 26/02/2026
        }
        field(50001; VendorInvoice; Decimal)
        {
            CaptionML = ENU = 'Purchase Receipt invoiced', FRA = 'Réceptions Facturées';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("Detailed Vendor Ledg. Entry"."Debit Amount (LCY)" where("Vendor No." = field("No."),
                                                                                 "Entry Type" = const("Initial Entry"),
                                                                                 "Credit Amount (LCY)" = filter(<> 0),
                                                                                 "Currency Code" = field("Currency Filter"),
                                                                                 "Posting Date" = field("Start Date Filter")));//WDC.CHG 26/02/2026
        }
        field(50002; "Open Debit"; Decimal)
        {
            CaptionML = ENU = 'Open Debit', FRA = 'Débit';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("Detailed Vendor Ledg. Entry"."Debit Amount (LCY)" where("Vendor No." = field("No."),
                                                                                 "Entry Type" = const("Initial Entry"),
                                                                                 "Debit Amount (LCY)" = filter(<> 0),
                                                                                 "Applied Vend. Ledger Entry No." = filter(0),
                                                                                 "Currency Code" = field("Currency Filter")));
        }
        field(50003; "Open Credit"; Decimal)
        {
            CaptionML = ENU = 'Open Credit', FRA = 'Crédit';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("Detailed Vendor Ledg. Entry"."Credit Amount (LCY)" where("Vendor No." = field("No."),
                                                                                  "Entry Type" = const("Initial Entry"),
                                                                                  "Credit Amount (LCY)" = filter(<> 0),
                                                                                  "Applied Vend. Ledger Entry No." = filter(0),
                                                                                  "Currency Code" = field("Currency Filter")));
        }

        field(50004; "Total Receipt"; Decimal)
        {
            CaptionML = ENU = 'Total Receipt Not Invoiced', FRA = 'Total RCA non Facturées';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("Purchase Line"."Amt. Rcd. Not Invoiced (LCY)" where("Buy-from Vendor No." = field("No."),
                                                                                  "Amt. Rcd. Not Invoiced (LCY)" = filter(<> 0),
                                                                                  "Order Date" = field("Start Date Filter")));//WDC.CHG 26/02/2026
        }
        field(50005; "Start Year Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(50006; "Due Date Filter"; Date)
        {
            CaptionML = ENU = 'Due Date Filter', FRA = 'Filtre date d''échéance';
            FieldClass = FlowFilter;
        }
        field(50007; Report; Decimal)
        {
            CaptionML = ENU = 'Report', FRA = 'Report';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" where("Vendor No." = field("No."),
                                                                                "Posting Date" = field("Start Year Filter"),
                                                                                 "Currency Code" = field("Currency Filter")));
        }
        field(50008; "Draft Not Due"; Decimal)
        {
            CaptionML = ENU = 'Draft Not Due', FRA = 'Traites non échus';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("Detailed Vendor Ledg. Entry"."Debit Amount (LCY)" where("Payment Slip Type" = Const(Draft),
                                                           "Initial Entry Due Date" = field("Due Date Filter"),
                                                           "Vendor No." = field("No."),
                                                           "Document Type" = filter(Payment),
                                                           "Entry Type" = const("Initial Entry"),
                                                            "Posting Date" = field("Start Date Filter")));//WDC.CHG 26/02/2026
        }
        //<<WDC.CHG 26/02/2026 

        field(50009; "Start Date Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(50010; "Balance (LCY) Amount"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = - sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" where("Vendor No." = field("No."),
                                                                                   "Initial Entry Global Dim. 1" = field("Global Dimension 1 Filter"),
                                                                                   "Initial Entry Global Dim. 2" = field("Global Dimension 2 Filter"),
                                                                                   "Currency Code" = field("Currency Filter"),
                                                                                   "Posting Date" = field("Start Date Filter")));//WDC.CHG 26/02/2026
            Caption = 'Balance (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        //>>WDC.CHG 26/02/2026 

    }
}
