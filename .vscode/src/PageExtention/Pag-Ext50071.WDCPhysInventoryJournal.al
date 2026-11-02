namespace CRC.CRC;

using Microsoft.Finance.GeneralLedger.Journal;
using Microsoft.Inventory.Counting.Journal;
using Microsoft.Inventory.Journal;

pageextension 50071 "WDC Phys. Inventory Journal" extends "Phys. Inventory Journal"
{
    layout
    {
        addafter("Qty. (Phys. Inventory)")
        {
            field("Qty to apply"; Rec."Qty to apply")
            {
                ApplicationArea = all;
            }
        }
    }
    actions
    {
        addafter(Print)
        {
            // action(InitImport)
            // {
            //     ApplicationArea = All;
            //     CaptionML = ENU = 'InitImport', FRA = 'Initialiser l''import';
            //     Image = Restore;
            //     trigger OnAction()
            //     var
            //         ItemJournalLine: Record "Item Journal Line";
            //     begin
            //         ItemJournalLine.Reset();
            //         ItemJournalLine.SetRange("Journal Template Name", 'INVENTAIRE');
            //         ItemJournalLine.SetRange("Journal Batch Name", 'CORR-INV25');
            //         ItemJournalLine.ModifyAll("Phys. Inventory", true);
            //     end;

            // }

            action(Import)
            {
                ApplicationArea = All;
                CaptionML = ENU = 'Import inventory lines', FRA = 'Import lignes inventaire';
                Image = ImportExcel;
                RunObject = xmlport "WDC Import Phy. Inventory";

            }
            action("Apply quantity")
            {
                ApplicationArea = All;
                CaptionML = ENU = 'Apply quantity', FRA = 'Appliquer quantité';
                Image = Restore;
                trigger OnAction()
                var
                    ItemJournalLine: Record "Item Journal Line";
                begin
                    ItemJournalLine.Reset();
                    ItemJournalLine.SetRange("Journal Template Name", Rec."Journal Template Name");
                    ItemJournalLine.SetRange("Journal Batch Name", rec."Journal Batch Name");
                    if ItemJournalLine.FindFirst() then
                        repeat
                            ItemJournalLine.Validate("Qty. (Phys. Inventory)", ItemJournalLine."Qty to apply");
                            ItemJournalLine.Modify;
                        until ItemJournalLine.Next() = 0;
                    Message('Opération terminée');
                end;

            }
        }
    }
}
