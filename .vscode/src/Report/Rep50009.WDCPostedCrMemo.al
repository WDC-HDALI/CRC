namespace CRC.CRC;

using Microsoft.Purchases.History;
using System.Security.AccessControl;
using Microsoft.Bank.BankAccount;
using Microsoft.Inventory.Item;
using Microsoft.Foundation.Shipping;
using Microsoft.Sales.Customer;
using Microsoft.Sales.History;

report 50009 "WDC PostedCrMemo"
{
    ApplicationArea = All;
    CaptionML = ENU = 'Sales Credit Memo', FRA = 'Avoir Vente';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    Permissions = tabledata "Sales Cr.Memo Header" = rimd;
    RDLCLayout = './.vscode/src/Report/RDLC/PostedSalesCreditMemo.rdlc';
    dataset
    {
        dataitem("Sales Cr.Memo Header"; "Sales Cr.Memo Header")
        {
            column(No_; "No.")
            {

            }
            column(Posting_Date; "Posting Date")
            {

            }
            column(Sell_to_Customer_No_; "Sell-to Customer No.")
            {

            }

            column(Sell_to_Customer_Name; "Sell-to Customer Name")
            {

            }
            column(Sell_to_Address; "Sell-to Address")
            {

            }
            column(Sell_to_Phone_No_; "Sell-to Phone No.")
            {

            }
            column(customerCIN; customer."VAT Registration No.")
            {

            }
            column(Stamp_Amount; "Stamp Amount")
            {

            }
            column(SystemCreatedBy; UserR."User Name")
            {

            }
            dataitem("Sales Cr.Memo Line"; "Sales Cr.Memo Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemLinkReference = "Sales Cr.Memo Header";
                DataItemTableView = SORTING("Document No.", "Line No.");
                column(ItemNo; "No.")
                {

                }
                column(Description; Description)
                {

                }
                column(Quantity; Quantity)
                {

                }
                column(Unit_of_Measure_Code; "Unit of Measure Code")
                {

                }
                column(Unit_Price; "Unit Price")
                {

                }
                column(Line_Discount__; "Line Discount %")
                {

                }
                column(Line_Discount_Amount; "Line Discount Amount")
                {

                }

                column(Line_Amount; "Line Amount")
                {

                }
                column(VAT__; "VAT %")
                {

                }
                column(Amount_Including_VAT; "Amount Including VAT")
                {

                }

                column(paymentMethodedescription; paymentMethode.Description)
                {

                }
                column(TotalBrut; TotalBrut)
                {

                }
                column(TotalRemise; TotalRemise)
                {

                }
                column(TotalNetHTVA; TotalNetHTVA)
                {

                }
                column(MontantTVA7; MontantTVA7)
                {

                }
                column(MontantTVA13; MontantTVA13)
                {

                }
                column(MontantTVA19; MontantTVA19)
                {

                }
                column(TotalNet; TotalNet)
                {

                }
                column(TotalNetLetter; AmountLetter)
                {

                }
                column(CamionNo; ShippingAgent.Name)
                {

                }
                column(transporteurname; ShippingService.Description)
                {

                }
                column(TotalTransport; TotalTransport)
                {

                }
                column(TotalRedevance; TotalRedevance)
                {

                }
                trigger OnAfterGetRecord()
                var
                    lItem: record item;
                    lItemCharge: record "Item Charge";
                begin
                    if "Sales Cr.Memo Line".type = "Sales Cr.Memo Line".type::"Charge (Item)" then begin
                        lItemCharge.reset();
                        if lItemCharge.Get("Sales Cr.Memo Line"."No.") then
                            if lItemCharge."Gen. Prod. Posting Group" = 'REDEVANCE' then
                                CurrReport.skip();
                    end
                    else begin
                        lItem.reset();
                        if lItem.get("Sales Cr.Memo Line"."No.") then
                            if (litem."Associated With Iron" = true) or (litem."Associated With Cement" = true) then
                                CurrReport.skip();
                    end;
                end;
            }
            trigger OnAfterGetRecord()

            begin
                TotalRedevance := 0;
                TotalTransport := 0;
                TotalBrut := 0;
                TotalRemise := 0;
                TotalNetHTVA := 0;
                montantTVA7 := 0;
                MontantTVA13 := 0;
                MontantTVA19 := 0;
                //TotalNet := "Sales Cr.Memo Header"."Stamp Amount";
                UserR.Get(SystemCreatedBy);
                paymentMethode.reset();
                if paymentMethode.get("Payment Method Code") then;
                customer.reset();
                if customer.get("Sell-to Customer No.") then;
                ShippingAgent.Reset();
                ShippingService.Reset();
                if ShippingAgent.get("Shipping Agent Code") then;
                if ShippingService.get("Shipping Agent Code", "Shipping Agent Service Code") then;
                SalesCrMemoLine.reset();
                SalesCrMemoLine.setcurrentkey("Document No.", "Line No.");
                SalesCrMemoLine.setrange("Document No.", "No.");
                if SalesCrMemoLine.findset() then
                    repeat
                        if SalesCrMemoLine.type = SalesCrMemoLine.type::"Charge (Item)" then begin
                            ChargeItem.reset();
                            if ChargeItem.Get(SalesCrMemoLine."No.") then
                                if ChargeItem."Gen. Prod. Posting Group" = 'REDEVANCE' then
                                    TotalRedevance += SalesCrMemoLine."Line Amount";
                        end;
                        item.reset();
                        if item.get(SalesCrMemoLine."No.") then
                            if (item."Associated With Iron" = true) or (item."Associated With Cement" = true) then
                                TotalTransport += SalesCrMemoLine."Line Amount"
                            else begin
                                TotalBrut += SalesCrMemoLine.Quantity * SalesCrMemoLine."Unit Price";
                                TotalRemise += SalesCrMemoLine."Line Discount Amount";
                                TotalNetHTVA += SalesCrMemoLine."Line Amount";
                            end;
                        if SalesCrMemoLine."VAT %" = 7 then
                            MontantTVA7 += SalesCrMemoLine."Amount Including VAT" - SalesCrMemoLine."Line Amount";
                        if SalesCrMemoLine."VAT %" = 13 then
                            MontantTVA13 += SalesCrMemoLine."Amount Including VAT" - SalesCrMemoLine."Line Amount";
                        if SalesCrMemoLine."VAT %" = 19 then
                            MontantTVA19 += SalesCrMemoLine."Amount Including VAT" - SalesCrMemoLine."Line Amount";
                        TotalNet += SalesCrMemoLine."Amount Including VAT";
                    until SalesCrMemoLine.next() = 0;
                ConvAmounttoLetter."Montant en texte sans millimes"(AmountLetter, TotalNet);
            end;


        }

    }
    var
        TotalBrut: Decimal;
        TotalRemise: Decimal;
        TotalNetHTVA: Decimal;
        MontantTVA13: Decimal;
        MontantTVA7: Decimal;
        MontantTVA19: Decimal;
        TotalNet: Decimal;
        paymentMethode: record "Payment Method";
        ConvAmounttoLetter: codeunit "WDC-ED Conv Amount to Letter";
        AmountLetter: text[250];
        SalesCrMemoLine: record "Sales Cr.Memo Line";
        NumberOfLine: Integer;
        NumberOfPage: Integer;
        customer: record Customer;
        ShippingAgent: record "Shipping Agent";
        ShippingService: record "Shipping Agent Services";
        item: record Item;
        TotalTransport: Decimal;
        TotalRedevance: Decimal;
        ChargeItem: Record "Item Charge";
        UserR: Record User;

}
