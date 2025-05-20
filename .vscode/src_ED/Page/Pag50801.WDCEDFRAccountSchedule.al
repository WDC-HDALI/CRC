page 50801 "WDC-ED FR Account Schedule"
{
    AutoSplitKey = true;
    CaptionML = ENU = 'FR Account Schedule', FRA = 'Tableau analyse Bilan/Résultat';
    DataCaptionFields = "Schedule Name";
    MultipleNewLines = true;
    PageType = Worksheet;
    SaveValues = true;
    SourceTable = "WDC-ED FR Acc. Schedule Line";

    layout
    {
        area(content)
        {
            field(CurrentSchedName; CurrentSchedName)
            {
                ApplicationArea = All;
                CaptionML = ENU = 'Name', FRA = 'Nom';
                Lookup = true;

                trigger OnLookup(var Text: Text): Boolean
                begin
                    exit(AccSchedManagement.LookupName(CurrentSchedName, Text));
                end;

                trigger OnValidate()
                begin
                    AccSchedManagement.CheckName(CurrentSchedName);
                    CurrentSchedNameOnAfterValidat;
                end;
            }
            repeater(Control1)
            {
                ShowCaption = false;
                field("Row No."; Rec."Row No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Totaling Type"; Rec."Totaling Type")
                {
                    ApplicationArea = All;
                }
                field(Totaling; Rec.Totaling)
                {
                    ApplicationArea = All;
                }
                field("Totaling Debtor"; Rec."Totaling Debtor")
                {
                    ApplicationArea = All;
                }
                field("Totaling Creditor"; Rec."Totaling Creditor")
                {
                    ApplicationArea = All;
                }
                field("Totaling 2"; Rec."Totaling 2")
                {
                    ApplicationArea = All;
                }
                field("Calculate with"; Rec."Calculate with")
                {
                    ApplicationArea = All;
                }
                field("New Page"; Rec."New Page")
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
            action(Print)
            {
                ApplicationArea = All;
                CaptionML = ENU = '&Print', FRA = '&Imprimer';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    AccSchedName.SetFilter(Name, Rec."Schedule Name");
                    REPORT.Run(REPORT::"WDC-ED FR Account Schedule", true, false, AccSchedName);
                end;
            }
        }
        area(reporting)
        {
            action("FR Account Schedule")
            {
                ApplicationArea = All;
                CaptionML = ENU = 'FR Account Schedule', FRA = 'Tableau analyse Bilan/Résultat';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "WDC-ED FR Account Schedule";
            }
        }
    }

    trigger OnOpenPage()
    begin
        AccSchedManagement.OpenSchedule(CurrentSchedName, Rec);
    end;

    procedure SetAccSchedName(NewAccSchedName: Code[10])
    begin
        CurrentSchedName := NewAccSchedName;
    end;

    local procedure CurrentSchedNameOnAfterValidat()
    begin
        CurrPage.SaveRecord;
        AccSchedManagement.SetName(CurrentSchedName, Rec);
        CurrPage.Update(false);
    end;

    var
        AccSchedName: Record "WDC-ED FR Acc. Schedule Name";
        AccSchedManagement: Codeunit "WDC-ED FR AccSchedManagement";
        CurrentSchedName: Code[10];
}

