page 50882 "WDC-ED Pay. Step Ledger List"
{
    CaptionML = ENU = 'Payment Step Ledger List', FRA = 'Liste étapes comptabilisation règlement';
    CardPageID = "WDC-ED Payment Step Ledger";
    Editable = false;
    PageType = List;
    SourceTable = "WDC-ED Payment Step Ledger";

    layout
    {
        area(content)
        {
            repeater(Control1120000)
            {
                ShowCaption = false;
                field("Payment Class"; Rec."Payment Class")
                {
                    ApplicationArea = All;
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                }
                field(Sign; Rec.Sign)
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Accounting Type"; Rec."Accounting Type")
                {
                    ApplicationArea = All;
                }
                field("Account Type"; Rec."Account Type")
                {
                    ApplicationArea = All;
                }
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = All;
                }
                field("Customer Posting Group"; Rec."Customer Posting Group")
                {
                    ApplicationArea = All;
                }
                field("Vendor Posting Group"; Rec."Vendor Posting Group")
                {
                    ApplicationArea = All;
                }
                field(Root; Rec.Root)
                {
                    ApplicationArea = All;
                }
                field("Detail Level"; Rec."Detail Level")
                {
                    ApplicationArea = All;
                }
                field(Application; Rec.Application)
                {
                    ApplicationArea = All;
                }
                field("Memorize Entry"; Rec."Memorize Entry")
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
                field("Posting RS"; Rec."Posting RS")
                {
                    ApplicationArea = All;
                }
                field("Cancel Posting RS"; Rec."Cancel Posting RS")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}

