page 50883 "WDC-ED Payment Period Setup"
{
    ApplicationArea = All;
    CaptionML = ENU = 'Payment Period Setup', FRA = 'Configuration de l''échéance';
    DelayedInsert = true;
    PageType = List;
    SourceTable = "WDC-ED Payment Period Setup";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Days From"; Rec."Days From")
                {
                    ApplicationArea = All;
                }
                field("Days To"; Rec."Days To")
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

