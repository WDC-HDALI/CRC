namespace CRC.CRC;
using Microsoft.Purchases.Posting;
using Microsoft.Purchases.Document;
using Microsoft.Warehouse.Document;
using Microsoft.Warehouse.History;
using Microsoft.Purchases.History;

codeunit 50001 "WDC Purchase Subscribers"
{
    // Enleve l'option de validation et laisser que la réception
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post (Yes/No)", 'OnBeforeConfirmPost', '', FALSE, FALSE)]
    local procedure OnBeforeConfirmPost(var PurchaseHeader: Record "Purchase Header"; var HideDialog: Boolean; var IsHandled: Boolean; var DefaultOption: Integer)
    Var

        lText001: TextConst ENU = 'Do you want to post this order',
                            FRA = 'Voulez-vous valider la commande?';
        lText002: TextConst ENU = 'Operation is cancelled',
                            FRA = 'Opération annulée';
    begin
        if PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Order then begin
            if Not Confirm(StrSubstNo(lText001)) then
                Error(lText002);
            DefaultOption := 1;
            HideDialog := true;
            PurchaseHeader.Receive := true;
        end;
    end;
    //<<Control Deleting Posted document
    [EventSubscriber(ObjectType::Table, database::"Purch. Inv. Header", OnBeforeDeleteEvent, '', FALSE, FALSE)]
    local procedure OnBeforeDeleteEvent(var Rec: Record "Purch. Inv. Header")
    var
        ltext001: TextConst ENU = 'You cannot delete a posted document', FRA = 'Vous ne pouvez pas supprimer un document validé';
    begin
        error(ltext001)
    end;

    [EventSubscriber(ObjectType::Table, database::"Purch. Cr. Memo Hdr.", OnBeforeDeleteEvent, '', FALSE, FALSE)]
    local procedure OnBeforeDeleteEventCRMemo(var Rec: Record "Purch. Cr. Memo Hdr.")
    var
        ltext001: TextConst ENU = 'You cannot delete a posted document', FRA = 'Vous ne pouvez pas supprimer un document validé';
    begin
        error(ltext001)
    end;

    [EventSubscriber(ObjectType::Table, database::"Purch. Rcpt. Header", OnBeforeDeleteEvent, '', FALSE, FALSE)]
    local procedure OnBeforeDeleteEventshp(var Rec: Record "Purch. Rcpt. Header")
    var
        ltext001: TextConst ENU = 'You cannot delete a posted document', FRA = 'Vous ne pouvez pas supprimer un document validé';
    begin
        error(ltext001)
    end;

    [EventSubscriber(ObjectType::Table, database::"Return Shipment Header", OnBeforeDeleteEvent, '', FALSE, FALSE)]
    local procedure OnBeforeDeleteEventRetRec(var Rec: Record "Return Shipment Header")
    var
        ltext001: TextConst ENU = 'You cannot delete a posted document', FRA = 'Vous ne pouvez pas supprimer un document validé';
    begin
        error(ltext001)
    end;
    //>>Control Deleting Posted document

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Post Receipt", 'OnCreatePostedRcptLineOnBeforeSetPostedSourceDocument', '', FALSE, FALSE)]
    procedure OnCreatePostedRcptLineOnBeforeSetPostedSourceDocument(var PostedWhseReceiptLine: Record "Posted Whse. Receipt Line"; WarehouseReceiptLine: Record "Warehouse Receipt Line")
    begin
        PostedWhseReceiptLine."Unité de réception" := WarehouseReceiptLine."Unité de réception";
        PostedWhseReceiptLine."Qté de réception" := WarehouseReceiptLine."Qté de réception";
    end;


    [EventSubscriber(ObjectType::Codeunit, 90, 'OnBeforeCheckAndUpdate', '', false, false)]
    local procedure OnBeforeCheckAndUpdate(var PurchaseHeader: Record "Purchase Header"; var ModifyHeader: Boolean)
    begin
        PurchaseHeader.Validate("Payment Method Code", '');
    end;

}
