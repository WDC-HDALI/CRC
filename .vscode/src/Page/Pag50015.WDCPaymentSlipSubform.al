namespace CRC.CRC;

page 50015 "WDC Payment Slip Subform"
{
    ApplicationArea = All;
    CaptionML = ENU = 'WDC Lines payment slip', FRA = 'WDC Lignes borderaux paiement';
    PageType = List;
    SourceTable = "WDC-ED Payment Line";
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Posted; Rec.Posted)
                {
                    applicationArea = All;
                }
                field("Account Type"; Rec."Account Type")
                {
                    applicationArea = All;
                }
                field("Account No."; Rec."Account No.")
                {
                    applicationArea = All;
                }
                field("No."; Rec."No.")
                {
                    applicationArea = All;
                }
                field("Document No."; Rec."Document No.")
                {
                    applicationArea = All;
                }

                field("Payment Methode Code"; Rec."Payment Methode Code")
                {
                    applicationArea = All;
                }
                field("Payment Class"; Rec."Payment Class")
                {
                    applicationArea = All;
                }
                field("Payment Slip Type"; Rec."Payment Slip Type")
                {
                    applicationArea = All;
                }
                field("Payment Slip No."; Rec."Payment Slip No.")
                {
                    applicationArea = All;
                }
                field("Payment State"; Rec."Payment State")
                {
                    applicationArea = All;
                }
                field("Payment in Progress"; Rec."Payment in Progress")
                {
                    applicationArea = All;
                }
                field("Payment Reference"; Rec."Payment Reference")
                {
                    applicationArea = All;
                }
                field("Payment Object"; Rec."Payment Object")
                {
                    applicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    applicationArea = All;
                }
                field("Due Date"; Rec."Due Date")
                {
                    applicationArea = All;
                }
                field("ED Type"; Rec."ED Type")
                {
                    applicationArea = All;
                }
                field("Référence chèque"; Rec."Référence chèque")
                {
                    applicationArea = All;
                }
                field("Status Name"; Rec."Status Name")
                {
                    applicationArea = All;
                }
                field("Status No."; Rec."Status No.")
                {
                    applicationArea = All;
                }
                field("Amount (LCY)"; Rec."Amount (LCY)")
                {
                    applicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    applicationArea = All;
                }
                field("Bank Account No."; Rec."Bank Account No.")
                {
                    applicationArea = All;
                }
                field("Bank Account Name"; Rec."Bank Account Name")
                {
                    applicationArea = All;
                }
                field("Validated RS Amount"; Rec."Validated RS Amount")
                {
                    applicationArea = All;
                }
                field("Validated RS Amount LCY"; Rec."Validated RS Amount LCY")
                {
                    applicationArea = All;
                }
                field("Validated RS VAT Amount"; Rec."Validated RS VAT Amount")
                {
                    applicationArea = All;
                }
                field("Validated RS VAT Amount LCY"; Rec."Validated RS VAT Amount LCY")
                {
                    applicationArea = All;
                }
                field("RS Amount"; Rec."RS Amount")
                {
                    applicationArea = All;
                }
                field("RS Amount LCY"; Rec."RS Amount LCY")
                {
                    applicationArea = All;
                }
                field("Line No."; Rec."Line No.")
                {
                    applicationArea = All;
                }
                field("Header Account No."; Rec."Header Account No.")
                {
                    applicationArea = All;
                }
                field("Header Account Type"; Rec."Header Account Type")
                {
                    applicationArea = All;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    applicationArea = All;
                }
                field("Currency Factor"; Rec."Currency Factor")
                {
                    applicationArea = All;
                }
                field("Bank Account Code"; Rec."Bank Account Code")
                {
                    applicationArea = All;
                }
            }
        }
    }
}
