namespace CRC.CRC;

using Microsoft.Purchases.Payables;
//******************Documentation***********************
//WDC01  WDC.HG  11/08/2025  Create current object : update vendor card to show historics and recpt not invoiced detailes
page 50027 "WDC Vendor Historics"
{
    ApplicationArea = All;
    CaptionML = ENU = 'Vendor Historics', FRA = 'Extrait fournisseur';
    PageType = ListPart;
    SourceTable = "Vendor Ledger Entry";
    SourceTableView = sorting("Vendor No.", "Posting Date", "Currency Code") where(Reversed = filter(false));
    Editable = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = all;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = all;
                }
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = all;
                }
                field("Debit Amount (LCY)"; Rec."Debit Amount (LCY)")
                {
                    ApplicationArea = all;
                }
                field("Credit Amount (LCY)"; Rec."Credit Amount (LCY)")
                {
                    ApplicationArea = all;
                }
            }
        }
    }
}
