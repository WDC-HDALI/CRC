//**************Documentation**************
// WDC.FS 09/06/2025: Add fields
pageextension 50032 "WDC Whse. Receipt Subform" extends "Whse. Receipt Subform"
{
    layout
    {
        modify(Quantity)
        {
            trigger OnAfterValidate()
            begin
                CurrPage.Update(false);
            end;
        }
        modify("Qty. to Receive")
        {
            trigger OnAfterValidate()
            begin
                CalculateAmounts();
                CurrPage.Update(false);
            end;
        }
        addafter("Qty. to Receive")
        {
            field("Unit Code"; Rec."Unit of Measure Code")
            {
                ApplicationArea = all;

            }
        }
        modify("Qty. per Unit of Measure")
        {
            Visible = false;
        }
        modify("Qty. to Cross-Dock")
        {
            Visible = false;
        }
        modify("Unit of Measure Code")
        {
            Visible = false;
        }
        addafter("Unit of Measure Code")
        {
            field("Direct Unit Cost"; Rec."Direct Unit Cost")
            {
                ApplicationArea = All;
            }
            field("Line Discount %"; Rec."Line Discount %")
            {
                ApplicationArea = All;
                Editable = false;
            }

            field(LineAmount; LineAmount)
            {
                CaptionML = ENU = 'Line Amount HT', FRA = 'Montant ligne HT';
                ApplicationArea = All;
                Editable = false;
            }
            field("VAT %"; Rec."VAT %")
            {
                CaptionML = ENU = 'VAT %', FRA = 'TVA %';
                ApplicationArea = All;
                Editable = false;
            }
            field(VATAmount; VATAmount)
            {
                CaptionML = ENU = 'VAT Amount', FRA = 'Montant TVA';
                ApplicationArea = All;
                Editable = false;
            }
            field(AmountInclVAT; AmountInclVAT)
            {
                CaptionML = ENU = 'Amount Incl. VAT', FRA = 'Montant TTC';
                ApplicationArea = All;
                Editable = false;
            }
        }
        addlast(content)
        {
            group("Totals")
            {
                ShowCaption = false;

                field("Total HT"; TotalHT)
                {
                    ApplicationArea = All;
                    Editable = false;
                    CaptionML = ENU = 'Total excl. VAT', FRA = 'Total HT';
                    Style = Strong;
                }
                field("Total TVA"; TotalTVA)
                {
                    ApplicationArea = All;
                    Editable = false;
                    CaptionML = ENU = 'Total VAT', FRA = 'Total TVA';
                    Style = Strong;
                }
                field("Total TTC"; TotalTTC)
                {
                    ApplicationArea = All;
                    Editable = false;
                    CaptionML = ENU = 'Total incl. VAT', FRA = 'Total TTC';
                    Style = Strong;
                }
            }
        }
    }
    trigger OnAfterGetRecord()

    begin
        CalculateAmounts();
    end;

    procedure CalculateAmounts()
    var
        lWhseReceiptLine: Record "Warehouse Receipt Line";
    begin
        TotalHT := 0;
        TotalTVA := 0;
        TotalTTC := 0;
        LineAmount := Rec."Qty. to Receive" * Rec."Direct Unit Cost" - Rec."Discount Amount";
        VATAmount := (Rec."Qty. to Receive" * Rec."Direct Unit Cost" - Rec."Discount Amount") * Rec."VAT %" / 100;
        AmountInclVAT := LineAmount + VATAmount;

        lWhseReceiptLine.Reset();
        lWhseReceiptLine.SetCurrentKey("No.", "Source Type", "Source Subtype", "Source No.", "Source Line No.");
        lWhseReceiptLine.SetRange("No.", Rec."No.");
        if lWhseReceiptLine.FindFirst() then
            repeat
                lWhseReceiptLine.CalcFields("Direct Unit Cost", "VAT %", "Discount Amount", "Line Discount %");
                TotalHT += lWhseReceiptLine."Qty. to Receive" * lWhseReceiptLine."Direct Unit Cost" - lWhseReceiptLine."Discount Amount";
                TotalTVA += (lWhseReceiptLine."Qty. to Receive" * lWhseReceiptLine."Direct Unit Cost" - lWhseReceiptLine."Discount Amount") * lWhseReceiptLine."VAT %" / 100;
            until lWhseReceiptLine.Next() = 0;
        TotalTTC := TotalHT + TotalTVA;
        CurrPage.Update(false);
    end;

    var
        LineAmount: Decimal;
        VATAmount: Decimal;
        AmountInclVAT: Decimal;
        TotalHT: Decimal;
        TotalTVA: Decimal;
        TotalTTC: Decimal;

}