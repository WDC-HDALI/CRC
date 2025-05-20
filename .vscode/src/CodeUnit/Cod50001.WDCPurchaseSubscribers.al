namespace CRC.CRC;
using Microsoft.Purchases.Posting;
using Microsoft.Purchases.Document;

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

}
