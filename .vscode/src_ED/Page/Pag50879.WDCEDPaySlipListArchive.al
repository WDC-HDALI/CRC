page 50879 "WDC-ED Pay. Slip List Archive"
{
    ApplicationArea = All;
    CaptionML = ENU = 'Payment Slip Archive', FRA = 'Archives bordereau paiement';
    CardPageID = "WDC-ED Payment Slip Archive";
    Editable = false;
    PageType = List;
    SourceTable = "WDC-ED Payment Header Archive";
    UsageCategory = History;

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
    }
}

