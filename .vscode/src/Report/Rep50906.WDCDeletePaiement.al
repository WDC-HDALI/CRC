namespace CRC.CRC;

using Microsoft.Sales.History;
using Microsoft.Foundation.Company;
using Microsoft.Finance.VAT.Ledger;
using Microsoft.Bank.Ledger;
using Microsoft.Sales.Receivables;
using Microsoft.Finance.GeneralLedger.Ledger;
//**********************documentation***********************//
//wdc01   wdc.FS   26/11/2025   Report: Delete Paiement
//************************************************************//

report 50906 "WDC Delete Paiement"
{
    CaptionML = ENU = 'wdc Delete Paiement', FRA = 'wdc Supprimer Paiement';
    //UseRequestPage = false;
    Permissions = tabledata "G/L Entry" = RIMD, tabledata "Cust. Ledger Entry" = RIMD, tabledata "Detailed Cust. Ledg. Entry" = RIMD, tabledata "Bank Account Ledger Entry" = RIMD;
    ApplicationArea = All;
    ProcessingOnly = true;
    UsageCategory = Administration;


    dataset
    {

        dataitem("Company Information"; "Company Information")
        {
            column(Name; "Name") { }

            trigger OnAfterGetRecord()
            var
                GlEntry: Record "G/L Entry";
                CustEntry: Record "Cust. Ledger Entry";
                DetCustEntry: Record "Detailed Cust. Ledg. Entry";
                BankEntry: Record "Bank Account Ledger Entry";
                Text001: TextConst ENU = 'You must enter a Document No.', FRA = 'Vous devez entrer un N° de document';
            begin
                //<<wdc01
                if DocumentNo = '' then
                    Error(Text001);

                GlEntry.reset();
                GlEntry.SetRange("Document No.", DocumentNo);
                GlEntry.SetRange("Document Type", GlEntry."Document Type"::Payment);
                if GlEntry.FindSet then
                    repeat
                        GlEntry.Delete();
                    until GlEntry.Next() = 0;

                CustEntry.reset();
                CustEntry.SetRange("Document No.", DocumentNo);
                CustEntry.SetRange("Document Type", CustEntry."Document Type"::Payment);
                if CustEntry.FindSet then
                    repeat
                        CustEntry.Delete();
                    until CustEntry.Next() = 0;

                DetCustEntry.reset();
                DetCustEntry.SetRange("Document No.", DocumentNo);
                DetCustEntry.SetRange("Document Type", DetCustEntry."Document Type"::Payment);
                if DetCustEntry.FindSet then
                    repeat
                        DetCustEntry.Delete();
                    until DetCustEntry.Next() = 0;

                BankEntry.Reset();
                BankEntry.SetRange("Document No.", DocumentNo);
                BankEntry.SetRange("Document Type", BankEntry."Document Type"::Payment);
                if BankEntry.FindSet then
                    repeat
                        BankEntry.Delete();
                    until BankEntry.Next() = 0;

            end;

            trigger OnPostDataItem()
            var
                Text002: TextConst ENU = 'Payment deleted for Document No.: %1', FRA = 'Paiement supprimé pour le N° de document : %1';
            begin
                Message(Text002, DocumentNo);
            end;
            //>>wdc01
        }


    }
    //<<wdc01
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Options)
                {
                    field(DocumentNo; DocumentNo)
                    {
                        ApplicationArea = All;
                        CaptionML = ENU = 'Document No.', FRA = 'N° de document';
                    }
                }
            }
        }
    }
    //>>wdc01

    var
        DocumentNo: Code[20];
}