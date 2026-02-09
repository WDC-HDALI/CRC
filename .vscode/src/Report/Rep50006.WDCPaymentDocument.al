namespace CRC.CRC;

using Microsoft.Sales.Receivables;
using System.Utilities;
using Microsoft.Finance.GeneralLedger.Journal;
using Microsoft.Sales.Customer;
using Microsoft.Foundation.Company;
//*************************Documentation******************
//WDC01  WDC.HG 02/06/2025  Create Current Object
report 50006 "WDC Payment Document"
{
    Captionml = ENU = 'Payment Document', FRA = ' Document paiement';
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './.vscode/src/Report/RDLC/Payment Document.rdlc';
    dataset
    {
        dataitem(DetailedCustLedgEntry; "Detailed Cust. Ledg. Entry")
        {
            DataItemTableView = where("Document Type" = filter(payment | " "));
            column(Document_Type; "Document Type")
            {

            }
            column(Document_No_; "Document No.")
            {

            }
            column(Customer_No_; "Customer No.")
            {

            }
            column(CustomerName; Customer.Name)
            {

            }
            column(Amount; Amount)
            {

            }
            column(Amount__LCY_; "Amount (LCY)")
            {

            }
            column(Payment_Method_Code; CustomerLedgerEntry."Payment Method Code")
            {

            }
            column(ModeReglement; ModeReglement)
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

            }
            column(amountletter; amountletter)
            {

            }
            column(ImprimeDate; workdate)
            {

            }
            trigger OnAfterGetRecord()

            begin
                ModeReglement := '';
                if Customer.get("Customer No.") then;
                CustomerLedgerEntry.reset();
                CustomerLedgerEntry.SetFilter("Document Type", '%1|%2', CustomerLedgerEntry."Document Type"::Payment, CustomerLedgerEntry."Document Type"::" ");
                CustomerLedgerEntry.SetRange("Document No.", DetailedCustLedgEntry."Document No.");
                CustomerLedgerEntry.SetRange("Entry No.", DetailedCustLedgEntry."Applied Cust. Ledger Entry No.");
                if CustomerLedgerEntry.FindSet() then begin
                    CustomerLedgerEntry.CalcFields("Amount (LCY)");
                    if CustomerLedgerEntry."Payment Method Code" = 'RS' then
                        ModeReglement := 'Retenue à la source'
                    else
                        ModeReglement := CustomerLedgerEntry."Payment Method Code";
                    TotalAmount += abs(CustomerLedgerEntry."Amount (LCY)");
                end;
                AmountLetter := '';
                ConvAmounttoLetter."Montant en texte sans millimes"(AmountLetter, TotalAmount);
            end;

            trigger OnPreDataItem()
            var
                myInt: Integer;
            begin
                TotalAmount := 0;
                DetailedCustLedgEntry.SetRange("Cust. Ledger Entry No.", entryNo);
            end;
        }
    }

    // requestpage
    // {
    //     layout
    //     {
    //         area(Content)
    //         {
    //             group(GroupName)
    //             {
    //                 ShowCaption = false;
    //                 field(PaymentNo; PaymentNo)
    //                 {
    //                     CaptionML = ENU = 'Payment No.', FRA = 'N° paiement';
    //                     ApplicationArea = Basic, Suite;
    //                     trigger OnLookup(var text: text): Boolean
    //                     var
    //                         DetailedCustLedgEntry: record "Detailed Cust. Ledg. Entry";
    //                         DetailedCustumerledgerentries: page "Detailed Cust. Ledg. Entries";
    //                     begin
    //                         DetailedCustLedgEntry.reset();
    //                         DetailedCustLedgEntry.SetRange("Document Type", DetailedCustLedgEntry."Document Type"::Payment);
    //                         DetailedCustLedgEntry.SetRange("Cust. Ledger Entry No.", entryNo);
    //                         DetailedCustumerledgerentries.SetTableView(DetailedCustLedgEntry);
    //                         DetailedCustumerledgerentries.LookupMode(true);
    //                         if DetailedCustumerledgerentries.RunModal = action::LookupOK then begin
    //                             DetailedCustumerledgerentries.GetRecord(DetailedCustLedgEntry);
    //                             PaymentNo := DetailedCustLedgEntry."Document No.";
    //                             DetailedEntryNo := DetailedCustLedgEntry."Entry No.";
    //                         end;
    //                     end;
    //                 }
    //             }
    //         }
    //     }
    //     actions
    //     {
    //         area(Processing)
    //         {
    //         }
    //     }


    trigger OnInitReport()
    begin
        //PaymentNo := '';
        //detailedEntryNo := 0;
    end;

    trigger OnPreReport()
    begin
        CompanyInformation.get();
        CompanyInformation.CalcFields(Picture);
        // if PaymentNo = '' then
        //     Error(err001);


    end;

    procedure GetCustomerLedgerEntryNo(pInvoiceNo: code[20]): Integer
    var
        lCustomerLedgerEntry: record "Cust. Ledger Entry";
    begin
        lCustomerLedgerEntry.reset();
        CustomerLedgerEntry.SetCurrentKey("Document Type", "Posting Date");
        lCustomerLedgerEntry.setrange("Document Type", CustomerLedgerEntry."Document Type"::Invoice);
        lCustomerLedgerEntry.setrange("Document No.", pInvoiceNo);
        if lCustomerLedgerEntry.FindSet() then
            entryNo := lCustomerLedgerEntry."Entry No.";
    end;



    var
        Customer: record Customer;
        PaymentNo: code[20];
        CompanyInformation: record "Company Information";
        err001: TextConst FRA = 'Le N° du paiement est obligatoire',
                           ENU = 'The Payment No. is mandatory';
        ConvAmounttoLetter: codeunit "WDC-ED Conv Amount to Letter";
        amountletter: text[250];
        CustomerLedgerEntry: record "Cust. Ledger Entry";
        entryNo: integer;
        DetailedEntryNo: Integer;
        TotalAmount: Decimal;
        ModeReglement: text;



}