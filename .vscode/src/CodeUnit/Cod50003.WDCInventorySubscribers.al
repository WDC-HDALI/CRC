namespace CRC.CRC;
using Microsoft.Purchases.Posting;
using Microsoft.Finance.VAT.Setup;
using Microsoft.Inventory.Ledger;
using Microsoft.Inventory.Posting;
using Microsoft.Warehouse.History;
using Microsoft.Inventory.Journal;
using Microsoft.Inventory.Location;
using Microsoft.Sales.Customer;
using Microsoft.Inventory.History;
using Microsoft.Inventory.Item;
using Microsoft.Inventory.Document;
using Microsoft.Foundation.Reporting;
using Microsoft.Inventory.Transfer;
using Microsoft.Sales.Setup;
using Microsoft.Finance.GeneralLedger.Posting;
using Microsoft.Finance.GeneralLedger.Ledger;
using Microsoft.Sales.History;
using Microsoft.Sales.Document;
using Microsoft.Sales.Posting;
using Microsoft.Warehouse.Document;
using Microsoft.Purchases.History;
using Microsoft.Purchases.Document;
using Microsoft.Finance.GeneralLedger.Setup;
using Microsoft.Sales.Receivables;
using Microsoft.Finance.GeneralLedger.Journal;
//*******************Documentation************************
//WDC01  WDC.HG  19/05/2025  post invt. Shipment document
//WDC02  WDC.HG  29/05/2025  Post Payment Statut
//WDC03  WDC.HG  30/05/2025  Post bank payment 
//WDC04  WDC.HG  10/06/2025  InsertBorderauLookup
//WDC06  WDC.HG  23/06/2025  block the purchase order printout if the status is open
//wdc07  WDC.FS  26/06/2025 Transfer the Order Transfer to Posted Transfer Shipments

codeunit 50003 "WDC Inventory Subscribers"
{
    // Enleve l'option de la réception et laisser que l'expédition 
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post (Yes/No)", 'OnBeforeGetPostingOptions', '', FALSE, FALSE)]
    procedure OnBeforeGetPostingOptions(TransferHeader: Record "Transfer Header"; Selection: Option; var PostShipment: Boolean; var PostReceipt: Boolean; var IsHandled: Boolean; var PostTransfer: Boolean; var DefaultNumber: Integer; PostBatch: Boolean; PreviewMode: Boolean)
    var
        lText001: TextConst ENU = 'Do you want to post this order',
                            FRA = 'Voulez-vous valider le transfert?';
        lText002: TextConst ENU = 'Operation is cancelled',
                            FRA = 'Opération annulée';
    begin
        if Not Confirm(StrSubstNo(lText001)) then
            Error(lText002);
        if Not TransferHeader."Direct Transfer" then begin
            DefaultNumber := 1;
            PostShipment := true;
            PostReceipt := false;
            IsHandled := true;
        end;
    end;
    //<<WDC01

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Invt. Doc.-Post Shipment", 'OnRunOnBeforeInvtShptHeaderInsert', '', FALSE, FALSE)]
    local procedure OnRunOnBeforeInvtShptHeaderInsert(var InvtShptHeader: Record "Invt. Shipment Header"; InvtDocHeader: Record "Invt. Document Header")
    begin
        InvtShptHeader.CustomerNo := InvtDocHeader.CustomerNo;
        InvtShptHeader.CustomerName := InvtDocHeader.CustomerName;
        InvtShptHeader.CustomerAddress := InvtDocHeader.CustomerAddress;
        InvtShptHeader.CustomerPhoneNo := InvtDocHeader.CustomerPhoneNo;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Invt. Doc.-Post Shipment", 'OnRunOnBeforeInvtShptLineInsert', '', FALSE, FALSE)]
    local procedure OnRunOnBeforeInvtShptLineInsert(var InvtShptLine: Record "Invt. Shipment Line"; InvtDocLine: Record "Invt. Document Line"; var InvtShipmentHeader: Record "Invt. Shipment Header"; InvtDocumentHeader: Record "Invt. Document Header")
    begin
        InvtShptLine."VAT %" := InvtDocLine."VAT %";
        InvtShptLine."Line Discount %" := InvtDocLine."Line Discount %";
        InvtShptLine."Line Discount Amount" := InvtDocLine."Line Discount Amount";
        InvtShptLine."Line Amount HT" := InvtDocLine."Line Amount HT";
        InvtShptLine."Amount Including VAT" := InvtDocLine."Amount Including VAT";
        InvtShptLine."Line VAT Amount" := InvtDocLine."Line VAT Amount";

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Invt. Doc.-Post Shipment", 'OnAfterOnRun', '', FALSE, FALSE)]

    local procedure OnAfterOnRun(var InvtDocumentHeader: Record "Invt. Document Header"; InvtDocumentHeader2: Record "Invt. Document Header"; var InvtDocumentLine: Record "Invt. Document Line"; InvtShipmentHeader: Record "Invt. Shipment Header"; InvtShipmentLine: Record "Invt. Shipment Line")
    var
        OpenNewInvoiceQst: TextConst ENU = 'the Inventory Shipment has been posted  to posted Inventory Shipment  %1. \ Do you want to open the new Inventory Shipment ?',
                                                 FRA = 'La sortie stock a été convertie en sortie stock validée (%1).\ Souhaitez-vous ouvrir cette nouvelle sortie stock ?';
    begin
        if Confirm(StrSubstNo(OpenNewInvoiceQst, InvtShipmentHeader."No.")) then begin
            PAGE.Run(PAGE::WDCPostedInvtShipment, InvtShipmentHeader);
        end;
    end;
    //>>WDC01


    [EventSubscriber(ObjectType::Table, database::"Purchase Header", OnBeforePrintRecords, '', FALSE, FALSE)]
    local procedure OnBeforePrintRecords(var PurchaseHeader: Record "Purchase Header"; ShowRequestForm: Boolean; var IsHandled: Boolean)
    var
        err01: TextConst FRA = 'Statut doit être égal à ''Lancé'' dans En-tête achat: Type document=%1, N°=%2.', ENU = 'Status must be equal to ''Released'' in Purchase Header: Document Type=%1, No.=%2.';
    begin
        if PurchaseHeader.TestStatusIsNotReleased() then
            ERROR(StrSubstNo(err01, PurchaseHeader."Document Type", PurchaseHeader."No."))
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Document-Print", 'OnBeforeDoPrintPurchHeader', '', FALSE, FALSE)]
    local procedure OnBeforeDoPrintPurchHeader(var PurchHeader: Record "Purchase Header"; ReportUsage: Integer; SendAsEmail: Boolean; var IsPrinted: Boolean)
    var
        err01: TextConst FRA = 'Statut doit être égal à ''Lancé'' dans En-tête achat: Type document=%1, N°=%2.', ENU = 'Status must be equal to ''Released'' in Purchase Header: Document Type=%1, No.=%2.';
    begin
        if PurchHeader.TestStatusIsNotReleased() then
            ERROR(StrSubstNo(err01, PurchHeader."Document Type", PurchHeader."No."))
    end;

    [EventSubscriber(ObjectType::Table, database::"Purchase Header", OnBeforeSendRecords, '', FALSE, FALSE)]
    local procedure OnBeforeSendRecords(var PurchaseHeader: Record "Purchase Header"; var IsHandled: Boolean)
    var
        err01: TextConst FRA = 'Statut doit être égal à ''Lancé'' dans En-tête achat: Type document=%1, N°=%2.', ENU = 'Status must be equal to ''Released'' in Purchase Header: Document Type=%1, No.=%2.';
    begin
        if PurchaseHeader.TestStatusIsNotReleased() then
            ERROR(StrSubstNo(err01, PurchaseHeader."Document Type", PurchaseHeader."No."))
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Document-Print", 'OnDoPrintPurchaseHeaderToDocumentAttachmentOnBeforeRunSaveAsDocumentAttachment', '', FALSE, FALSE)]
    local procedure OnDoPrintPurchaseHeaderToDocumentAttachmentOnBeforeRunSaveAsDocumentAttachment(var PurchaseHeader: Record "Purchase Header"; ReportUsage: Integer; ShowNotificationAction: Boolean; var IsHandled: Boolean)
    var
        err01: TextConst FRA = 'Statut doit être égal à ''Lancé'' dans En-tête achat: Type document=%1, N°=%2.', ENU = 'Status must be equal to ''Released'' in Purchase Header: Document Type=%1, No.=%2.';
    begin
        if PurchaseHeader.TestStatusIsNotReleased() then
            ERROR(StrSubstNo(err01, PurchaseHeader."Document Type", PurchaseHeader."No."))
    end;

    [EventSubscriber(ObjectType::Table, database::"Purchase Header", OnBeforeOnDelete, '', FALSE, FALSE)]
    local procedure OnBeforeOnDelete(var PurchaseHeader: Record "Purchase Header"; var IsHandled: Boolean)
    begin
        PurchaseHeader.TestStatusOpen();
    end;
    //>>WDC06


    //<<wdc07
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post (Yes/No)", 'OnAfterPost', '', false, false)]
    local procedure OnAfterPost(TransHeader: Record "Transfer Header"; Selection: Option)
    var
        TransferShipmentHeader: Record "Transfer Shipment Header";
    begin

        TransferShipmentHeader.SetRange("Transfer Order No.", TransHeader."No.");
        if TransferShipmentHeader.FindFirst() then
            PAGE.Run(PAGE::"Posted Transfer Shipments", TransferShipmentHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post (Yes/No)", 'OnBeforePost', '', false, false)]

    local procedure OnBeforePost(var TransHeader: Record "Transfer Header"; var IsHandled: Boolean; var TransferOrderPostShipment: Codeunit "TransferOrder-Post Shipment"; var TransferOrderPostReceipt: Codeunit "TransferOrder-Post Receipt"; var PostBatch: Boolean; var TransferOrderPost: Enum "Transfer Order Post")
    var
        Location: Record Location;
    begin
        if Location.Get(TransHeader."Transfer-to Code") then
            if Location."Customer Mandatory" then
                TransHeader.TestField("Customer No.");
    end;



    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Shipment", 'OnAfterCreateItemJnlLine', '', false, false)]
    local procedure OnAfterCreateItemJnlLine(var ItemJournalLine: Record "Item Journal Line"; TransferLine: Record "Transfer Line"; TransferShipmentHeader: Record "Transfer Shipment Header"; TransferShipmentLine: Record "Transfer Shipment Line")
    var
        TransferHeader: Record "Transfer Header";
    begin
        if TransferHeader.Get(TransferLine."Document No.") then begin
            ItemJournalLine."Customer No." := TransferHeader."Customer No.";
            ItemJournalLine."Customer Name" := TransferHeader."Customer Name";
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnAfterInitItemLedgEntry', '', false, false)]
    local procedure OnAfterInitItemLedgEntry(var NewItemLedgEntry: Record "Item Ledger Entry"; var ItemJournalLine: Record "Item Journal Line"; var ItemLedgEntryNo: Integer)
    begin
        NewItemLedgEntry."Customer No." := ItemJournalLine."Customer No.";
        NewItemLedgEntry."Customer Name" := ItemJournalLine."Customer Name";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Shipment", 'OnAfterTransferOrderPostShipment', '', false, false)]

    local procedure OnAfterTransferOrderPostShipment(var TransferHeader: Record "Transfer Header"; CommitIsSuppressed: Boolean; var TransferShipmentHeader: Record "Transfer Shipment Header"; InvtPickPutaway: Boolean)
    begin
        TransferShipmentHeader."Customer No." := TransferHeader."Customer No.";
        TransferShipmentHeader."Customer Name" := TransferHeader."Customer Name";
        TransferShipmentHeader.Modify();
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterInsertReceiptHeader', '', false, false)]

    local procedure OnAfterInsertReceiptHeader(var PurchHeader: Record "Purchase Header"; var PurchRcptHeader: Record "Purch. Rcpt. Header"; var TempWhseRcptHeader: Record "Warehouse Receipt Header" temporary; WhseReceive: Boolean; CommitIsSuppressed: Boolean)
    begin
        PurchRcptHeader.Note := TempWhseRcptHeader.Note;
        PurchRcptHeader.Modify();
    end;

    //>>wdc07

    //<<Control Deleting Posted document

    [EventSubscriber(ObjectType::Table, database::"Posted Whse. Receipt Header", OnBeforeDeleteEvent, '', FALSE, FALSE)]
    local procedure OnBeforeDeleteEventWhseRCP(var Rec: Record "Posted Whse. Receipt Header")
    var
        ltext001: TextConst ENU = 'You cannot delete a posted document', FRA = 'Vous ne pouvez pas supprimer un document validé';
    begin
        error(ltext001)
    end;

    [EventSubscriber(ObjectType::Table, database::"Posted Whse. Shipment Header", OnBeforeDeleteEvent, '', FALSE, FALSE)]
    local procedure OnBeforeDeleteEventWhseShp(var Rec: Record "Posted Whse. Shipment Header")
    var
        ltext001: TextConst ENU = 'You cannot delete a posted document', FRA = 'Vous ne pouvez pas supprimer un document validé';
    begin
        error(ltext001)
    end;

    [EventSubscriber(ObjectType::Table, database::"Transfer Shipment Header", OnBeforeDeleteEvent, '', FALSE, FALSE)]
    local procedure OnBeforeDeleteEventTransshp(var Rec: Record "Transfer Shipment Header")
    var
        ltext001: TextConst ENU = 'You cannot delete a posted document', FRA = 'Vous ne pouvez pas supprimer un document validé';
    begin
        error(ltext001)
    end;

    [EventSubscriber(ObjectType::Table, database::"Transfer Receipt Header", OnBeforeDeleteEvent, '', FALSE, FALSE)]
    local procedure OnBeforeDeleteEventTransRecp(var Rec: Record "Transfer Receipt Header")
    var
        ltext001: TextConst ENU = 'You cannot delete a posted document', FRA = 'Vous ne pouvez pas supprimer un document validé';
    begin
        error(ltext001)
    end;
    //>>Control Deleting Posted document
}