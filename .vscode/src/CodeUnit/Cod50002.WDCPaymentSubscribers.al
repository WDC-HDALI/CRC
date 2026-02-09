namespace CRC.CRC;
using Microsoft.Finance.GeneralLedger.Posting;
using Microsoft.Finance.GeneralLedger.Journal;
using Microsoft.Sales.Customer;
using Microsoft.Bank.BankAccount;
using Microsoft.Sales.Receivables;
using Microsoft.Finance.GeneralLedger.Ledger;
using Microsoft.Finance.GeneralLedger.Setup;

codeunit 50002 "WDC Payment Subscribers"
{
    //<<WDC02
    [EventSubscriber(ObjectType::Table, database::"Cust. Ledger Entry", OnAfterCopyCustLedgerEntryFromGenJnlLine, '', FALSE, FALSE)]
    local procedure OnAfterCopyCustLedgerEntryFromGenJnlLine(var CustLedgerEntry: Record "Cust. Ledger Entry"; GenJournalLine: Record "Gen. Journal Line")
    var
    begin
        CustLedgerEntry."Bank Name" := GenJournalLine."Bank Name";
        if (GenJournalLine."Payment Method Code" = 'CHEQUE') OR (GenJournalLine."Payment Method Code" = 'TRAITE') and (GenJournalLine."Document Type" = GenJournalLine."Document Type"::Payment) then
            CustLedgerEntry.PaymentStatut := CustLedgerEntry.PaymentStatut::PayementToCollect;
    end;
    //>>WDC02
    //<<WDC03
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnAfterInitGLEntry', '', FALSE, FALSE)]
    local procedure OnAfterInitGLEntry(var GLEntry: Record "G/L Entry"; GenJournalLine: Record "Gen. Journal Line")
    var
        lGeneralLedgerSetup: record "General Ledger Setup";
    begin
        lGeneralLedgerSetup.get();
        IF (GenJournalLine."Payment Reference" <> '') and (GenJournalLine."Applies-to Doc. Type" = GenJournalLine."Applies-to Doc. Type"::Payment) and ((GenJournalLine."Journal Batch Name" = lGeneralLedgerSetup."Check Slip Sheet") or (GenJournalLine."Journal Batch Name" = lGeneralLedgerSetup."Bank Draft Slip Sheet")) then begin
            GLEntry."Cheque No." := GenJournalLine."Payment Reference";
            GLEntry."Initial Payment No." := GenJournalLine."Applies-to Doc. No.";
            SetCustLedgerEntryStatus(GenJournalLine);
        End;
    end;

    procedure SetCustLedgerEntryStatus(pGenJournalLine: record "Gen. Journal Line")
    var
        lCustomerLedgEntry: Record "Cust. Ledger Entry";
    begin
        lCustomerLedgEntry.Reset();
        //lCustomerLedgEntry.SetCurrentKey()
        lCustomerLedgEntry.setrange("Document Type", lCustomerLedgEntry."Document Type"::Payment);
        lCustomerLedgEntry.SetRange("Payment Reference", pGenJournalLine."Payment Reference");
        lCustomerLedgEntry.SetRange(PaymentStatut, lCustomerLedgEntry.PaymentStatut::PayementToCollect);
        if lCustomerLedgEntry.FindFirst() then Begin
            lCustomerLedgEntry.ModifyAll(PaymentStatut, lCustomerLedgEntry.PaymentStatut::"Bank payment");
        end;
    end;
    //>>WDC03
    //<<WDC04
    procedure InserteBordereauLookup()
    var
        BorderauLineQuery: Query "WDC Borderau Line";
        LookupRec: Record "WDC borderau lookup";
    begin
        LookupRec.DeleteAll();

        if BorderauLineQuery.Open() then begin
            while BorderauLineQuery.Read() do begin
                LookupRec.Init();
                LookupRec.entryNo := LookupRec.GetEntryNo();
                LookupRec."Document No." := BorderauLineQuery.Document_No_;
                LookupRec."Posting date" := BorderauLineQuery.Posting_Date;
                LookupRec.Insert(true);
                Commit();
            end;

            BorderauLineQuery.Close();
        end;
    end;
    //>>WDC04
    //<<WDC05
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnAfterInitCustLedgEntry', '', FALSE, FALSE)]
    local procedure OnAfterInitCustLedgEntry(var CustLedgerEntry: Record "Cust. Ledger Entry"; GenJournalLine: Record "Gen. Journal Line"; var GLRegister: Record "G/L Register")
    var
        RsJournalLine: record "Gen. Journal Line";
        RsConfiguration: record "WDC-ST Retained Group";
        GeneralLedgerSetup: record "General Ledger Setup";
    begin
        GeneralLedgerSetup.get();
        if (GenJournalLine."Taux RS" <> '') and (GenJournalLine."Rs Amount" <> 0) and (GenJournalLine."Journal Batch Name" <> GeneralLedgerSetup."Payment Sheet") then begin
            RsConfiguration.reset();
            RsJournalLine.Init();
            RsJournalLine."Journal Batch Name" := GenJournalLine."Journal Batch Name";
            RsJournalLine."Journal Template Name" := GenJournalLine."Journal Template Name";
            RsJournalLine."Line No." := GenJournalLine.GetNewLineNo(RsJournalLine."Journal Template Name", RsJournalLine."Journal Batch Name");
            RsJournalLine."Posting Date" := GenJournalLine."Posting Date";
            RsJournalLine."Document No." := GenJournalLine."Document No.";
            RsJournalLine."Document Type" := RsJournalLine."Document Type"::" ";
            RsJournalLine."Account Type" := RsJournalLine."Account Type"::"G/L Account";
            RsJournalLine."Payment Method Code" := 'RS';
            if RsConfiguration.get(RsConfiguration."Type Retenue"::"à la source", GenJournalLine."Taux RS") then
                RsJournalLine.Validate("Account No.", RsConfiguration."Retention Account No.");
            RsJournalLine."Bal. Account Type" := GenJournalLine."Account Type";
            RsJournalLine."Bal. Account No." := GenJournalLine."Account No.";
            RsJournalLine.validate(Amount, GenJournalLine."Rs Amount");
            RsJournalLine."Applies-to Doc. Type" := GenJournalLine."Applies-to Doc. Type";
            RsJournalLine."Applies-to Doc. No." := GenJournalLine."Applies-to Doc. No.";
            RsJournalLine.insert(true);
        end
    end;
    //>>WDC05
    //<<WDC06

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post", 'OnBeforeGenJnlPostBatchRun', '', FALSE, FALSE)]
    local procedure OnBeforeGenJnlPostBatchRun(var GenJnlLine: Record "Gen. Journal Line"; var IsHandled: Boolean; var GenJnlPostBatch: Codeunit "Gen. Jnl.-Post Batch")
    Var
        lPaymentMethod: Record "Payment Method";
        ltext001: TextConst ENU = 'Document type must have an empty value in unpaid line %1',
                        FRA = 'Type Document doit avoir un valeur vide dans ligne impayé %1';
    begin
        if lPaymentMethod.get(GenJnlLine."Payment Method Code") then
            if lPaymentMethod.Unpaid and (GenJnlLine."Document Type" <> GenJnlLine."Document Type"::" ") then
                Error(ltext001, GenJnlLine."Line No.");
    end;
    //<<WDC07

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Batch", 'OnAfterPostGenJournalLine', '', FALSE, FALSE)]
    local procedure OnAfterPostGenJournalLine(var GenJournalLine: Record "Gen. Journal Line"; var Result: Boolean; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line")

    Var
        PaymentMethod: record "Payment Method";
        customer: record Customer;
    begin
        if (GenJournalLine."Payment Method Code" <> '') and (GenJournalLine."Account Type" = GenJournalLine."Account Type"::Customer) then
            if PaymentMethod.get(GenJournalLine."Payment Method Code") then begin
                if PaymentMethod.Unpaid = true then begin
                    if customer.get(GenJournalLine."Account No.") then
                        if customer.IsBlocked() = false then begin
                            customer.Blocked := customer.Blocked::Ship;
                            customer.Modify();
                        end
                end;
            end;
    end;
    //>>WDC07
    // local procedure OnAfterPostGenJnlLine(var GenJournalLine: Record "Gen. Journal Line"; CommitIsSuppressed: Boolean; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; IsPosted: Boolean; var PostingGenJournalLine: Record "Gen. Journal Line")
    // begin
    // end;
}
