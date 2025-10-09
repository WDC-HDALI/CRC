//*****************Documentation********************
//WDC01  WDC.HG  11/07/2025  take the  Total TTC for BL instead of HT 
namespace CRC.CRC;

using Microsoft.Sales.History;
using Microsoft.Sales.Receivables;
using Microsoft.Inventory.Item;
using Microsoft.Finance.VAT.Setup;
using Microsoft.Sales.Document;
using Microsoft.Sales.Customer;
using System.Utilities;

report 50013 "WDC Global Customer Balance"
{
    DefaultLayout = RDLC;
    RDLCLayout = './.vscode/src/Report/RDLC/GlobalCustomerBalance.rdl';
    ApplicationArea = All;
    CaptionML = ENU = 'Global Customer Balance', FRA = 'Extrait client';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(Customer; Customer)
        {
            DataItemTableView = SORTING("No.");
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.";

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
            column(Customer_No; "No.")
            {

            }
            column(Customer_Name; Name)
            {

            }

            column(Payment_Terms_Code; "Payment Terms Code")
            {

            }

            dataitem("Sales Shipment Line"; "Sales Shipment Line")
            {
                DataItemLink = "Sell-to Customer No." = field("No.");
                DataItemTableView = SORTING("Document No.", "Line No.")
                                        ORDER(Ascending)
                                        where("Qty. Shipped Not Invoiced" = filter(<> 0));

                column(DocumentNo_SalesShipmentLine; "Sales Shipment Line"."Document No.")
                {

                }

                column(PostingDate_SalesShipmentLine; "Posting Date")
                {

                }
                column(ShipAmount; ShipAmount)
                {

                }
                column(TotalBL; TotalBL)
                {

                }
                column(Type_Doc; Type_Doc)
                {

                }
                column(SalesShipmentLine_SelltoCustomerNo; "Sell-to Customer No.")
                {

                }
                column(ShipAgentservvice; ShphipmentHeader."Shipping Agent Service Code")
                {
                }
                column(ShippingAgentCode; ShphipmentHeader."Shipping Agent Code")
                {

                }
                trigger OnPreDataItem()
                begin
                    Type_Doc := 'BL NON FACTURE';
                    "Sales Shipment Line".SetFilter("Posting Date", '%1..%2', StartingDate, EndingDate);
                end;

                trigger OnAfterGetRecord()
                var

                    lSalesLine: Record "Sales Line";
                    VATPostingSetup: Record "VAT Posting Setup";
                    item: record Item;

                begin
                    ShipAmount := 0;
                    UnitPriceTTC := 0;
                    if ShphipmentHeader.Get("Sales Shipment Line"."Document No.") then;
                    //<<WDC01
                    If "Item Charge Base Amount" <> 0 then
                        ShipAmount := "Item Charge Base Amount" * (1 + "VAT %" / 100)
                    else if "VAT Base Amount" <> 0 then
                        ShipAmount := "VAT Base Amount" * (1 + "VAT %" / 100)
                    else
                        If lSalesLine.GET(lSalesLine."Document Type"::Order, "Sales Shipment Line"."Order No.", "Sales Shipment Line"."Order Line No.") then begin
                            UnitPriceTTC := lSalesLine."Unit Price" * (1 + (lSalesLine."VAT %" / 100));
                            ShipAmount := (UnitPriceTTC * "Sales Shipment Line".Quantity) * (1 - ("Line Discount %" / 100)); //lSalesLine."Shipped Not Invoiced (LCY)";
                        end;
                    //<<WDC01
                    TotalBL += ShipAmount;
                end;
            }

            dataitem("Return Receipt Line"; "Return Receipt Line")
            {
                DataItemLink = "Sell-to Customer No." = field("No.");
                DataItemTableView = SORTING("Document No.", "Line No.")
                                        ORDER(Ascending)
                                        where("Return Qty. Rcd. Not Invd." = filter(<> 0));

                column(DocumentNo_ReturnReceiptLine; "Return Receipt Line"."Document No.")
                {

                }
                column(PostingDate_ReturnReceiptLine; "Posting Date")
                {

                }


                column(ShipAmount2; ShipAmount2)
                {

                }
                column(TotalRetour; TotalRetour)
                {

                }
                column(Type_Doc6; Type_Doc)
                {

                }

                trigger OnPreDataItem()
                begin

                    Type_Doc := 'RETOUR NON FACTURE';
                    "Return Receipt Line".SetFilter("Posting Date", '%1..%2', StartingDate, EndingDate);
                end;

                trigger OnAfterGetRecord()
                var
                    lSalesLine: Record "Sales Line";
                    lUnitPriceTTC: Decimal;
                begin
                    ShipAmount2 := 0;

                    If "Item Charge Base Amount" <> 0 then
                        ShipAmount2 := "Item Charge Base Amount"
                    else begin
                        lUnitPriceTTC := "Return Receipt Line"."Unit Price" * (1 + ("Return Receipt Line"."VAT %" / 100));
                        ShipAmount2 := lUnitPriceTTC * (1 - ("Return Receipt Line"."Line Discount %" / 100));

                    end;

                    TotalRetour := ShipAmount2;
                end;
            }


            dataitem(Paiement; "Cust. Ledger Entry")
            {
                DataItemLink = "Customer No." = field("No.");
                DataItemTableView = SORTING("Entry No.") ORDER(Ascending) where(Reversed = filter(false));

                column(Paiement_PostingDate; Paiement."Posting Date")
                {

                }
                column(Paiement_DocumentType; Paiement."Document Type")
                {

                }
                column(Paiement_DocumentNo; Paiement."Document No.")
                {

                }
                column(Paiement_AmountLCY; ShipAmount)
                {

                }

                column(Credit_Amount__LCY_; "Credit Amount (LCY)")
                {

                }
                column(Debit_Amount__LCY_; "Debit Amount (LCY)")
                {

                }


                column(Payment_Slip_Type; PaymentType)
                {

                }

                column(Due_Date; DueDate)
                {

                }
                column(Bank_Name; "Bank Name")
                {

                }
                column(N_cheque; "Payment Reference")
                {

                }
                column(TotalPaiement; TotalPaiement)
                {

                }
                trigger OnPreDataItem()
                begin

                    Paiement.SetFilter("Posting Date", '%1..%2', StartingDate, EndingDate);
                end;

                trigger OnAfterGetRecord()
                var

                begin
                    PaymentType := '';

                    if Paiement."Customer Posting Group" <> 'C_EFFIMP' then
                        PaymentType := Format(Paiement."Payment Slip Type")
                    else begin
                        if Paiement."Credit Amount (LCY)" <> 0 then
                            PaymentType := 'Régl. impayé'
                        else if Paiement."Debit Amount (LCY)" <> 0 then
                            PaymentType := 'Impayé';
                    end;

                    DueDate := 0D;
                    if Paiement."Payment Slip Type" = Paiement."Payment Slip Type"::Draft then
                        DueDate := Paiement."Due Date";
                    Type_Doc := Format("Document Type");
                    ShipAmount := 0;
                    Paiement.CalcFields("Amount (LCY)", "Debit Amount (LCY)", "Credit Amount (LCY)");
                    ShipAmount := Paiement."Amount (LCY)"; //* (-1);
                    TotalPaiement += ShipAmount;
                end;
            }

            dataitem(Integer; Integer)
            {
                DataItemTableView = SORTING(Number) ORDER(Ascending)
                                        where(Number = filter(1));


                column(Number; Number)
                {

                }
                column(Type_Doc5; Type_Doc)
                {

                }
                column(Total_recette; Total_recette)
                {

                }
                trigger OnAfterGetRecord()
                var
                begin

                    Total_recette := TotalBL - TotalRetour + TotalPaiement;
                    Type_Doc := 'TOTAL';

                end;

            }

            trigger OnPreDataItem()
            begin
                if (StartingDate = 0D) or (EndingDate = 0D) then
                    Error('Les dates début et fin ne doivent pas être vide!');
                if EndingDate < StartingDate then
                    Error('Date fin ne doit pas être antérieur à la date début !');
            end;

            trigger OnAfterGetRecord()
            begin
                CompanyInfo.Get;
                CompanyInfo.CalcFields(Picture);
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Filters)
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

                }
            }
        }
    }

    labels
    {
        title = 'EXTRAIT CLIENT';
        Page = 'Page';
        Date = 'Date';
        Client = 'N° client';
        Nom_Client = 'Nom client';
        Doc = 'N° document';
        Montant = 'Montant';
    }

    trigger OnInitReport()
    begin
        StartingDate := DMY2Date(1, Date2DMY(WorkDate, 2), Date2DMY(WorkDate, 3));
        EndingDate := CALCDATE('<CM>', StartingDate);
    end;

    var
        ShphipmentHeader: Record "Sales Shipment Header";
        StartingDate: Date;
        EndingDate: Date;
        ShipCustName: Text[100];
        ShipAmount: Decimal;
        ShipAmount2: Decimal;
        UnitPriceTTC: Decimal;
        Type_Doc: Text[20];
        ToDisplay: Integer;
        TotalBL: Decimal;
        TotalRetour: Decimal;
        TotalFacture: Decimal;
        TotalAvoir: Decimal;
        TotalPaiement: Decimal;
        Total_recette: Decimal;
        Avoir_Montant: Decimal;
        CompanyInfo: Record 79;
        DueDate: Date;
        PaymentType: Text[50];
}
