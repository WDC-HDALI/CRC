namespace CRC.CRC;

using Microsoft.Sales.Receivables;
using System.Utilities;
using Microsoft.Finance.GeneralLedger.Journal;
using Microsoft.Sales.Customer;
using Microsoft.Foundation.Company;
//*************************Documentation******************
//WDC01  WDC.HG 02/06/2025  Create Current Object
report 50018 "WDC Print Cust. Payment LAZREG"
{
    Captionml = ENU = 'Payment Document', FRA = ' Document paiement';
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './.vscode/src/Report/RDLC/PrintCustPaymentLZRG.rdlc';
    dataset
    {
        dataitem(DetailedCustLedgEntry; "Detailed Cust. Ledg. Entry")
        {

            column(Document_Type; "Document Type")
            {

            }
            column(Document_No_; "Document No.")
            {

            }
            column(Customer_No_; "Customer No.")
            {

            }
            column(CustomerName; "Customer Name")
            {

            }
            column(Amount; Amount)
            {
                DecimalPlaces = 0 : 3;
            }
            column(Amount__LCY_; "Amount (LCY)")
            {
                DecimalPlaces = 0 : 3;
            }
            column(Payment_Method_Code; CustomerLedgerEntry."Payment Method Code")
            {

            }
            column(ModeReglement; ModeReglement)//"Payment slip type")
            {

            }
            column(Payment_Reference; CustomerLedgerEntry."Payment Reference")
            {

            }
            column(Bank_Name; CustomerLedgerEntry."Bank Name")
            {

            }

            column(CompanyInformation; CompanyInformation.Name)
            {

            }
            column(TotalAmount; TotalAmount)
            {
                DecimalPlaces = 0 : 3;
            }
            column(amountletter; amountletter)
            {

            }
            column(Posting_Date; "Posting Date")
            {

            }
            trigger OnAfterGetRecord()

            begin
                ModeReglement := '';
                if Customer.get("Customer No.") then;
                CustomerLedgerEntry.reset();
                CustomerLedgerEntry.SetRange("Entry No.", DetailedCustLedgEntry."Cust. Ledger Entry No.");
                if CustomerLedgerEntry.FindSet() then begin
                    CustomerLedgerEntry.CalcFields("Amount (LCY)");
                    if CustomerLedgerEntry."Payment Method Code" = 'RS' then
                        ModeReglement := 'Retenue à la source'
                    else
                        ModeReglement := CustomerLedgerEntry."Payment Method Code";
                    //TotalAmount += abs(CustomerLedgerEntry."Amount (LCY)");
                end;
                AmountLetter := '';
                ConvAmounttoLetter."Montant en texte sans millimes"(AmountLetter, ABS("Amount (LCY)"));
            end;

            trigger OnPreDataItem()
            var
                myInt: Integer;
            begin
                TotalAmount := 0;
                // DetailedCustLedgEntry.SetRange("Cust. Ledger Entry No.", entryNo);
            end;
        }
    }


    trigger OnPreReport()
    begin
        CompanyInformation.get();
        CompanyInformation.CalcFields(Picture);
    end;


    var
        Customer: record Customer;

        CompanyInformation: record "Company Information";
        ConvAmounttoLetter: codeunit "WDC-ED Conv Amount to Letter";
        amountletter: text[250];
        CustomerLedgerEntry: record "Cust. Ledger Entry";
        entryNo: integer;

        TotalAmount: Decimal;
        ModeReglement: text;



}