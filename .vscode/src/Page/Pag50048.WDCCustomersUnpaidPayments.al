namespace CRC.CRC;

using Microsoft.Sales.Receivables;
using Microsoft.Sales.Customer;
using Microsoft.Sales.Setup;
using Microsoft.Foundation.NoSeries;
using Microsoft.Bank.BankAccount;
using Microsoft.Finance.GeneralLedger.Posting;
using Microsoft.Finance.GeneralLedger.Journal;

page 50048 "WDC Customers Unpaid Payments"
{

    ApplicationArea = All;
    CaptionML = ENU = 'Customers Unpaid Payments', FRA = 'Liste impayés clients';
    PageType = List;
    Editable = false;
    UsageCategory = History;
    SourceTable = "Detailed Cust. Ledg. Entry";
    SourceTableView = sorting("Customer No.", "Entry Type", "Posting Date", "Initial Document Type")
                                                                            where("Payment Slip Type" = filter(Draft | cheque),
                                                                            Unpaid = const(true),
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
                field("Amount (LCY)"; Abs(Rec."Amount (LCY)"))
                {
                    CaptionML = ENU = 'Amount (LCY)', FRA = 'Montant';
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
                field("Unpaid Before GoLive"; Rec."Unpaid Before GoLive")
                {
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

            action("Encaissed unpaid")
            {
                ApplicationArea = All;
                CaptionML = ENU = 'Encaissed Unpaid', FRA = 'Encaisser l''impayé';
                Image = CashFlow;
                PromotedCategory = Process;
                Promoted = true;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    lPageUpdateUnpaid: Page "WDC Encaiss Unpaid";
                    lText004: TextConst ENU = 'Are you sure you want to encaiss this payment?',
                                        FRA = 'Voulez-vous vraiment encaisser ce paiement ?';
                    lDetCustLedgEntr: Record "Detailed Cust. Ledg. Entry";
                begin
                    if Not confirm(lText004) then
                        exit;
                    lDetCustLedgEntr.Reset();
                    lDetCustLedgEntr.SetCurrentKey("Entry No.");
                    lDetCustLedgEntr.SetRange("Entry No.", Rec."Entry No.");
                    if lDetCustLedgEntr.FindFirst() then begin
                        lPageUpdateUnpaid.SetParameters(lDetCustLedgEntr."Payment Slip Type", lDetCustLedgEntr."Credit Amount (LCY)", lDetCustLedgEntr."Payment Reference");
                        lPageUpdateUnpaid.SetTableView(lDetCustLedgEntr);
                        lPageUpdateUnpaid.Run();
                    end;

                end;
            }

            // action(PrintCustomerDraft)
            // {
            //     ApplicationArea = All;
            //     CaptionML = ENU = 'Print Customer Draft', FRA = 'Imprimer Traite client';
            //     Image = PrintInstallment;
            //     PromotedCategory = Process;
            //     Promoted = true;
            //     PromotedIsBig = true;
            //     trigger OnAction()
            //     var
            //         lCustomerDraft: report "WDC-ST Customer Draft";
            //         lCustLedgEntr: Record "Cust. Ledger Entry";
            //         lText001: TextConst ENU = 'You have to select a draft payment',
            //                             FRA = 'Vous devez sélectionner un paiement traite';
            //     begin
            //         If rec."Payment Slip Type" <> rec."Payment Slip Type"::Draft then
            //             Error(lText001);

            //         lCustLedgEntr.Reset();
            //         lCustLedgEntr.SetRange("Entry No.", Rec."Cust. Ledger Entry No.");
            //         if lCustLedgEntr.FindFirst() then begin
            //             lCustomerDraft.SetTableView(lCustLedgEntr);
            //             lCustomerDraft.Run();
            //         end;
            //     end;
            // }
            // action(ModifyDueDate)
            // {
            //     ApplicationArea = All;
            //     Captionml = ENU = 'Update Due Date', FRA = 'Modifier la Date d''échéance';
            //     Image = DueDate;
            //     PromotedCategory = Process;
            //     Promoted = true;
            //     PromotedIsBig = true;
            //     trigger OnAction()
            //     var
            //         lDetCustLedgEntr: Record "Detailed Cust. Ledg. Entry";
            //         err01: TextConst ENU = 'you cannot change the due date for this case',
            //                          FRA = 'vous ne pouvez pas modifier la date d''échéance pour ce cas';

            //     begin
            //         CurrPage.SetSelectionFilter(lDetCustLedgEntr);
            //         if lDetCustLedgEntr.FindFirst() then begin
            //             if lDetCustLedgEntr."Payment Slip Type" <> lDetCustLedgEntr."Payment Slip Type"::Draft then
            //                 error(err01);
            //             Report.RunModal(54017, true, true, lDetCustLedgEntr);
            //         end;
            //     end;
            // }
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