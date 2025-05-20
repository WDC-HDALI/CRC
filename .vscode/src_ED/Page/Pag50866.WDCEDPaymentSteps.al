page 50866 "WDC-ED Payment Steps"
{
    AutoSplitKey = true;
    CaptionML = ENU = 'Payment Step', FRA = 'Etape règlement';
    CardPageID = "WDC-ED Payment Step Card";
    DataCaptionFields = "Payment Class";
    DelayedInsert = true;
    PageType = List;
    SourceTable = "WDC-ED Payment Step";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                }
                field("Payment Class"; Rec."Payment Class")
                {
                    ApplicationArea = All;
                }
                field("Next Status"; Rec."Next Status")
                {
                    ApplicationArea = All;
                }
                field("Next Status Name"; Rec."Next Status Name")
                {
                    ApplicationArea = All;
                }
                field("Previous Status"; Rec."Previous Status")
                {
                    ApplicationArea = All;
                }
                field("Previous Status Name"; Rec."Previous Status Name")
                {
                    ApplicationArea = All;
                }
                field("Action Type"; Rec."Action Type")
                {
                    ApplicationArea = All;
                }
                field("Report No."; Rec."Report No.")
                {
                    ApplicationArea = All;
                }
                field("Header Nos. Series"; Rec."Header Nos. Series")
                {
                    ApplicationArea = All;
                }
                field("Reason Code"; Rec."Reason Code")
                {
                    ApplicationArea = All;
                }
                field("Source Code"; Rec."Source Code")
                {
                    ApplicationArea = All;
                }
                field("Export No."; Rec."Export No.")
                {
                    ApplicationArea = All;
                }
                field("Export Type"; Rec."Export Type")
                {
                    ApplicationArea = All;
                }
                field("Acceptation Code<>No"; Rec."Acceptation Code<>No")
                {
                    ApplicationArea = All;
                }
                field(Correction; Rec.Correction)
                {
                    ApplicationArea = All;
                }
                field("Verify Header RIB"; Rec."Verify Header RIB")
                {
                    ApplicationArea = All;
                }
                field("Verify Lines RIB"; Rec."Verify Lines RIB")
                {
                    ApplicationArea = All;
                }
                field("Verify Due Date"; Rec."Verify Due Date")
                {
                    ApplicationArea = All;
                }
                field("Realize VAT"; Rec."Realize VAT")
                {
                    ApplicationArea = All;
                }

            }
        }
    }
}

