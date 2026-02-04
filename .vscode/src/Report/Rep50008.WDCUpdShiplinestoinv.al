namespace CRC.CRC;

using Microsoft.Foundation.Company;
using Microsoft.Sales.History;
using Microsoft.Sales.Document;
using Microsoft.Inventory.Ledger;

report 50008 "WDC Upd Ship. lines to inv."
{
    ApplicationArea = All;
    CaptionML = ENU = 'Init. Shipments Lines to Invoice', FRA = 'Rénitialiser lignes d''expédition à facturer';
    UsageCategory = Administration;
    ProcessingOnly = true;
    Permissions = TableData "Sales Shipment Line" = rimd,
                  TableData "Item Ledger Entry" = rimd,
                  TableData "Sales Line" = rimd;
    dataset
    {
        dataitem(SalesShipmentLine; "Sales Shipment Line")
        {
            DataItemTableView = sorting("Document No.", "Line No.");
            trigger OnPreDataItem();
            var
                lText001: TextConst ENU = 'Please select Shipment No. to proceed.',
                                FRA = 'Veuillez sélectionner le numéro d''expédition pour continuer.';
            begin
                if ShipmentNo = '' then
                    Error(lText001);
                SalesShipmentLine.setfilter("Document No.", ShipmentNo);
            end;

            trigger OnAfterGetRecord()
            var
            begin
                SalesShipmentLine."Quantity Invoiced" := 0;
                SalesShipmentLine."Qty. Invoiced (Base)" := 0;
                SalesShipmentLine."Qty. Shipped Not Invoiced" := SalesShipmentLine.Quantity;
                SalesShipmentLine.Modify();

                ItemLedgerEntry.reset;
                ItemLedgerEntry.SetRange("Document No.", SalesShipmentLine."Document No.");
                ItemLedgerEntry.SetRange("Document Line No.", SalesShipmentLine."Line No.");
                ItemLedgerEntry.SetRange("Entry Type", ItemLedgerEntry."Entry Type"::Sale);
                ItemLedgerEntry.SetRange("Document Type", ItemLedgerEntry."Document Type"::"Sales Shipment");
                if ItemLedgerEntry.FindFirst() then begin
                    //ItemLedgerEntry."Shipped Qty. Not Returned" := ;
                    ItemLedgerEntry."Invoiced Quantity" := 0;
                    ItemLedgerEntry."Completely Invoiced" := false;
                    ItemLedgerEntry."Last Invoice Date" := 0D;
                    ItemLedgerEntry.Modify();
                end;
                if SalesLines.Get(SalesLines."Document Type"::Order, SalesShipmentLine."Order No.", SalesShipmentLine."Order Line No.") then begin
                    SalesLines."Quantity Invoiced" := 0;
                    SalesLines."Qty. Invoiced (Base)" := 0;
                    SalesLines.Validate("Qty. to Invoice", SalesShipmentLine.Quantity);
                    SalesLines.Validate("Qty. Shipped Not Invoiced", SalesShipmentLine.Quantity);
                    SalesLines."Qty. Shipped Not Invd. (Base)" := SalesShipmentLine.Quantity;
                    SalesLines."Qty. Invoiced (Base)" := 0;
                    SalesLines."Shipped Not Inv. (LCY) No VAT" := SalesLines.Amount;
                    SalesLines."Shipped Not Invoiced (LCY)" := SalesLines."Amount Including VAT";
                    SalesLines.Modify();
                end;
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(filterGroup)
                {
                    Caption = 'Filters';

                    field(ShipmentNo; ShipmentNo)
                    {

                        Captionml = ENU = 'Shipment No.', FRA = 'N° d''expédition';
                        TableRelation = "Sales Shipment Header";
                        ApplicationArea = All;
                    }
                }
            }
        }

    }
    var
        ShipmentNo: Code[50];
        SalesLines: Record "Sales Line";
        ItemLedgerEntry: Record "Item Ledger Entry";
}
