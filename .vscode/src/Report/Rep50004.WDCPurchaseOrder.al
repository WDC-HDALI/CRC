namespace CRC.CRC;

using Microsoft.Purchases.Document;
using System.Security.User;
using Microsoft.Foundation.Company;
using Microsoft.Foundation.Shipping;
//*********************Documentation**************************
//<<WDC01  WDC.HG  24/11/2025  Add Purchaser Code 

report 50004 "WDC Purchase Order"
{
    CaptionML = ENU = 'Purchase Order', FRA = 'Commande achat';
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './.vscode/src/Report/RDLC/PurchaseOrder.rdlc';

    dataset
    {
        dataitem(PurchaseHeader; "Purchase Header")
        {
            DataItemTableView = where("Document Type" = filter(order));
            column(No_; "No.")
            {

            }
            column(Buy_from_Vendor_No_; "Buy-from Vendor No.")
            {

            }
            column(Buy_from_Vendor_Name; "Buy-from Vendor Name")
            {

            }
            column(Buy_from_Address; "Buy-from Address")
            {

            }
            column(Buy_from_City; "Buy-from City")
            {

            }
            column(Posting_Date; "Posting Date")
            {

            }
            column(Payment_Method_Code; "Payment Method Code")
            {

            }
            column(Shipment_Method_Code; "Shipment Method Code")
            {

            }
            column(Transport_Method; TransportMode)
            {

            }
            column(CompanyName; CompanyInformation.Name)

            {

            }
            column(Companyaddress; CompanyInformation.Address)

            {

            }
            column(Companycity; CompanyInformation.City)
            {

            }
            column(destinationname; DestinationName)
            {

            }
            column(destinationddress; DestinationAddress)
            {

            }
            column(destinationcity; DestinationCity)
            {

            }

            column(CompanyMF; DestinationMF)
            {

            }
            //<<WDC01
            column(Purchaser_Code; "Purchaser Code")
            {

            }
            //>>WDC01

            dataitem(PurchaseLine; "Purchase Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemLinkReference = PurchaseHeader;
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
                column(Unit_Cost; "Unit Cost")
                {

                }
                column(SetVisibleUnictCost; SetVisibleUnictCost)
                {

                }

            }
            trigger OnAfterGetRecord()
            var
                ShippingAgent: record "Shipping Agent";
                ShippingAgentService: record "Shipping Agent Services";
            begin
                DestinationMF := '';
                TransportMode := '';
                DestinationName := '';
                DestinationAddress := '';
                DestinationCity := '';
                DestinationMF := CompanyInformation."VAT Registration No.";
                if ShipToAddressEqualsCompanyShipToAddress() then begin
                    DestinationName := CompanyInformation.Name;
                    DestinationAddress := CompanyInformation.Address;
                    DestinationCity := CompanyInformation.City;
                end else begin
                    DestinationName := PurchaseHeader."Ship-to Name";
                    DestinationAddress := PurchaseHeader."Ship-to Address";
                    DestinationCity := "Ship-to City";
                end;
                if "Truck No." <> '' then
                    if ShippingAgent.get("Truck No.") then
                        TransportMode := ShippingAgent.Name;
                if "Shipping Agent No." <> '' then
                    if ShippingAgentService.get("Truck No.", "Shipping Agent No.") then
                        if TransportMode = '' then
                            TransportMode := ShippingAgentService.Description
                        else
                            TransportMode += '/' + ShippingAgentService.Description;
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
                    ShowCaption = false;
                    field(SetVisibleUnictCost; SetVisibleUnictCost)
                    {
                        CaptionML = ENU = 'Display the purchase price', FRA = 'Afficher le prix d''achat';
                        ApplicationArea = Basic, Suite;
                        Editable = displayCost;
                    }
                }
            }
        }
    }
    trigger OnInitReport()


    begin
        CompanyInformation.get();
        if usersetup.get(UserId) then
            displayCost := usersetup."Display Purchase Cost"
        else
            displayCost := false;
    end;

    var
        CompanyInformation: record "Company Information";
        SetVisibleUnictCost: Boolean;
        DestinationName: text[100];
        DestinationAddress: text[100];
        DestinationCity: text[30];
        TransportMode: text;
        DestinationMF: text[20];
        usersetup: record "User Setup";
        displayCost: Boolean;
}
