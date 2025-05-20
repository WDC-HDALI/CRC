namespace CRC.CRC;

using Microsoft.Sales.History;
using Microsoft.Bank.BankAccount;
using Microsoft.Sales.Document;
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

            }
            column(Order_No_; "Order No.")
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
            column(No__Printed; "No. Printed")
            {

            }
            column(customerCIN; customer."Registration Number")
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
                SalesInvoiceLine.reset();
                "Sales Invoice Line".setcurrentkey("Document No.", "Line No.");
                SalesInvoiceLine.setrange("Document No.", "No.");
                SalesInvoiceLine.SetRange(Type, SalesInvoiceLine.type::Item);
                if SalesInvoiceLine.findset() then
                    repeat
                        TotalBrut += SalesInvoiceLine.Quantity * SalesInvoiceLine."Unit Price";
                        TotalRemise += SalesInvoiceLine."Line Discount Amount";
                        TotalNetHTVA += SalesInvoiceLine."Line Amount";
                        if SalesInvoiceLine."VAT %" = 7 then
                            MontantTVA7 += SalesInvoiceLine."Amount Including VAT" - SalesInvoiceLine."Line Amount";
                        if SalesInvoiceLine."VAT %" = 13 then
                            MontantTVA13 += SalesInvoiceLine."Amount Including VAT" - SalesInvoiceLine."Line Amount";
                        if SalesInvoiceLine."VAT %" = 19 then
                            MontantTVA19 += SalesInvoiceLine."Amount Including VAT" - SalesInvoiceLine."Line Amount";
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
        SalesInvoiceLine: record "Sales Invoice Line";
        NumberOfLine: Integer;
        NumberOfPage: Integer;
        customer: record customer;
}
