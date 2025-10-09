namespace CRC.CRC;

using Microsoft.Sales.History;
using Microsoft.Inventory.Item;

page 50023 "WDC Sales Shipment Not Inv."
{
    ApplicationArea = All;
    CaptionML = ENU = 'Sales Shipment Not Inv.', FRA = 'BL non facturées';
    PageType = ListPart;
    SourceTable = "Sales Shipment Header";
    SourceTableView = where("Remain to Invoice" = const(true));
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = all;
                    TableRelation = "Sales Shipment Header";
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                    ApplicationArea = All;
                }
                field("Sell-to Customer Name"; Rec."Sell-to Customer Name")
                {
                    ApplicationArea = All;
                }
                field(TotalPayer; TotalPayer)
                {
                    CaptionML = ENU = 'Amount Including VAT', FRA = 'Montant TTC';
                    ApplicationArea = all;
                    Style = StrongAccent;
                }
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
        }
    }
    trigger OnAfterGetRecord()
    var
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


        VSalesshipmentline.reset();
        VSalesshipmentline.SetCurrentKey("Document No.", "Line No.");
        VSalesshipmentline.setrange("Document No.", Rec."No.");
        if VSalesshipmentline.FindSet() then begin
            repeat
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
                        TotalNetvcRemise += VSalesshipmentline."Item Charge Base Amount";
                    end;
                if VSalesshipmentline."VAT %" = 7 then
                    MontantTva7 += VSalesshipmentline."Item Charge Base Amount" * (VSalesshipmentline."VAT %" / 100);
                if VSalesshipmentline."VAT %" = 19 then
                    MontantTva19 += VSalesshipmentline."Item Charge Base Amount" * (VSalesshipmentline."VAT %" / 100);
                if VSalesshipmentline."VAT %" = 13 then
                    MontantTva13 += VSalesshipmentline."Item Charge Base Amount" * (VSalesshipmentline."VAT %" / 100);
            //TotalSansTva += VSalesshipmentline."Item Charge Base Amount";
            until VSalesshipmentline.Next() = 0;
            TotalSansTva += TotalNetvcRemise + TotalTransport + TotalRedevance;
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
}
