pageextension 54039 "WDC-ST PST Sales Invoice Subf" extends "Posted Sales Invoice Subform"
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
        lSalesInvLine: Record "Sales Invoice Line";
        lPostedSalesInv: Record "Sales Invoice Header";

    begin
        StampAmount := 0;
        if lPostedSalesInv.Get(Rec."Document No.") then begin
            StampAmount := lPostedSalesInv."Stamp Amount";
            lPostedSalesInv.CalcFields("Amount Including VAT");
            TotalInvoice := lPostedSalesInv."Amount Including VAT" + StampAmount;
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