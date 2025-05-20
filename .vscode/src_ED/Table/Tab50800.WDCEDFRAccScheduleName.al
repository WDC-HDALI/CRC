table 50800 "WDC-ED FR Acc. Schedule Name"
{
    CaptionML = ENU = 'FR Acc. Schedule Name', FRA = 'Nom tableau d''analyse B/R';
    DataCaptionFields = Name, Description;
    LookupPageID = "WDC-ED FR Acc. Schedule Names";

    fields
    {
        field(1; Name; Code[10])
        {
            CaptionML = ENU = 'Name', FRA = 'Nom';
            NotBlank = true;
        }
        field(2; Description; Text[80])
        {
            CaptionML = ENU = 'Description', FRA = 'Description';
        }
        field(50800; "Caption Column 1"; Text[30])
        {
            CaptionML = ENU = 'Caption Column 1', FRA = 'Titre colonne 1';
        }
        field(50801; "Caption Column 2"; Text[30])
        {
            CaptionML = ENU = 'Caption Column 2', FRA = 'Titre colonne 2';
        }
        field(50802; "Caption Column 3"; Text[30])
        {
            CaptionML = ENU = 'Caption Column 3', FRA = 'Titre colonne 3';
        }
        field(50803; "Caption Column Previous Year"; Text[30])
        {
            CaptionML = ENU = 'Caption Column Previous Year', FRA = 'Titre colonne année précédente';
        }
    }

    keys
    {
        key(Key1; Name)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; Name, Description)
        {
        }
    }

    trigger OnDelete()
    begin
        AccSchedLine.SetRange("Schedule Name", Name);
        AccSchedLine.DeleteAll();
    end;

    var
        AccSchedLine: Record "WDC-ED FR Acc. Schedule Line";
}

