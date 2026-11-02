namespace CRC.CRC;

using Microsoft.Finance.GeneralLedger.Ledger;

page 50708 "WDC G/L Entry"
{
    ApplicationArea = All;
    Caption = 'WDC G/L Entry';
    PageType = List;
    SourceTable = "G/L Entry";
    UsageCategory = Administration;
    Permissions = tabledata "G/L Entry" = RIMD;

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
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = all;
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = all;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = all;
                }
                field("G/L Account No."; Rec."G/L Account No.")
                {
                    ApplicationArea = all;
                }
                field("G/L Account Name"; Rec."G/L Account Name")
                {
                    ApplicationArea = all;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                }
                field("Bal. Account Type"; Rec."Bal. Account Type")
                {
                    ApplicationArea = all;
                }
                field("Bal. Account No."; Rec."Bal. Account No.")
                {
                    ApplicationArea = all;
                }
                field("Debit Amount"; Rec."Debit Amount")
                {
                    ApplicationArea = all;
                }
                field("Credit Amount"; Rec."Credit Amount")
                {
                    ApplicationArea = all;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = all;
                }
                field("Payment Slip Type"; Rec."Payment Slip Type")
                {
                    ApplicationArea = all;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = all;
                }
                field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
                {
                    ApplicationArea = all;
                }
                field("Gen. Posting Type"; Rec."Gen. Posting Type")
                {
                    ApplicationArea = all;
                }
                field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
                {
                    ApplicationArea = all;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = all;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = all;
                }
                field("Account Id"; Rec."Account Id")
                {
                    ApplicationArea = all;
                }
                field("Add.-Currency Credit Amount"; Rec."Add.-Currency Credit Amount")
                {
                    ApplicationArea = all;
                }
                field("Add.-Currency Debit Amount"; Rec."Add.-Currency Debit Amount")
                {
                    ApplicationArea = all;
                }
                field("Additional-Currency Amount"; Rec."Additional-Currency Amount")
                {
                    ApplicationArea = all;
                }
                field("Alloc. Journal Line SystemId"; Rec."Alloc. Journal Line SystemId")
                {
                    ApplicationArea = all;
                }
                field("Allocation Account No."; Rec."Allocation Account No.")
                {
                    ApplicationArea = all;
                }
                field("Business Unit Code"; Rec."Business Unit Code")
                {
                    ApplicationArea = all;
                }
                field("Close Income Statement Dim. ID"; Rec."Close Income Statement Dim. ID")
                {
                    ApplicationArea = all;
                }
                field(Comment; Rec.Comment)
                {
                    ApplicationArea = all;
                }
                field("Dimension Changes Count"; Rec."Dimension Changes Count")
                {
                    ApplicationArea = all;
                }
                field("Dimension Set ID"; Rec."Dimension Set ID")
                {
                    ApplicationArea = all;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = all;
                }
                field("External Document No."; Rec."External Document No.")
                {
                    ApplicationArea = all;
                }
                field("FA Entry No."; Rec."FA Entry No.")
                {
                    ApplicationArea = all;
                }
                field("FA Entry Type"; Rec."FA Entry Type")
                {
                    ApplicationArea = all;
                }
                field("IC Partner Code"; Rec."IC Partner Code")
                {
                    ApplicationArea = all;
                }
                field("Job No."; Rec."Job No.")
                {
                    ApplicationArea = all;
                }
                field("Journal Batch Name"; Rec."Journal Batch Name")
                {
                    ApplicationArea = all;
                }
                field("Journal Templ. Name"; Rec."Journal Templ. Name")
                {
                    ApplicationArea = all;
                }
                field("Last Dim. Correction Entry No."; Rec."Last Dim. Correction Entry No.")
                {
                    ApplicationArea = all;
                }
                field("Last Dim. Correction Node"; Rec."Last Dim. Correction Node")
                {
                    ApplicationArea = all;
                }
                field("Last Modified DateTime"; Rec."Last Modified DateTime")
                {
                    ApplicationArea = all;
                }
                field("No. Series"; Rec."No. Series")
                {
                    ApplicationArea = all;
                }
                field("Non-Deductible VAT Amount"; Rec."Non-Deductible VAT Amount")
                {
                    ApplicationArea = all;
                }
                field("Non-Deductible VAT Amount ACY"; Rec."Non-Deductible VAT Amount ACY")
                {
                    ApplicationArea = all;
                }
                field("Prior-Year Entry"; Rec."Prior-Year Entry")
                {
                    ApplicationArea = all;
                }
                field("Prod. Order No."; Rec."Prod. Order No.")
                {
                    ApplicationArea = all;
                }
                field("Reason Code"; Rec."Reason Code")
                {
                    ApplicationArea = all;
                }
                field(Reversed; Rec.Reversed)
                {
                    ApplicationArea = all;
                }
                field("Reversed Entry No."; Rec."Reversed Entry No.")
                {
                    ApplicationArea = all;
                }
                field("Reversed by Entry No."; Rec."Reversed by Entry No.")
                {
                    ApplicationArea = all;
                }
                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                {
                    ApplicationArea = all;
                }
                field("Shortcut Dimension 4 Code"; Rec."Shortcut Dimension 4 Code")
                {
                    ApplicationArea = all;
                }
                field("Shortcut Dimension 5 Code"; Rec."Shortcut Dimension 5 Code")
                {
                    ApplicationArea = all;
                }
                field("Shortcut Dimension 6 Code"; Rec."Shortcut Dimension 6 Code")
                {
                    ApplicationArea = all;
                }
                field("Shortcut Dimension 7 Code"; Rec."Shortcut Dimension 7 Code")
                {
                    ApplicationArea = all;
                }
                field("Shortcut Dimension 8 Code"; Rec."Shortcut Dimension 8 Code")
                {
                    ApplicationArea = all;
                }
                field("Source Code"; Rec."Source Code")
                {
                    ApplicationArea = all;
                }
                field("Source Currency Amount"; Rec."Source Currency Amount")
                {
                    ApplicationArea = all;
                }
                field("Source Currency Code"; Rec."Source Currency Code")
                {
                    ApplicationArea = all;
                }
                field("Source Currency VAT Amount"; Rec."Source Currency VAT Amount")
                {
                    ApplicationArea = all;
                }
                field("Source No."; Rec."Source No.")
                {
                    ApplicationArea = all;
                }
                field("Source Type"; Rec."Source Type")
                {
                    ApplicationArea = all;
                }
                field("Src. Curr. Non-Ded. VAT Amount"; Rec."Src. Curr. Non-Ded. VAT Amount")
                {
                    ApplicationArea = all;
                }
                field("System-Created Entry"; Rec."System-Created Entry")
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
                field("Tax Area Code"; Rec."Tax Area Code")
                {
                    ApplicationArea = all;
                }
                field("Tax Group Code"; Rec."Tax Group Code")
                {
                    ApplicationArea = all;
                }
                field("Tax Liable"; Rec."Tax Liable")
                {
                    ApplicationArea = all;
                }
                field("Transaction No."; Rec."Transaction No.")
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
                field("VAT Amount"; Rec."VAT Amount")
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
                field("VAT Reporting Date"; Rec."VAT Reporting Date")
                {
                    ApplicationArea = all;
                }
            }
        }
    }
}
