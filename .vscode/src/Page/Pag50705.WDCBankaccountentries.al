namespace CRC.CRC;

using Microsoft.Bank.Ledger;

page 50705 "WDC Bank account entries"
{
    ApplicationArea = All;
    Caption = 'WDC Bank account entries';
    PageType = List;
    SourceTable = "Bank Account Ledger Entry";
    Permissions = tabledata "Bank Account Ledger Entry" = RIMD;
    UsageCategory = Administration;

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
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = all;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = all;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = all;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = all;
                }
                field("Payment Slip Type"; Rec."Payment Slip Type")
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
                field("Bal. Account No."; Rec."Bal. Account No.")
                {
                    ApplicationArea = all;
                }
                field("Bal. Account Type"; Rec."Bal. Account Type")
                {
                    ApplicationArea = all;
                }
                field("Bank Acc. Posting Group"; Rec."Bank Acc. Posting Group")
                {
                    ApplicationArea = all;
                }
                field("Bank Account No."; Rec."Bank Account No.")
                {
                    ApplicationArea = all;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                }
                field("Debit Amount (LCY)"; Rec."Debit Amount (LCY)")
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
                field("Credit Amount (LCY)"; Rec."Credit Amount (LCY)")
                {
                    ApplicationArea = all;
                }
                field(Positive; Rec.Positive)
                {
                    ApplicationArea = all;
                }
                field(Open; Rec.Open)
                {
                    ApplicationArea = all;
                }
                field(Lettrage; Rec.Lettrage)
                {
                    ApplicationArea = all;
                }
                field("Check Ledger Entries"; Rec."Check Ledger Entries")
                {
                    ApplicationArea = all;
                }
                field("Closed at Date"; Rec."Closed at Date")
                {
                    ApplicationArea = all;
                }
                field("Closed by Entry No."; Rec."Closed by Entry No.")
                {
                    ApplicationArea = all;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = all;
                }
                field("Dimension Set ID"; Rec."Dimension Set ID")
                {
                    ApplicationArea = all;
                }
                field("External Document No."; Rec."External Document No.")
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
                field("Initial Date"; Rec."Initial Date")
                {
                    ApplicationArea = all;
                }
                field("Initial Document No."; Rec."Initial Document No.")
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
                field("Our Contact Code"; Rec."Our Contact Code")
                {
                    ApplicationArea = all;
                }
                field("Reason Code"; Rec."Reason Code")
                {
                    ApplicationArea = all;
                }
                field("Remaining Amount"; Rec."Remaining Amount")
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
                field("Statement Date"; Rec."Statement Date")
                {
                    ApplicationArea = all;
                }
                field("Statement Line No."; Rec."Statement Line No.")
                {
                    ApplicationArea = all;
                }
                field("Statement No."; Rec."Statement No.")
                {
                    ApplicationArea = all;
                }
                field("Statement Status"; Rec."Statement Status")
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
                field("Transaction No."; Rec."Transaction No.")
                {
                    ApplicationArea = all;
                }
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = all;
                }
            }
        }
    }
}
