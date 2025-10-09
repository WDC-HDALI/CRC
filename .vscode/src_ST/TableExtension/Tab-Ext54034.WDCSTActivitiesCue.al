namespace CRC.CRC;

using Microsoft.Sales.RoleCenters;
using Microsoft.RoleCenters;
using Microsoft.Sales.Receivables;
using Microsoft.Sales.History;
using Microsoft.Purchases.Payables;
using Microsoft.Finance.GeneralLedger.Ledger;

tableextension 54034 "WDC-ST Activities Cue" extends "Activities Cue"
{
    fields
    {
        field(54000; "Purchase Cheque"; Decimal)
        {
            CaptionML = ENU = 'Purchase Cheque', FRA = 'Chèque achats';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("Detailed Vendor Ledg. Entry"."Debit Amount (LCY)" where("Payment Slip Type" = Const(Cheque),
                                                           "Posting Date" = field("Date Filter"),
                                                           "Entry Type" = const("Initial Entry")));
        }
        field(54001; "Purchase Draft"; Decimal)
        {
            CaptionML = ENU = 'Purchase Draft', FRA = 'Traite achats';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("Detailed Vendor Ledg. Entry"."Debit Amount (LCY)" where("Payment Slip Type" = Const(Draft),
                                                           "Posting Date" = field("Date Filter"),
                                                           "Entry Type" = const("Initial Entry")));
        }
        field(54002; "Purchase Cash"; Decimal)
        {
            CaptionML = ENU = 'Purchase Cash', FRA = 'Espèces achats';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("Detailed Vendor Ledg. Entry"."Debit Amount (LCY)" where("Payment Slip Type" = Const(Cash),
                                                           "Posting Date" = field("Date Filter"),
                                                           "Entry Type" = const("Initial Entry")));
        }
        field(54003; "Purchase Transfer"; Decimal)
        {
            CaptionML = ENU = 'Purchase Transfer', FRA = 'Virement achats';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("Detailed Vendor Ledg. Entry"."Debit Amount (LCY)" where("Payment Slip Type" = Const(Transfer),
                                                           "Posting Date" = field("Date Filter"),
                                                           "Entry Type" = const("Initial Entry")));
        }
        field(54004; "Sales Cheque"; Decimal)
        {
            CaptionML = ENU = 'Sales Cheque', FRA = 'Chèque ventes';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("Detailed Cust. Ledg. Entry"."Credit Amount (LCY)" where("Payment Slip Type" = Const(Cheque),
                                                           "Posting Date" = field("Date Filter"),
                                                           "Entry Type" = const("Initial Entry")));
        }
        field(54005; "Sales Draft"; Decimal)
        {
            CaptionML = ENU = 'Sales Draft', FRA = 'Traite ventes';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("Detailed Cust. Ledg. Entry"."Credit Amount (LCY)" where("Payment Slip Type" = Const(Draft),
                                                           "Posting Date" = field("Date Filter"),
                                                           "Entry Type" = const("Initial Entry")));
        }
        field(54006; "Sales Cash"; Decimal)
        {
            CaptionML = ENU = 'Sales Cash', FRA = 'Espèces ventes';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("Detailed Cust. Ledg. Entry"."Credit Amount (LCY)" where("Payment Slip Type" = Const(Cash),
                                                           "Posting Date" = field("Date Filter"),
                                                           "Entry Type" = const("Initial Entry")));
        }
        field(54007; "Sales Transfer"; Decimal)
        {
            CaptionML = ENU = 'Sales Transfer', FRA = 'Virement ventes';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("Detailed Cust. Ledg. Entry"."Credit Amount (LCY)" where("Payment Slip Type" = Const(Transfer),
                                                           "Posting Date" = field("Date Filter"),
                                                           "Entry Type" = const("Initial Entry")));
        }
        field(54008; "Sales RS"; Decimal)
        {
            CaptionML = ENU = 'Sales RS', FRA = 'RS ventes';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("Detailed Cust. Ledg. Entry"."Credit Amount (LCY)" where("Payment Slip Type" = Const(RS),
                                                           "Posting Date" = field("Date Filter"),
                                                           "Entry Type" = const("Initial Entry")));
        }
        field(54009; "Sales Invoice"; Decimal)
        {
            CaptionML = ENU = 'Sales Invoice', FRA = 'Factures ventes';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("Detailed Cust. Ledg. Entry"."Debit Amount (LCY)" where("Document Type" = Const("Invoice"),
                                                           "Posting Date" = field("Date Filter"),
                                                           "Entry Type" = const("Initial Entry")));
        }
        field(54010; "Sales Cr. Memo"; Decimal)
        {
            CaptionML = ENU = 'Sales Cr. Memo', FRA = 'Avoirs ventes';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("Detailed Cust. Ledg. Entry"."Credit Amount (LCY)" where("Document Type" = Const("Credit Memo"),
                                                           "Posting Date" = field("Date Filter"),
                                                           "Entry Type" = const("Initial Entry")));
        }
        field(54011; "Invoice Long Terme"; Decimal)
        {
            CaptionML = ENU = 'Invoice Long Terme', FRA = 'Factures à terme';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("Detailed Cust. Ledg. Entry"."Debit Amount (LCY)" where("Payment Terms Code" = Filter('<>COMPTANT'),
                                                           "Document Type" = Const("Invoice"),
                                                           "Posting Date" = field("Date Filter"),
                                                           "Entry Type" = const("Initial Entry")));
        }
        field(54012; "Invoice Cash"; Decimal)
        {
            CaptionML = ENU = 'Invoice Cash', FRA = 'Factures comptant';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("Detailed Cust. Ledg. Entry"."Debit Amount (LCY)" where("Payment Terms Code" = Filter('COMPTANT'),
                                                          "Document Type" = Const("Invoice"),
                                                           "Posting Date" = field("Date Filter"),
                                                           "Entry Type" = const("Initial Entry")));
        }
        field(54013; "Cr. Memo Long Terme"; Decimal)
        {
            CaptionML = ENU = 'Cr. Memo Long Terme', FRA = 'Avoirs à terme';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("Detailed Cust. Ledg. Entry"."Credit Amount (LCY)" where("Payment Terms Code" = Filter('<>COMPTANT'),
                                                           "Document Type" = Const("Credit Memo"),
                                                           "Posting Date" = field("Date Filter"),
                                                           "Entry Type" = const("Initial Entry")));
        }
        field(54014; "Cr. Memo Cash"; Decimal)
        {
            CaptionML = ENU = 'Cr. Memo Cash', FRA = 'Avoirs comptants';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("Detailed Cust. Ledg. Entry"."Credit Amount (LCY)" where("Payment Terms Code" = Filter('COMPTANT'),
                                                          "Document Type" = Const("Credit Memo"),
                                                           "Posting Date" = field("Date Filter"),
                                                           "Entry Type" = const("Initial Entry")));
        }
        field(54015; "Date Filter"; Date)
        {
            CaptionML = ENU = 'Date Filter', FRA = 'Filtre date';
            FieldClass = FlowFilter;
        }
        field(54016; "Total Payment"; Decimal)
        {
            CaptionML = ENU = 'Total Payment', FRA = 'Total paiements';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("Detailed Cust. Ledg. Entry"."Credit Amount (LCY)" where("Payment Slip Type" = filter(<> " "),
                                                           "Posting Date" = field("Date Filter"),
                                                           "Entry Type" = const("Initial Entry")));
        }

        field(50017; "Sales Inv. Due Next Week"; Integer)
        {
            CalcFormula = count("Cust. Ledger Entry" where("Document Type" = filter(Invoice),
                                                            "Due Date" = field("Due Next Week Filter"),
                                                            Open = const(true)));
            CaptionML = ENU = 'Sales Invoices Due Next Week', FRA = 'Factures dues la semaine prochaine';
            Editable = false;
            FieldClass = FlowField;
        }
        //<<*****************unpaid***********
        field(54018; "Unpaid Draft"; Decimal)
        {
            CaptionML = ENU = 'Unpaid Draft', FRA = 'Traites impayés';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("Detailed Cust. Ledg. Entry"."Debit Amount (LCY)" where("Payment Slip Type" = Const(Draft),
                                                           "Posting Date" = field("Date Filter"),
                                                           "Entry Type" = const("Initial Entry"),
                                                           "Document Type" = const(" ")));
        }
        field(54019; "Unpaid Cheque"; Decimal)
        {
            CaptionML = ENU = 'Unpaid Cheque', FRA = 'Chèques impayés';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("Detailed Cust. Ledg. Entry"."Debit Amount (LCY)" where("Payment Slip Type" = Const(Cheque),
                                                           "Posting Date" = field("Date Filter"),
                                                           "Entry Type" = const("Initial Entry"),
                                                           "Document Type" = const(" ")));
        }

        // ********************************<<Payment comptant*************************************************
        field(54020; "Cash Sales Cheque"; Decimal)
        {
            CaptionML = ENU = 'Cash Sales Cheque', FRA = 'Chèques ventes comptants';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("Detailed Cust. Ledg. Entry"."Credit Amount (LCY)" where("Payment Slip Type" = Const(Cheque),
                                                           "Posting Date" = field("Date Filter"),
                                                           "Payment Terms Code" = filter('COMPTANT'),
                                                           "Journal Batch Name" = filter('REGLEMENT'),
                                                           "Entry Type" = const("Initial Entry")));
        }
        field(54021; "Cash Sales Draft"; Decimal)
        {
            CaptionML = ENU = 'Cash Sales Draft', FRA = 'Traites ventes comptants';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("Detailed Cust. Ledg. Entry"."Credit Amount (LCY)" where("Payment Slip Type" = Const(Draft),
                                                           "Posting Date" = field("Date Filter"),
                                                           "Payment Terms Code" = filter('COMPTANT'),
                                                           "Journal Batch Name" = filter('REGLEMENT'),
                                                           "Entry Type" = const("Initial Entry")));
        }
        field(54022; "Cash Sales Cash"; Decimal)
        {
            CaptionML = ENU = 'Cash Sales Cash', FRA = 'Espèces ventes comptant';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("Detailed Cust. Ledg. Entry"."Credit Amount (LCY)" where("Payment Slip Type" = Const(Cash),
                                                           "Posting Date" = field("Date Filter"),
                                                           "Payment Terms Code" = filter('COMPTANT'),
                                                           "Journal Batch Name" = filter('REGLEMENT'),
                                                           "Entry Type" = const("Initial Entry")));
        }
        field(54023; "Cash Sales Transfer"; Decimal)
        {
            CaptionML = ENU = 'Cash Sales Transfer', FRA = 'Virements ventes comptants';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("Detailed Cust. Ledg. Entry"."Credit Amount (LCY)" where("Payment Slip Type" = Const(Transfer),
                                                           "Posting Date" = field("Date Filter"),
                                                           "Payment Terms Code" = filter('COMPTANT'),
                                                            "Journal Batch Name" = filter('REGLEMENT'),
                                                           "Entry Type" = const("Initial Entry")));
        }
        field(54024; "Cash Sales RS"; Decimal)
        {
            CaptionML = ENU = 'Cash Sales RS', FRA = 'RS ventes comptants';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("Detailed Cust. Ledg. Entry"."Credit Amount (LCY)" where("Payment Slip Type" = Const(RS),
                                                           "Posting Date" = field("Date Filter"),
                                                           "Payment Terms Code" = filter('COMPTANT'),
                                                           "Entry Type" = const("Initial Entry")));
        }

        field(54025; "Cash Payment Cr Memo"; Decimal)
        {
            CaptionML = ENU = 'Cash Payment Cr Memo', FRA = 'Payments par avoir comptants';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("Detailed Cust. Ledg. Entry"."Credit Amount (LCY)" where("Document Type" = Const(Invoice),
                                                           "Posting Date" = field("Date Filter"),
                                                           "Customer No." = filter('9999'),
                                                           "Credit Amount (LCY)" = filter(<> 0),
                                                           "Entry Type" = const(Application)));
        }
        field(54026; "Cash Total Payment"; Decimal)
        {
            CaptionML = ENU = 'Cash Total Payment', FRA = 'Total paiements comptants';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("Detailed Cust. Ledg. Entry"."Credit Amount (LCY)" where("Payment Slip Type" = filter(<> " "),
                                                           "Posting Date" = field("Date Filter"),
                                                           "Payment Terms Code" = filter('COMPTANT'),
                                                           "Journal Batch Name" = filter('REGLEMENT'),
                                                           "Entry Type" = const("Initial Entry")));
        }
        //------------------------------>>Payment comptant--------------------------------------------
        field(54028; "Term Payment Cheque"; Decimal)
        {
            CaptionML = ENU = 'Term Payment Cheque', FRA = 'Chèque ventes à terme';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("Detailed Cust. Ledg. Entry"."Credit Amount (LCY)" where("Payment Slip Type" = Const(Cheque),
                                                           "Posting Date" = field("Date Filter"),
                                                           "Payment Terms Code" = filter('<>COMPTANT'),
                                                           "Entry Type" = const("Initial Entry")));
        }
        field(54029; "Term Payment Draft"; Decimal)
        {
            CaptionML = ENU = 'Term Payment Draft', FRA = 'Traite ventes à terme';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("Detailed Cust. Ledg. Entry"."Credit Amount (LCY)" where("Payment Slip Type" = Const(Draft),
                                                           "Posting Date" = field("Date Filter"),
                                                           "Payment Terms Code" = filter('<>COMPTANT'),
                                                           "Entry Type" = const("Initial Entry")));
        }
        field(54030; "Term Payment Cash"; Decimal)
        {
            CaptionML = ENU = 'Term Payment Cash', FRA = 'Espèces ventes à terme';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("Detailed Cust. Ledg. Entry"."Credit Amount (LCY)" where("Payment Slip Type" = Const(Cash),
                                                           "Posting Date" = field("Date Filter"),
                                                           "Payment Terms Code" = filter('<>COMPTANT'),
                                                           "Entry Type" = const("Initial Entry")));
        }
        field(54031; "Term Payment Transfer"; Decimal)
        {
            CaptionML = ENU = 'Term Payment Transfer', FRA = 'Virements ventes à terme';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("Detailed Cust. Ledg. Entry"."Credit Amount (LCY)" where("Payment Slip Type" = Const(Transfer),
                                                           "Posting Date" = field("Date Filter"),
                                                           "Payment Terms Code" = filter('<>COMPTANT'),
                                                           "Entry Type" = const("Initial Entry")));
        }
        field(54032; "Term Payment RS"; Decimal)
        {
            CaptionML = ENU = 'Term Payment RS', FRA = 'RS ventes à terme';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("Detailed Cust. Ledg. Entry"."Credit Amount (LCY)" where("Payment Slip Type" = Const(RS),
                                                           "Posting Date" = field("Date Filter"),
                                                           "Payment Terms Code" = filter('<>COMPTANT'),
                                                           "Entry Type" = Const("Initial Entry")));
        }
        field(54033; "Term Payment Cr Memo"; Decimal)
        {
            CaptionML = ENU = 'Term Payment Cr Memo', FRA = 'Payments par avoir à terme';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("Detailed Cust. Ledg. Entry"."Credit Amount (LCY)" where("Document Type" = Const(Invoice),
                                                           "Posting Date" = field("Date Filter"),
                                                           "Customer No." = filter('<>9999'),
                                                           "Credit Amount (LCY)" = filter(<> 0),
                                                           "Entry Type" = const(Application)));
        }
        field(54034; "Term Total Payment"; Decimal)
        {
            CaptionML = ENU = 'Term Total Payments', FRA = 'Total paiements à terme';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("Detailed Cust. Ledg. Entry"."Credit Amount (LCY)" where("Payment Slip Type" = filter(<> " "),
                                                           "Posting Date" = field("Date Filter"),
                                                           "Payment Terms Code" = filter('<>COMPTANT'),
                                                           // "Journal Batch Name" = filter('<>REGLEMENT'),
                                                           "Entry Type" = const("Initial Entry")));
        }

        //*****************Avance client comptant ************
        field(54040; "Cash Advance Cheque"; Decimal)
        {
            CaptionML = ENU = 'Cash Advance Cheque', FRA = 'Chèques Avance comptants';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("Detailed Cust. Ledg. Entry"."Credit Amount (LCY)" where("Payment Slip Type" = Const(Cheque),
                                                           "Posting Date" = field("Date Filter"),
                                                           "Payment Terms Code" = filter('COMPTANT'),
                                                           "Journal Batch Name" = filter('<>REGLEMENT'),
                                                           "Entry Type" = const("Initial Entry")));
        }
        field(54041; "Cash Advance Draft"; Decimal)
        {
            CaptionML = ENU = 'Cash Advance Draft', FRA = 'Traites avance comptants';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("Detailed Cust. Ledg. Entry"."Credit Amount (LCY)" where("Payment Slip Type" = Const(Draft),
                                                           "Posting Date" = field("Date Filter"),
                                                           "Payment Terms Code" = filter('COMPTANT'),
                                                           "Journal Batch Name" = filter('<>REGLEMENT'),
                                                           "Entry Type" = const("Initial Entry")));
        }
        field(54042; "Cash Advance Cash"; Decimal)
        {
            CaptionML = ENU = 'Cash Advance Cash', FRA = 'Espèces avance comptant';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("Detailed Cust. Ledg. Entry"."Credit Amount (LCY)" where("Payment Slip Type" = Const(Cash),
                                                           "Posting Date" = field("Date Filter"),
                                                           "Payment Terms Code" = filter('COMPTANT'),
                                                           "Journal Batch Name" = filter('<>REGLEMENT'),
                                                           "Entry Type" = const("Initial Entry")));
        }
        field(54043; "Cash Advance Transfer"; Decimal)
        {
            CaptionML = ENU = 'Cash Advance Transfer', FRA = 'Virements avance comptants';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("Detailed Cust. Ledg. Entry"."Credit Amount (LCY)" where("Payment Slip Type" = Const(Transfer),
                                                           "Posting Date" = field("Date Filter"),
                                                           "Payment Terms Code" = filter('COMPTANT'),
                                                           "Journal Batch Name" = filter('<>REGLEMENT'),
                                                           "Entry Type" = const("Initial Entry")));
        }
        field(54044; "Cash Advance RS"; Decimal)
        {
            CaptionML = ENU = 'Cash Advance RS', FRA = 'RS avance comptant';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("Detailed Cust. Ledg. Entry"."Credit Amount (LCY)" where("Payment Slip Type" = Const(RS),
                                                           "Posting Date" = field("Date Filter"),
                                                           "Payment Terms Code" = filter('COMPTANT'),
                                                           "Journal Batch Name" = filter('<>REGLEMENT'),
                                                           "Entry Type" = const("Initial Entry")));
        }


        field(54045; "Cash Total Advance"; Decimal)
        {
            CaptionML = ENU = 'Cash Total Advance', FRA = 'Total avances comptants';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("Detailed Cust. Ledg. Entry"."Credit Amount (LCY)" where("Payment Slip Type" = filter(<> " "),
                                                           "Posting Date" = field("Date Filter"),
                                                           "Payment Terms Code" = filter('COMPTANT'),
                                                           "Journal Batch Name" = filter('<>REGLEMENT'),
                                                           "Entry Type" = const("Initial Entry")));
        }
        //--------------------------------------------------------------------------

        // //*****************Avance client à Terme ************
        // field(54050; "Term Advance Cheque"; Decimal)
        // {
        //     CaptionML = ENU = 'Term Advance Cheque', FRA = 'Chèques avance à terme';
        //     FieldClass = FlowField;
        //     Editable = false;
        //     CalcFormula = sum("Detailed Cust. Ledg. Entry"."Credit Amount (LCY)" where("Payment Slip Type" = Const(Cheque),
        //                                                    "Posting Date" = field("Date Filter"),
        //                                                    "Payment Terms Code" = filter('<>COMPTANT'),
        //                                                    "Journal Batch Name" = filter('<>REGLEMENT'),
        //                                                    "Entry Type" = const("Initial Entry")));
        // }
        // field(54051; "Term Advance Draft"; Decimal)
        // {
        //     CaptionML = ENU = 'Term Advance Draft', FRA = 'Traites avance à terme';
        //     FieldClass = FlowField;
        //     Editable = false;
        //     CalcFormula = sum("Detailed Cust. Ledg. Entry"."Credit Amount (LCY)" where("Payment Slip Type" = Const(Draft),
        //                                                    "Posting Date" = field("Date Filter"),
        //                                                    "Payment Terms Code" = filter('<>COMPTANT'),
        //                                                    "Journal Batch Name" = filter('<>REGLEMENT'),
        //                                                    "Entry Type" = const("Initial Entry")));
        // }
        // field(54052; "Term Advance Cash"; Decimal)
        // {
        //     CaptionML = ENU = 'Term Advance Cash', FRA = 'Espèces avance à terme';
        //     FieldClass = FlowField;
        //     Editable = false;
        //     CalcFormula = sum("Detailed Cust. Ledg. Entry"."Credit Amount (LCY)" where("Payment Slip Type" = Const(Cash),
        //                                                    "Posting Date" = field("Date Filter"),
        //                                                    "Payment Terms Code" = filter('<>COMPTANT'),
        //                                                    "Journal Batch Name" = filter('<>REGLEMENT'),
        //                                                    "Entry Type" = const("Initial Entry")));
        // }
        // field(54053; "Term Advance Transfer"; Decimal)
        // {
        //     CaptionML = ENU = 'Term Advance Transfer', FRA = 'Virements avance à terme';
        //     FieldClass = FlowField;
        //     Editable = false;
        //     CalcFormula = sum("Detailed Cust. Ledg. Entry"."Credit Amount (LCY)" where("Payment Slip Type" = Const(Transfer),
        //                                                    "Posting Date" = field("Date Filter"),
        //                                                    "Payment Terms Code" = filter('<>COMPTANT'),
        //                                                    "Journal Batch Name" = filter('<>REGLEMENT'),
        //                                                    "Entry Type" = const("Initial Entry")));
        // }
        // field(54054; "Term Advance RS"; Decimal)
        // {
        //     CaptionML = ENU = 'Term Advance RS', FRA = 'RS avance à terme';
        //     FieldClass = FlowField;
        //     Editable = false;
        //     CalcFormula = sum("Detailed Cust. Ledg. Entry"."Credit Amount (LCY)" where("Payment Slip Type" = Const(RS),
        //                                                    "Posting Date" = field("Date Filter"),
        //                                                    "Payment Terms Code" = filter('<>COMPTANT'),
        //                                                    "Journal Batch Name" = filter('<>REGLEMENT'),
        //                                                    "Entry Type" = const("Initial Entry")));
        // }


        // field(54055; "Term Total Advance"; Decimal)
        // {
        //     CaptionML = ENU = 'Term Total Advance', FRA = 'Total avances à terme';
        //     FieldClass = FlowField;
        //     Editable = false;
        //     CalcFormula = sum("Detailed Cust. Ledg. Entry"."Credit Amount (LCY)" where("Payment Slip Type" = filter(<> " "),
        //                                                    "Posting Date" = field("Date Filter"),
        //                                                    "Payment Terms Code" = filter('<>COMPTANT'),
        //                                                    "Journal Batch Name" = filter('<>REGLEMENT'),
        //                                                    "Entry Type" = const("Initial Entry")));
        // }
        // //--------------------------------------------------------------------------

        field(54060; "Month Cash Invoices"; Decimal)
        {
            CaptionML = ENU = 'Month Cash Invoices', FRA = 'Factures comptants du mois';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("Detailed Cust. Ledg. Entry"."Debit Amount (LCY)" where("Payment Terms Code" = Filter('COMPTANT'),
                                                          "Document Type" = Const("Invoice"),
                                                           "Posting Date" = field("Month Filter"),
                                                           "Entry Type" = const("Initial Entry")));
        }
        field(54061; "Month Term Invoices"; Decimal)
        {
            CaptionML = ENU = 'Month Term Invoices', FRA = 'Factures à terme du mois';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("Detailed Cust. Ledg. Entry"."Debit Amount (LCY)" where("Payment Terms Code" = Filter('<>COMPTANT'),
                                                          "Document Type" = Const("Invoice"),
                                                           "Posting Date" = field("Month Filter"),
                                                           "Entry Type" = const("Initial Entry")));
        }

        field(54065; "Month Filter"; Date)
        {
            CaptionML = ENU = 'Month Filter', FRA = 'Filtre du mois';
            FieldClass = FlowFilter;
        }
    }
    var
        sales: page 1310;
}
