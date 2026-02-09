namespace CRC.CRC;

using Microsoft.Sales.History;
using Microsoft.Bank.BankAccount;
using Microsoft.Inventory.Item;
using Microsoft.Foundation.Shipping;
using Microsoft.Sales.Document;
using System.Security.AccessControl;
using Microsoft.Finance.Currency;
using Microsoft.Sales.Customer;
//*****************Documentation**************************
//WDC01  WDC.HG  10/09/2025  add the Invoice No for Comptant passager 
//WDC02  WDC.HG  24/11/2025  Add SalesPersonCode 
//WDC03  WDC.FS  06/01/2026  Add Fields
report 50002 WDCSalesShipment
{
    Captionml = ENU = 'Sales Shipment', FRA = 'Bon livraison';
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    Permissions = tabledata "Sales Invoice Header" = rimd;
    RDLCLayout = './.vscode/src/Report/RDLC/SalesShipment.rdlc';

    dataset
    {
        dataitem(SalesShipmentHeader; "Sales Shipment Header")
        {
            column(No_; "No.")
            {

            }
            column(Bill_to_Customer_No_; "Bill-to Customer No.")
            {

            }
            column(Sell_to_Phone_No_; "Sell-to Phone No.")
            {

            }
            column(Bill_to_Name; "Sell-to Customer Name")
            {

            }

            column(Bill_to_Address; "Bill-to Address")
            {

            }
            column(Bill_to_City; "Bill-to City")
            {

            }
            column(Bill_to_Post_Code; "Bill-to Post Code")
            {

            }
            column(Posting_Date; "Posting Date")
            {

            }
            column(SystemCreatedBy; UserR."User Name")
            {

            }
            column(Order_No_; "Order No.")
            {

            }
            column(customer; customer."VAT Registration No.")
            {

            }
            column(TotalBrut; TotalBrut)
            {

            }
            column(totalRemise; totalRemise)
            {

            }
            column(TotalNetvcRemise; TotalNetvcRemise)
            {

            }
            column(MontantTva7; MontantTva7)
            {

            }
            column(MontantTva13; MontantTva13)
            {

            }
            column(MontantTva19; MontantTva19)
            {

            }
            column(TotalPayer; TotalPayer)
            {

            }
            column(amountletter; amountletter)
            {

            }
            //<<WDC03
            //column(CamionNo; shippingAgent.Name)
            //{

            //}
            column(CamionNo; "Truck No.")
            {

            }
            //column(ChauffeurName; "Shipping Agent Service Code")
            //{

            //}
            column(ChauffeurName; "Driver name")
            {

            }
            //>>WDC03
            column(paymentmethod; paymentmethod.Description)
            {

            }
            column(DestinationAddress; DestinationAddress)
            {

            }
            column(No__Printed; "No. Printed")
            {

            }
            column(TotalTransport; TotalTransport)
            {

            }
            column(TotalRedevance; TotalRedevance)
            {

            }
            //<<WDC01
            column(Posted_description; "Posted description")
            {

            }
            column(Customer_Posting_Group; customer."Customer Posting Group")
            {

            }
            //>>WDC01
            //<<WDC02
            column(Salesperson_Code; "Salesperson Code")
            {

            }
            //>>WDC02
            dataitem(SalesShipmentLine; "Sales Shipment Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemLinkReference = SalesShipmentHeader;
                DataItemTableView = SORTING("Document No.", "Line No.");

                column(ItemNo; "No.")
                {

                }
                column(itemDescription; "Description")
                {

                }
                column(Quantityshipped; Quantity)
                {
                    DecimalPlaces = 0 : 5;

                }
                column(Unit_of_Measure_Code; "Unit of Measure Code")
                {

                }
                column(Unit_Price; "Unit Price")
                {
                    DecimalPlaces = 0 : 5;
                }
                column(Line_Discount__; "Line Discount %")
                {
                    DecimalPlaces = 0 : 5;
                }
                column(Item_Charge_Base_Amount; "Item Charge Base Amount")
                {
                    DecimalPlaces = 0 : 5;
                }
                column(VAT__; "VAT %")
                {
                    DecimalPlaces = 0 : 5;
                }
                column(NumberOfLine; NumberOfLine)
                {

                }
                column(NumberOfPage; NumberOfPage)
                {

                }
                trigger OnAfterGetRecord()
                var
                    lItem: record item;
                    lItemCharge: record "Item Charge";
                begin
                    if "SalesShipmentLine".type = "SalesShipmentLine".type::"Charge (Item)" then begin
                        lItemCharge.reset();
                        if lItemCharge.Get("SalesShipmentLine"."No.") then
                            if lItemCharge."Gen. Prod. Posting Group" = 'REDEVANCE' then
                                //IsLineVisible := false;
                                CurrReport.skip();
                    end
                    else begin
                        lItem.reset();
                        if lItem.get("SalesShipmentLine"."No.") then
                            if (litem."Associated With Iron" = true) or (litem."Associated With Cement" = true) then
                                //IsLineVisible := false;
                                 CurrReport.skip();
                    end;
                    NumberOfLine += 1;
                    NumberOfPage := (NumberOfLine - 1) div 15 + 1;
                end;

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
                UserR.Get(SystemCreatedBy);
                customer.reset();
                if customer.get("Bill-to Customer No.") then;
                //<<WDC01
                if SalesShipmentHeader."Order No." <> '' then begin
                    SalesHeader.reset();
                    if SalesHeader.get(SalesHeader."Document Type"::Order, SalesShipmentHeader."Order No.") then;
                end;
                //<<WDC01
                shippingAgent.reset();
                if shippingAgent.get(SalesShipmentHeader."Shipping Agent Code") then;
                shippingAgentService.reset();
                if shippingAgentService.get(SalesShipmentHeader."Shipping Agent Code", SalesShipmentHeader."Shipping Agent Service Code") then;
                paymentmethod.reset();
                if paymentmethod.get(SalesShipmentHeader."Payment Method Code") then;
                VSalesshipmentline.reset();
                VSalesshipmentline.SetCurrentKey("Document No.", "Line No.");
                VSalesshipmentline.setrange("Document No.", SalesShipmentHeader."No.");
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
                                    if VSalesshipmentline."VAT Base Amount" <> 0 then begin
                                        TotalRedevance += VSalesshipmentline."VAT Base Amount"
                                    end
                                    else if VSalesshipmentline."Item Charge Base Amount" <> 0 then begin
                                        TotalRedevance += VSalesshipmentline."Item Charge Base Amount"
                                    end
                                    else
                                        TotalRedevance += VSalesshipmentline.Quantity * VSalesshipmentline."Unit Price";

                        end;
                        item.reset();
                        if item.get(VSalesshipmentline."No.") then
                            if (item."Associated With Iron" = true) or (item."Associated With Cement" = true) then begin
                                if VSalesshipmentline."VAT Base Amount" <> 0 then begin
                                    TotalTransport += VSalesshipmentline."VAT Base Amount"
                                end
                                else if VSalesshipmentline."Item Charge Base Amount" <> 0 then begin
                                    TotalTransport += VSalesshipmentline."Item Charge Base Amount"
                                end
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
                            end
                        end;
                    //TotalSansTva += VSalesshipmentline."Item Charge Base Amount";
                    until VSalesshipmentline.Next() = 0;
                    TotalSansTva += TotalNetvcRemise + TotalTransport + TotalRedevance;
                    //<<WDC01
                    if SalesHeader."Invoice Discount value" <> 0 then
                        TotalSansTva := TotalSansTva - SalesHeader."Invoice Discount value";
                    //<<WDC01
                    TotalPayer := TotalSansTva + MontantTva7 + MontantTva19 + MontantTva13;
                    ConvAmounttoLetter."Montant en texte sans millimes"(AmountLetter, TotalPayer);
                end
            end;
        }

    }


    trigger OnPostReport()

    begin
        //if not CurrReport.Preview then
        CODEUNIT.Run(CODEUNIT::"Sales Shpt.-Printed", SalesShipmentHeader);

    end;

    var
        customer: Record Customer;
        VSalesshipmentline: record "Sales Shipment Line";
        TotalBrut: Decimal;
        totalRemise: Decimal;
        TotalNetvcRemise: decimal;
        MontantTva7: Decimal;
        MontantTva19: Decimal;
        MontantTva13: Decimal;
        TotalPayer: Decimal;
        TotalSansTva: decimal;
        ConvAmounttoLetter: codeunit "WDC-ED Conv Amount to Letter";
        shippingAgent: record "Shipping Agent";
        shippingAgentService: record "Shipping Agent Services";
        amountletter: text[250];
        NumberOfLine: Integer;
        NumberOfPage: Integer;
        paymentmethod: record "Payment Method";
        item: record Item;
        TotalTransport: Decimal;
        ChargeItem: record "Item Charge";
        TotalRedevance: decimal;
        SalesHeader: record "Sales Header";
        UserR: Record User;





}
