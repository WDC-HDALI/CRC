namespace CRC.CRC;

using Microsoft.Sales.History;
using Microsoft.Foundation.Company;
using Microsoft.Finance.VAT.Ledger;
using Microsoft.Bank.Ledger;
using Microsoft.Sales.Receivables;
using Microsoft.Finance.GeneralLedger.Ledger;

report 50906 "WDC Delete Paiement"
{
    Caption = 'Delete paiement';
    UseRequestPage = false;
    Permissions = tabledata "G/L Entry" = RIMD, tabledata "Cust. Ledger Entry" = RIMD, tabledata "Detailed Cust. Ledg. Entry" = RIMD, tabledata "Bank Account Ledger Entry" = RIMD;
    ApplicationArea = All;
    ProcessingOnly = true;
    dataset
    {

        dataitem("Company Information"; "Company Information")
        {

            column(Name; "Name")
            {
            }
            trigger OnAfterGetRecord()
            var
                GlEntry: Record "G/L Entry";
                CustEntry: record "Cust. Ledger Entry";
                DetCustEntry: Record "Detailed Cust. Ledg. Entry";
                BankEntry: Record "Bank Account Ledger Entry";
            begin
                clear(GlEntry);
                Clear(CustEntry);
                Clear(DetCustEntry);
                Clear(BankEntry);
                GlEntry.SetFilter("Entry No.", '%1|%2', 13923, 13922);
                if GlEntry.findset then
                    repeat
                        GlEntry.Delete();
                    until GlEntry.Next() = 0;

                CustEntry.SetFilter("Entry No.", '%1', 13923);
                if CustEntry.findset then
                    repeat
                        CustEntry.Delete();
                    until CustEntry.Next() = 0;

                DetCustEntry.SetFilter("Entry No.", '%1|%2|%3|%4|%5', 7297, 7298, 7299, 7468, 7469, 7469);
                if DetCustEntry.FindSet then
                    repeat
                        DetCustEntry.Delete();
                    until DetCustEntry.Next() = 0;

                BankEntry.SetFilter("Entry No.", '%1', 13922);
                if BankEntry.FindSet then
                    repeat
                        BankEntry.Delete();
                    until BankEntry.Next() = 0;
            end;

            trigger OnPostDataItem()
            begin
                Message('Opération de mise à jour terminée')
            end;

        }
    }


}