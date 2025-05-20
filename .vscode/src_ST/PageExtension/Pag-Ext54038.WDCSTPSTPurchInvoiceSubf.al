pageextension 54038 "WDC-ST PST Purch. Invoice Subf" extends "Posted Purch. Invoice Subform"
{
    layout
    {
        modify("Total Amount Incl. VAT")
        {
            Style = None;
            Visible = false;
        }

        addafter("Total Amount Incl. VAT")
        {

            field(StampAmount; StampAmount)
            {
                CaptionClass = GetCaptionWithCurrencyCode(StampCaption, rec.GetCurrencyCode());
                ApplicationArea = All;
                Editable = false;
            }
            field(TotalInvoice; TotalInvoice)
            {
                CaptionClass = GetCaptionWithCurrencyCode(TotalTTCCaption, rec.GetCurrencyCode());
                ApplicationArea = All;
                Editable = false;
                Style = Strong;
            }

        }
    }
    trigger OnOpenPage()
    begin
        StampAmount := 0;
    end;

    trigger OnAfterGetRecord()
    var
        lPurchInvLine: Record "Purch. Inv. Line";
        lPostedPurchInv: Record "Purch. Inv. Header";

    begin
        StampAmount := 0;
        if lPostedPurchInv.Get(Rec."Document No.") then begin
            StampAmount := lPostedPurchInv."Stamp Amount";
            lPostedPurchInv.CalcFields("Amount Including VAT");
            TotalInvoice := lPostedPurchInv."Amount Including VAT" + StampAmount;
        end;
    end;

    local procedure GetCaptionWithCurrencyCode(CaptionWithoutCurrencyCode: Text; CurrencyCode: Code[10]): Text
    var
        GLSetup: Record "General Ledger Setup";
    begin
        if CurrencyCode = '' then begin
            GLSetup.Get();
            CurrencyCode := GLSetup.GetCurrencyCode(CurrencyCode);
        end;

        if CurrencyCode <> '' then
            exit(CaptionWithoutCurrencyCode + StrSubstNo(' (%1)', CurrencyCode));

        exit(CaptionWithoutCurrencyCode);
    end;

    var
        StampCaption: TextConst ENU = 'STAMP AMOUNT', FRA = 'Timbre';
        TotalTTCCaption: TextConst ENU = 'TOTAL TTC', FRA = 'Total TTC';
        StampAmount: Decimal;
        TotalInvoice: Decimal;
}