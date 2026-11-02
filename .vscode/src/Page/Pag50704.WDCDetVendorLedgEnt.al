namespace CRC.CRC;

using Microsoft.Purchases.Payables;

page 50704 "WDC Det. Vendor Ledg. Ent"
{
    ApplicationArea = All;
    Caption = 'WDC Det. Vendor Ledg. Ent';
    PageType = List;
    SourceTable = "Detailed Vendor Ledg. Entry";
    UsageCategory = Administration;
    Editable = true;
    Permissions = tabledata "Detailed Vendor Ledg. Entry" = RIMD;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = all;
                }
                field("Entry Type"; Rec."Entry Type")
                {
                    ApplicationArea = all;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = all;
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = all;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = all;
                }
                field("Amount (LCY)"; Rec."Amount (LCY)")
                {
                    ApplicationArea = all;
                }

                field("Vendor Ledger Entry No."; Rec."Vendor Ledger Entry No.")
                {
                    ApplicationArea = all;
                }
                field("Application No."; Rec."Application No.")
                {
                    ApplicationArea = all;
                }
                field("Applied Vend. Ledger Entry No."; Rec."Applied Vend. Ledger Entry No.")
                {
                    ApplicationArea = all;
                }
                field("Credit Amount"; Rec."Credit Amount")
                {
                    ApplicationArea = all;
                }
                field("Credit Amount (LCY)"; Rec."Credit Amount (LCY)")
                {
                    ApplicationArea = all;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = all;
                }
                field("Debit Amount"; Rec."Debit Amount")
                {
                    ApplicationArea = all;
                }
                field("Debit Amount (LCY)"; Rec."Debit Amount (LCY)")
                {
                    ApplicationArea = all;
                }

                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = all;
                }

                field("Exch. Rate Adjmt. Reg. No."; Rec."Exch. Rate Adjmt. Reg. No.")
                {
                    ApplicationArea = all;
                }
                field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
                {
                    ApplicationArea = all;
                }
                field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
                {
                    ApplicationArea = all;
                }
                field("Initial Document Type"; Rec."Initial Document Type")
                {
                    ApplicationArea = all;
                }
                field("Initial Entry Due Date"; Rec."Initial Entry Due Date")
                {
                    ApplicationArea = all;
                }
                field("Initial Entry Global Dim. 1"; Rec."Initial Entry Global Dim. 1")
                {
                    ApplicationArea = all;
                }
                field("Initial Entry Global Dim. 2"; Rec."Initial Entry Global Dim. 2")
                {
                    ApplicationArea = all;
                }
                field("Journal Batch Name"; Rec."Journal Batch Name")
                {
                    ApplicationArea = all;
                }
                field("Ledger Entry Amount"; Rec."Ledger Entry Amount")
                {
                    ApplicationArea = all;
                }
                field("Max. Payment Tolerance"; Rec."Max. Payment Tolerance")
                {
                    ApplicationArea = all;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = all;
                }
                field("Posting Group"; Rec."Posting Group")
                {
                    ApplicationArea = all;
                }
                field("Reason Code"; Rec."Reason Code")
                {
                    ApplicationArea = all;
                }
                field("Remaining Pmt. Disc. Possible"; Rec."Remaining Pmt. Disc. Possible")
                {
                    ApplicationArea = all;
                }
                field("Source Code"; Rec."Source Code")
                {
                    ApplicationArea = all;
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ApplicationArea = all;
                }
                field(SystemCreatedBy; Rec.SystemCreatedBy)
                {
                    ApplicationArea = all;
                }
                field(SystemId; Rec.SystemId)
                {
                    ApplicationArea = all;
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                    ApplicationArea = all;
                }
                field(SystemModifiedBy; Rec.SystemModifiedBy)
                {
                    ApplicationArea = all;
                }
                field("Tax Jurisdiction Code"; Rec."Tax Jurisdiction Code")
                {
                    ApplicationArea = all;
                }
                field("Transaction No."; Rec."Transaction No.")
                {
                    ApplicationArea = all;
                }
                field("Transit Folder No."; Rec."Transit Folder No.")
                {
                    ApplicationArea = all;
                }
                field(Unapplied; Rec.Unapplied)
                {
                    ApplicationArea = all;
                }
                field("Unapplied by Entry No."; Rec."Unapplied by Entry No.")
                {
                    ApplicationArea = all;
                }
                field("Use Tax"; Rec."Use Tax")
                {
                    ApplicationArea = all;
                }
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = all;
                }
                field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group")
                {
                    ApplicationArea = all;
                }
                field("VAT Prod. Posting Group"; Rec."VAT Prod. Posting Group")
                {
                    ApplicationArea = all;
                }

            }
        }
    }
}
