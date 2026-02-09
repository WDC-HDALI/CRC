namespace CRC.CRC;

using Microsoft.Foundation.Company;
using Microsoft.Inventory.Ledger;
using Microsoft.Inventory.History;

report 50907 DeleteShipmentEntries
{
    CaptionML = ENU = 'Delete shipment entries ', FRA = 'Supprimer sortie stock validéé';
    UseRequestPage = false;
    Permissions = tabledata "Invt. Shipment Header" = RIMD, tabledata "Item Ledger Entry" = RIMD, tabledata "Value Entry" = RIMD, tabledata "Invt. Shipment Line" = RIMD;
    ApplicationArea = All;
    ProcessingOnly = true;
    UsageCategory = Lists;
    dataset
    {
        dataitem(CompanyInformation; "Company Information")
        {
            column(Name; "Name")
            {
            }
            trigger OnAfterGetRecord()
            var
                linvshipmentheader: record "Invt. Shipment Header";
                lItemLedgerEntry: record "Item Ledger Entry";
                lValueEntry: record "Value Entry";
                lInvtShipmentLine: record "Invt. Shipment Line";
            begin
                if confirm('voulez vous supprimer les écritures de la sortie de stock BS250003 ?', false) then begin
                    linvshipmentheader.reset();
                    lItemLedgerEntry.reset();
                    lValueEntry.reset();
                    if linvshipmentheader.get('BS250003') then
                        linvshipmentheader.Delete();

                    lInvtShipmentLine.reset();
                    lInvtShipmentLine.setrange("Document No.", 'BS250003');
                    if lInvtShipmentLine.FindSet() then
                        repeat
                            lInvtShipmentLine.Delete();
                        until lInvtShipmentLine.next() = 0;

                    if lItemLedgerEntry.get(8750) then
                        lItemLedgerEntry.Delete();
                    if lValueEntry.get(13006) then
                        lValueEntry.Delete();
                end;
            End;

            trigger OnPostDataItem()
            begin
                Message('Opération de mise à jour terminée')
            end;

        }
    }

}

