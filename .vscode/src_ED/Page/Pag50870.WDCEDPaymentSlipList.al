page 50870 "WDC-ED Payment Slip List"
{

    CaptionML = ENU = 'Payment Slip List', FRA = 'Liste bordereau paiement';
    CardPageID = "WDC-ED Payment Slip";
    Editable = false;
    PageType = List;
    SourceTable = "WDC-ED Payment Header";
    UsageCategory = Lists;
    SourceTableView = SORTING("Posting Date", "No.") order(ascending);
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field("Payment Slip Type"; Rec."Payment Slip Type")
                {
                    ApplicationArea = All;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }

                field("Payment Class Name"; Rec."Payment Class Name")
                {
                    ApplicationArea = All;
                }
                field("Status Name"; Rec."Status Name")
                {
                    ApplicationArea = All;
                }
                field("Amount (LCY)"; Rec."Amount (LCY)")
                {
                    ApplicationArea = All;
                }

                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Create Payment Slip")
            {
                ApplicationArea = All;
                CaptionML = ENU = 'Create Payment Slip', FRA = 'Créer bordereau de paiement';
                Image = NewDocument;
                RunObject = Codeunit "WDC-ED Payment Management";
            }
        }
    }

}