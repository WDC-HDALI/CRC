namespace CRC.CRC;

using Microsoft.Foundation.Company;
using Microsoft.Inventory.Ledger;
using Microsoft.Inventory.History;
using Microsoft.Sales.History;

report 50908 "WDC Rename Sales Shipment"
{
    CaptionML = ENU = 'Rename Sales shipment', FRA = 'Renommer Expédition ventes enregistrées';
    Permissions = tabledata "Sales Shipment Header" = RIMD, tabledata "Item Ledger Entry" = RIMD, tabledata "Value Entry" = RIMD, tabledata "Sales Shipment Line" = RIMD;
    ApplicationArea = All;
    UsageCategory = Lists;
    ProcessingOnly = true;
    dataset
    {
        dataitem("Sales Shipment Header"; "Sales Shipment Header")
        {
            RequestFilterFields = "No.";
            column(No_; "No.")
            {
            }
            trigger OnAfterGetRecord()
            var
                linvshipmentheader: record "Invt. Shipment Header";
                lItemLedgerEntry: record "Item Ledger Entry";
                lValueEntry: record "Value Entry";
                lSalesShipmentLine: record "Sales Shipment Line";
            begin
                if DocumentNo = '' then
                    Error('Le numéro d''expédition ne peut pas être vide.');

                if confirm('voulez vous renommer l''expédition ?', false) then begin

                    //     lSalesShipmentLine.reset();
                    //     lSalesShipmentLine.setrange("Document No.", "Sales Shipment Header"."No.");
                    //     if lSalesShipmentLine.FindSet() then
                    //         repeat
                    //             lSalesShipmentLine."Document No." := DocumentNo;
                    //             lSalesShipmentLine.Modify();
                    //         until lSalesShipmentLine.next() = 0;

                    lItemLedgerEntry.reset();
                    lItemLedgerEntry.SetRange("Document No.", "Sales Shipment Header"."No.");
                    if lItemLedgerEntry.FindFirst() then
                        repeat
                            lItemLedgerEntry."Document No." := DocumentNo;
                            lItemLedgerEntry.Modify();
                        until lItemLedgerEntry.next() = 0;

                    lValueEntry.reset();
                    lValueEntry.SetRange("Document No.", "Sales Shipment Header"."No.");
                    if lValueEntry.FindFirst() then
                        repeat
                            lValueEntry."Document No." := DocumentNo;
                            lValueEntry.Modify();
                        until lValueEntry.next() = 0;
                    "Sales Shipment Header".Rename(DocumentNo);
                end;

                //end;
            End;

            trigger OnPostDataItem()
            begin
                Message('Opération de mise à jour terminée')
            end;

        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(Group)
                {
                    Caption = 'Paramètres';

                    field("DocumentNo"; DocumentNo)
                    {
                        Caption = 'Nouveau numéro d''expédition';
                        ApplicationArea = All;
                    }
                }
            }
        }
    }
    var
        DocumentNo: Code[20];

}

