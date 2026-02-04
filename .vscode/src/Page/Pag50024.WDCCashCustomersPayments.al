namespace CRC.CRC;

using Microsoft.Sales.Receivables;
using Microsoft.Sales.Customer;

page 50024 "WDC Cash Customers Payments"
{

    ApplicationArea = All;
    CaptionML = ENU = 'Cash Customers Payments', FRA = 'Liste paiements clients comptants ';
    PageType = List;
    Editable = false;
    Permissions = tabledata "Detailed Cust. Ledg. Entry" = rimd;
    UsageCategory = History;
    SourceTable = "Detailed Cust. Ledg. Entry";
    SourceTableView = sorting("Customer No.", "Entry Type", "Posting Date", "Initial Document Type")
                                                                            where("Document Type" = filter(Payment),
                                                                            "Posting Group" = filter(<> 'C-GROUPE'),
                                                                            "Amount (LCY)" = filter(< 0),
                                                                            "Entry Type" = const("Initial Entry"));

    layout
    {
        area(Content)
        {
            repeater(General)
            {

                field("Document No."; Rec."Document No.")
                {
                    CaptionML = ENU = 'Document No.', FRA = 'N° Reçu';
                    ApplicationArea = all;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = all;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = all;
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = all;
                }

                field("Payment Slip Type"; Rec."Payment Slip Type")
                {
                    ApplicationArea = all;
                }
                field("Credit Amount (LCY)"; Rec."Credit Amount (LCY)")
                {
                    CaptionML = ENU = 'Amount', FRA = 'Montant';
                    ApplicationArea = all;
                }
                field("Payment Reference"; Rec."Payment Reference")
                {
                    ApplicationArea = all;
                }
                field("Bank Name"; Rec."Bank Name")
                {
                    ApplicationArea = all;
                }
                field("Initial Entry Due Date"; Rec."Initial Entry Due Date")
                {
                    CaptionML = ENU = 'Due Date', FRA = 'Date échéance';
                    ApplicationArea = all;
                }

            }

        }

    }
    actions
    {
        area(Creation)
        {
            action(PrintPayment)
            {
                ApplicationArea = All;
                CaptionML = ENU = 'Print Payment', FRA = 'Imprimer Règlement';
                Image = PrintDocument;
                PromotedCategory = Process;
                Promoted = true;
                PromotedIsBig = true;


                trigger OnAction()
                var
                    PayementDocument: report "WDC Print Customer Payment";
                    lDetCustLedgEntr: Record "Detailed Cust. Ledg. Entry";
                begin
                    lDetCustLedgEntr.Reset();
                    lDetCustLedgEntr.SetRange("Entry No.", Rec."Entry No.");
                    if lDetCustLedgEntr.FindFirst() then begin
                        PayementDocument.SetTableView(lDetCustLedgEntr);
                        PayementDocument.Run();
                    end;
                end;
            }
        }
    }
    trigger OnAfterGetRecord()
    var
        lPostedSalesInv: Record 112;
        InvoiceNo: code[20];
        lcustomer: record Customer;
        lUpdateDetCustLedgEntri: Report "WDC Upd Cust name Det Cust_Led";
    begin
        // lUpdateDetCustLedgEntri.UpdateDetCustLedgEntri(Rec."Entry No.");

        CurrPage.Update(false);
    end;
}