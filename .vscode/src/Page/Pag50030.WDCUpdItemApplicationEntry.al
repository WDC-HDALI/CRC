namespace CRC.CRC;

using Microsoft.Inventory.Ledger;

page 50030 "WDC Upd Item Application Entry"
{
    ApplicationArea = All;
    Caption = 'WDC Upd Item Application Entry';
    PageType = List;
    SourceTable = "Item Application Entry";
    UsageCategory = Lists;
    Permissions = tabledata "Item Application Entry" = rimd;
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
                field("Item Ledger Entry No."; Rec."Item Ledger Entry No.")
                {
                    ApplicationArea = all;
                }
                field("Inbound Item Entry No."; Rec."Inbound Item Entry No.")
                {
                    ApplicationArea = all;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = all;
                }
                field("Item Register No."; Rec."Item Register No.")
                {
                    ApplicationArea = all;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = all;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = all;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = all;
                }
                field("Outbound Item Entry No."; Rec."Outbound Item Entry No.")
                {
                    ApplicationArea = all;
                }
                field("Output Completely Invd. Date"; Rec."Output Completely Invd. Date")
                {
                    ApplicationArea = all;
                }
                field("Outbound Entry is Updated"; Rec."Outbound Entry is Updated")
                {
                    ApplicationArea = all;
                }
                field("Latest Valuation Date"; Rec."Latest Valuation Date")
                {
                    ApplicationArea = all;
                }
                field("Cost Application"; Rec."Cost Application")
                {
                    ApplicationArea = all;
                }
            }
        }
    }
}
