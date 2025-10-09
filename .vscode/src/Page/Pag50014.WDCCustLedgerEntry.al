namespace CRC.CRC;

using Microsoft.Sales.Receivables;
using Microsoft.Sales.History;

page 50014 "WDC Cust. Ledger Entry"
{
    ApplicationArea = All;
    CaptionML = ENU = 'Customer Historics', FRA = 'Extrait client';
    PageType = ListPart;
    Editable = false;
    SourceTable = "Cust. Ledger Entry";
    SourceTableView = sorting("Customer No.", "Posting Date", "Currency Code") where(Reversed = filter(false));

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = all;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = all;
                    trigger OnDrillDown()
                    var
                        lSalesInvHeader: Record "Sales Invoice Header";
                        lSalesInvoiceCard: Page "Posted Sales Invoice";
                    begin
                        // Implement drill down logic here
                        if rec."Document Type" = rec."Document Type"::Invoice then begin
                            lSalesInvHeader.reset();
                            lSalesInvHeader.setrange("No.", rec."Document No.");
                            if lSalesInvHeader.findfirst() then begin
                                // Open Sales Invoice Header page
                                lSalesInvoiceCard.SetTableView(lSalesInvHeader);
                                lSalesInvoiceCard.run();
                            end;
                        end;
                    end;
                }
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = all;
                }
                field("Debit Amount (LCY)"; Rec."Debit Amount (LCY)")
                {
                    ApplicationArea = all;
                }
                field("Credit Amount (LCY)"; Rec."Credit Amount (LCY)")
                {
                    ApplicationArea = all;
                }
            }
            // field(TotalDebit; TotalDebit)
            // {
            //     CaptionML = ENU = 'Total Debit', FRA = 'Total débit';
            //     ApplicationArea = all;
            //     Editable = false;
            //     Style = StrongAccent;
            // }
            // field(TotalCredit; TotalCredit)
            // {
            //     CaptionML = ENU = 'Total Credit', FRA = 'Total Crédit';
            //     ApplicationArea = all;
            //     Editable = false;
            //     Style = StrongAccent;
            // }
        }

    }

    trigger OnAfterGetRecord()
    Var
        lUpdateCustName: report "WDC Upd Cust name Det Cust_Led";
    begin
        // Clear(lUpdateCustName);
        // lUpdateCustName.UpdateCustLedgEntri(rec."Entry No.");
        // CurrPage.Update(false);
    end;



    var
        TotalDebit: Decimal;
        TotalCredit: Decimal;
}
