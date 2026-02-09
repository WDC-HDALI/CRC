pageextension 54037 "WDC-ST Purch. Invoice Subform" extends "Purch. Invoice Subform"
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
        modify(Quantity)
        {
            trigger OnAfterValidate()
            begin
                CurrPage.Update();
            end;
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
        modify("Direct Unit Cost")
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



    procedure UpdateAmountIncludingVAT()
    var
        lPurchLine: Record "Purchase Line";
        lPurchHeader: Record "Purchase Header";

    begin
        StampAmount := 0;
        if lPurchHeader.Get(Rec."Document Type", Rec."Document No.") then begin
            StampAmount := lPurchHeader."Stamp Amount";
            lPurchHeader.CalcFields("Amount Including VAT");
            if lPurchHeader."Amount Including VAT" <> 0 then
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