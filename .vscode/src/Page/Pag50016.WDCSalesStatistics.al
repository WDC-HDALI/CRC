namespace CRC.CRC;

using Microsoft.RoleCenters;
using Microsoft.Sales.Receivables;
using Microsoft.Foundation.Period;

page 50016 "WDC Sales Statistics"
{
    ApplicationArea = All;
    PageType = CardPart;
    SourceTable = "Activities Cue";
    CaptionML = ENU = 'Sales Statistics', FRA = 'Statistiques vente';
    layout
    {

        area(Content)
        {
            group(Statistics)
            {
                ShowCaption = false;

                CaptionML = ENU = 'Cash', FRA = 'Comptant';
                field("Sales Cash"; Rec."Sales Cash")
                {
                    CaptionML = ENU = 'Cash Sales of the Day', FRA = 'Espèces du jour';
                    ApplicationArea = All;
                }
                field("Sales Cheque"; Rec."Sales Cheque")
                {
                    CaptionML = ENU = 'Cheque Sales of the Day', FRA = 'Chèque du jour';
                    ApplicationArea = All;
                }
                field("Sales Draft"; Rec."Sales Draft")
                {
                    CaptionML = ENU = 'Draft Sales of the Day', FRA = 'Traite du jour';
                    ApplicationArea = All;
                }
                field("Sales Transfer"; Rec."Sales Transfer")
                {
                    CaptionML = ENU = 'Transfer Sales of the Day', FRA = 'Virement du jour';
                    ApplicationArea = All;
                }
                field("Sales RS"; Rec."Sales RS")
                {
                    CaptionML = ENU = 'RS Sales of the Day', FRA = 'RS du jour';
                    ApplicationArea = All;

                }

                field("Cr. Memo Cash"; Rec."Cr. Memo Cash")
                {
                    CaptionML = ENU = 'Cash Credit Memos of the Day', FRA = 'Avoirs comptant du jour';
                    ApplicationArea = All;
                }
                field("Total Payment"; Rec."Total Payment")
                {
                    CaptionML = ENU = 'Total Payment of the Day', FRA = 'Total paiement du jour';
                    ApplicationArea = All;
                }
                field("Invoice Cash"; Rec."Invoice Cash")
                {
                    CaptionML = ENU = 'Cash Invoices of the Day', FRA = 'Factures comptant du jour';
                    ApplicationArea = All;
                }

                field("Invoice Long Terme"; Rec."Invoice Long Terme")
                {
                    CaptionML = ENU = 'Long Term Invoices of the Day', FRA = 'Factures à terme du jour';
                    ApplicationArea = All;
                }

                field("Cr. Memo Long Terme"; Rec."Cr. Memo Long Terme")
                {
                    CaptionML = ENU = 'Long Term Credit Memos of the Day', FRA = 'Avoirs à terme du jour';
                    ApplicationArea = All;
                }
                field("Sales This Month"; Rec."Sales This Month")
                {
                    ApplicationArea = All;
                    Editable = false;
                    trigger OnDrillDown()
                    begin
                        //ActivitiesMgt.DrillDownSalesThisMonth();
                        WDC_FilterDrillDownSalesThisMonth;
                    end;
                }
                field("Overdue Sales Invoice Amount"; Rec."Overdue Sales Invoice Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                    trigger OnDrillDown()
                    begin
                        //ActivitiesMgt.SetFilterOverdueSalesInvoice(CustLedgerEntryOverdueInv, false);
                        ActivitiesMgt.DrillDownCalcOverdueSalesInvoiceAmount();
                        //WDC_FilterDrillDownSalesThisMonth;
                    end;
                }
                field("Sales Inv. Due Next Week"; Rec."Sales Inv. Due Next Week")
                {
                    ApplicationArea = All;
                    trigger OnDrillDown()
                    begin
                        // ActivitiesMgt.SetFilterForCalcSalesThisMonthAmount();(CustLedgerEntrySalesMonth,false);
                        WDC_SetFilterForCalcOverdueInvoiceAmount();
                    end;
                }

            }
        }

    }
    procedure WDC_SetFilterForCalcOverdueInvoiceAmount()
    var
        lCustLedgEntrie: Page "Customer Ledger Entries";
    begin
        CustLedgerEntryOverdueInv.Setrange("Document Type", CustLedgerEntryOverdueInv."Document Type"::Invoice);
        CustLedgerEntryOverdueInv.SetRange(Open, true);
        CustLedgerEntryOverdueInv.SetFilter("Due Date", '..%1', CalcDate('<+1W>', WorkDate));
        if CustLedgerEntryOverdueInv.FindFirst() then begin
            lCustLedgEntrie.SetTableView(CustLedgerEntryOverdueInv);
            lCustLedgEntrie.RunModal();
        end;
    end;

    procedure WDC_FilterDrillDownSalesThisMonth()
    var
        lCustLedgEntrie: Page "Customer Ledger Entries";
        AccountingPeriod: Record "Accounting Period";
        StartOfMonth: Date;
        EndOfMonth: Date;
    begin

        StartOfMonth := DMY2Date(1, Date2DMY(WorkDate, 2), Date2DMY(WorkDate, 3));
        EndOfMonth := CALCDATE('<CM>', StartOfMonth);

        CustLedgerEntrySalesMonth.reset;
        CustLedgerEntrySalesMonth.SetCurrentKey("Posting Date", "Document Type");
        CustLedgerEntrySalesMonth.SetFilter("Document Type", '%1|%2',
          CustLedgerEntrySalesMonth."Document Type"::Invoice, CustLedgerEntrySalesMonth."Document Type"::"Credit Memo");
        CustLedgerEntrySalesMonth.SetRange("Posting Date", StartOfMonth, EndOfMonth);
        //CustLedgerEntrySalesMonth.SetRange("Open", true);
        if CustLedgerEntrySalesMonth.FindFirst() then begin
            lCustLedgEntrie.SetTableView(CustLedgerEntrySalesMonth);
            lCustLedgEntrie.RunModal();
        end;
    end;

    procedure SalesThisMonth() TotalAmount: Decimal
    var
        AccountingPeriod: Record "Accounting Period";
        [SecurityFiltering(SecurityFilter::Filtered)]
        CustLedgEntrySales: Query "Cust. Ledg. Entry Sales";
        StartOfMonth: Date;
        EndOfMonth: Date;
    begin
        TotalAmount := 0;
        StartOfMonth := DMY2Date(1, Date2DMY(WorkDate, 2), Date2DMY(WorkDate, 3));
        EndOfMonth := CALCDATE('<CM>', StartOfMonth);

        CustLedgerEntrySalesMonth.reset;
        CustLedgerEntrySalesMonth.SetCurrentKey("Posting Date", "Document Type");
        CustLedgerEntrySalesMonth.SetFilter("Document Type", '%1|%2',
          CustLedgerEntrySalesMonth."Document Type"::Invoice, CustLedgerEntrySalesMonth."Document Type"::"Credit Memo");
        CustLedgerEntrySalesMonth.SetRange("Posting Date", StartOfMonth, EndOfMonth);
        if CustLedgerEntrySalesMonth.FindFirst() then
            repeat
                CustLedgerEntrySalesMonth.CalcFields("Amount (LCY)");
                TotalAmount += CustLedgerEntrySalesMonth."Amount (LCY)";
            until CustLedgerEntrySalesMonth.Next() = 0;
    end;

    trigger OnOpenPage()
    begin
        Rec.SetFilter("Due Next Week Filter", '..%1', CalcDate('<+1W>', WorkDate));
        Rec.SetFilter("Due Date Filter", '%1', WorkDate);
        Rec.SetFilter("Date Filter", '%1..%2', StartDateFilter, EndDateFilter);
        Rec.CalcFields("Sales Cash", "Sales Cheque", "Sales Draft", "Sales Transfer", "Sales RS", "Total Payment");
        Rec.CalcFields("Sales Inv. Due Next Week");
        Rec.CalcFields("Sales Invoice", "Cr. Memo Cash", "Cr. Memo Long Terme", "Invoice Cash", "Invoice Long Terme");

    end;

    trigger OnAfterGetRecord()
    begin
        Rec.SetFilter("Due Next Week Filter", '..%1', CalcDate('<+1W>', WorkDate));
        Rec.SetFilter("Due Date Filter", '%1', WorkDate);
        Rec.SetFilter("Date Filter", '%1..%2', StartDateFilter, EndDateFilter);
        Rec.CalcFields("Sales Cash", "Sales Cheque", "Sales Draft", "Sales Transfer", "Sales RS", "Total Payment");
        Rec.CalcFields("Sales Inv. Due Next Week");
        Rec.CalcFields("Sales Invoice", "Cr. Memo Cash", "Cr. Memo Long Terme", "Invoice Cash", "Invoice Long Terme");
        rec."Sales This Month" := SalesThisMonth();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        Rec.SetFilter("Due Next Week Filter", '..%1', CalcDate('<+1W>', WorkDate()));
        Rec.SetFilter("Due Date Filter", '%1', WorkDate());
        Rec.SetFilter("Date Filter", '%1..%2', StartDateFilter, EndDateFilter);
        Rec.CalcFields("Sales Cash", "Sales Cheque", "Sales Draft", "Sales Transfer", "Sales RS", "Total Payment");
        Rec.CalcFields("Sales Inv. Due Next Week");
        Rec.CalcFields("Sales Invoice", "Cr. Memo Cash", "Cr. Memo Long Terme", "Invoice Cash", "Invoice Long Terme");
        rec."Sales This Month" := SalesThisMonth();
    end;

    procedure SetDateFilter(pStartDateFilter: Date; pEndDateFilter: Date)
    begin
        StartDateFilter := pStartDateFilter;
        EndDateFilter := pEndDateFilter;
    end;

    var
        ActivitiesMgt: Codeunit "Activities Mgt.";
        StartDateFilter: Date;
        EndDateFilter: Date;

        CustLedgerEntryOverdueInv: Record "Cust. Ledger Entry";
        CustLedgerEntrySalesMonth: Record "Cust. Ledger Entry";
}
