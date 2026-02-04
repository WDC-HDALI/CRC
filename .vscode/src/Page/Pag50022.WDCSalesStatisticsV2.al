namespace CRC.CRC;

using Microsoft.RoleCenters;
using Microsoft.Sales.Receivables;
using Microsoft.Foundation.Period;

page 50022 "WDC Sales Statistics_V2"
{
    ApplicationArea = All;
    PageType = CardPart;
    SourceTable = "Activities Cue";
    CaptionML = ENU = '---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------',
                FRA = '---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------';
    layout
    {

        area(Content)
        {
            group(Cash9999)
            {
                CaptionML = ENU = 'Cash 9999', FRA = 'Comptant 9999';
                field("Cash Sales Cash"; Rec."Cash Sales Cash")
                {
                    CaptionML = ENU = 'Cash ', FRA = 'Espèces';
                    ApplicationArea = All;
                }
                field("Cash Sales Cheque"; Rec."Cash Sales Cheque")
                {
                    CaptionML = ENU = 'Cheque ', FRA = 'Chèque';
                    ApplicationArea = All;
                }
                field("Cash Sales Draft"; Rec."Cash Sales Draft")
                {
                    CaptionML = ENU = 'Draft ', FRA = 'Traite';
                    ApplicationArea = All;
                }
                field("Cash Sales Transfer"; Rec."Cash Sales Transfer")
                {
                    CaptionML = ENU = 'Transfer', FRA = 'Virement';
                    ApplicationArea = All;
                }
                field("Cash Sales RS"; Rec."Cash Sales RS")
                {
                    CaptionML = ENU = 'RS', FRA = 'RS';
                    ApplicationArea = All;
                }
                field("Cash Payment Cr Memo"; Rec."Cash Payment Cr Memo")
                {
                    CaptionML = ENU = 'Cr Memo Payment', FRA = 'Paiements par avoir';
                    ApplicationArea = All;
                }
                field("Cash Total Payment"; Rec."Cash Total Payment")
                {
                    CaptionML = ENU = 'Total Payment', FRA = 'Total paiement';
                    ApplicationArea = All;
                }
                field("Invoice Cash"; Rec."Invoice Cash")
                {
                    CaptionML = ENU = 'Cash Invoices', FRA = 'Factures comptant';
                    ApplicationArea = All;
                }
            }

            //>>*********************** Comptant 9999 ****************************


            //<<*********************** Avance   9999 ****************************
            group("Cash Customer Advance")
            {
                CaptionML = ENU = 'Advance cash customers', FRA = 'Avances clients comptants';

                field("Cash Advance Cash"; Rec."Cash Advance Cash")
                {
                    CaptionML = ENU = 'Cash Advance', FRA = 'Avance Espèces';
                    ApplicationArea = All;
                }
                field("Cash Advance Cheque"; Rec."Cash Advance Cheque")
                {
                    CaptionML = ENU = 'Cheque Advance', FRA = 'Avance chèque';
                    ApplicationArea = All;
                }
                field("Cash Advance Draft"; Rec."Cash Advance Draft")
                {
                    CaptionML = ENU = 'Draft Advance', FRA = 'Avance traite';
                    ApplicationArea = All;
                }
                field("Cash Advance transfer"; Rec."Cash Advance transfer")
                {
                    CaptionML = ENU = 'Transfer Advance', FRA = 'Avance virement';
                    ApplicationArea = All;
                }
                field("Cash Advance RS"; Rec."Cash Advance RS")
                {
                    CaptionML = ENU = 'RS Advance', FRA = 'Avance RS';
                    ApplicationArea = All;
                }
                field("Cash Total Advance"; Rec."Cash Total Advance")
                {
                    CaptionML = ENU = 'Total Advance', FRA = 'Total avance';
                    ApplicationArea = All;
                }
            }
            //>>******************Avance 9999*************************


            //>>*********************** Comptant 9999 ****************************


            //<<*********************** Avance  à terme ****************************
            group("Term Customer Payment")
            {
                CaptionML = ENU = 'Received in advance Term customers', FRA = 'Reçus clients à terme';

                field("Term Payment Cash"; Rec."Term Payment Cash")
                {
                    ApplicationArea = All;
                }
                field("Term Payment Cheque"; Rec."Term Payment Cheque")
                {
                    ApplicationArea = All;
                }
                field("Term Payment Draft"; Rec."Term Payment Draft")
                {
                    ApplicationArea = All;
                }
                field("Term Payment Transfer"; Rec."Term Payment Transfer")
                {
                    ApplicationArea = All;
                }
                field("Term Payment RS"; Rec."Term Payment RS")
                {
                    ApplicationArea = All;
                }
                field("Term Payment Cr Memo"; Rec."Term Payment Cr Memo")
                {
                    ApplicationArea = All;
                }
                field("Term Total Payment"; Rec."Term Total Payment")
                {
                    ApplicationArea = All;
                }
            }

            //>>******************Avance à terme*************************

            group(Total)
            {

                CaptionML = ENU = 'Totaux',
                            FRA = 'Totaux';

                field("Sales Cash"; Rec."Sales Cash")
                {
                    CaptionML = ENU = 'Total Cash', FRA = 'Total espèce';
                    ApplicationArea = all;
                    Style = Strong;

                }

                field("Sales Cheque"; Rec."Sales Cheque")
                {
                    CaptionML = ENU = 'Total Cheque', FRA = 'Total chèques';
                    ApplicationArea = all;
                    Style = Strong;
                }

                field("Sales Draft"; Rec."Sales Draft")
                {
                    CaptionML = ENU = 'Total Draft', FRA = 'Total traites';
                    ApplicationArea = all;
                    Style = Strong;
                }

                field("Sales Transfer"; Rec."Sales Transfer")
                {
                    CaptionML = ENU = 'Total Transfer', FRA = 'Total virements';
                    ApplicationArea = all;
                    Style = Strong;
                }

                field("Sales RS"; Rec."Sales RS")
                {
                    CaptionML = ENU = 'Total RS', FRA = 'Total RS';
                    ApplicationArea = all;
                    Style = Strong;
                }
                field("Total Payment"; Rec."Total Payment")
                {
                    CaptionML = ENU = 'Total Payments', FRA = 'Total paiements';
                    ApplicationArea = all;
                    Style = Strong;
                }

            }
            group(TotalInvoice)
            {
                CaptionML = ENU = 'Month Recup', FRA = 'Récap du mois';
                field("Month Cash Invoices"; Rec."Month Cash Invoices")
                {
                    ApplicationArea = all;
                }
                field("Month Term Invoices"; Rec."Month Term Invoices")
                {
                    ApplicationArea = all;
                }
                //<<CHG01
                field("Month Cash Credit Memo"; Rec."Month Cash Credit Memo")
                {
                    ApplicationArea = all;
                }
                field("Month Term Credit Memo"; Rec."Month Term Credit Memo")
                {
                    ApplicationArea = all;
                }
                //>>CHG01

                field("Sales This Month"; Rec."Sales This Month")
                {
                    CaptionML = ENU = 'Month CA', FRA = 'Total chiffre d''affaire du mois';
                    ApplicationArea = All;
                    Editable = false;
                    Style = StrongAccent;
                    trigger OnDrillDown()
                    begin
                        WDC_FilterDrillDownSalesThisMonth;
                    end;
                }
                field("Overdue Sales Invoice Amount"; Rec."Overdue Sales Invoice Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                    trigger OnDrillDown()
                    begin
                        ActivitiesMgt.DrillDownCalcOverdueSalesInvoiceAmount();
                    end;
                }
                field("Sales Inv. Due Next Week"; Rec."Sales Inv. Due Next Week")
                {
                    ApplicationArea = All;
                    trigger OnDrillDown()
                    begin
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
            lCustLedgEntrie.Editable(false);
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
    Var
        StartOfMonth: Date;
        EndOfMonth: Date;
    begin

        StartOfMonth := DMY2Date(1, Date2DMY(WorkDate, 2), Date2DMY(WorkDate, 3));
        EndOfMonth := CALCDATE('<CM>', StartOfMonth);
        Rec.SetFilter("Month Filter", '%1..%2', StartOfMonth, EndOfMonth);

        Rec.SetFilter("Due Next Week Filter", '..%1', CalcDate('<+1W>', WorkDate));
        Rec.SetFilter("Due Date Filter", '%1', WorkDate);
        Rec.SetFilter("Date Filter", '%1..%2', StartDateFilter, EndDateFilter);
        Rec.CalcFields("Sales Cash", "Sales Cheque", "Sales Draft", "Sales Transfer", "Sales RS", "Total Payment");
        Rec.CalcFields("Sales Inv. Due Next Week");
        Rec.CalcFields("Sales Invoice", "Cr. Memo Cash", "Cr. Memo Long Terme", "Invoice Cash", "Invoice Long Terme");

    end;

    trigger OnAfterGetRecord()
    Var
        StartOfMonth: Date;
        EndOfMonth: Date;
    begin

        StartOfMonth := DMY2Date(1, Date2DMY(WorkDate, 2), Date2DMY(WorkDate, 3));
        EndOfMonth := CALCDATE('<CM>', StartOfMonth);
        Rec.SetFilter("Month Filter", '%1..%2', StartOfMonth, EndOfMonth);
        Rec.SetFilter("Due Next Week Filter", '..%1', CalcDate('<+1W>', WorkDate));
        Rec.SetFilter("Due Date Filter", '%1', WorkDate);
        Rec.SetFilter("Date Filter", '%1..%2', StartDateFilter, EndDateFilter);
        Rec.CalcFields("Sales Cash", "Sales Cheque", "Sales Draft", "Sales Transfer", "Sales RS", "Total Payment");
        Rec.CalcFields("Sales Inv. Due Next Week");
        Rec.CalcFields("Sales Invoice", "Cr. Memo Cash", "Cr. Memo Long Terme", "Invoice Cash", "Invoice Long Terme");
        rec.CalcFields("Cash Advance Cash", "Cash Advance Cheque", "Cash Advance Draft", "Cash Advance RS", "Cash Advance Transfer", "Cash Advance Transfer",
               "Cash Payment Cr Memo", "Cash Sales Cash", "Cash Sales Cheque", "Cash Sales Draft", "Cash Sales RS", "Cash Sales Transfer", "Cash Sales RS",
               "Cash Sales Transfer", "Cash Total Advance", "Cash Total Payment", "Cr. Memo Cash", "Cr. Memo Long Terme", "Invoice Cash", "Invoice Long Terme",
               "Sales Cash", "Sales Cheque", "Sales Draft", "Sales RS", "Total Payment", "Term Payment Cash", "Term Payment Cheque",
               "Term Payment Cr Memo", "Term Payment Draft", "Term Payment Draft", "Term Payment RS", "Term Payment Transfer", "Term Total Payment");

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
        Rec.CalcFields("Cash Advance Cash", "Cash Advance Cheque", "Cash Advance Draft", "Cash Advance RS", "Cash Advance Transfer", "Cash Advance Transfer",
               "Cash Payment Cr Memo", "Cash Sales Cash", "Cash Sales Cheque", "Cash Sales Draft", "Cash Sales RS", "Cash Sales Transfer", "Cash Sales RS",
               "Cash Sales Transfer", "Cash Total Advance", "Cash Total Payment", "Cr. Memo Cash", "Cr. Memo Long Terme", "Invoice Cash", "Invoice Long Terme",
               "Sales Cash", "Sales Cheque", "Sales Draft", "Sales RS", "Total Payment", "Term Payment Cash", "Term Payment Cheque",
               "Term Payment Cr Memo", "Term Payment Draft", "Term Payment Draft", "Term Payment RS", "Term Payment Transfer", "Term Total Payment");

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
