namespace CRC.CRC;
using Microsoft.Purchases.Posting;
using Microsoft.Inventory.Transfer;
using Microsoft.Purchases.Document;

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


}
