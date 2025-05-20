page 50873 "WDC-ED Payment Steps List"
{
    CaptionML = ENU = 'Payment Steps List', FRA = 'Liste des étapes règlement';
    PageType = List;
    SourceTable = "WDC-ED Payment Step";

    layout
    {
        area(content)
        {
            repeater(Control1)
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
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                }
                field("Previous Status"; Rec."Previous Status")
                {
                    ApplicationArea = All;
                }
                field("Next Status"; Rec."Next Status")
                {
                    ApplicationArea = All;
                }
                field("Action Type"; Rec."Action Type")
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

