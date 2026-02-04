namespace CRC.CRC;

using Microsoft.Inventory.Ledger;

page 50031 "WDC Value Entry"
{
    ApplicationArea = All;
    Caption = 'WDC Value Entry';
    PageType = List;
    SourceTable = "Value Entry";
    UsageCategory = Administration;
    Permissions = tabledata "Value Entry" = rimd;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                }

                field("Entry Type"; Rec."Entry Type")
                {
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                }
                field("Item Ledger Entry Type"; Rec."Item Ledger Entry Type")
                {
                    ApplicationArea = All;
                }
                field("Item Ledger Entry No."; Rec."Item Ledger Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Invoiced Quantity"; Rec."Invoiced Quantity")
                {
                    ApplicationArea = All;
                }
                field("Cost Amount (Actual) (ACY)"; Rec."Cost Amount (Actual) (ACY)")
                {
                    ApplicationArea = All;
                }
                field("Cost Amount (Expected)"; Rec."Cost Amount (Expected)")
                {
                    ApplicationArea = All;
                }
                field("Cost Amount (Expected) (ACY)"; Rec."Cost Amount (Expected) (ACY)")
                {
                    ApplicationArea = All;
                }
                field("Cost Amount (Non-Invtbl.)"; Rec."Cost Amount (Non-Invtbl.)")
                {
                    ApplicationArea = All;
                }
                field("Cost Amount (Non-Invtbl.)(ACY)"; Rec."Cost Amount (Non-Invtbl.)(ACY)")
                {
                    ApplicationArea = All;
                }
                field("Cost Posted to G/L"; Rec."Cost Posted to G/L")
                {
                    ApplicationArea = All;
                }
                field("Cost Posted to G/L (ACY)"; Rec."Cost Posted to G/L (ACY)")
                {
                    ApplicationArea = All;
                }
                field("Cost per Unit"; Rec."Cost per Unit")
                {
                    ApplicationArea = All;
                }
                field("Cost per Unit (ACY)"; Rec."Cost per Unit (ACY)")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field(Adjustment; Rec.Adjustment)
                {
                    ApplicationArea = All;
                }
                field("Applies-to Entry"; Rec."Applies-to Entry")
                {
                    ApplicationArea = All;
                }
                field("Average Cost Exception"; Rec."Average Cost Exception")
                {
                    ApplicationArea = All;
                }
                field("Capacity Ledger Entry No."; Rec."Capacity Ledger Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Cost Amount (Actual)"; Rec."Cost Amount (Actual)")
                {
                    ApplicationArea = All;
                }
                field("Dimension Set ID"; Rec."Dimension Set ID")
                {
                    ApplicationArea = All;
                }
                field("Discount Amount"; Rec."Discount Amount")
                {
                    ApplicationArea = All;
                }
                field("Document Line No."; Rec."Document Line No.")
                {
                    ApplicationArea = All;
                }
                field("Drop Shipment"; Rec."Drop Shipment")
                {
                    ApplicationArea = All;
                }

                field("Purchase Amount (Actual)"; Rec."Purchase Amount (Actual)")
                {
                    ApplicationArea = All;
                }
                field("Purchase Amount (Expected)"; Rec."Purchase Amount (Expected)")
                {
                    ApplicationArea = All;
                }
                field("Exp. Cost Posted to G/L (ACY)"; Rec."Exp. Cost Posted to G/L (ACY)")
                {
                    ApplicationArea = All;
                }
                field("Expected Cost"; Rec."Expected Cost")
                {
                    ApplicationArea = All;
                }
                field("Expected Cost Posted to G/L"; Rec."Expected Cost Posted to G/L")
                {
                    ApplicationArea = All;
                }
                field("External Document No."; Rec."External Document No.")
                {
                    ApplicationArea = All;
                }
                field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
                {
                    ApplicationArea = All;
                }
                field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
                {
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = All;
                }
                field(Inventoriable; Rec.Inventoriable)
                {
                    ApplicationArea = All;
                }
                field("Inventory Posting Group"; Rec."Inventory Posting Group")
                {
                    ApplicationArea = All;
                }
                field("Item Charge No."; Rec."Item Charge No.")
                {
                    ApplicationArea = All;
                }
                field("Item Ledger Entry Quantity"; Rec."Item Ledger Entry Quantity")
                {
                    ApplicationArea = All;
                }
                field("Item Register No."; Rec."Item Register No.")
                {
                    ApplicationArea = All;
                }
                field("Job Ledger Entry No."; Rec."Job Ledger Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Job No."; Rec."Job No.")
                {
                    ApplicationArea = All;
                }
                field("Job Task No."; Rec."Job Task No.")
                {
                    ApplicationArea = All;
                }
                field("Journal Batch Name"; Rec."Journal Batch Name")
                {
                    ApplicationArea = All;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Order Line No."; Rec."Order Line No.")
                {
                    ApplicationArea = All;
                }
                field("Order No."; Rec."Order No.")
                {
                    ApplicationArea = All;
                }
                field("Order Type"; Rec."Order Type")
                {
                    ApplicationArea = All;
                }
                field("Partial Revaluation"; Rec."Partial Revaluation")
                {
                    ApplicationArea = All;
                }

                field("Reason Code"; Rec."Reason Code")
                {
                    ApplicationArea = All;
                }
                field("Return Reason Code"; Rec."Return Reason Code")
                {
                    ApplicationArea = All;
                }
                field("SIFT Bucket No."; Rec."SIFT Bucket No.")
                {
                    ApplicationArea = All;
                }
                field("Sales Amount (Actual)"; Rec."Sales Amount (Actual)")
                {
                    ApplicationArea = All;
                }
                field("Sales Amount (Expected)"; Rec."Sales Amount (Expected)")
                {
                    ApplicationArea = All;
                }
                field("Salespers./Purch. Code"; Rec."Salespers./Purch. Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 4 Code"; Rec."Shortcut Dimension 4 Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 5 Code"; Rec."Shortcut Dimension 5 Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 6 Code"; Rec."Shortcut Dimension 6 Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 7 Code"; Rec."Shortcut Dimension 7 Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 8 Code"; Rec."Shortcut Dimension 8 Code")
                {
                    ApplicationArea = All;
                }
                field("Source Code"; Rec."Source Code")
                {
                    ApplicationArea = All;
                }
                field("Source No."; Rec."Source No.")
                {
                    ApplicationArea = All;
                }
                field("Source Posting Group"; Rec."Source Posting Group")
                {
                    ApplicationArea = All;
                }
                field("Source Type"; Rec."Source Type")
                {
                    ApplicationArea = All;
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ApplicationArea = All;
                }
                field(SystemCreatedBy; Rec.SystemCreatedBy)
                {
                    ApplicationArea = All;
                }
                field(SystemId; Rec.SystemId)
                {
                    ApplicationArea = All;
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                    ApplicationArea = All;
                }
                field(SystemModifiedBy; Rec.SystemModifiedBy)
                {
                    ApplicationArea = All;
                }
                field("Transit Folder No."; Rec."Transit Folder No.")
                {
                    ApplicationArea = All;
                }
                field("Type"; Rec."Type")
                {
                    ApplicationArea = All;
                }
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = All;
                }
                field("VAT Reporting Date"; Rec."VAT Reporting Date")
                {
                    ApplicationArea = All;
                }
                field("Valuation Date"; Rec."Valuation Date")
                {
                    ApplicationArea = All;
                }
                field("Valued By Average Cost"; Rec."Valued By Average Cost")
                {
                    ApplicationArea = All;
                }
                field("Valued Quantity"; Rec."Valued Quantity")
                {
                    ApplicationArea = All;
                }
                field("Variance Type"; Rec."Variance Type")
                {
                    ApplicationArea = All;
                }
                field("Variant Code"; Rec."Variant Code")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
