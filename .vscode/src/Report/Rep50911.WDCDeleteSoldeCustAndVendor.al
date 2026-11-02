namespace CRC.CRC;

using Microsoft.Sales.History;
using Microsoft.Foundation.Company;
using Microsoft.Finance.VAT.Ledger;
using Microsoft.Bank.Ledger;
using Microsoft.Sales.Receivables;
using Microsoft.Inventory.Ledger;
using Microsoft.Purchases.Payables;
using Microsoft.Finance.GeneralLedger.Ledger;
//**********************documentation***********************//
//wdc01   wdc.FS   26/11/2025   Report: Delete Solde CustAndVendor
//************************************************************//

report 50911 "WDC Delete Solde CustAndVendor"
{

    CaptionML = ENU = 'wdc Delete Solde CustAndVendor', FRA = 'wdc Supprimer Solde Client et Fournisseur';
    //UseRequestPage = false;
    ApplicationArea = All;
    ProcessingOnly = true;
    //UsageCategory = Administration;
    Permissions = TableData "G/L Entry" = rimd,
   TableData "VAT Entry" = rimd,
   TableData "Value Entry" = rimd,
   TableData "Cust. Ledger Entry" = rimd,
   TableData "Detailed Cust. Ledg. Entry" = rimd,
    TableData "Vendor Ledger Entry" = rimd,
    TableData "Detailed Vendor Ledg. Entry" = rimd;

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
                lVendorLedgEntry: Record "Vendor Ledger Entry";
                lDetVendorLeg: Record "Detailed Vendor Ledg. Entry";
                Text001: TextConst ENU = 'You must enter a Document No.', FRA = 'Vous devez entrer un N° de document';
            begin
                //<<wdc01
                if DocumentNo = '' then
                    Error(Text001);

                GlEntry.reset();
                GlEntry.SetRange("Document No.", DocumentNo);
                if GlEntry.FindSet then
                    repeat
                        GlEntry.Delete();
                    until GlEntry.Next() = 0;

                CustEntry.reset();
                CustEntry.SetRange("Document No.", DocumentNo);
                if CustEntry.FindSet then
                    repeat
                        CustEntry.Delete();
                    until CustEntry.Next() = 0;

                DetCustEntry.reset();
                DetCustEntry.SetRange("Document No.", DocumentNo);
                if DetCustEntry.FindSet then
                    repeat
                        DetCustEntry.Delete();
                    until DetCustEntry.Next() = 0;

                lVendorLedgEntry.Reset();
                lVendorLedgEntry.SetRange("Document No.", DocumentNo);
                if lVendorLedgEntry.FindSet then
                    repeat
                        lVendorLedgEntry.Delete();
                    until lVendorLedgEntry.Next() = 0;

                lDetVendorLeg.Reset();
                lDetVendorLeg.SetRange("Document No.", DocumentNo);
                if lDetVendorLeg.FindSet then
                    repeat
                        lDetVendorLeg.Delete();
                    until lDetVendorLeg.Next() = 0;

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