//**************Documentation**************
//wdc01  WDC.FS 09/06/2025: Add fields
//wdc02  WDC.FS 24/02/2026: Add action
pageextension 50034 "WDC Posted Purch Rcpt. Sub" extends "Posted Purchase Rcpt. Subform"
{
    layout
    {
        addafter("Unit of Measure Code")
        {
            // field("Unité de réception"; Rec."Unité de réception")
            // {
            //     ApplicationArea = all;
            // }
            // field("Qté de réception"; Rec."Qté de réception")
            // {
            //     ApplicationArea = all;
            // }

        }
    }
    //<<wdc02
    actions
    {
        addlast(Processing)
        {
            action(OpenRelatedPurchaseInvoice)
            {
                ApplicationArea = All;
                CaptionML = ENU = 'Related Purchase Invoice', FRA = 'Facture achat correspondante';
                Image = Invoice;

                trigger OnAction()
                var
                    TempPurchInvLine: Record "Purch. Inv. Line" temporary;
                    PurchInvHeader: Record "Purch. Inv. Header";
                    TEXT001: Label 'Aucune facture  achat n a été trouvée pour cette ligne.';

                begin
                    rec.GetPurchInvLines(TempPurchInvLine);

                    if TempPurchInvLine.IsEmpty() then begin
                        Message(TExt001);
                        exit;
                    end;

                    TempPurchInvLine.FindFirst();

                    PurchInvHeader.RESET;
                    PurchInvHeader.SetRange("No.", TempPurchInvLine."Document No.");

                    if PurchInvHeader.FindSet() THEN
                        Page.Run(Page::"Posted Purchase Invoice", PurchInvHeader)

                end;
            }
        }
    }
    //>>wdc02
}