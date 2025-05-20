page 50870 "WDC-ED Payment Slip List"
{
    ApplicationArea = All;
    CaptionML = ENU = 'Payment Slip List', FRA = 'Liste bordereau paiement';
    CardPageID = "WDC-ED Payment Slip";
    Editable = false;
    PageType = List;
    SourceTable = "WDC-ED Payment Header";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field("Payment Class"; Rec."Payment Class")
                {
                    ApplicationArea = All;
                }
                field("Status Name"; Rec."Status Name")
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

