namespace CRC.CRC;

using Microsoft.Sales.History;
using Microsoft.Inventory.Item;

report 50030 "WDC Cash Invoice Of The Day"
{
    DefaultLayout = RDLC;
    RDLCLayout = './.vscode/src/Report/RDLC/CashInvoice.rdl';
    ApplicationArea = All;
    CaptionML = ENU = 'Cash Invoice Of The Day', FRA = 'Etat des Factures Au Comptant';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(SalesInvoiceHeader; "Sales Invoice Header")
        {
            DataItemTableView = SORTING("No.") where("Customer Posting Group" = filter('C-PASSAGER'));
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
            column(Sell_to_Customer_No_; "Sell-to Customer No.")
            {

            }
            column(Sell_to_Customer_Name; "Sell-to Customer Name")
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
            column(TotalTva; TotalTva)
            {

            }
            column(TotalNet; TotalNet)
            {

            }
            column(StartingDate; StartingDate)
            {

            }
            column(EndingDate; EndingDate)
            {

            }



            trigger OnPreDataItem()
            begin
                if (StartingDate = 0D) or (EndingDate = 0D) then
                    Error('Les dates début et fin ne doivent pas être vide!');
                SalesInvoiceHeader.SetFilter("Posting Date", '%1..%2', StartingDate, EndingDate);


            end;

            trigger OnAfterGetRecord()
            begin
                TotalBrut := 0;
                TotalRemise := 0;
                TotalNetHTVA := 0;
                TotalTva := 0;
                TotalNet := SalesInvoiceHeader."Stamp Amount";
                SalesInvoiceLine.reset();
                SalesInvoiceLine.setcurrentkey("Document No.", "Line No.");
                SalesInvoiceLine.setrange("Document No.", "No.");
                if SalesInvoiceLine.findset() then
                    repeat
                        TotalBrut += SalesInvoiceLine.Quantity * SalesInvoiceLine."Unit Price";
                        TotalRemise += SalesInvoiceLine."Line Discount Amount";
                        TotalNetHTVA += SalesInvoiceLine."Amount";
                        TotalTva += SalesInvoiceLine."Amount Including VAT" - SalesInvoiceLine."Amount";
                        TotalNet += SalesInvoiceLine."Amount Including VAT";
                    until SalesInvoiceLine.next() = 0;
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
    labels
    {
        title = 'ETAT DES FACTURES AU COMPTANT';
        Page = 'Page';
        Date = 'Date';
        Client = 'N° Client';
        Facture = 'N° facture';
        Designation = 'Désignation';
        Brut = 'Brut';
        Remise = 'Remise';
        TotalHT = 'H.T.';
        TVA = 'TVA';
        TTC = 'TTC';
    }
    trigger OnPreReport()
    var
    begin
        CompanyInfo.Get;
        CompanyInfo.CalcFields(Picture);
    end;

    trigger OnInitReport()
    var
        myInt: Integer;
    begin
        StartingDate := WorkDate();
        EndingDate := WorkDate();
    end;

    var
        StartingDate: Date;
        EndingDate: Date;
        CompanyInfo: Record 79;
        TotalBrut: decimal;
        TotalRemise: Decimal;
        TotalNetHTVA: decimal;
        TotalNet: Decimal;
        SalesInvoiceLine: record "Sales Invoice Line";
        Item: record Item;
        ChargeItem: record "Item Charge";
        TotalTva: Decimal;
}
