namespace CRC.CRC;

using Microsoft.Purchases.Document;
using System.Security.User;
using Microsoft.Purchases.History;

pageextension 50069 "WDC Posted Purchase Invoice" extends "Posted Purchase Invoice"
{
    layout
    {
        modify("Payment Method Code")
        {
            Editable = false;
        }
    }
    actions
    {

        addlast(processing)
        {
            action(DeleteInvoice)
            {
                ApplicationArea = All;
                CaptionML = ENU = 'Cancel Invoice', FRA = 'Annuler la facture';
                Image = Delete;
                PromotedCategory = Process;
                Promoted = true;
                PromotedIsBig = true;
                Visible = IsDeleteInvoiceVisible;
                trigger OnAction()
                var
                    lCancelPurchaseInv: Report "WDC Cancel Pstd Purch Invoice";
                    lPurchInvoiceHeader: Record "Purch. Inv. Header";
                    lText001: textconst ENU = 'You cannot delete this invoice, please contact your administrator!',
                                     FRA = 'Vous n''avez pas l''autorisation de supprimer la facture';
                begin
                    if Not UserSetup."Allow Delete Purch. Invoice" then
                        error(lText001);
                    lPurchInvoiceHeader.Reset();
                    lPurchInvoiceHeader.SetRange("No.", Rec."No.");
                    If lPurchInvoiceHeader.FindFirst() then begin
                        lCancelPurchaseInv.SetTableView(lPurchInvoiceHeader);
                        lCancelPurchaseInv.Run();
                    end;
                end;
            }
        }
    }
    trigger OnAfterGetRecord()

    begin
        UserSetup.get(UserId);
        IsDeleteInvoiceVisible := UserSetup."Allow Delete sales Invoice";

        CurrPage.Update(false);
    end;


    Var
        UserSetup: Record "User Setup";
        IsDeleteInvoiceVisible: Boolean;
}
