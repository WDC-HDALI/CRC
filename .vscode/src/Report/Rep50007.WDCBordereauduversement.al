namespace CRC.CRC;

using Microsoft.Finance.GeneralLedger.Ledger;
using Microsoft.Bank.BankAccount;
using Microsoft.Finance.GeneralLedger.Journal;
using Microsoft.Sales.Receivables;
using Microsoft.Finance.GeneralLedger.Account;
using Microsoft.Foundation.Company;
using Microsoft.Sales.Customer;

report 50007 "WDC Bordereau du versement"
{
    Captionml = ENU = 'Payment slip', FRA = 'Bordereau de versement';
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './.vscode/src/Report/RDLC/BordereauDeVersement.rdlc';
    dataset
    {
        dataitem(GLEntry; "G/L Entry")
        {
            DataItemTableView = where("Document Type" = filter(''), "Bal. Account Type" = filter('Bank Account'), "Initial Payment No." = filter(<> ''), "Cheque No." = filter(<> ''));

            column(CompanyName; CompanyInformation.Name)
            {

            }
            column(Posting_Date; "Posting Date")
            {

            }
            column(Document_Type; "Document Type")
            {

            }

            column(Document_No_; "Document No.")
            {

            }

            column(Cheque_No_; "Cheque No.")
            {

            }
            column(Initial_Payment_No_; "Initial Payment No.")
            {

            }
            column(Amount; abs(Amount))
            {

            }
            column(G_L_Account_No_; "G/L Account No.")
            {

            }
            column(Tireur; Tireur)
            {

            }
            column(BankClient; BankClient)
            {

            }
            column(Ville; Ville)
            {

            }
            column(amountletter; amountletter)
            {

            }
            column(NumeroCompte; BANKAccount."No.")
            {

            }
            column(NomBanque; BankAccount.Name)
            {

            }
            column(dateimprime; workdate)
            {

            }
            column(NumeroBordereau; NumeroBordereau)
            {

            }
            column(Position; Position)
            {

            }
            column(TotalAmount; TotalAmount)
            {

            }
            trigger OnPreDataItem()
            var
            begin
                GLEntry.SetRange("Document No.", NumeroBordereau);

            end;

            trigger OnAfterGetRecord()
            var
                CustomerLedgerEntry: record "Cust. Ledger Entry";
            begin
                ville := '';
                Tireur := '';
                BankClient := '';
                BankAccount.reset();
                if BANKAccount.get(GLEntry."Bal. Account No.") then;
                CustomerLedgerEntry.reset();
                CustomerLedgerEntry.SetCurrentKey("Document Type", "Posting Date");
                CustomerLedgerEntry.setrange("Document Type", CustomerLedgerEntry."Document Type"::Payment);
                CustomerLedgerEntry.SetRange("Document No.", GLEntry."Initial Payment No.");
                if CustomerLedgerEntry.findset() then begin
                    BankClient := CustomerLedgerEntry."Bank Name";
                    Tireur := CustomerLedgerEntry.Description;
                    Customer.reset();
                    if customer.get(CustomerLedgerEntry."Customer No.") then
                        Ville := Customer.City;
                end;
                Position += 1;
                TotalAmount += abs(Amount);
                amountletter := '';
                ConvAmounttoLetter."Montant en texte sans millimes"(AmountLetter, TotalAmount);
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
                    field(NumeroBordereau; NumeroBordereau)
                    {
                        CaptionML = ENU = 'payment slip', FRA = 'bordereau de paiement ';
                        ApplicationArea = Basic, Suite;
                        TableRelation = "WDC borderau lookup"."Document No.";
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
    trigger OnInitReport()
    begin
        Paymentssubscriber.InserteBordereauLookup();
    end;

    trigger OnPreReport()
    begin
        CompanyInformation.get();
        CompanyInformation.CalcFields(Picture);
        Position := 0;
        TotalAmount := 0;
        if NumeroBordereau = '' then error(err01)
    end;

    var
        Tireur: text[100];
        BankClient: code[20];
        Ville: Text[30];
        Customer: record Customer;
        BANKAccount: record "Bank Account";
        ConvAmounttoLetter: codeunit "WDC-ED Conv Amount to Letter";
        amountletter: text[250];
        NumeroBordereau: code[20];
        err01: TextConst FRA = 'Le N� du Bordereau est obligatoire',
                           ENU = 'Payment Slip No. is mandatory';
        Position: Integer;
        TotalAmount: decimal;
        CompanyInformation: record "Company Information";
        Paymentssubscriber: Codeunit "WDC Payment Subscribers";



}
