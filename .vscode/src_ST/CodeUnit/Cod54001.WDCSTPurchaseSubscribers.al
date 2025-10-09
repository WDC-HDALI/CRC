//****************Documentation*************
//WDC01  WDC.HG  22/09/2025 Correct the Credit Memo Entry 
codeunit 54001 "WDC-ST Purchase Subscribers"
{
    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnAfterValidateEvent', "Buy-from Vendor No.", false, false)]
    local procedure OnAfterUpdateBuyFromVend(var Rec: Record "Purchase Header")
    var
        lVendorPostingGroup: Record "Vendor Posting Group";
        BillToVendorTemplate: Record "Vendor Templ.";
    begin
        IF lVendorPostingGroup.GET(Rec."Vendor Posting Group") THEN BEGIN
            Rec."Apply Fiscal Stamp" := lVendorPostingGroup."Apply Fiscal Stamp";
            if Rec."Apply Fiscal Stamp" THEN
                Rec."Stamp Amount" := lVendorPostingGroup."Stamp Amount"
            else
                Rec."Stamp Amount" := 0;
        end;
    end;



    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnValidatePaytoVendorNoBeforeRecreateLines', '', false, false)]
    local procedure OnValidatePayToVendorTemplateCodeBeforeRecreatePurchaseLinesValidateStamp(var PurchaseHeader: Record "Purchase Header"; CallingFieldNo: Integer)
    var
        lVendorPostingGroup: Record "Vendor Posting Group";
        BillToVendorTemplate: Record "Vendor Templ.";
    begin
        IF lVendorPostingGroup.GET(PurchaseHeader."Vendor Posting Group") THEN BEGIN
            PurchaseHeader."Apply Fiscal Stamp" := lVendorPostingGroup."Apply Fiscal Stamp";
            if PurchaseHeader."Apply Fiscal Stamp" THEN
                PurchaseHeader."Stamp Amount" := lVendorPostingGroup."Stamp Amount"
            else
                PurchaseHeader."Stamp Amount" := 0;
        end;

    end;
    //WDC.CHG>>
    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnAfterCopyBuyFromVendorFieldsFromVendor', '', false, false)]
    local procedure OnAfterCopyFromVendorFieldsFromVendorApplyStamp(var PurchaseHeader: Record "Purchase Header")
    var
        lVendorPostingGroup: Record "Vendor Posting Group";
    begin
        IF lVendorPostingGroup.GET(PurchaseHeader."vendor Posting Group") THEN BEGIN
            PurchaseHeader."Apply Fiscal Stamp" := lVendorPostingGroup."Apply Fiscal Stamp";
            if PurchaseHeader."Apply Fiscal Stamp" THEN
                PurchaseHeader."Stamp Amount" := lVendorPostingGroup."Stamp Amount"
            else
                PurchaseHeader."Stamp Amount" := 0;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnAfterSetShipToForSpecOrder', '', false, false)]
    local procedure OnAfterSetShipToForSpecOrderApplyStamp(var PurchaseHeader: Record "Purchase Header")
    var
        lVendorPostingGroup: Record "Vendor Posting Group";
    begin
        lVendorPostingGroup.GET(PurchaseHeader."Vendor Posting Group");
        PurchaseHeader."Apply Fiscal Stamp" := lVendorPostingGroup."Apply Fiscal Stamp";
        IF lVendorPostingGroup."Apply Fiscal Stamp" THEN
            PurchaseHeader."Stamp Amount" := lVendorPostingGroup."Stamp Amount"
        else
            PurchaseHeader."Stamp Amount" := 0;
    end;


    [EventSubscriber(ObjectType::Codeunit, 90, 'OnBeforePurchInvHeaderInsert', '', false, false)]
    local procedure OnBeforePurchInvHeaderInsert(var PurchInvHeader: Record "Purch. Inv. Header"; PurchHeader: Record "Purchase Header"; CommitIsSupressed: Boolean)
    var
        VendorPostingGroup: Record "Vendor Posting Group";
        MntTimbre: Decimal;
    begin
        VendorPostingGroup.GET(PurchHeader."Vendor Posting Group");
        IF PurchHeader."Apply Fiscal Stamp" THEN BEGIN
            VendorPostingGroup.TestField("Apply Fiscal Stamp");
            VendorPostingGroup.TESTFIELD("Fiscal Stamp Account No.");
            VendorPostingGroup.TESTFIELD("Stamp Amount");
            MntTimbre := 0;
            MntTimbre := VendorPostingGroup."Stamp Amount";
            PurchInvHeader."Stamp Amount" := MntTimbre;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Quote to Order", 'OnCreatePurchHeaderOnBeforePurchOrderHeaderInsert', '', false, false)]
    local procedure OnBeforeInsertPurchOrderHeaderApllyStamp(var PurchOrderHeader: Record "Purchase Header"; PurchHeader: Record "Purchase Header")
    begin
        PurchOrderHeader."Apply Fiscal Stamp" := PurchHeader."Apply Fiscal Stamp";
        PurchOrderHeader."Stamp Amount" := PurchHeader."Stamp Amount";
        PurchHeader."Amount Including VAT" += PurchHeader."Stamp Amount"; //HD01::Ajout timbre au montant total de la facture
    end;

    [EventSubscriber(ObjectType::Codeunit, 826, 'OnPostLedgerEntryOnBeforeGenJnlPostLine', '', false, false)]
    local procedure OnBeforePostVendorEntryAddStampAmount(var GenJnlLine: Record "Gen. Journal Line"; var PurchHeader: Record "Purchase Header"; var TotalPurchLine: Record "Purchase Line"; var TotalPurchLineLCY: Record "Purchase Line"; PreviewMode: Boolean; SuppressCommit: Boolean; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line")
    var
        VendorPostingGroup: Record "Vendor Posting Group";
        MntTimbre: Decimal;
        CuSalesPurchHook: Codeunit "WDC-ST Sales&PurchaseHook";
    begin
        VendorPostingGroup.GET(PurchHeader."Vendor Posting Group");
        IF PurchHeader."Apply Fiscal Stamp" THEN BEGIN
            VendorPostingGroup.TestField("Apply Fiscal Stamp");
            VendorPostingGroup.TESTFIELD("Fiscal Stamp Account No.");
            VendorPostingGroup.TESTFIELD("Stamp Amount");
            MntTimbre := 0;
            MntTimbre := VendorPostingGroup."Stamp Amount";
            //<<WDC01
            if GenJnlLine.Amount < 0 then begin
                GenJnlLine.Amount := GenJnlLine.Amount - MntTimbre;
                GenJnlLine."Source Currency Amount" := GenJnlLine."Source Currency Amount" - MntTimbre;
                GenJnlLine."Amount (LCY)" := GenJnlLine."Amount (LCY)" - MntTimbre;
            end
            else begin
                GenJnlLine.Amount := GenJnlLine.Amount + MntTimbre;
                GenJnlLine."Source Currency Amount" := GenJnlLine."Source Currency Amount" + MntTimbre;
                GenJnlLine."Amount (LCY)" := GenJnlLine."Amount (LCY)" + MntTimbre;
            end;
            //>>WDC01
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, 826, 'OnPostLedgerEntryOnAfterGenJnlPostLine', '', false, false)]
    local procedure OnPostLedgerEntryOnAfterGenJnlPostLine(var GenJnlLine: Record "Gen. Journal Line"; var PurchHeader: Record "Purchase Header"; var TotalPurchLine: Record "Purchase Line"; var TotalPurchLineLCY: Record "Purchase Line"; PreviewMode: Boolean; SuppressCommit: Boolean; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line")
    var
        PurChaseFunctions: Codeunit "WDC-ST Sales&PurchaseHook";
    begin
        PurChaseFunctions.PurchPostTimbre(PurchHeader, GenJnlPostLine, GenJnlLine);
    end;

    [EventSubscriber(ObjectType::Page, Page::"Purchase Statistics", 'OnAfterCalculateTotals', '', false, false)]
    local procedure OnAfterCalculateTotalsAddStamp(var PurchHeader: Record "Purchase Header"; var TotalPurchLine: Record "Purchase Line"; var TotalPurchLineLCY: Record "Purchase Line"; var TempVATAmountLine: Record "VAT Amount Line"; var TotalAmt1: Decimal; var TotalAmt2: Decimal)
    begin
        TotalAmt2 += PurchHeader."Stamp Amount";
    end;
}