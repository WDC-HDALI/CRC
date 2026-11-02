namespace CRC.CRC;

using Microsoft.Purchases.Document;
using System.Security.User;
using Microsoft.Purchases.History;

pageextension 50070 "WDC Posted Purch. Credit Memo" extends "Posted Purchase Credit Memo"
{

    actions
    {

        addlast(processing)
        {
            action(DeleteInvoice)
            {
                ApplicationArea = All;
                CaptionML = ENU = 'Cancel Invoice', FRA = 'Annuler l''avoir';
                Image = Delete;
                PromotedCategory = Process;
                Promoted = true;
                PromotedIsBig = true;
                Visible = IsDeleteInvoiceVisible;
                trigger OnAction()
                var
                    lCancelPurchaseCrMemo: Report "WDC Cancel Purch Credit Memo";
                    lPurchCrMemoHeader: Record "Purch. Cr. Memo Hdr.";
                    lText001: textconst ENU = 'You cannot delete this Cr. Memo, please contact your administrator!',
                                     FRA = 'Vous n''avez pas l''autorisation de supprimer l''avoir';
                begin
                    if Not UserSetup."Allow Delete Purch. Invoice" then
                        error(lText001);
                    lPurchCrMemoHeader.Reset();
                    lPurchCrMemoHeader.SetRange("No.", Rec."No.");
                    If lPurchCrMemoHeader.FindFirst() then begin
                        lCancelPurchaseCrMemo.SetTableView(lPurchCrMemoHeader);
                        lCancelPurchaseCrMemo.Run();
                    end;
                end;

            }
        }
    }
    trigger OnOpenPage()
    begin
        rec.SetCurrentKey("Posting Date");
    end;

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
