namespace CRC.CRC;

using Microsoft.Sales.Receivables;
using Microsoft.Finance.GeneralLedger.Journal;
using Microsoft.Foundation.NoSeries;
using Microsoft.Finance.GeneralLedger.Setup;
using Microsoft.Bank.BankAccount;
//***************Documentation*******************
//WDC01  WDC.HG  29/05/2025  Create Current Object
page 50013 "WDC Payment Lines"
{
    ApplicationArea = All;
    Captionml = ENU = 'Payment to be encaissed', FRA = 'Paiement à encaisser';
    PageType = Worksheet;
    SourceTable = "Cust. Ledger Entry";

    layout
    {
        area(Content)
        {

            group(control2)
            {
                ShowCaption = false;
                field(BanqueNo; BanqueNo)
                {
                    captionml = ENU = 'Bank payment', FRA = 'Paiement en banque';
                    ApplicationArea = all;
                    TableRelation = "Bank Account"."No.";
                    Lookup = true;
                }
            }
            repeater(control1)
            {
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = all;
                }

                field("Payment Method Code"; Rec."Payment Method Code")
                {
                    ApplicationArea = all;
                }
                field("Payment Reference"; Rec."Payment Reference")
                {
                    ApplicationArea = all;
                }
                field("Bank Name"; Rec."Bank Name")
                {

                }
                field("Amount (LCY)"; Rec."Amount (LCY)")
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
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = all;
                }
                field(PaymentStatut; Rec.PaymentStatut)
                {
                    ApplicationArea = all;
                }



            }
        }
    }
    trigger OnOpenPage()
    var
        GeneralLedgerSetup: record "General Ledger Setup";
    begin
        GeneralLedgerSetup.get();
        rec.Setrange("Document Type", rec."Document Type"::Payment);
        rec.setrange(PaymentStatut, rec.PaymentStatut::PayementToCollect);
        rec.setrange(IsInserted, false);
        if CurrentJnlBatchName = GeneralLedgerSetup."Check Slip Sheet" then
            rec.SetRange("Payment Method Code", 'CHEQUE')
        else if CurrentJnlBatchName = GeneralLedgerSetup."Bank Draft Slip Sheet" then
            rec.SetRange("Payment Method Code", 'TRAITE');

    end;

    procedure InsertSelectedJournalLine()
    var
        lCustomerLedgerEntry: record "Cust. Ledger Entry";
        lGenJournalLine: record "Gen. Journal Line";
        lGenJournalBatch: record "Gen. Journal Batch";
    begin
        lGenJournalBatch.get('PAYMENTS', CurrentJnlBatchName);
        lCustomerLedgerEntry.reset();
        CurrPage.SetSelectionFilter(lCustomerLedgerEntry);
        if lCustomerLedgerEntry.findset() then
            repeat
                lGenJournalLine.init();
                lGenJournalLine."Journal Batch Name" := CurrentJnlBatchName;
                lGenJournalLine."Journal Template Name" := 'PAYMENTS';
                lGenJournalLine."Line No." := lGenJournalLine.GetNewLineNo(lGenJournalLine."Journal Template Name", lGenJournalLine."Journal Batch Name");
                lGenJournalLine.validate("Posting Date", WorkDate);
                lGenJournalLine.validate("Document Type", lGenJournalLine."Document Type"::" ");
                lGenJournalLine."Account Type" := lGenJournalLine."Account Type"::"Bank Account";
                lGenJournalLine."Account No." := BanqueNo;
                lGenJournalLine."Bal. Account Type" := lCustomerLedgerEntry."Bal. Account Type";
                lGenJournalLine."Bal. Account No." := lCustomerLedgerEntry."Bal. Account No.";
                lGenJournalLine."Payment Method Code" := lCustomerLedgerEntry."Payment Method Code";
                lGenJournalLine."Document No." := NoSeries.PeekNextNo(lGenJournalBatch."No. Series", WorkDate);
                lGenJournalLine."Payment Reference" := lCustomerLedgerEntry."Payment Reference";
                lCustomerLedgerEntry.CalcFields(Amount);
                lGenJournalLine.validate(amount, abs(lCustomerLedgerEntry.amount));
                lGenJournalLine."Applies-to Doc. Type" := lCustomerLedgerEntry."Document Type";
                lGenJournalLine."Applies-to Doc. No." := lCustomerLedgerEntry."Document No.";
                lGenJournalLine.insert(true);
                lCustomerLedgerEntry.IsInserted := true;
                lCustomerLedgerEntry.Modify();
            until lCustomerLedgerEntry.next() = 0;
    end;

    procedure SetPaymentJournalName(pCurrentJnlBatchName: code[10])
    begin
        CurrentJnlBatchName := pCurrentJnlBatchName;

    end;

    var
        BanqueNo: code[20];
        CurrentJnlBatchName: code[10];
        NoSeries: Codeunit "No. Series";

}