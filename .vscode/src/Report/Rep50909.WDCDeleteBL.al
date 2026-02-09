namespace CRC.CRC;

using Microsoft.Sales.History;
using Microsoft.Inventory.Ledger;
using Microsoft.Foundation.Company;
using Microsoft.Finance.VAT.Ledger;
using Microsoft.Bank.Ledger;
using Microsoft.Sales.Receivables;
using Microsoft.Finance.GeneralLedger.Ledger;
//**********************documentation***********************//
//wdc01   wdc.FS   23/12/2025   Report: Delete Paiement
//************************************************************//

report 50909 "WDC Delete BL"
{
    CaptionML = ENU = 'Delete Sales shipment', FRA = 'Delete Sales shipment';
    //UseRequestPage = false;
    Permissions = tabledata "Item Ledger Entry" = RIMD, tabledata "Sales Shipment Header" = RIMD, tabledata "Sales Shipment Line" = RIMD, tabledata "Value Entry" = RIMD;
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
                ItemLedgEntry: Record "Item Ledger Entry";
                SalesShipHeader: Record "Sales Shipment Header";
                SalesShipLine: Record "Sales Shipment Line";
                ValueEntry: Record "Value Entry";
                Text001: TextConst ENU = 'You must enter a Document No.', FRA = 'Vous devez entrer un N° de document';
            begin
                //<<wdc01
                if DocumentNo = '' then
                    Error(Text001);

                ItemLedgEntry.reset();
                ItemLedgEntry.SetRange("Document No.", DocumentNo);
                if ItemLedgEntry.FindSet then
                    repeat
                        ItemLedgEntry.Delete();
                    until ItemLedgEntry.Next() = 0;



                ValueEntry.reset();
                ValueEntry.SetRange("Document No.", DocumentNo);
                if ValueEntry.FindSet then
                    repeat
                        ValueEntry.Delete();
                    until ValueEntry.Next() = 0;

                SalesShipLine.reset();
                SalesShipLine.SetRange("Document No.", DocumentNo);
                if SalesShipLine.FindSet then
                    repeat
                        SalesShipLine.Delete();
                    until SalesShipLine.Next() = 0;

                SalesShipHeader.reset();
                SalesShipHeader.SetRange("No.", DocumentNo);
                if SalesShipHeader.FindSet then
                    SalesShipHeader.Delete();
            end;

            trigger OnPostDataItem()
            var
                Text002: TextConst ENU = 'Payment deleted for Document No.: %1', FRA = 'Paiement supprimé pour le N° de document : %1';
            begin
                Message(Text002, DocumentNo);
            end;

        }


    }

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


    var
        DocumentNo: Code[20];
}