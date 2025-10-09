namespace CRC.CRC;

using Microsoft.Sales.History;
using Microsoft.Inventory.Item;
using Microsoft.Foundation.Shipping;
using Microsoft.Sales.Document;

report 50029 "WDC driver statistic"
{
    DefaultLayout = RDLC;
    RDLCLayout = './.vscode/src/Report/RDLC/DriverShippingStatistic.rdl';
    ApplicationArea = All;
    CaptionML = ENU = 'Driver Statistics', FRA = 'Statistiques des chauffeurs';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(SalesShipmentHeader; "Sales Shipment Header")
        {
            DataItemTableView = SORTING("No.");
            // RequestFilterFields = "Shipping Agent Service Code", "Shipping Agent Code", "Posting Date", "Sell-to Customer Name";
            column(COMPANYNAME; COMPANYNAME)
            {

            }
            column(Picture_Company; CompanyInfo.Picture)
            {

            }
            column(Address_Company; CompanyInfo.Address)
            {

            }
            column(City_Company; CompanyInfo.City)
            {
            }
            column(PostCode_Company; CompanyInfo."Post Code")
            {
            }
            column(Phone_Company; CompanyInfo."Phone No.")
            {

            }
            column(No_; "No.")
            {

            }
            column(Posting_Date; "Posting Date")
            {

            }
            column(Sell_to_Customer_Name; "Sell-to Customer Name")
            {

            }
            column(Ship_to_Address; "Ship-to Address")
            {

            }
            column(Shipping_Agent_Code; "Shipping Agent Code")
            {

            }
            column(Shipping_Agent_Service_Code; "Shipping Agent Service Code")
            {

            }
            column(Distance; Distance)
            {

            }
            column(TotalTransportTTC; TotalTransportTTC)
            {

            }

            trigger OnPreDataItem()
            begin
                if EndingDate < StartingDate then
                    Error('Date fin ne doit pas être antérieur à la date début !');
                SalesShipmentHeader.SetFilter("Posting Date", '%1..%2', StartingDate, EndingDate);
                SalesShipmentHeader.SetFilter("Shipping Agent Service Code", DriverCode);
            end;

            trigger OnAfterGetRecord()
            var
                lSalesShipmentLine: record "Sales Shipment Line";
                lItem: record Item;
            begin
                distance := 0;
                TotalTransportTTC := 0;
                lSalesShipmentLine.SetCurrentKey("Document No.", "Line No.");
                lSalesShipmentLine.SetRange("Document No.", SalesShipmentHeader."No.");
                lSalesShipmentLine.SetRange(Type, lSalesShipmentLine.Type::Item);
                if lSalesShipmentLine.FindSet() then
                    repeat
                        TotalTVA := 0;
                        TotalHT := 0;
                        if lItem.get(lSalesShipmentLine."No.") then begin
                            if (lItem.Type = lItem.Type::Service) and (Not lItem."Associated With Cement")
                           and (Not lItem."Associated With Iron") then begin
                                TotalHT := round((lSalesShipmentLine.Quantity * lSalesShipmentLine."Unit Price"), 0.001, '=');
                                if lSalesHeader."Invoice Discount Value" <> 0 then begin
                                    if lSalesLine.get(lSalesLine."Document Type"::order, lSalesShipmentLine."Order No.", lSalesShipmentLine."Line No.") then
                                        TotalTVA += lSalesLine.Amount * (lSalesShipmentLine."VAT %" / 100);
                                end else
                                    TotalTVA += TotalHT * (lSalesShipmentLine."VAT %" / 100);

                                TotalTransportTTC += TotalHT + TotalTVA;
                            end
                        end;
                    until lSalesShipmentLine.Next() = 0;
            end;

        }

    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(filtres)
                {
                    field(StartingDate; StartingDate)
                    {
                        ApplicationArea = all;
                        CaptionML = ENU = 'Starting Date', FRA = 'Date début';
                    }
                    field(EndingDate; EndingDate)
                    {
                        ApplicationArea = all;
                        Captionml = ENU = 'Ending Date', FRA = 'Date fin';
                    }
                    field(DriverCode; DriverCode)
                    {
                        ApplicationArea = all;
                        CaptionML = ENU = 'Driver Code', FRA = 'Code Chauffeur';
                        TableRelation = "Shipping Agent Services".Code where("Company Transporter" = const(true));
                    }
                }
            }
        }

    }
    trigger OnPreReport()
    var
    begin
        CompanyInfo.Get;
        CompanyInfo.CalcFields(Picture);
    end;

    var
        StartingDate: Date;
        EndingDate: Date;
        Distance: Decimal;
        TotalTransportTTC: decimal;
        CompanyInfo: Record 79;
        lSalesHeader: Record "Sales Header";
        lSalesLine: Record "Sales Line";
        TotalHT: Decimal;
        TotalTVA: Decimal;
        DriverCode: Code[20];
}