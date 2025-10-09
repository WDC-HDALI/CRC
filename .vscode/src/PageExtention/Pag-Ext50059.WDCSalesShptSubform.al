//****************Documentation***************
//WDC01  WDC.HG 29/07/2025 Create Current Object : Continuation of  valuation of posted sales shipment
namespace CRC.CRC;

using Microsoft.Sales.History;
using Microsoft.Sales.Document;

pageextension 50059 "WDC Sales Shpt Subform" extends "Posted Sales Shpt. Subform"
{
    layout
    {
        addafter("Unit of Measure Code")
        {
            field("unit price"; Rec."unit price")
            {
                ApplicationArea = All;
                Editable = false;
                CaptionML = ENU = 'Unit Price incl. Discount', FRA = 'Prix unitaire HT';
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
                }
                field("Total TVA"; TotalTVA)
                {
                    ApplicationArea = All;
                    Editable = false;
                    CaptionML = ENU = 'Total VAT', FRA = 'Total TVA';
                }
                field("Total TTC"; TotalTTC)
                {
                    ApplicationArea = All;
                    Editable = false;
                    CaptionML = ENU = 'Total incl. VAT', FRA = 'Total TTC';
                }

            }

        }

    }
    var
        TotalHT: Decimal;
        TotalTVA: Decimal;
        TotalTTC: Decimal;

    trigger OnAfterGetRecord()
    var
        salesshipmentline: record "Sales Shipment Line";
        lLineAmount: Decimal;
        salesheader: record "Sales Header";
        lsalesline: record "Sales Line";
    begin
        if rec."Order No." <> '' then begin
            salesheader.reset();
            if salesheader.get(salesheader."Document Type"::Order, rec."Order No.") then;
        end;
        if rec.Quantity < 0 then begin
            rec."Item Charge Base Amount" := rec."Item Charge Base Amount" * (-1);
            rec."VAT Base Amount" := rec."VAT Base Amount" * (-1)
        end;
        if rec."Item Charge Base Amount" <> 0 then
            LineAmount := rec."Item Charge Base Amount"
        else if rec."VAT Base Amount" <> 0 then
            LineAmount := rec."VAT Base Amount"
        else begin

            if rec."Line Discount %" <> 0 then
                LineAmount := (rec.Quantity * rec."Unit Price") * (1 - (rec."Line Discount %" / 100))
            else
                LineAmount := round((rec.Quantity * rec."Unit Price"), 0.001, '=');
        end;
        TotalHT := 0;
        TotalTVA := 0;
        TotalTTC := 0;
        lLineAmount := 0;
        salesshipmentline.reset();
        salesshipmentline.SetCurrentKey("Document No.", "Line No.");
        salesshipmentline.SetRange("Document No.", Rec."Document No.");
        if salesshipmentline.FindSet() then
            repeat
                if salesshipmentline.Quantity < 0 then begin
                    salesshipmentline."Item Charge Base Amount" := salesshipmentline."Item Charge Base Amount" * (-1);
                    salesshipmentline."VAT Base Amount" := salesshipmentline."VAT Base Amount" * (-1)
                end;
                if salesshipmentline."VAT Base Amount" <> 0 then
                    lLineAmount := salesshipmentline."VAT Base Amount"
                else if salesshipmentline."Item Charge Base Amount" <> 0 then
                    lLineAmount := salesshipmentline."Item Charge Base Amount"
                else begin
                    if salesshipmentline."Line Discount %" <> 0 then
                        lLineAmount := (salesshipmentline.Quantity * salesshipmentline."Unit Price") * (1 - (salesshipmentline."Line Discount %" / 100))
                    else
                        lLineAmount := round((salesshipmentline.Quantity * salesshipmentline."Unit Price"), 0.001, '=');
                end;
                TotalHT += lLineAmount;
                if salesheader."Invoice Discount Value" <> 0 then begin
                    lsalesline.reset();
                    if lsalesline.get(lsalesline."Document Type"::order, salesshipmentline."Order No.", salesshipmentline."Line No.") then
                        TotalTva += lsalesline.Amount * (salesshipmentline."VAT %" / 100);
                end
                else
                    TotalTva += lLineAmount * (salesshipmentline."VAT %" / 100);
            until salesshipmentline.Next() = 0;
        if salesheader."Invoice Discount Value" <> 0 then
            TotalHT := TotalHT - salesheader."Invoice Discount Value";
        TotalTTC := TotalHT + TotalTVA;
    end;

    var
        LineAmount: Decimal;


}



