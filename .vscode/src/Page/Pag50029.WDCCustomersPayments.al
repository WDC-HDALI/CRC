namespace CRC.CRC;

using Microsoft.Sales.Receivables;
using Microsoft.Sales.Customer;
using Microsoft.Sales.Setup;
using Microsoft.Bank.BankAccount;
using Microsoft.Finance.GeneralLedger.Posting;
using Microsoft.Foundation.NoSeries;
using Microsoft.Finance.GeneralLedger.Journal;

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

                field(Unpaid; Rec.Unpaid)
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
            action(ModifyDueDate)
            {
                ApplicationArea = All;
                Captionml = ENU = 'Update Due Date', FRA = 'Modifier la Date d''échéance';
                Image = DueDate;
                PromotedCategory = Process;
                Promoted = true;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    lDetCustLedgEntr: Record "Detailed Cust. Ledg. Entry";
                    err01: TextConst ENU = 'you cannot change the due date for this case',
                                     FRA = 'vous ne pouvez pas modifier la date d''échéance pour ce cas';

                begin
                    CurrPage.SetSelectionFilter(lDetCustLedgEntr);
                    if lDetCustLedgEntr.FindFirst() then begin
                        if lDetCustLedgEntr."Payment Slip Type" <> lDetCustLedgEntr."Payment Slip Type"::Draft then
                            error(err01);
                        Report.RunModal(54017, true, true, lDetCustLedgEntr);
                    end;
                end;
            }
            action("Mark as Unpaid")
            {
                ApplicationArea = All;
                CaptionML = ENU = 'Mark as Unpaid', FRA = 'Marquer comme impayé';
                Image = Undo;
                PromotedCategory = Process;
                Promoted = true;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    lText001: TextConst ENU = 'Are you sure you want to mark this payment as unpaid?',
                                        FRA = 'Voulez-vous vraiment marquer ce paiement comme impayé ?';
                begin
                    if Not confirm(lText001) then
                        exit;
                    UnpaidPayment();
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

    procedure UnpaidPayment()

    var
        lGenJournalLine: Record "Gen. Journal Line";
        lGenJournalLine2: Record "Gen. Journal Line";
        lGenJournalBatch: Record "Gen. Journal Batch";
        lGenJnlPostBatch: Codeunit "Gen. Jnl.-Post Batch";
        lSerieNo: Codeunit "No. Series";
        lNextLineNo: Integer;
        lJournalTemplateName: Text[20];
        lJournalBatchName: Text[20];
        lCustLedgerEntry: Record "Cust. Ledger Entry";
        lReportUpdateUnpaid: Report "WDC Upd Unpaid Cust. Entries";
        lPaymentMethode: record "Payment Method";
        lCustPostingGroup: Record "Customer Posting Group";
        lText001: TextConst ENU = 'You can only mark as unpaid payments with payment slip type Cheque or Draft',
                                        FRA = 'Vous ne pouvez marquer comme impayé que les paiements de type traite ou chèque';
        lText002: TextConst ENU = 'Payment marked as unpaid successfully',
                                        FRA = 'Paiement marqué comme impayé avec succès';
        lText003: TextConst ENU = 'This payment is already marked as unpaid',
                                        FRA = 'Ce paiement est déjà marqué comme impayé';

    begin
        lCustLedgerEntry.Get(rec."Cust. Ledger Entry No.");
        if lCustLedgerEntry.Unpaid then
            Error(lText003);

        lJournalTemplateName := 'PAYMENTS';
        if Rec."Payment Slip Type" = Rec."Payment Slip Type"::Draft then
            lJournalBatchName := 'IMPTRAIT'
        else if Rec."Payment Slip Type" = Rec."Payment Slip Type"::Cheque then
            lJournalBatchName := 'IMPCHQ'
        else
            Error(lText001);

        lGenJournalBatch.Get(lJournalTemplateName, lJournalBatchName);
        lPaymentMethode.Get(lGenJournalBatch."Payment Method Code");
        lCustPostingGroup.Get(lPaymentMethode."Posting Group");

        InitGenJournalLine(lJournalBatchName);

        lGenJournalLine2.Init();
        lGenJournalLine2.Validate("Journal Template Name", lJournalTemplateName);
        lGenJournalLine2.Validate("Journal Batch Name", lJournalBatchName);
        lGenJournalLine2."Line No." := 10000;
        if lGenJournalLine2.Insert(True) then begin
            lGenJournalLine2."Document No." := lSerieNo.GetNextNo(lGenJournalBatch."No. Series", WorkDate());
            lGenJournalLine2."Posting Date" := WorkDate();
            lGenJournalLine2."Account Type" := lGenJournalBatch."Account Type";
            lGenJournalLine2.Validate("Account No.", rec."Customer No.");
            lGenJournalLine2.Validate("Document Type", lGenJournalLine2."Document Type"::" ");
            lGenJournalLine2."Payment Reference" := rec."Payment Reference";
            lGenJournalLine2.Validate("Debit Amount", rec."Credit Amount (LCY)");
            lGenJournalLine2.Validate("Payment Slip Type", rec."Payment Slip Type");
            lGenJournalLine2.Validate("Bal. Account Type", lGenJournalBatch."Bal. Account Type");
            lGenJournalLine2.Validate("Bal. Account No.", lGenJournalBatch."Bal. Account No.");
            lGenJournalLine2."Applies-to Doc. Type" := lGenJournalLine2."Applies-to Doc. Type"::Payment;
            lGenJournalLine2."Applies-to Doc. No." := rec."Document No.";
            lGenJournalLine2.Validate("Posting Group", lPaymentMethode."Posting Group");
            lGenJournalLine2.Validate("Payment Method Code", lPaymentMethode.Code);
            If lGenJournalLine2.Modify(true) then begin
                lGenJnlPostBatch.Run(lGenJournalLine2);
                lReportUpdateUnpaid.GetCustLedgerEntriesNo(rec."Entry No.");
                lReportUpdateUnpaid.UseRequestPage(false);
                lReportUpdateUnpaid.Run();
                Message(lText002);
                CurrPage.Update(false);
            end;
        end;
    end;

    procedure InitGenJournalLine(pJournalBatchName: Text[20])
    var
        lGenJournalLine: Record "Gen. Journal Line";
    begin
        lGenJournalLine.Init();
        lGenJournalLine.Validate("Journal Template Name", 'PAYMENTS');
        lGenJournalLine.SetRange("Journal Batch Name", pJournalBatchName);
        lGenJournalLine.DeleteAll();

    end;

    var
        PrintModel2: Boolean;
}