namespace CRC.CRC;

using Microsoft.Sales.History;
using Microsoft.Bank.BankAccount;
using Microsoft.Inventory.Item;
using Microsoft.Foundation.Shipping;
using Microsoft.Sales.Document;
using System.Security.AccessControl;
using Microsoft.Finance.Currency;
using Microsoft.Foundation.Company;
using Microsoft.Sales.Customer;
//*****************Documentation**************************
//WDC01  WDC.FS 12/02/2026  Create New report Sales Invoice Bonian

report 50038 "WDC Sales Invoice BONIAN"
{
    Captionml = ENU = 'Sales Invoice', FRA = 'Facture de vente';
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    Permissions = tabledata "Sales Invoice Header" = rimd;
    RDLCLayout = './.vscode/src/Report/RDLC/SalesInvoiceBN.rdlc';

    dataset
    {
        dataitem(SalesInvoiceHeader; "Sales Invoice Header")
        {
            column(Picture; CompanyInfo.Picture)
            {

            }
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
            column(customerCIN; "VAT Registration No.")
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

            column(CamionNo; "Truck No.")
            {

            }
            column(StampAmount; "Stamp Amount")
            {

            }

            column(ChauffeurName; "Driver name")
            {

            }

            column(paymentmethod; paymentmethod.Description)
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

            column(Customer_Posting_Group; customer."Customer Posting Group")
            {

            }

            column(Salesperson_Code; "Salesperson Code")
            {

            }

            dataitem(SalesInvoiceLine; "Sales Invoice Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemLinkReference = SalesInvoiceHeader;
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
                column(Item_Charge_Base_Amount; "Amount")
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
                    if SalesInvHeader.get("SalesInvoiceHeader"."No.") then; //Pour récupérer le nombre d'imprime à jour
                    if "SalesInvoiceLine".type = "SalesInvoiceLine".type::"Charge (Item)" then begin
                        lItemCharge.reset();
                        if lItemCharge.Get("SalesInvoiceLine"."No.") then
                            if lItemCharge."Gen. Prod. Posting Group" = 'REDEVANCE' then
                                //IsLineVisible := false;
                                CurrReport.skip();
                    end
                    else begin
                        lItem.reset();
                        if lItem.get("SalesInvoiceLine"."No.") then
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
                AmountLetter := '';
                UserR.Get(SystemCreatedBy);
                CompanyInfo.get;
                CompanyInfo.CalcFields(Picture);
                if customer.get("Bill-to Customer No.") then;

                if SalesInvoiceHeader."Order No." <> '' then begin
                    SalesHeader.reset();
                    if SalesHeader.get(SalesHeader."Document Type"::Order, SalesInvoiceHeader."Order No.") then;
                end;

                shippingAgent.reset();
                if shippingAgent.get(SalesInvoiceHeader."Shipping Agent Code") then;
                shippingAgentService.reset();
                if shippingAgentService.get(SalesInvoiceHeader."Shipping Agent Code", SalesInvoiceHeader."Shipping Agent Service Code") then;
                paymentmethod.reset();
                if paymentmethod.get(SalesInvoiceHeader."Payment Method Code") then;
                VSalesinvoiceline.reset();
                VSalesinvoiceline.SetCurrentKey("Document No.", "Line No.");
                VSalesinvoiceline.setrange("Document No.", SalesInvoiceHeader."No.");
                if VSalesinvoiceline.FindSet() then begin
                    repeat
                        if VSalesinvoiceline.Quantity < 0 then begin
                            VSalesinvoiceline."Amount" := VSalesinvoiceline."Amount" * (-1);
                            VSalesinvoiceline."VAT Base Amount" := VSalesinvoiceline."VAT Base Amount" * (-1)
                        end;
                        if VSalesinvoiceline.type = VSalesinvoiceline.type::"Charge (Item)" then begin
                            ChargeItem.reset();
                            if ChargeItem.Get(VSalesinvoiceline."No.") then
                                if ChargeItem."Gen. Prod. Posting Group" = 'REDEVANCE' then
                                    if VSalesinvoiceline."VAT Base Amount" <> 0 then begin
                                        TotalRedevance += VSalesinvoiceline."VAT Base Amount"
                                    end
                                    else if VSalesinvoiceline."Amount" <> 0 then begin
                                        TotalRedevance += VSalesinvoiceline."Amount"
                                    end
                                    else
                                        TotalRedevance += VSalesinvoiceline.Quantity * VSalesinvoiceline."Unit Price";

                        end;
                        item.reset();
                        if item.get(VSalesinvoiceline."No.") then
                            if (item."Associated With Iron" = true) or (item."Associated With Cement" = true) then begin
                                if VSalesinvoiceline."VAT Base Amount" <> 0 then begin
                                    TotalTransport += VSalesinvoiceline."VAT Base Amount"
                                end
                                else if VSalesinvoiceline."Amount" <> 0 then begin
                                    TotalTransport += VSalesinvoiceline."Amount"
                                end
                                else
                                    TotalTransport += VSalesinvoiceline.Quantity * VSalesinvoiceline."Unit Price";
                            end
                            else begin
                                //TotalBrut += VSalesinvoiceline.Quantity * VSalesinvoiceline."Unit Price";
                                TotalBrut += VSalesinvoiceline.Amount;
                                totalRemise += (VSalesinvoiceline.Quantity * VSalesinvoiceline."Unit Price") - VSalesinvoiceline."Amount";


                                if VSalesinvoiceline."VAT Base Amount" <> 0 then
                                    TotalNetvcRemise += VSalesinvoiceline."VAT Base Amount"
                                else
                                    TotalNetvcRemise += VSalesinvoiceline."Amount";
                            end;
                        if SalesHeader."Invoice Discount Value" <> 0 then begin
                            lsalesline.reset();
                            if lsalesline.get(lsalesline."Document Type"::Order, VSalesinvoiceline."Order No.", VSalesinvoiceline."Line No.") then begin
                                if VSalesinvoiceline."VAT %" = 7 then
                                    MontantTva7 += lsalesline.Amount * (VSalesinvoiceline."VAT %" / 100);
                                if VSalesinvoiceline."VAT %" = 19 then
                                    MontantTva19 += lsalesline.Amount * (VSalesinvoiceline."VAT %" / 100);
                                if VSalesinvoiceline."VAT %" = 13 then
                                    MontantTva13 += lsalesline.Amount * (VSalesinvoiceline."VAT %" / 100);
                            end;
                        end
                        else begin
                            if VSalesinvoiceline."VAT %" = 7 then begin
                                if VSalesinvoiceline."VAT Base Amount" <> 0 then
                                    MontantTva7 += VSalesinvoiceline."VAT Base Amount" * (VSalesinvoiceline."VAT %" / 100)
                                else
                                    MontantTva7 += VSalesinvoiceline."Amount" * (VSalesinvoiceline."VAT %" / 100);
                            end;
                            if VSalesinvoiceline."VAT %" = 19 then begin
                                if VSalesinvoiceline."VAT Base Amount" <> 0 then
                                    MontantTva19 += VSalesinvoiceline."VAT Base Amount" * (VSalesinvoiceline."VAT %" / 100)
                                else
                                    MontantTva19 += VSalesinvoiceline."Amount" * (VSalesinvoiceline."VAT %" / 100);
                            end;
                            if VSalesinvoiceline."VAT %" = 13 then begin
                                if VSalesinvoiceline."VAT Base Amount" <> 0 then
                                    MontantTva13 += VSalesinvoiceline."VAT Base Amount" * (VSalesinvoiceline."VAT %" / 100)
                                else
                                    MontantTva13 += VSalesinvoiceline."Amount" * (VSalesinvoiceline."VAT %" / 100);
                            end
                        end;
                    //TotalSansTva += VSalesshipmentline."Item Charge Base Amount";
                    until VSalesinvoiceline.Next() = 0;
                    TotalSansTva += TotalNetvcRemise + TotalTransport + TotalRedevance;
                    //<<WDC01
                    if SalesHeader."Invoice Discount value" <> 0 then
                        TotalSansTva := TotalSansTva - SalesHeader."Invoice Discount value";
                    //<<WDC01
                    TotalPayer := Round(TotalSansTva + MontantTva7 + MontantTva19 + MontantTva13 + SalesInvoiceHeader."Stamp Amount", 0.001);
                    ConvAmounttoLetter."Montant en texte sans millimes"(AmountLetter, TotalPayer);
                end
            end;
        }

    }


    trigger OnPostReport()

    begin
        //if not CurrReport.Preview then
        CODEUNIT.Run(CODEUNIT::"Sales Inv.-Printed", SalesInvoiceHeader);

    end;


    var
        customer: Record Customer;
        VSalesinvoiceline: record "Sales Invoice Line";
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
        CompanyInfo: Record "Company Information";
        SalesInvHeader: Record "Sales Invoice Header";



}
