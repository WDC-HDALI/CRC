codeunit 50060 "WDC-TF Subscr TransitFolder"
{
    [EventSubscriber(ObjectType::Table, database::"Vendor Ledger Entry", 'OnAfterCopyVendLedgerEntryFromGenJnlLine', '', FALSE, FALSE)]
    local procedure OnAfterCopyVendLedgerEntryFromGenJnlLine(var VendorLedgerEntry: Record "Vendor Ledger Entry"; GenJournalLine: Record "Gen. Journal Line")
    begin
        VendorLedgerEntry."Transit Folder No." := GenJournalLine."Transit Folder No.";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnBeforeInsertDtldVendLedgEntry', '', FALSE, FALSE)]
    local procedure OnBeforeInsertDtldVendLedgEntry(var DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry"; GenJournalLine: Record "Gen. Journal Line"; DtldCVLedgEntryBuffer: Record "Detailed CV Ledg. Entry Buffer"; GLRegister: Record "G/L Register")
    begin
        DtldVendLedgEntry."Transit Folder No." := GenJournalLine."Transit Folder No.";
    end;

    [EventSubscriber(ObjectType::Table, database::"Item Journal Line", 'OnAfterCopyItemJnlLineFromPurchHeader', '', FALSE, FALSE)]
    local procedure OnAfterCopyItemJnlLineFromPurchHeader(var ItemJnlLine: Record "Item Journal Line"; PurchHeader: Record "Purchase Header")
    begin
        ItemJnlLine."Transit Folder No." := PurchHeader."Transit Folder No.";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnAfterInitItemLedgEntry', '', FALSE, FALSE)]
    local procedure OnAfterInitItemLedgEntry(var NewItemLedgEntry: Record "Item Ledger Entry"; var ItemJournalLine: Record "Item Journal Line"; var ItemLedgEntryNo: Integer)
    begin
        NewItemLedgEntry."Transit Folder No." := ItemJournalLine."Transit Folder No.";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnInitValueEntryOnAfterAssignFields', '', FALSE, FALSE)]
    local procedure OnInitValueEntryOnAfterAssignFields(var ValueEntry: Record "Value Entry"; ItemLedgEntry: Record "Item Ledger Entry"; ItemJnlLine: Record "Item Journal Line")
    begin
        ValueEntry."Transit Folder No." := ItemJnlLine."Transit Folder No.";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Get Receipt", 'OnAfterPurchRcptLineSetFilters', '', FALSE, FALSE)]
    local procedure OnAfterPurchRcptLineSetFilters(var PurchRcptLine: Record "Purch. Rcpt. Line"; PurchaseHeader: Record "Purchase Header")
    var
        Lvendor: Record Vendor;
    begin
        Lvendor.GET(PurchaseHeader."Buy-from Vendor No.");
        IF Lvendor."Foreign Vendor" THEN
            PurchaseHeader.TESTFIELD("Transit Folder No.");
        IF PurchaseHeader."Transit Folder No." <> '' THEN
            PurchRcptLine.SETRANGE("Transit Folder No.", PurchaseHeader."Transit Folder No.");
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Charge Assgnt. (Purch.)", 'OnBeforeInsertItemChargeAssgntWithAssignValues', '', FALSE, FALSE)]
    local procedure OnBeforeInsertItemChargeAssgntWithAssignValues(var ItemChargeAssgntPurch: Record "Item Charge Assignment (Purch)"; FromItemChargeAssgntPurch: Record "Item Charge Assignment (Purch)")
    begin
        ItemChargeAssgntPurch."Transit Folder No." := FromItemChargeAssgntPurch."Transit Folder No.";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Charge Assgnt. (Purch.)", 'OnBeforeCreateRcptChargeAssgnt', '', FALSE, FALSE)]
    local procedure OnBeforeCreateRcptChargeAssgnt(var FromPurchRcptLine: Record "Purch. Rcpt. Line"; ItemChargeAssignmentPurch: Record "Item Charge Assignment (Purch)"; var IsHandled: Boolean)
    var
        ItemChargeAssgntPurch2: Record "Item Charge Assignment (Purch)";
        NextLine: Integer;
        "Item Charge Assgnt. (Purch.)": Codeunit "Item Charge Assgnt. (Purch.)";
    begin
        if IsHandled then
            exit;

        FromPurchRcptLine.TestField("Work Center No.", '');
        NextLine := ItemChargeAssignmentPurch."Line No.";
        ItemChargeAssgntPurch2.SetRange("Document Type", ItemChargeAssignmentPurch."Document Type");
        ItemChargeAssgntPurch2.SetRange("Document No.", ItemChargeAssignmentPurch."Document No.");
        ItemChargeAssgntPurch2.SetRange("Document Line No.", ItemChargeAssignmentPurch."Document Line No.");
        ItemChargeAssgntPurch2.SetRange(
          "Applies-to Doc. Type", ItemChargeAssgntPurch2."Applies-to Doc. Type"::Receipt);
        repeat
            ItemChargeAssgntPurch2.SetRange("Applies-to Doc. No.", FromPurchRcptLine."Document No.");
            ItemChargeAssgntPurch2.SetRange("Applies-to Doc. Line No.", FromPurchRcptLine."Line No.");
            FromPurchRcptLine.CalcFields("Transit Folder No.");
            ItemChargeAssignmentPurch."Transit Folder No." := FromPurchRcptLine."Transit Folder No.";
            if not ItemChargeAssgntPurch2.FindFirst() then
                "Item Charge Assgnt. (Purch.)".InsertItemChargeAssignment(
                    ItemChargeAssignmentPurch, ItemChargeAssgntPurch2."Applies-to Doc. Type"::Receipt,
                    FromPurchRcptLine."Document No.", FromPurchRcptLine."Line No.",
                    FromPurchRcptLine."No.", FromPurchRcptLine.Description, NextLine);
        until FromPurchRcptLine.Next() = 0;
        IsHandled := true;
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnCheckAndUpdateOnBeforeSetPostingFlags', '', FALSE, FALSE)]
    local procedure OnCheckAndUpdateOnBeforeSetPostingFlags(var PurchHeader: Record "Purchase Header"; var TempPurchLineGlobal: Record "Purchase Line" temporary)
    var
        TransitFolder: Record "WDC-TF Transit Folder";
        UserSetup: Record "User Setup";
        lPurchaseLine: Record 39;
        Text061: TextConst ENU = 'This folder is closed',
                           FRA = 'Le dossier d''import utilisé est clôturé';
    begin
        IF TransitFolder.GET(PurchHeader."Transit Folder No.") THEN BEGIN
            UserSetup.GET(USERID);
            IF TransitFolder.Statut = TransitFolder.Statut::Closed THEN
                IF UserSetup."Allow Item Charge Assignement" = FALSE THEN
                    ERROR(Text061);
            lPurchaseLine.SETRANGE("Document Type", PurchHeader."Document Type");
            lPurchaseLine.SETRANGE("Document No.", PurchHeader."No.");
            lPurchaseLine.SETRANGE(Type, lPurchaseLine.Type::Item);
            lPurchaseLine.SETFILTER(Quantity, '<>%1', 0);
            IF (NOT lPurchaseLine.ISEMPTY) THEN
                TransitFolder.Statut := TransitFolder.Statut::"Goods Receipt"
            ELSE
                TransitFolder.Statut := TransitFolder.Statut::Invoiced;
            TransitFolder.MODIFY;

        END;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterCheckTrackingAndWarehouseForShip', '', FALSE, FALSE)]
    local procedure OnAfterCheckTrackingAndWarehouseForShip(var PurchaseHeader: Record "Purchase Header"; var Ship: Boolean; CommitIsSupressed: Boolean; var TempPurchaseLine: Record "Purchase Line" temporary; var TempWarehouseShipmentHeader: Record "Warehouse Shipment Header" temporary; var TempWarehouseReceiptHeader: Record "Warehouse Receipt Header" temporary)
    var
        lVendor: Record Vendor;

    begin
        IF lVendor.GET(PurchaseHeader."Buy-from Vendor No.") THEN
            IF lVendor."Foreign Vendor" THEN
                IF PurchaseHeader."Document Type" IN [PurchaseHeader."Document Type"::Order, PurchaseHeader."Document Type"::Invoice] THEN
                    IF PurchaseHeader."Transit Folder No." = '' THEN
                        ERROR(Text062);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnPostVendorEntryOnAfterInitNewLine', '', FALSE, FALSE)]
    local procedure OnPostVendorEntryOnAfterInitNewLine(var PurchaseHeader: Record "Purchase Header"; var GenJnlLine: Record "Gen. Journal Line")

    begin
        GenJnlLine."Transit Folder No." := PurchaseHeader."Transit Folder No.";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforePostPurchLine', '', FALSE, FALSE)]
    local procedure OnBeforePostPurchLine(var PurchHeader: Record "Purchase Header"; var PurchLine: Record "Purchase Line"; var IsHandled: Boolean)
    var
        lVendor: Record Vendor;
        lChargeItem: Record "Item Charge";
    begin
        if PurchHeader."Transit Folder No." = '' then begin
            if PurchLine.Type = PurchLine.Type::"Charge (Item)" then
                if lChargeItem.Get(PurchLine."No.") then
                    if lChargeItem."Mandatory Transit Folder No." then
                        ERROR(Text062);
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforePostInvoice', '', FALSE, FALSE)]
    local procedure OnBeforePostInvoice(var PurchHeader: Record "Purchase Header"; PreviewMode: Boolean; CommitIsSupressed: Boolean; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; var IsHandled: Boolean; var Window: Dialog; HideProgressWindow: Boolean; var TotalPurchLine: Record "Purchase Line"; var TotalPurchLineLCY: Record "Purchase Line"; var InvoicePostingInterface: Interface "Invoice Posting"; var InvoicePostingParameters: Record "Invoice Posting Parameters"; GenJnlLineDocNo: Code[20]; GenJnlLineExtDocNo: Code[35]; GenJnlLineDocType: Enum "Gen. Journal Document Type"; SrcCode: Code[10])
    var
        lVendor: Record Vendor;
    begin
        IF PurchHeader."Transit Folder No." = '' THEN
            IF lVendor.GET(PurchHeader."Buy-from Vendor No.") THEN
                IF lVendor."Foreign Vendor" THEN
                    IF PurchHeader."Document Type" IN [PurchHeader."Document Type"::Order, PurchHeader."Document Type"::Invoice] THEN
                        ERROR(Text062);
    end;

    // procedure CheckChargeItemTransitFolder(pPurchaseHeader: Record "Purchase Header")
    // var
    //     lPurchaseLine: Record "Purchase Line";
    //     lChargeItem: Record "Item Charge";
    // begin
    //     IF pPurchaseHeader."Transit Folder No." = '' THEN BEGIN
    //         lPurchaseLine.reset;
    //         lPurchaseLine.SetRange("Document Type", pPurchaseHeader."Document Type");
    //         lPurchaseLine.SetRange("Document No.", pPurchaseHeader."No.");
    //         lPurchaseLine.SetRange(Type, lPurchaseLine.Type::"Charge (Item)");
    //         if lPurchaseLine.FindFirst() then
    //             repeat
    //                 if lChargeItem.Get(lPurchaseLine."No.") then
    //                     if lChargeItem."Mandatory Transit Folder No." then
    //                         ERROR(Text062);
    //             until lPurchaseLine.Next() = 0;
    //     END;
    // end;

    var
        Text062: TextConst ENU = 'Please, fill the transit folder No. to user charge item',
                           FRA = 'Veuillez renseigner SVP le N° dossier d''importation.';
}
