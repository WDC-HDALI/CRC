namespace CRC.CRC;
using Microsoft.Sales.History;
using Microsoft.Inventory.Item;
using Microsoft.Sales.Document;
//****************Documentation**********************
//wdc01  WDC.FS  25/06/2025 Add field "Invoice No." 
//WDC02  WDC.HG  01/07/2025  Add the No. of the posted invoice
//WDC03  WDC.HG  27/08/2025  Add filters and the total ttc to the list
page 50004 "Sales Shipments to Post"
{
    ApplicationArea = All;
    CaptionML = ENU = 'Sales Shipments to Post', FRA = 'Expéditions vente à Valider';
    PageType = StandardDialog;
    SourceTable = "Sales Shipment Header";

    //Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    layout
    {
        area(Content)
        {
            //<<WDC03
            group(Filtres)
            {
                ShowCaption = false;
                field(ShipmentNoFilter; ShipmentNo)
                {
                    ApplicationArea = All;
                    CaptionML = ENU = 'No.', FRA = 'N°';
                    TableRelation = "Sales Shipment Header"."No." where("Sell-to Customer No." = field("Sell-to Customer No."), "Remain to Delivery" = filter(true));
                    trigger OnValidate()
                    begin
                        if ShipmentNo <> '' then begin
                            Rec.Setfilter("No.", '%1', ShipmentNo);
                            CurrPage.Update(false);
                        end
                        else begin
                            Rec.RESET();
                            CurrPage.Update(false);
                        end;
                    end;
                }
                field(InvoiceNoFilter; InvoiceNo)
                {
                    ApplicationArea = All;
                    CaptionML = ENU = 'Invoice No.', FRA = 'N° facture';
                    TableRelation = "Sales Invoice Header"."No." where("Sell-to Customer No." = field("Sell-to Customer No."));
                    trigger OnValidate()
                    begin
                        if InvoiceNo <> '' then begin
                            Rec.SetFilter("Posted description", '%1', InvoiceNo);
                            CurrPage.Update(false);
                        end
                        else begin
                            Rec.RESET();
                            CurrPage.Update(false);
                        end;
                    end;
                }
                //>>WDC03
            }
            repeater(General)
            {
                CaptionML = ENU = 'General', FRA = 'Général';
                Editable = false;
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Posting Description"; Rec."Posting Description")
                {
                    ApplicationArea = All;
                    VISIBLE = false;
                }
                //<<wdc02
                field("Posted description"; Rec."Posted description")
                {
                    DrillDown = false;
                    CaptionML = ENU = 'Invoice No.', FRA = 'N° Facture';
                    ApplicationArea = All;
                }
                //>>WDC02
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                //<<WDC03
                field(TotalTTC; TotamAmountTTC)
                {
                    CaptionML = ENU = 'Amount Including VAT', FRA = 'Montant TTC';
                    ApplicationArea = all;
                    Style = StrongAccent;
                    Editable = false;
                }
                //>>WDC03
                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                    ApplicationArea = All;
                }
                field("Sell-to Customer Name"; Rec."Sell-to Customer Name")
                {
                    ApplicationArea = All;
                }
                field("Ship-to Address"; Rec."Ship-to Address")
                {
                    ApplicationArea = All;
                }
                field("Ship-to Address 2"; Rec."Ship-to Address 2")
                {
                    ApplicationArea = All;
                }
                field("Ship-to City"; Rec."Ship-to City")
                {
                    ApplicationArea = All;
                }
                field("Ship-to Post Code"; Rec."Ship-to Post Code")
                {
                    ApplicationArea = All;
                }
                field("Ship-to Country/Region Code"; Rec."Ship-to Country/Region Code")
                {
                    ApplicationArea = All;
                }
                field("Transport Method"; Rec."Transport Method")
                {
                    ApplicationArea = All;
                }
                field("Shipping Agent Code"; Rec."Shipping Agent Code")
                {
                    ApplicationArea = All;
                }


            }
        }
    }
    trigger OnAfterGetRecord()
    var
        myInt: Integer;
    begin
        TotamAmountTTC := GetTotalTTC();
    end;

    procedure GetTotalTTC(): Decimal

    var

        lsalesline: record "Sales Line";
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
        if rec."Order No." <> '' then begin
            SalesHeader.reset();
            if SalesHeader.get(SalesHeader."Document Type"::Order, rec."Order No.") then;
        end;
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
            until VSalesshipmentline.Next() = 0;
            TotalSansTva += TotalNetvcRemise + TotalTransport + TotalRedevance;
            if SalesHeader."Invoice Discount value" <> 0 then
                TotalSansTva := TotalSansTva - SalesHeader."Invoice Discount value";
            TotalPayer := TotalSansTva + MontantTva7 + MontantTva19 + MontantTva13;
            exit(TotalPayer);
        end;
    end;

    var
        ShipmentNo: code[20];
        InvoiceNo: text[100];
        TotamAmountTTC: Decimal;
}