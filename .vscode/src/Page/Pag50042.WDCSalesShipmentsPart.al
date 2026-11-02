

Page 50042 "WDC Sales Shipments Part"
{
    ApplicationArea = All;
    CaptionML = ENU = 'Sales Shipments',
                FRA = 'Bons de livraison';
    PageType = ListPart;
    SourceTable = "Sales Shipment Header";
    CardPageId = "Posted Sales Shipment";
    DeleteAllowed = false;
    ModifyAllowed = false;
    InsertAllowed = false;
    SourceTableView = sorting("Posting Date") where("Sell-to Customer No." = filter('<>9999'),
    "Not Totally Canceled" = filter(true),
    "Customer Posting Group" = filter(<> 'C-PASSAGER'));
    layout
    {
        area(Content)
        {

            repeater(General)

            {
                Editable = false;
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
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
                field(LineAmountInclVat; LineAmountInclVat)
                {
                    CaptionML = ENU = 'Amount Incl. VAT', FRA = 'Montant TTC';
                    ApplicationArea = All;
                    DecimalPlaces = 0 : 5;
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
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ApplicationArea = all;
                    Editable = false;
                }
            }

        }
        //<<WDC04

    }

    trigger OnAfterGetRecord()
    begin
        CalculateLineAmountInclVat(rec."No.", rec."Order No.");
    end;

    procedure CalculateLineAmountInclVat(pDocuementNo: Code[20]; pOrderNo: Code[20])
    var
        lsalesline: record "Sales Line";
        MontantTva7: Decimal;
        MontantTva19: Decimal;
        MontantTva13: Decimal;
        VSalesshipmentline: record "Sales Shipment Line";
        TotalBrut: Decimal;
        totalRemise: Decimal;
        TotalNetvcRemise: decimal;

        TotalSansTva: decimal;
        item: record Item;
        TotalTransport: Decimal;
        ChargeItem: record "Item Charge";
        TotalRedevance: decimal;
        SalesHeader: record "Sales Header";
        MontantTva: Decimal;
    begin
        LineAmountInclVat := 0;

        if pOrderNo <> '' then begin
            SalesHeader.reset();
            if SalesHeader.get(SalesHeader."Document Type"::Order, pOrderNo) then;
        end;

        VSalesshipmentline.reset();
        VSalesshipmentline.SetCurrentKey("Document No.", "Line No.");
        VSalesshipmentline.setrange("Document No.", pDocuementNo);
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
            LineAmountInclVat := TotalSansTva + MontantTva7 + MontantTva19 + MontantTva13;

        end
    end;

    // procedure GetTotalAmountIncVat(pStartDate: Date; pEndDate: Date): Decimal
    // var
    //     lsalesline: record "Sales Line";
    //     lSalesShipHeader: record "Sales Shipment Header";
    //     VSalesshipmentline: record "Sales Shipment Line";
    //     TotalBrut: Decimal;
    //     totalRemise: Decimal;
    //     TotalNetvcRemise: decimal;
    //     MontantTva7: Decimal;
    //     MontantTva19: Decimal;
    //     MontantTva13: Decimal;
    //     lLineAmountInclVat: Decimal;
    //     TotalSansTva: decimal;
    //     item: record Item;
    //     TotalTransport: Decimal;
    //     ChargeItem: record "Item Charge";
    //     TotalRedevance: decimal;
    //     SalesHeader: record "Sales Header";
    //     MontantTva: Decimal;
    // begin

    //     TotalAmountIncVat := 0;
    //     lSalesShipHeader.Reset();
    //     lSalesShipHeader.SetCurrentKey("Posting Date", "Sell-to Customer No.");
    //     lSalesShipHeader.CalcFields("Remain to Invoice", "Not Totally Canceled");
    //     lSalesShipHeader.SetRange("Not Totally Canceled", true);
    //     lSalesShipHeader.SetFilter("Customer Posting Group", '<>%1', 'C-PASSAGER');
    //     if CustomerNoFilter <> '' then
    //         lSalesShipHeader.Setfilter("Sell-to Customer No.", CustomerNoFilter)
    //     else
    //         lSalesShipHeader.Setfilter("Sell-to Customer No.", '<>%1', '9999');

    //     if (pStartDate <> 0D) and (pEndDate <> 0D) then
    //         lSalesShipHeader.SetFilter("Posting Date", '%1..%2', pStartDate, pEndDate)
    //     else if (pStartDate <> 0D) and (pEndDate = 0D) then
    //         lSalesShipHeader.SetFilter("Posting Date", '%1..', pStartDate)
    //     else if (pStartDate = 0D) and (pEndDate <> 0D) then
    //         lSalesShipHeader.SetFilter("Posting Date", '..%1', pEndDate);
    //     if lSalesShipHeader.FindSet() then
    //         repeat
    //             MontantTva7 := 0;
    //             MontantTva13 := 0;
    //             MontantTva19 := 0;
    //             TotalRedevance := 0;
    //             TotalTransport := 0;
    //             TotalBrut := 0;
    //             TotalNetvcRemise := 0;
    //             TotalNetvcRemise := 0;
    //             TotalSansTva := 0;
    //             lLineAmountInclVat := 0;
    //             if lSalesShipHeader."Order No." <> '' then begin
    //                 SalesHeader.reset();
    //                 if SalesHeader.get(SalesHeader."Document Type"::Order, lSalesShipHeader."Order No.") then;
    //             end;

    //             VSalesshipmentline.reset();
    //             VSalesshipmentline.SetCurrentKey("Document No.", "Line No.");
    //             VSalesshipmentline.setrange("Document No.", lSalesShipHeader."No.");
    //             if VSalesshipmentline.FindSet() then
    //                 repeat
    //                     if VSalesshipmentline.Quantity < 0 then begin
    //                         VSalesshipmentline."Item Charge Base Amount" := VSalesshipmentline."Item Charge Base Amount" * (-1);
    //                         vsalesshipmentline."VAT Base Amount" := vsalesshipmentline."VAT Base Amount" * (-1)
    //                     end;
    //                     if VSalesshipmentline.type = VSalesshipmentline.type::"Charge (Item)" then begin
    //                         ChargeItem.reset();
    //                         if ChargeItem.Get(VSalesshipmentline."No.") then
    //                             if ChargeItem."Gen. Prod. Posting Group" = 'REDEVANCE' then
    //                                 if VSalesshipmentline."VAT Base Amount" <> 0 then
    //                                     TotalRedevance += VSalesshipmentline."VAT Base Amount"
    //                                 else if VSalesshipmentline."Item Charge Base Amount" <> 0 then
    //                                     TotalRedevance += VSalesshipmentline."Item Charge Base Amount"
    //                                 else
    //                                     TotalRedevance += VSalesshipmentline.Quantity * VSalesshipmentline."Unit Price";
    //                     end;
    //                     if item.get(VSalesshipmentline."No.") then
    //                         if (item."Associated With Iron" = true) or (item."Associated With Cement" = true) then begin
    //                             if VSalesshipmentline."VAT Base Amount" <> 0 then
    //                                 TotalTransport += VSalesshipmentline."VAT Base Amount"
    //                             else if VSalesshipmentline."Item Charge Base Amount" <> 0 then
    //                                 TotalTransport += VSalesshipmentline."Item Charge Base Amount"
    //                             else if VSalesshipmentline."Item Charge Base Amount" <> 0 then
    //                                 TotalTransport += VSalesshipmentline."Item Charge Base Amount"
    //                             else
    //                                 TotalTransport += VSalesshipmentline.Quantity * VSalesshipmentline."Unit Price";
    //                         end
    //                         else begin
    //                             TotalBrut += VSalesshipmentline.Quantity * VSalesshipmentline."Unit Price";
    //                             totalRemise += (VSalesshipmentline.Quantity * VSalesshipmentline."Unit Price") - VSalesshipmentline."Item Charge Base Amount";
    //                             if VSalesshipmentline."VAT Base Amount" <> 0 then
    //                                 TotalNetvcRemise += VSalesshipmentline."VAT Base Amount"
    //                             else
    //                                 TotalNetvcRemise += VSalesshipmentline."Item Charge Base Amount";
    //                         end;
    //                     if SalesHeader."Invoice Discount Value" <> 0 then begin
    //                         if lsalesline.get(lsalesline."Document Type"::Order, VSalesshipmentline."Order No.", VSalesshipmentline."Line No.") then begin
    //                             if VSalesshipmentline."VAT %" = 7 then
    //                                 MontantTva7 += lsalesline.Amount * (VSalesshipmentline."VAT %" / 100);
    //                             if VSalesshipmentline."VAT %" = 19 then
    //                                 MontantTva19 += lsalesline.Amount * (VSalesshipmentline."VAT %" / 100);
    //                             if VSalesshipmentline."VAT %" = 13 then
    //                                 MontantTva13 += lsalesline.Amount * (VSalesshipmentline."VAT %" / 100);
    //                         end;
    //                     end
    //                     else begin
    //                         if VSalesshipmentline."VAT %" = 7 then begin
    //                             if VSalesshipmentline."VAT Base Amount" <> 0 then
    //                                 MontantTva7 += VSalesshipmentline."VAT Base Amount" * (VSalesshipmentline."VAT %" / 100)
    //                             else
    //                                 MontantTva7 += VSalesshipmentline."Item Charge Base Amount" * (VSalesshipmentline."VAT %" / 100);
    //                         end;
    //                         if VSalesshipmentline."VAT %" = 19 then begin
    //                             if VSalesshipmentline."VAT Base Amount" <> 0 then
    //                                 MontantTva19 += VSalesshipmentline."VAT Base Amount" * (VSalesshipmentline."VAT %" / 100)
    //                             else
    //                                 MontantTva19 += VSalesshipmentline."Item Charge Base Amount" * (VSalesshipmentline."VAT %" / 100);
    //                         end;
    //                         if VSalesshipmentline."VAT %" = 13 then begin
    //                             if VSalesshipmentline."VAT Base Amount" <> 0 then
    //                                 MontantTva13 += VSalesshipmentline."VAT Base Amount" * (VSalesshipmentline."VAT %" / 100)
    //                             else
    //                                 MontantTva13 += VSalesshipmentline."Item Charge Base Amount" * (VSalesshipmentline."VAT %" / 100);
    //                         end;
    //                     end;
    //                 until VSalesshipmentline.Next() = 0;
    //             TotalSansTva += TotalNetvcRemise + TotalTransport + TotalRedevance;
    //             if SalesHeader."Invoice Discount value" <> 0 then
    //                 TotalSansTva := TotalSansTva - SalesHeader."Invoice Discount value";
    //             lLineAmountInclVat := TotalSansTva + MontantTva7 + MontantTva19 + MontantTva13;
    //             TotalAmountIncVat += lLineAmountInclVat;
    //         until lSalesShipHeader.Next() = 0;
    //     exit(TotalAmountIncVat);
    // end;

    procedure FilterCurrentPage(pStartDate: Date; pEndDate: Date; pCustomerNo: Code[20])
    var
        GLSetup: record "General Ledger Setup";
        Dialog1: Dialog;
    begin
        Dialog1.open('Encours..');
        GLSetup.Get();
        if (pEndDate <> 0D) and (pStartDate <> 0D) then
            Rec.SetFilter("Posting Date", '%1..%2', pStartDate, pEndDate)
        else if (pStartDate = 0D) and (pEndDate <> 0D) then
            Rec.SetFilter("Posting Date", '..%1', pEndDate)
        else if (pStartDate <> 0D) and (pEndDate = 0D) then
            Rec.SetFilter("Posting Date", '%1..', pStartDate)
        else
            Rec.SetFilter("Posting Date", '%1..%2', GLSetup."Go Live Date" + 1, WorkDate());

        if pCustomerNo <> '' then
            Rec.Setfilter("Sell-to Customer No.", pCustomerNo)
        else
            Rec.Setfilter("Sell-to Customer No.", '<>%1', '9999');
        Dialog1.close();
        CurrPage.Update(false);
    end;

    var
        StartDateFilter: Date;
        EndDateFilter: Date;
        LineAmountInclVat: Decimal;
        TotalAmountIncVat: Decimal;
        CustomerNoFilter: Code[20];
        CustomerName: Text[100];
        SalespersonFilter: Code[20];
        SalesSetup: Record "Sales & Receivables Setup";
        GenLedgSetup: Record "General Ledger Setup";
}