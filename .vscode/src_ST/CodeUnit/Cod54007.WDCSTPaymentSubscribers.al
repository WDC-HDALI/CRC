//**************Documentation********************
//WDC01  WDC.HG  22/07/2025   display the "reference payement" in vendor ledger entries 
codeunit 54007 "WDC-ST PaymentSubscribers"
{
    // [EventSubscriber(ObjectType::Table, Database::"Payment Line", 'OnAfterValidateEvent', 'Amount', FALSE, FALSE)]
    // local procedure OnAfterValidateEventAmountPayLine(var Rec: Record "Payment Line"; var xRec: Record "Payment Line"; CurrFieldNo: Integer)
    // begin
    //     IF (Rec."Montant Retenue" = 0) AND (Rec."Montant Retenue Validé" = 0) AND (Rec."Montant Retenue TVA" = 0)
    //         AND (Rec."Montant Retenue TVA Validé" = 0) AND (Rec."Montant Commission" = 0) AND (Rec."Montant Commission Validé" = 0)
    //         AND (Rec."Montant TVA sur Commission" = 0) AND (Rec."Montant TVA sur Com. validé" = 0) THEN BEGIN
    //         Rec."Montant Initial" := Rec.Amount;
    //         Rec."Montant Initial DS" := Rec."Amount (LCY)";
    //     END;
    // end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnAfterInitCustLedgEntry', '', FALSE, FALSE)]
    local procedure OnAfterInitCustLedgEntry(var CustLedgerEntry: Record "Cust. Ledger Entry"; GenJournalLine: Record "Gen. Journal Line")
    var
        lPaymentMethod: record "Payment Method";
    begin
        if GenJournalLine."Payment Slip Type" <> GenJournalLine."Payment Slip Type"::" " then
            CustLedgerEntry."Payment Slip Type" := GenJournalLine."Payment Slip Type"
        else begin
            IF lPaymentMethod.Get(GenJournalLine."Payment Method Code") then
                CustLedgerEntry."Payment Slip Type" := lPaymentMethod."Payment Type";
        end;
        CustLedgerEntry."Payment Terms Code" := GenJournalLine."Payment Terms Code";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnAfterInitVendLedgEntry', '', FALSE, FALSE)]
    local procedure OnAfterInitVendLedgEntry(var VendorLedgerEntry: Record "Vendor Ledger Entry"; GenJournalLine: Record "Gen. Journal Line")
    var
        lPaymentMethod: record "Payment Method";
    begin
        if GenJournalLine."Payment Slip Type" <> GenJournalLine."Payment Slip Type"::" " then
            VendorLedgerEntry."Payment Slip Type" := GenJournalLine."Payment Slip Type"
        else begin
            IF lPaymentMethod.Get(GenJournalLine."Payment Method Code") then
                VendorLedgerEntry."Payment Slip Type" := lPaymentMethod."Payment Type";
        end;

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnBeforeInsertDtldVendLedgEntry', '', FALSE, FALSE)]
    local procedure OnBeforeInsertDtldVendLedgEntry(var DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry"; GenJournalLine: Record "Gen. Journal Line"; DtldCVLedgEntryBuffer: Record "Detailed CV Ledg. Entry Buffer"; GLRegister: Record "G/L Register")
    var
        lPaymentMethod: record "Payment Method";
    begin
        if GenJournalLine."Payment Slip Type" <> GenJournalLine."Payment Slip Type"::" " then
            DtldVendLedgEntry."Payment Slip Type" := GenJournalLine."Payment Slip Type"
        else begin
            IF lPaymentMethod.Get(GenJournalLine."Payment Method Code") then
                DtldVendLedgEntry."Payment Slip Type" := lPaymentMethod."Payment Type";
        end;
        //<<WDC01
        if GenJournalLine."Payment Reference" <> '' then
            DtldVendLedgEntry."Payment Reference" := GenJournalLine."Payment Reference";
        //>>WDC01
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnBeforeInsertDtldCustLedgEntry', '', FALSE, FALSE)]
    local procedure OnBeforeInsertDtldCustLedgEntry(var DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry"; GenJournalLine: Record "Gen. Journal Line"; DtldCVLedgEntryBuffer: Record "Detailed CV Ledg. Entry Buffer"; GLRegister: Record "G/L Register")
    var
        lPaymentMethod: record "Payment Method";
    begin
        if GenJournalLine."Payment Slip Type" <> GenJournalLine."Payment Slip Type"::" " then
            DtldCustLedgEntry."Payment Slip Type" := GenJournalLine."Payment Slip Type"
        else begin
            IF lPaymentMethod.Get(GenJournalLine."Payment Method Code") then
                DtldCustLedgEntry."Payment Slip Type" := lPaymentMethod."Payment Type";
        end;
        DtldCustLedgEntry."Payment Terms Code" := GenJournalLine."Payment Terms Code";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnAfterInitBankAccLedgEntry', '', FALSE, FALSE)]
    local procedure OnAfterInitBankAccLedgEntry(var BankAccountLedgerEntry: Record "Bank Account Ledger Entry"; GenJournalLine: Record "Gen. Journal Line")
    var
        lPaymentMethod: record "Payment Method";
    begin
        if GenJournalLine."Payment Slip Type" <> GenJournalLine."Payment Slip Type"::" " then
            BankAccountLedgerEntry."Payment Slip Type" := GenJournalLine."Payment Slip Type"
        else begin
            IF lPaymentMethod.Get(GenJournalLine."Payment Method Code") then
                BankAccountLedgerEntry."Payment Slip Type" := lPaymentMethod."Payment Type";
        end;

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnAfterInitGLEntry', '', FALSE, FALSE)]
    local procedure OnAfterInitGLEntry(var GLEntry: Record "G/L Entry"; GenJournalLine: Record "Gen. Journal Line")
    begin
        if GLEntry."G/L Account No." = '43200010' then
            GLEntry."Payment Slip Type" := GenJournalLine."Payment Slip Type"::RS
        else
            GLEntry."Payment Slip Type" := GenJournalLine."Payment Slip Type";
    end;
}