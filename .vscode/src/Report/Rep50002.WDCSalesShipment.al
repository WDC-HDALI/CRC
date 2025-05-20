namespace CRC.CRC;

using Microsoft.Sales.History;
using Microsoft.Bank.BankAccount;
using Microsoft.Foundation.Shipping;
using Microsoft.Finance.Currency;
using Microsoft.Sales.Customer;

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
            column(Bill_to_Name; "Bill-to Name")
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
            column(CamionNo; shippingAgent.Name)
            {

            }
            column(ChauffeurName; shippingAgentService.Description)
            {

            }
            column(paymentmethod; paymentmethod.Description)
            {

            }
            column(No__Printed; "No. Printed")
            {

            }
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
                column(Item_Charge_Base_Amount; "Item Charge Base Amount")
                {

                }
                column(VAT__; "VAT %")
                {

                }
                column(NumberOfLine; NumberOfLine)
                {

                }
                column(NumberOfPage; NumberOfPage)
                {

                }
                trigger OnAfterGetRecord()
                begin
                    NumberOfLine += 1;
                    NumberOfPage := (NumberOfLine - 1) div 15 + 1;
                end;

            }



            trigger OnAfterGetRecord()
            begin
                TotalBrut := 0;
                TotalNetvcRemise := 0;
                TotalNetvcRemise := 0;
                MontantTva7 := 0;
                MontantTva19 := 0;
                MontantTva13 := 0;
                TotalSansTva := 0;
                TotalPayer := 0;
                customer.reset();
                if customer.get("Bill-to Customer No.") then;
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
                        TotalBrut += VSalesshipmentline.Quantity * VSalesshipmentline."Unit Price";
                        totalRemise += (VSalesshipmentline.Quantity * VSalesshipmentline."Unit Price") - VSalesshipmentline."Item Charge Base Amount";
                        TotalNetvcRemise += VSalesshipmentline."Item Charge Base Amount";
                        if VSalesshipmentline."VAT %" = 7 then
                            MontantTva7 += VSalesshipmentline."Item Charge Base Amount" * (VSalesshipmentline."VAT %" / 100);
                        if VSalesshipmentline."VAT %" = 19 then
                            MontantTva19 += VSalesshipmentline."Item Charge Base Amount" * (VSalesshipmentline."VAT %" / 100);
                        if VSalesshipmentline."VAT %" = 13 then
                            MontantTva13 += VSalesshipmentline."Item Charge Base Amount" * (VSalesshipmentline."VAT %" / 100);
                        TotalSansTva += VSalesshipmentline."Item Charge Base Amount";
                    until VSalesshipmentline.Next() = 0;
                    TotalPayer := TotalSansTva + MontantTva7 + MontantTva19 + MontantTva13;
                    ConvAmounttoLetter."Montant en texte sans millimes"(AmountLetter, TotalPayer);
                end
            end;
        }

    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }
    }
    trigger OnPostReport()

    begin
        if not CurrReport.Preview then
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



}
