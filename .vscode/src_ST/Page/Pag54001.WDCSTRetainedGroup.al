page 54001 "WDC-ST Retained Group"
{
    PageType = List;
    SourceTable = "WDC-ST Retained Group";
    UsageCategory = Lists;
    CaptionML = ENU = 'Retained Group', FRA = 'Groupes retenue';
    ApplicationArea = all;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("RS Type"; Rec."RS Type")
                {
                    ApplicationArea = all;
                }
                field(Code; Rec.Code)
                {
                    ApplicationArea = all;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                }
                field("Retention %"; Rec."Retention %")
                {
                    ApplicationArea = all;
                }
                field("Retention Account No."; Rec."Retention Account No.")
                {
                    ApplicationArea = all;
                }
                field("Type Retenue"; Rec."Type Retenue")
                {
                    ApplicationArea = all;
                }

            }
        }
    }

    actions
    {
    }
}

