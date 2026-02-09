pageextension 54042 "WDC-ST Sales Cr. Memo Subform" extends "Sales Cr. Memo Subform"
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
        modify("Line Discount %")
        {
            trigger OnAfterValidate()
            begin
                CurrPage.Update();
            end;
        }
        modify("Line Discount Amount")
        {
            trigger OnAfterValidate()
            begin
                CurrPage.Update();
            end;
        }
        modify("Unit Price")
        {
            trigger OnAfterValidate()
            begin
                CurrPage.Update();
            end;
        }
        addafter("Total Amount Incl. VAT")
        {
            field(StampAmount; StampAmount)
            {
                CaptionClass = GetCaptionWithCurrencyCode(StampCaption, rec."Currency Code");
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

    trigger OnAfterGetCurrRecord()
    var
    begin
        UpdateAmountIncludingVAT;
    end;

    trigger OnAfterGetRecord()
    var

    begin
        UpdateAmountIncludingVAT;
    end;

    Procedure UpdateAmountIncludingVAT()
    var
        lSalesLine: Record "Sales Line";
        lSalesHeader: Record "Sales Header";

    begin
        StampAmount := 0;
        if lSalesHeader.Get(Rec."Document Type", Rec."Document No.") then begin
            StampAmount := lSalesHeader."Stamp Amount";
            lSalesHeader.CalcFields("Amount Including VAT");
            if lSalesHeader."Amount Including VAT" <> 0 then
                TotalInvoice := lSalesHeader."Amount Including VAT" + StampAmount;
            CurrPage.Update(false);
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