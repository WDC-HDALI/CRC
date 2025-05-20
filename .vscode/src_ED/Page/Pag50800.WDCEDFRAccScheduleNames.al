page 50800 "WDC-ED FR Acc. Schedule Names"
{
    CaptionML = ENU = 'FR Account Schedule Names', FRA = 'Noms tableau d''analyse B/R';
    PageType = List;
    SourceTable = "WDC-ED FR Acc. Schedule Name";
    UsageCategory = Tasks;

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
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Caption Column 1"; Rec."Caption Column 1")
                {
                    ApplicationArea = All;
                }
                field("Caption Column 2"; Rec."Caption Column 2")
                {
                    ApplicationArea = All;
                }
                field("Caption Column 3"; Rec."Caption Column 3")
                {
                    ApplicationArea = All;
                }
                field("Caption Column Previous Year"; Rec."Caption Column Previous Year")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(EditAccountSchedule)
            {
                ApplicationArea = All;
                CaptionML = ENU = 'Edit Account Schedule', FRA = 'Modifier tableau d''analyse';
                Image = Edit;
                Promoted = true;
                PromotedCategory = Process;
                ShortCutKey = 'Return';

                trigger OnAction()
                var
                    AccSchedule: Page "WDC-ED FR Account Schedule";
                begin
                    AccSchedule.SetAccSchedName(Rec.Name);
                    AccSchedule.Run;
                end;
            }
        }
    }
}

