namespace CRC.CRC;

using Microsoft.Sales.Receivables;
using Microsoft.Sales.Customer;
using Microsoft.Sales.Setup;

page 50029 "WDC Customers Payments"
{

    ApplicationArea = All;
    CaptionML = ENU = 'Customers Payments', FRA = 'Liste paiements clients';
    PageType = List;
    Editable = false;
    UsageCategory = History;
    SourceTable = "Detailed Cust. Ledg. Entry";
    SourceTableView = sorting("Customer No.", "Entry Type", "Posting Date", "Initial Document Type")
                                                                            where("Document Type" = filter(Payment),
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
                Visible = not PrintModel2;

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
            action(PrintPaymentModel2)
            {
                ApplicationArea = All;
                CaptionML = ENU = 'Print Payment', FRA = 'Imprimer réçu';
                Image = PrintDocument;
                PromotedCategory = Process;
                Promoted = true;
                PromotedIsBig = true;
                Visible = PrintModel2;
                ;
                trigger OnAction()
                var
                    PayementDocument: report "WDC Print Cust. Payment LAZREG";
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
            action(PrintCustomerDraft)
            {
                ApplicationArea = All;
                CaptionML = ENU = 'Print Customer Draft', FRA = 'Imprimer Traite client';
                Image = PrintInstallment;
                PromotedCategory = Process;
                Promoted = true;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    lCustomerDraft: report "WDC-ST Customer Draft";
                    lCustLedgEntr: Record "Cust. Ledger Entry";
                    lText001: TextConst ENU = 'You have to select a draft payment',
                                        FRA = 'Vous devez sélectionner un paiement traite';
                begin
                    If rec."Payment Slip Type" <> rec."Payment Slip Type"::Draft then
                        Error(lText001);

                    lCustLedgEntr.Reset();
                    lCustLedgEntr.SetRange("Entry No.", Rec."Cust. Ledger Entry No.");
                    if lCustLedgEntr.FindFirst() then begin
                        lCustomerDraft.SetTableView(lCustLedgEntr);
                        lCustomerDraft.Run();
                    end;
                end;
            }
        }
    }
    trigger OnOpenPage()
    var
        lSalesSetup: Record "Sales & Receivables Setup";
        lUpdateDetCustLedgEntri: Report "WDC Upd Cust name Det Cust_Led";
    begin
        PrintModel2 := false;
        lSalesSetup.Get();
        PrintModel2 := lSalesSetup."Print Paiement Model2";
        lUpdateDetCustLedgEntri.UpdateDetCustLedgEntri();
    end;

    trigger OnAfterGetRecord()
    var
        lPostedSalesInv: Record 112;
        InvoiceNo: code[20];
        lcustomer: record Customer;
        lUpdateDetCustLedgEntri: Report "WDC Upd Cust name Det Cust_Led";
    begin
        //lUpdateDetCustLedgEntri.UpdateDetCustLedgEntri(Rec."Entry No.");

        CurrPage.Update(false);
    end;

    var
        PrintModel2: Boolean;
}