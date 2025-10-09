namespace CRC.CRC;

using Microsoft.Sales.History;
using Microsoft.Bank.BankAccount;
using Microsoft.Foundation.Shipping;
using Microsoft.Sales.Receivables;
using Microsoft.Sales.Document;
using System.Security.AccessControl;
using System.Security.User;
using Microsoft.Inventory.Item;
using Microsoft.Sales.Customer;

report 50003 "WDC Posted Sales Invoice "
{
    ApplicationArea = All;
    CaptionML = ENU = 'Sales Invoice', FRA = 'Facture vente';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    Permissions = tabledata "Sales Invoice Header" = rimd;
    RDLCLayout = './.vscode/src/Report/RDLC/PostedSalesInvoice.rdlc';

    dataset
    {
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
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
            column(Stamp_Amount; "Stamp Amount")
            {
                DecimalPlaces = 0 : 5;
            }
            column(SystemCreatedBy; UserR."User Name")
            {

            }

            column(Order_No_; "Order No.")
            {

            }
            column(paymentMethodedescription; paymentMethode.Description)
            {

            }
            column(TotalBrut; TotalBrut)
            {
                DecimalPlaces = 0 : 5;
            }
            column(TotalRemise; TotalRemise)
            {
                DecimalPlaces = 0 : 5;
            }
            column(TotalNetHTVA; TotalNetHTVA)
            {
                DecimalPlaces = 0 : 5;
            }
            column(MontantTVA7; MontantTVA7)
            {
                DecimalPlaces = 0 : 5;
            }
            column(MontantTVA13; MontantTVA13)
            {
                DecimalPlaces = 0 : 5;
            }
            column(MontantTVA19; MontantTVA19)
            {
                DecimalPlaces = 0 : 5;
            }
            column(TotalNet; TotalNet)
            {
                DecimalPlaces = 0 : 5;
            }
            column(TotalNetLetter; AmountLetter)
            {

            }
            column(No__Printed; SalesInvHeader."No. Printed")
            {

            }
            column(customerCIN; "Sales Invoice Header"."VAT Registration No.")
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
                DecimalPlaces = 0 : 5;
            }
            column(PaymentMethodeText; PaymentMethodeText)
            {

            }

            dataitem("Sales Invoice Line"; "Sales Invoice Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemLinkReference = "Sales Invoice Header";
                DataItemTableView = SORTING("Document No.", "Line No.");
                column(ItemNo; "No.")
                {

                }
                column(Description; Description)
                {

                }
                column(Quantity; Quantity)
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
                column(Line_Discount_Amount; "Line Discount Amount")
                {
                    DecimalPlaces = 0 : 5;
                }

                column(Line_Amount; "Line Amount")
                {
                    DecimalPlaces = 0 : 5;
                }
                column(VAT__; "VAT %")
                {
                    DecimalPlaces = 0 : 5;
                }
                column(Amount_Including_VAT; "Amount Including VAT")
                {
                    DecimalPlaces = 0 : 5;
                }

                column(NumberOfLine; NumberOfLine)
                {

                }
                column(NumberOfPage; NumberOfPage)
                {

                }
                column(IsLineVisible; IsLineVisible)
                {

                }

                trigger OnAfterGetRecord()
                var
                    lItem: record item;
                    lItemCharge: record "Item Charge";
                begin
                    IsLineVisible := true;
                    if "Sales Invoice Line".type = "Sales Invoice Line".type::"Charge (Item)" then begin
                        lItemCharge.reset();
                        if lItemCharge.Get("Sales Invoice Line"."No.") then
                            if lItemCharge."Gen. Prod. Posting Group" = 'REDEVANCE' then
                                //IsLineVisible := false;
                        CurrReport.skip();
                    end
                    else begin
                        lItem.reset();
                        if lItem.get("Sales Invoice Line"."No.") then
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
                UserName: Text;


            begin
                UserR.Get(SystemCreatedBy);

                if SalesInvHeader.get("Sales Invoice Header"."No.") then; //Pour récupérer le nombre d'imprime à jour
                SetPaymentCodeText();
                TotalRedevance := 0;
                TotalTransport := 0;
                TotalBrut := 0;
                TotalRemise := 0;
                TotalNetHTVA := 0;
                montantTVA7 := 0;
                MontantTVA13 := 0;
                MontantTVA19 := 0;
                TotalNet := "Sales Invoice Header"."Stamp Amount";
                paymentMethode.reset();
                if paymentMethode.get("Payment Method Code") then;
                customer.reset();
                if customer.get("Sell-to Customer No.") then;
                ShippingAgent.Reset();
                ShippingService.Reset();
                if ShippingAgent.get("Shipping Agent Code") then;
                if ShippingService.get("Shipping Agent Code", "Shipping Agent Service Code") then;
                SalesInvoiceLine.reset();
                "Sales Invoice Line".setcurrentkey("Document No.", "Line No.");
                SalesInvoiceLine.setrange("Document No.", "No.");
                if SalesInvoiceLine.findset() then
                    repeat
                        if SalesInvoiceLine.type = SalesInvoiceLine.type::"Charge (Item)" then begin
                            ChargeItem.reset();
                            if ChargeItem.Get(SalesInvoiceLine."No.") then
                                if ChargeItem."Gen. Prod. Posting Group" = 'REDEVANCE' then
                                    TotalRedevance += SalesInvoiceLine."Amount";
                        end;
                        item.reset();
                        if item.get(SalesInvoiceLine."No.") then
                            if (item."Associated With Iron" = true) or (item."Associated With Cement" = true) then
                                TotalTransport += SalesInvoiceLine."Amount"
                            else begin
                                TotalBrut += SalesInvoiceLine.Quantity * SalesInvoiceLine."Unit Price";
                                TotalRemise += SalesInvoiceLine."Line Discount Amount";
                                TotalNetHTVA += SalesInvoiceLine."Amount";
                            end;
                        if SalesInvoiceLine."VAT %" = 7 then
                            MontantTVA7 += SalesInvoiceLine."Amount Including VAT" - SalesInvoiceLine."Amount";
                        if SalesInvoiceLine."VAT %" = 13 then
                            MontantTVA13 += SalesInvoiceLine."Amount Including VAT" - SalesInvoiceLine."Amount";
                        if SalesInvoiceLine."VAT %" = 19 then
                            MontantTVA19 += SalesInvoiceLine."Amount Including VAT" - SalesInvoiceLine."Amount";
                        TotalNet += SalesInvoiceLine."Amount Including VAT";
                    until SalesInvoiceLine.next() = 0;
                ConvAmounttoLetter."Montant en texte sans millimes"(AmountLetter, TotalNet);

            end;


        }

    }

    trigger OnPostReport()

    begin
        if not CurrReport.Preview then
            CODEUNIT.Run(CODEUNIT::"Sales Inv.-Printed", "Sales Invoice Header");

    end;

    procedure SetPaymentCodeText()
    var
        lCustomerLedgerEntry: record "Cust. Ledger Entry";
        lDetailedCustLedgEntry: record "Detailed Cust. Ledg. Entry";
    begin
        PaymentMethodeText := '';
        lCustomerLedgerEntry.reset();
        lCustomerLedgerEntry.SetCurrentKey("Document Type", "Posting Date");
        lCustomerLedgerEntry.setrange("Document Type", lCustomerLedgerEntry."Document Type"::Invoice);
        lCustomerLedgerEntry.setrange("Document No.", "Sales Invoice Header"."No.");
        if lCustomerLedgerEntry.FindSet() then begin
            lDetailedCustLedgEntry.reset();
            lDetailedCustLedgEntry.SetRange("Document Type", lDetailedCustLedgEntry."Document Type"::Payment);
            lDetailedCustLedgEntry.SetRange("Cust. Ledger Entry No.", lCustomerLedgerEntry."Entry No.");
            if lDetailedCustLedgEntry.FindSet() then
                repeat
                    if lDetailedCustLedgEntry."Payment Slip Type" <> lDetailedCustLedgEntry."Payment Slip Type"::" " then begin
                        if PaymentMethodeText <> '' then
                            PaymentMethodeText += '/';
                        PaymentMethodeText += format(lDetailedCustLedgEntry."Payment Slip Type");
                    end
                until lDetailedCustLedgEntry.Next() = 0;
        end;
    end;

    var
        UserR: Record User;
        SalesInvHeader: Record "Sales Invoice Header";
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
        SalesInvoiceLine: record "Sales Invoice Line";
        NumberOfLine: Integer;
        NumberOfPage: Integer;
        customer: record customer;
        ShippingAgent: record "Shipping Agent";
        ShippingService: record "Shipping Agent Services";
        item: record Item;
        TotalTransport: Decimal;
        TotalRedevance: Decimal;
        ChargeItem: record "Item Charge";
        IsLineVisible: Boolean;
        PaymentMethodeText: text;

}
