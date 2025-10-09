namespace CRC.CRC;

using Microsoft.Inventory.Ledger;

page 50018 "WDC Update Item Ledger Entry"
{
    ApplicationArea = All;
    Caption = 'WDC Update Item Ledger Entry';
    PageType = List;
    SourceTable = "Item Ledger Entry";
    Editable = true;
    UsageCategory = Administration;
    Permissions = tabledata "Item Ledger Entry" = rimd;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Applied Entry to Adjust"; Rec."Applied Entry to Adjust")
                {
                }
                field("Applies-to Entry"; Rec."Applies-to Entry")
                {
                }
                field("Area"; Rec."Area")
                {
                }
                field("Assemble to Order"; Rec."Assemble to Order")
                {
                }
                field("Completely Invoiced"; Rec."Completely Invoiced")
                {
                }
                field(Correction; Rec.Correction)
                {
                }
                field("Cost Amount (Actual)"; Rec."Cost Amount (Actual)")
                {
                }
                field("Cost Amount (Actual) (ACY)"; Rec."Cost Amount (Actual) (ACY)")
                {
                }
                field("Cost Amount (Expected)"; Rec."Cost Amount (Expected)")
                {
                }
                field("Cost Amount (Expected) (ACY)"; Rec."Cost Amount (Expected) (ACY)")
                {
                }
                field("Cost Amount (Non-Invtbl.)"; Rec."Cost Amount (Non-Invtbl.)")
                {
                }
                field("Cost Amount (Non-Invtbl.)(ACY)"; Rec."Cost Amount (Non-Invtbl.)(ACY)")
                {
                }
                field("Country/Region Code"; Rec."Country/Region Code")
                {
                }
                field("Customer Name"; Rec."Customer Name")
                {
                }
                field("Customer No."; Rec."Customer No.")
                {
                }
                field("Derived from Blanket Order"; Rec."Derived from Blanket Order")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("Dimension Set ID"; Rec."Dimension Set ID")
                {
                }
                field("Document Date"; Rec."Document Date")
                {
                }
                field("Document Line No."; Rec."Document Line No.")
                {
                }
                field("Document No."; Rec."Document No.")
                {
                }
                field("Document Type"; Rec."Document Type")
                {
                }
                field("Drop Shipment"; Rec."Drop Shipment")
                {
                }
                field("Entry No."; Rec."Entry No.")
                {
                }
                field("Entry Type"; Rec."Entry Type")
                {
                }
                field("Entry/Exit Point"; Rec."Entry/Exit Point")
                {
                }
                field("Expiration Date"; Rec."Expiration Date")
                {
                }
                field("External Document No."; Rec."External Document No.")
                {
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                }
                field("Invoiced Quantity"; Rec."Invoiced Quantity")
                {
                }
                field("Item Category Code"; Rec."Item Category Code")
                {
                }
                field("Item Ledger Entry Quantity"; Rec."Item Ledger Entry Quantity")
                {
                }
                field("Item No."; Rec."Item No.")
                {
                }
                field("Item Reference No."; Rec."Item Reference No.")
                {
                }
                field("Item Register No."; Rec."Item Register No.")
                {
                }
                field("Item Tracking"; Rec."Item Tracking")
                {
                }
                field("Job No."; Rec."Job No.")
                {
                }
                field("Job Purchase"; Rec."Job Purchase")
                {
                }
                field("Job Task No."; Rec."Job Task No.")
                {
                }
                field("Last Invoice Date"; Rec."Last Invoice Date")
                {
                }
                field("Location Code"; Rec."Location Code")
                {
                }
                field("Lot No."; Rec."Lot No.")
                {
                }
                field("No. Series"; Rec."No. Series")
                {
                }
                field(Nonstock; Rec.Nonstock)
                {
                }
                field(Open; Rec.Open)
                {
                }
                field("Order Line No."; Rec."Order Line No.")
                {
                }
                field("Order No."; Rec."Order No.")
                {
                }
                field("Order Type"; Rec."Order Type")
                {
                }
                field("Originally Ordered No."; Rec."Originally Ordered No.")
                {
                }
                field("Originally Ordered Var. Code"; Rec."Originally Ordered Var. Code")
                {
                }
                field("Out-of-Stock Substitution"; Rec."Out-of-Stock Substitution")
                {
                }
                field("Package No."; Rec."Package No.")
                {
                }
                field(Positive; Rec.Positive)
                {
                }
                field("Posting Date"; Rec."Posting Date")
                {
                }
                field("Prod. Order Comp. Line No."; Rec."Prod. Order Comp. Line No.")
                {
                }
                field("Purchase Amount (Actual)"; Rec."Purchase Amount (Actual)")
                {
                }
                field("Purchase Amount (Expected)"; Rec."Purchase Amount (Expected)")
                {
                }
                field("Purchasing Code"; Rec."Purchasing Code")
                {
                }
                field("Qty. per Unit of Measure"; Rec."Qty. per Unit of Measure")
                {
                }
                field(Quantity; Rec.Quantity)
                {
                }
                field("Remaining Quantity"; Rec."Remaining Quantity")
                {
                }
                field("Reserved Quantity"; Rec."Reserved Quantity")
                {
                }
                field("Return Reason Code"; Rec."Return Reason Code")
                {
                }
                field("SIFT Bucket No."; Rec."SIFT Bucket No.")
                {
                }
                field("Sales Amount (Actual)"; Rec."Sales Amount (Actual)")
                {
                }
                field("Sales Amount (Expected)"; Rec."Sales Amount (Expected)")
                {
                }
                field("Serial No."; Rec."Serial No.")
                {
                }
                field("Shipped Qty. Not Returned"; Rec."Shipped Qty. Not Returned")
                {
                }
                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                {
                }
                field("Shortcut Dimension 4 Code"; Rec."Shortcut Dimension 4 Code")
                {
                }
                field("Shortcut Dimension 5 Code"; Rec."Shortcut Dimension 5 Code")
                {
                }
                field("Shortcut Dimension 6 Code"; Rec."Shortcut Dimension 6 Code")
                {
                }
                field("Shortcut Dimension 7 Code"; Rec."Shortcut Dimension 7 Code")
                {
                }
                field("Shortcut Dimension 8 Code"; Rec."Shortcut Dimension 8 Code")
                {
                }
                field("Shpt. Method Code"; Rec."Shpt. Method Code")
                {
                }
                field("Source No."; Rec."Source No.")
                {
                }
                field("Source Type"; Rec."Source Type")
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
                field("Transaction Specification"; Rec."Transaction Specification")
                {
                }
                field("Transaction Type"; Rec."Transaction Type")
                {
                }
                field("Transit Folder No."; Rec."Transit Folder No.")
                {
                }
                field("Transport Method"; Rec."Transport Method")
                {
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                }
                field("Variant Code"; Rec."Variant Code")
                {
                }
                field("Warranty Date"; Rec."Warranty Date")
                {
                }
            }
        }
    }
}
