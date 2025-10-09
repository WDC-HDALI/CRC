namespace CRC.CRC;

using Microsoft.Sales.History;
using Microsoft.Sales.Document;

page 50021 "WDC Caisse Journal_V2"
{
    ApplicationArea = All;
    CaptionML = ENU = 'Caisse Journal', FRA = 'Journal caisse V2';
    PageType = Worksheet;
    Editable = true;
    CardPageId = "Posted Sales Invoice";
    SourceTable = "Sales Invoice Header";
    UsageCategory = Lists;
    Permissions = tabledata "Sales Invoice Header" = rm;

    layout
    {
        area(Content)
        {
            group(Filter)
            {
                CaptionML = ENU = 'Filter', FRA = 'Filtres';
                Editable = true;
                field(StartDateFilter; StartDateFilter)
                {
                    CaptionML = ENU = 'Date Debut filter', FRA = 'Filtre date début';
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        if StartDateFilter < EndDateFilter then
                            EndDateFilter := WorkDate();
                        Rec.SetFilter("Posting Date", '%1..%2', StartDateFilter, EndDateFilter);
                        CurrPage."WDC Sales Statistics_V2".Page.SetDateFilter(StartDateFilter, EndDateFilter);
                        CurrPage."WDC Sales Statistics_V2".Page.Update(false);
                        CurrPage.Update(false);
                    end;

                }
                field(EndDateFilter; EndDateFilter)
                {
                    CaptionML = ENU = 'End Date filter', FRA = 'Filtre date fin';
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        Rec.SetFilter("Posting Date", '%1..%2', StartDateFilter, EndDateFilter);
                        CurrPage."WDC Sales Statistics_V2".Page.SetDateFilter(StartDateFilter, EndDateFilter);
                        CurrPage."WDC Sales Statistics_V2".Page.Update(false);
                        CurrPage.Update(false);
                    end;

                }
                field(ViewStatistics; ViewStatistics)
                {
                    CaptionML = ENU = 'View Statistics', FRA = 'Voir Statistiques';
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        CurrPage.Update(false);
                    end;
                }
            }

            group(Statistique)
            {
                Visible = ViewStatistics;
                ShowCaption = false;
                part("WDC Sales Statistics_V2"; "WDC Sales Statistics_V2")
                {
                    ApplicationArea = All;
                }
            }

            group(Invoices)
            {
                CaptionML = ENU = 'Posted Sales Invoices', FRA = 'Factures vente enregistrées';
                repeater(General)
                {
                    Editable = false;
                    field("Payment Terms Code"; Rec."Payment Terms Code")
                    {
                        ApplicationArea = All;
                    }
                    field("Posting Date"; Rec."Posting Date")
                    {
                        ApplicationArea = All;
                    }
                    field("No."; Rec."No.")
                    {
                        ApplicationArea = All;
                    }
                    field("Bill-to Customer No."; Rec."Bill-to Customer No.")
                    {
                        ApplicationArea = All;
                    }
                    field("Sell-to Customer Name"; Rec."Sell-to Customer Name")
                    {
                        ApplicationArea = All;
                    }
                    field("Invoice Amount Including Stamp"; Rec."Invoice Amount Including Stamp")
                    {
                        ApplicationArea = All;
                        Style = Strong;
                    }

                    field("Cash Payment"; Rec."Cash Payment")
                    {
                        ApplicationArea = All;
                    }
                    field("Cheque Payment"; Rec."Cheque Payment")
                    {
                        ApplicationArea = All;
                    }
                    field("Draft Payment"; Rec."Draft Payment")
                    {
                        ApplicationArea = All;
                    }
                    field("Transfer Payment"; Rec."Transfer Payment")
                    {
                        ApplicationArea = All;
                    }
                    field("RS Amount"; Rec."RS Amount")
                    {
                        ApplicationArea = All;
                    }
                    field("Cr. Memo Amount"; Rec."Cr. Memo Amount")
                    {
                        ApplicationArea = All;
                    }
                    field("Remaining Amount"; Rec."Remaining Amount")
                    {
                        ApplicationArea = All;
                    }
                }

            }

        }

    }
    actions
    {
        area(Navigation)
        {
            // group(PostedSalesInvoices)
            // {
            //   CaptionML = ENU = 'Posted Sales Invoices', FRA = 'Factures vente enregistrées';

            action(CashInvoice)
            {
                ApplicationArea = All;
                CaptionML = ENU = 'CashInvoice', FRA = 'Facture comptant';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = "Invoicing-MDL-Payments";
                trigger OnAction()
                var
                begin
                    rec.SetFilter("Customer Posting Group", '%1', 'C-PASSAGER');
                    CurrPage.Update(false);
                end;
            }
            action(TermeInvoice)
            {
                ApplicationArea = All;
                CaptionML = ENU = 'Term Invoice', FRA = 'Facture à terme';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = "Invoicing-MDL-Invoice";
                trigger OnAction()
                var
                begin
                    rec.SetFilter("Customer Posting Group", '<>%1', 'C-PASSAGER');
                    CurrPage.Update(false);
                end;
            }
            action(AllInvoice)
            {
                ApplicationArea = All;
                CaptionML = ENU = 'All Invoice', FRA = 'Toutes les factures';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = AllLines;
                trigger OnAction()
                var
                begin
                    rec.Reset();
                    CurrPage.Update(false);
                end;
            }
            action(SeeDocument)
            {
                ApplicationArea = All;
                CaptionML = ENU = 'See document', FRA = 'Afficher document';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = ShowSelected;
                RunObject = page "Posted Sales Invoice";
                RunPageLink = "No." = field("No.");
            }
            //}
            //  group(print)
            // {
            // CaptionML = ENU = 'Print', FRA = 'Imprimer';
            action(PrintCashJournal)
            {
                ApplicationArea = All;
                CaptionML = ENU = 'Print Cash Journal', FRA = 'Imprimer journal caisse';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Print;
                trigger OnAction()
                var
                    CashJournalReport: report "WDC Cash Journal V2";
                begin
                    CashJournalReport.SetFilterDate(StartDateFilter, EndDateFilter);
                    CashJournalReport.RunModal();
                end;

            }
        }
    }



    trigger OnAfterGetRecord()
    begin
        Rec.SetFilter("Posting Date", '%1..%2', StartDateFilter, EndDateFilter);
    end;

    trigger OnAfterGetCurrRecord()
    begin
        Rec.SetFilter("Posting Date", '%1..%2', StartDateFilter, EndDateFilter);
    end;

    trigger OnOpenPage()
    begin
        ViewStatistics := true;
        StartDateFilter := WorkDate();
        EndDateFilter := WorkDate();
        Rec.SetFilter("Posting Date", '%1..%2', StartDateFilter, EndDateFilter);
        CurrPage."WDC Sales Statistics_V2".Page.SetDateFilter(StartDateFilter, EndDateFilter);
        CurrPage."WDC Sales Statistics_V2".Page.Update(false);
        CurrPage.Update(false);
    end;

    var
        StartDateFilter: Date;
        EndDateFilter: Date;
        ViewStatistics: Boolean;

}
