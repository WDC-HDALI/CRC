codeunit 50802 "WDC-ED FR AccSchedManagement"
{
    TableNo = "WDC-ED FR Acc. Schedule Line";

    trigger OnRun()
    begin
    end;

    procedure OpenSchedule(var CurrentSchedName: Code[10]; var AccSchedLine: Record "WDC-ED FR Acc. Schedule Line")
    begin
        CheckTemplateName(CurrentSchedName);
        AccSchedLine.FilterGroup(2);
        AccSchedLine.SetRange("Schedule Name", CurrentSchedName);
        AccSchedLine.FilterGroup(0);
    end;

    procedure CheckTemplateName(var CurrentSchedName: Code[10])
    var
        AccSchedName: Record "WDC-ED FR Acc. Schedule Name";
    begin
        if not AccSchedName.Get(CurrentSchedName) then begin
            if not AccSchedName.FindFirst then begin
                AccSchedName.Init();
                AccSchedName.Name := Text1120000;
                AccSchedName.Description := Text1120001;
                AccSchedName.Insert();
                Commit();
            end;
            CurrentSchedName := AccSchedName.Name;
        end;
    end;

    procedure CheckName(CurrentSchedName: Code[10])
    var
        AccSchedName: Record "WDC-ED FR Acc. Schedule Name";
    begin
        AccSchedName.Get(CurrentSchedName);
    end;

    procedure SetName(CurrentSchedName: Code[10]; var AccSchedLine: Record "WDC-ED FR Acc. Schedule Line")
    begin
        AccSchedLine.FilterGroup(2);
        AccSchedLine.SetRange("Schedule Name", CurrentSchedName);
        AccSchedLine.FilterGroup(0);
        if AccSchedLine.Find('-') then;
    end;

    procedure LookupName(CurrentSchedName: Code[10]; var EntrdSchedName: Text[10]): Boolean
    var
        AccSchedName: Record "WDC-ED FR Acc. Schedule Name";
    begin
        AccSchedName.Name := CurrentSchedName;
        if PAGE.RunModal(0, AccSchedName) <> ACTION::LookupOK then
            exit(false);

        EntrdSchedName := AccSchedName.Name;
        exit(true);
    end;

    var
        Text1120000: TextConst ENU = 'DEFAULT',
                               FRA = 'DEFAUT';
        Text1120001: TextConst ENU = 'Default Schedule',
                               FRA = 'Tableau d''analyse par défaut';
}

