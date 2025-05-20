codeunit 54000 "WDC-ST Sales Subscribers"
{
    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnValidateBilltoCustomerTemplCodeOnBeforeRecreateSalesLines', '', false, false)]
    local procedure OnValidateBilltoCustomerTemplateCodeBeforeRecreateSalesLinesValidateStamp(var SalesHeader: Record "Sales Header"; CallingFieldNo: Integer)
    var
        lCustomerPostingGroup: Record "Customer Posting Group";
        BillToCustTemplate: Record "Customer Templ.";
        GeneralLedgerSetup: Record "General Ledger Setup";
    begin
        if BillToCustTemplate.Get(SalesHeader."Bill-to Customer Templ. Code") then begin // CHG01
            IF lCustomerPostingGroup.GET(SalesHeader."Customer Posting Group") THEN BEGIN
                SalesHeader."Apply Fiscal Stamp" := lCustomerPostingGroup."Apply Fiscal Stamp";
                if lCustomerPostingGroup."Apply Fiscal Stamp" THEN
                    SalesHeader."Stamp Amount" := lCustomerPostingGroup."Stamp Amount";
            END;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterCopyFromNewSellToCustTemplate', '', false, false)]//CHG01
    local procedure OnAfterCopyFromSellToCustTemplateApplyStamp(var SalesHeader: Record "Sales Header"; SellToCustTemplate: Record "Customer Templ.")
    var
        lCustomerPostingGroup: Record "Customer Posting Group";
    begin
        IF lCustomerPostingGroup.GET(SalesHeader."Customer Posting Group") THEN BEGIN
            SalesHeader."Apply Fiscal Stamp" := lCustomerPostingGroup."Apply Fiscal Stamp";
            if lCustomerPostingGroup."Apply Fiscal Stamp" THEN
                SalesHeader."Stamp Amount" := lCustomerPostingGroup."Stamp Amount";
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterSetFieldsBilltoCustomer', '', false, false)]
    local procedure OnAfterSetFieldsBilltoCustomerApplyStamp(var SalesHeader: Record "Sales Header"; Customer: Record Customer)
    var
        lCustomerPostingGroup: Record "Customer Posting Group";
    begin
        lCustomerPostingGroup.GET(SalesHeader."Customer Posting Group");
        SalesHeader."Apply Fiscal Stamp" := lCustomerPostingGroup."Apply Fiscal Stamp";
        IF lCustomerPostingGroup."Apply Fiscal Stamp" THEN
            SalesHeader."Stamp Amount" := lCustomerPostingGroup."Stamp Amount";
    end;

    [EventSubscriber(ObjectType::Codeunit, 825, 'OnPostLedgerEntryOnAfterGenJnlPostLine', '', false, false)]
    local procedure OnPostLedgerEntryOnAfterGenJnlPostLine(var GenJnlLine: Record "Gen. Journal Line"; var SalesHeader: Record "Sales Header"; var TotalSalesLine: Record "Sales Line"; var TotalSalesLineLCY: Record "Sales Line"; PreviewMode: Boolean; SuppressCommit: Boolean; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line")
    var
        SalesFunctions: Codeunit "WDC-ST Sales&PurchaseHook";
        tt: Codeunit 825;
    begin
        SalesFunctions.SalesPostTimbre(SalesHeader, GenJnlPostLine, GenJnlLine);
    end;

    [EventSubscriber(ObjectType::Codeunit, 825, 'OnPostLedgerEntryOnBeforeGenJnlPostLine', '', false, false)]
    local procedure OnPostLedgerEntryOnBeforeGenJnlPostLine(var GenJnlLine: Record "Gen. Journal Line"; var SalesHeader: Record "Sales Header"; var TotalSalesLine: Record "Sales Line"; var TotalSalesLineLCY: Record "Sales Line"; PreviewMode: Boolean; SuppressCommit: Boolean; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line")
    var
        CustomerPostingGroup: Record "Customer Posting Group";
        lStampAmount: Decimal;
        CuSalesPurchHook: Codeunit "WDC-ST Sales&PurchaseHook";
    begin
        CustomerPostingGroup.GET(SalesHeader."Customer Posting Group");
        IF SalesHeader."Apply Fiscal Stamp" THEN BEGIN
            CustomerPostingGroup.TestField("Apply Fiscal Stamp");
            CustomerPostingGroup.TESTFIELD("Fiscal Stamp Account No.");
            CustomerPostingGroup.TESTFIELD("Stamp Amount");
            lStampAmount := 0;
            lStampAmount := CustomerPostingGroup."Stamp Amount";
            IF GenJnlLine."Document Type" = GenJnlLine."Document Type"::"Credit Memo" THEN BEGIN
                GenJnlLine.Amount := GenJnlLine.Amount - lStampAmount;
                GenJnlLine."Source Currency Amount" := GenJnlLine."Source Currency Amount" - lStampAmount;
                GenJnlLine."Amount (LCY)" := GenJnlLine."Amount (LCY)" - lStampAmount;
            END
            ELSE BEGIN
                GenJnlLine.Amount := GenJnlLine.Amount + lStampAmount;
                GenJnlLine."Source Currency Amount" := GenJnlLine."Source Currency Amount" + lStampAmount;
                GenJnlLine."Amount (LCY)" := GenJnlLine."Amount (LCY)" + lStampAmount;
            END;
        end;

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforeSalesInvHeaderInsert', '', false, false)]
    local procedure OnBeforeSalesInvHeaderInsert(var SalesInvHeader: Record "Sales Invoice Header"; SalesHeader: Record "Sales Header"; CommitIsSuppressed: Boolean)
    var
        CustomerPostingGroup: Record "Customer Posting Group";
        lStampAmount: Decimal;
    begin
        CustomerPostingGroup.GET(SalesHeader."Customer Posting Group");
        IF SalesHeader."Apply Fiscal Stamp" THEN BEGIN
            CustomerPostingGroup.TestField("Apply Fiscal Stamp");
            CustomerPostingGroup.TESTFIELD("Fiscal Stamp Account No.");
            CustomerPostingGroup.TESTFIELD("Stamp Amount");
            lStampAmount := 0;
            lStampAmount := CustomerPostingGroup."Stamp Amount";
            SalesInvHeader."Stamp Amount" := lStampAmount;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Quote to Order", 'OnBeforeInsertSalesOrderHeader', '', false, false)]
    local procedure OnBeforeInsertSalesOrderHeaderApllyStamp(var SalesOrderHeader: Record "Sales Header"; SalesQuoteHeader: Record "Sales Header")
    begin
        SalesOrderHeader."Apply Fiscal Stamp" := SalesQuoteHeader."Apply Fiscal Stamp";
        SalesOrderHeader."Stamp Amount" := SalesQuoteHeader."Stamp Amount";
    end;

    [EventSubscriber(ObjectType::Page, 397, 'OnBeforeCalculateTotals', '', false, false)]
    local procedure OnBeforeCalculateTotalsAddStamp(SalesInvoiceHeader: Record "Sales Invoice Header"; var CustAmount: Decimal; var AmountInclVAT: Decimal; var InvDiscAmount: Decimal; var CostLCY: Decimal; var TotalAdjCostLCY: Decimal; var LineQty: Decimal; var TotalNetWeight: Decimal; var TotalGrossWeight: Decimal; var TotalVolume: Decimal; var TotalParcels: Decimal; var IsHandled: Boolean)
    begin
        AmountInclVAT := AmountInclVAT + SalesInvoiceHeader."Stamp Amount";
    end;

}