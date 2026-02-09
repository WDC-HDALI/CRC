//*************Documentation***************************
//WDC01  WDC.HG  09/07/2025  show new fields 
pageextension 50003 "WDC Posted Sales Shipments" extends "Posted Sales Shipments"
{

    CaptionML = FRA = 'Bon Livraison vente';
    AdditionalSearchTerms = 'Bon Livraison vente';

    layout
    {
        modify("Currency Code")
        {
            Visible = false;
        }
        modify("Location Code")
        {
            Visible = false;
        }
        modify("Shipping Agent Code")
        {
            ShowCaption = false;
        }
        modify("Shipping Agent Service Code")
        {
            ShowCaption = false;
        }

        addafter("Shipment Method Code")
        {
            field(ShippingAgentCode; Rec."Shipping Agent Code")
            {
                CaptionML = FRA = 'N° camion';
                ApplicationArea = All;
            }
            field(ShippingAgentServiceCode; Rec."Shipping Agent Service Code")
            {
                CaptionML = FRA = 'Code chauffeur';
                ApplicationArea = All;
            }
        }
        addbefore("Currency Code")
        {
            field(TotalPayer; TotalPayer)
            {
                CaptionML = ENU = 'Amount Including VAT', FRA = 'Montant TTC';
                ApplicationArea = all;
                Style = StrongAccent;
            }
            field("Remain to Invoice"; Rec."Remain to Invoice")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Remain to Delivery"; Rec."Remain to Delivery")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Not Totally Canceled"; Rec."Not Totally Canceled")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
        //<<WDC01
        addlast(Control1)
        {
            field(SystemCreatedAt; Rec.SystemCreatedAt)
            {
                ApplicationArea = all;
                Editable = false;
            }
        }
        //>>WDC01
    }
    trigger OnAfterGetRecord()
    var
        lsalesline: record "Sales Line";
    begin
        TotalRedevance := 0;
        TotalTransport := 0;
        TotalBrut := 0;
        TotalNetvcRemise := 0;
        TotalNetvcRemise := 0;
        MontantTva7 := 0;
        MontantTva19 := 0;
        MontantTva13 := 0;
        TotalSansTva := 0;
        TotalPayer := 0;
        //<<WDC02
        if rec."Order No." <> '' then begin
            SalesHeader.reset();
            if SalesHeader.get(SalesHeader."Document Type"::Order, rec."Order No.") then;
        end;
        //>>WDC02

        VSalesshipmentline.reset();
        VSalesshipmentline.SetCurrentKey("Document No.", "Line No.");
        VSalesshipmentline.setrange("Document No.", Rec."No.");
        if VSalesshipmentline.FindSet() then begin
            repeat
                if VSalesshipmentline.Quantity < 0 then begin
                    VSalesshipmentline."Item Charge Base Amount" := VSalesshipmentline."Item Charge Base Amount" * (-1);
                    vsalesshipmentline."VAT Base Amount" := vsalesshipmentline."VAT Base Amount" * (-1)
                end;
                if VSalesshipmentline.type = VSalesshipmentline.type::"Charge (Item)" then begin
                    ChargeItem.reset();
                    if ChargeItem.Get(VSalesshipmentline."No.") then
                        if ChargeItem."Gen. Prod. Posting Group" = 'REDEVANCE' then
                            if VSalesshipmentline."VAT Base Amount" <> 0 then
                                TotalRedevance += VSalesshipmentline."VAT Base Amount"
                            else if VSalesshipmentline."Item Charge Base Amount" <> 0 then
                                TotalRedevance += VSalesshipmentline."Item Charge Base Amount"
                            else
                                TotalRedevance += VSalesshipmentline.Quantity * VSalesshipmentline."Unit Price";

                end;
                item.reset();
                if item.get(VSalesshipmentline."No.") then
                    if (item."Associated With Iron" = true) or (item."Associated With Cement" = true) then begin
                        if VSalesshipmentline."VAT Base Amount" <> 0 then
                            TotalTransport += VSalesshipmentline."VAT Base Amount"
                        else if VSalesshipmentline."Item Charge Base Amount" <> 0 then
                            TotalTransport += VSalesshipmentline."Item Charge Base Amount"
                        else if VSalesshipmentline."Item Charge Base Amount" <> 0 then
                            TotalTransport += VSalesshipmentline."Item Charge Base Amount"
                        else
                            TotalTransport += VSalesshipmentline.Quantity * VSalesshipmentline."Unit Price";
                    end
                    else begin
                        TotalBrut += VSalesshipmentline.Quantity * VSalesshipmentline."Unit Price";
                        totalRemise += (VSalesshipmentline.Quantity * VSalesshipmentline."Unit Price") - VSalesshipmentline."Item Charge Base Amount";
                        if VSalesshipmentline."VAT Base Amount" <> 0 then
                            TotalNetvcRemise += VSalesshipmentline."VAT Base Amount"
                        else
                            TotalNetvcRemise += VSalesshipmentline."Item Charge Base Amount";
                    end;
                if SalesHeader."Invoice Discount Value" <> 0 then begin
                    lsalesline.reset();
                    if lsalesline.get(lsalesline."Document Type"::Order, VSalesshipmentline."Order No.", VSalesshipmentline."Line No.") then begin
                        if VSalesshipmentline."VAT %" = 7 then
                            MontantTva7 += lsalesline.Amount * (VSalesshipmentline."VAT %" / 100);
                        if VSalesshipmentline."VAT %" = 19 then
                            MontantTva19 += lsalesline.Amount * (VSalesshipmentline."VAT %" / 100);
                        if VSalesshipmentline."VAT %" = 13 then
                            MontantTva13 += lsalesline.Amount * (VSalesshipmentline."VAT %" / 100);
                    end;
                end
                else begin
                    if VSalesshipmentline."VAT %" = 7 then begin
                        if VSalesshipmentline."VAT Base Amount" <> 0 then
                            MontantTva7 += VSalesshipmentline."VAT Base Amount" * (VSalesshipmentline."VAT %" / 100)
                        else
                            MontantTva7 += VSalesshipmentline."Item Charge Base Amount" * (VSalesshipmentline."VAT %" / 100);
                    end;
                    if VSalesshipmentline."VAT %" = 19 then begin
                        if VSalesshipmentline."VAT Base Amount" <> 0 then
                            MontantTva19 += VSalesshipmentline."VAT Base Amount" * (VSalesshipmentline."VAT %" / 100)
                        else
                            MontantTva19 += VSalesshipmentline."Item Charge Base Amount" * (VSalesshipmentline."VAT %" / 100);
                    end;
                    if VSalesshipmentline."VAT %" = 13 then begin
                        if VSalesshipmentline."VAT Base Amount" <> 0 then
                            MontantTva13 += VSalesshipmentline."VAT Base Amount" * (VSalesshipmentline."VAT %" / 100)
                        else
                            MontantTva13 += VSalesshipmentline."Item Charge Base Amount" * (VSalesshipmentline."VAT %" / 100);
                    end;
                end;
            //TotalSansTva += VSalesshipmentline."Item Charge Base Amount";
            until VSalesshipmentline.Next() = 0;
            TotalSansTva += TotalNetvcRemise + TotalTransport + TotalRedevance;
            //<<WDC02
            if SalesHeader."Invoice Discount value" <> 0 then
                TotalSansTva := TotalSansTva - SalesHeader."Invoice Discount value";
            //<<WDC02
            TotalPayer := TotalSansTva + MontantTva7 + MontantTva19 + MontantTva13;
        end
    end;



    var
        VSalesshipmentline: record "Sales Shipment Line";
        TotalBrut: Decimal;
        totalRemise: Decimal;
        TotalNetvcRemise: decimal;
        MontantTva7: Decimal;
        MontantTva19: Decimal;
        MontantTva13: Decimal;
        TotalPayer: Decimal;
        TotalSansTva: decimal;
        item: record Item;
        TotalTransport: Decimal;
        ChargeItem: record "Item Charge";
        TotalRedevance: decimal;
        salesHeader: record "Sales Header";

}