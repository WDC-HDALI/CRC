namespace CRC.CRC;

using Microsoft.Sales.History;
using Microsoft.Bank.BankAccount;
using Microsoft.Sales.Document;
using System.Security.AccessControl;
using Microsoft.Sales.Customer;
using Microsoft.Inventory.Item;

report 50001 "WDC Devis "
{
    ApplicationArea = All;
    Captionml = ENU = 'Sales Quote', FRA = 'Devis vente';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './.vscode/src/Report/RDLC/SalesQuote.rdlc';

    dataset
    {
        dataitem("SalesHeader"; "Sales Header")
        {
            DataItemTableView = where("Document Type" = filter(Quote));

            column(No_; "No.")
            {

            }
            column(Posting_Date; "Document Date")
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
            column(SystemCreatedBy; UserR."User Name")
            {

            }
            column(VAT_Registration_No_; "VAT Registration No.")
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
            column(TotalTransport; TotalTransport)
            {

            }
            column(TotalRedevance; TotalRedevance)
            {

            }
            column(TotalNetLetter; AmountLetter)
            {

            }
            dataitem("Sales Line"; "Sales Line")
            {
                DataItemLink = "Document No." = FIELD("No."), "Document type" = field("document type");
                DataItemLinkReference = SalesHeader;
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
                var
                    lItem: record item;
                    lItemCharge: record "Item Charge";
                begin
                    if "Sales Line".type = "Sales Line".type::"Charge (Item)" then begin
                        lItemCharge.reset();
                        if lItemCharge.Get("Sales Line"."No.") then
                            if lItemCharge."Gen. Prod. Posting Group" = 'REDEVANCE' then
                                CurrReport.skip();
                    end
                    else begin
                        lItem.reset();
                        if lItem.get("Sales Line"."No.") then
                            if (lItem."Associated With Iron" = true) or (lItem."Associated With Cement" = true) then
                                CurrReport.skip();
                    end;
                    NumberOfLine += 1;
                    NumberOfPage := (NumberOfLine - 1) div 15 + 1;

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
                TotalNet := SalesHeader."Stamp Amount";
                UserR.Get(SystemCreatedBy);
                paymentMethode.reset();
                if paymentMethode.get("Payment Method Code") then;
                SalesLine.reset();
                SalesLine.setcurrentkey("Document Type", "Document No.", "Line No.");
                SalesLine.SetRange("Document Type", SalesHeader."Document Type");
                SalesLine.SetRange("Document No.", SalesHeader."No.");
                if SalesLine.findset() then
                    repeat
                        if SalesLine.type = SalesLine.type::"Charge (Item)" then begin
                            ChargeItem.reset();
                            if ChargeItem.Get(SalesLine."No.") then
                                if ChargeItem."Gen. Prod. Posting Group" = 'REDEVANCE' then
                                    TotalRedevance += SalesLine."Line Amount";
                        end;
                        item.reset();
                        if item.get(SalesLine."No.") then
                            if (item."Associated With Iron" = true) or (item."Associated With Cement" = true) then
                                TotalTransport += SalesLine."Line Amount"
                            else begin
                                TotalBrut += SalesLine.Quantity * SalesLine."Unit Price";
                                TotalRemise += SalesLine."Line Discount Amount";
                                TotalNetHTVA += SalesLine."Line Amount";
                            end;
                        if SalesLine."VAT %" = 7 then
                            MontantTVA7 += SalesLine."Amount Including VAT" - SalesLine."Line Amount";
                        if SalesLine."VAT %" = 13 then
                            MontantTVA13 += SalesLine."Amount Including VAT" - SalesLine."Line Amount";
                        if SalesLine."VAT %" = 19 then
                            MontantTVA19 += SalesLine."Amount Including VAT" - SalesLine."Line Amount";
                        TotalNet += SalesLine."Amount Including VAT";
                    until SalesLine.next() = 0;
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
        TotalTransport: Decimal;
        paymentMethode: record "Payment Method";
        ConvAmounttoLetter: codeunit "WDC-ED Conv Amount to Letter";
        AmountLetter: text[250];
        SalesLine: record "Sales Line";
        NumberOfLine: Integer;
        NumberOfPage: Integer;
        item: record Item;
        ChargeItem: record "Item Charge";
        TotalRedevance: Decimal;
        UserR: Record User;

}
