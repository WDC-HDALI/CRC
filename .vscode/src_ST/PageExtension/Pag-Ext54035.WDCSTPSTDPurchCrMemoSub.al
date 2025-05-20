pageextension 54035 "WDC-ST PSTD Purch. CrMemoSub." extends "Posted Purch. Cr. Memo Subform"
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
        lPostedPurchCrMemoLine: Record "Purch. Cr. Memo Line";
        lPostedPurchCrMemoHeader: Record "Purch. Cr. Memo Hdr.";

    begin
        StampAmount := 0;
        if lPostedPurchCrMemoHeader.Get(Rec."Document No.") then begin
            StampAmount := lPostedPurchCrMemoHeader."Stamp Amount";
            lPostedPurchCrMemoHeader.CalcFields("Amount Including VAT");
            TotalInvoice := lPostedPurchCrMemoHeader."Amount Including VAT" + StampAmount;
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