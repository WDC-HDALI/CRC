pageextension 54036 "WDC-ST Purch. Cr. Memo Subform" extends "Purch. Cr. Memo Subform"
{
    layout
    {
        modify("Total Amount Incl. VAT")
        {
            Style = None;
            Visible = false;
        }
        modify("Qty. to Assign")
        {
            Visible = false;
        }

        addafter("Total Amount Incl. VAT")
        {
            field(StampAmount; StampAmount)
            {
                CaptionClass = GetCaptionWithCurrencyCode(StampCaption, Rec."Currency Code");
                ApplicationArea = All;
                Editable = false;
            }
            field(TotalInvoice; TotalInvoice)
            {
                CaptionClass = GetCaptionWithCurrencyCode(TotalTTCCaption, rec."Currency Code");
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
        lPurchLine: Record "Purchase Line";
        lPurchHeader: Record "Purchase Header";
    begin
        StampAmount := 0;
        if lPurchHeader.Get(Rec."Document Type", Rec."Document No.") then begin
            StampAmount := lPurchHeader."Stamp Amount";
            lPurchHeader.CalcFields("Amount Including VAT");
            TotalInvoice := lPurchHeader."Amount Including VAT" + StampAmount;
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