namespace CRC.CRC;

using Microsoft.Purchases.Payables;

page 50026 "WDCDetailed Vendor Ledg. Ent"
{
    ApplicationArea = All;
    Caption = 'WDCDetailed Vendor Ledg. Ent';
    PageType = List;
    SourceTable = "Detailed Vendor Ledg. Entry";
    UsageCategory = Lists;
    Editable = true;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                }
                field("Entry Type"; Rec."Entry Type")
                {
                }
                field("Document No."; Rec."Document No.")
                {
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                }
                field(Amount; Rec.Amount)
                {
                }
                field("Amount (LCY)"; Rec."Amount (LCY)")
                {
                }

                field("Vendor Ledger Entry No."; Rec."Vendor Ledger Entry No.")
                {
                }
                field("Application No."; Rec."Application No.")
                {
                }
                field("Applied Vend. Ledger Entry No."; Rec."Applied Vend. Ledger Entry No.")
                {
                }
                field("Credit Amount"; Rec."Credit Amount")
                {
                }
                field("Credit Amount (LCY)"; Rec."Credit Amount (LCY)")
                {
                }
                field("Currency Code"; Rec."Currency Code")
                {
                }
                field("Debit Amount"; Rec."Debit Amount")
                {
                }
                field("Debit Amount (LCY)"; Rec."Debit Amount (LCY)")
                {
                }

                field("Document Type"; Rec."Document Type")
                {
                }

                field("Exch. Rate Adjmt. Reg. No."; Rec."Exch. Rate Adjmt. Reg. No.")
                {
                }
                field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
                {
                }
                field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
                {
                }
                field("Initial Document Type"; Rec."Initial Document Type")
                {
                }
                field("Initial Entry Due Date"; Rec."Initial Entry Due Date")
                {
                }
                field("Initial Entry Global Dim. 1"; Rec."Initial Entry Global Dim. 1")
                {
                }
                field("Initial Entry Global Dim. 2"; Rec."Initial Entry Global Dim. 2")
                {
                }
                field("Journal Batch Name"; Rec."Journal Batch Name")
                {
                }
                field("Ledger Entry Amount"; Rec."Ledger Entry Amount")
                {
                }
                field("Max. Payment Tolerance"; Rec."Max. Payment Tolerance")
                {
                }
                field("Posting Date"; Rec."Posting Date")
                {
                }
                field("Posting Group"; Rec."Posting Group")
                {
                }
                field("Reason Code"; Rec."Reason Code")
                {
                }
                field("Remaining Pmt. Disc. Possible"; Rec."Remaining Pmt. Disc. Possible")
                {
                }
                field("Source Code"; Rec."Source Code")
                {
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                }
                field(SystemCreatedBy; Rec.SystemCreatedBy)
                {
                }
                field(SystemId; Rec.SystemId)
                {
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                }
                field(SystemModifiedBy; Rec.SystemModifiedBy)
                {
                }
                field("Tax Jurisdiction Code"; Rec."Tax Jurisdiction Code")
                {
                }
                field("Transaction No."; Rec."Transaction No.")
                {
                }
                field("Transit Folder No."; Rec."Transit Folder No.")
                {
                }
                field(Unapplied; Rec.Unapplied)
                {
                }
                field("Unapplied by Entry No."; Rec."Unapplied by Entry No.")
                {
                }
                field("Use Tax"; Rec."Use Tax")
                {
                }
                field("User ID"; Rec."User ID")
                {
                }
                field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group")
                {
                }
                field("VAT Prod. Posting Group"; Rec."VAT Prod. Posting Group")
                {
                }

            }
        }
    }
}
