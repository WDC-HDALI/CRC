table 50801 "WDC-ED FR Acc. Schedule Line"
{
    CaptionML = ENU = 'FR Acc. Schedule Line', FRA = 'Ligne tableau d''analyse B/R';

    fields
    {
        field(1; "Schedule Name"; Code[10])
        {
            CaptionML = ENU = 'Schedule Name', FRA = 'Nom du tableau';
            TableRelation = "WDC-ED FR Acc. Schedule Name";
        }
        field(2; "Line No."; Integer)
        {
            CaptionML = ENU = 'Line No.', FRA = 'N° ligne';
        }
        field(3; "Row No."; Code[10])
        {
            CaptionML = ENU = 'Row No.', FRA = 'N° ligne totalisation';
        }
        field(4; Description; Text[80])
        {
            CaptionML = ENU = 'Description', FRA = 'Description';
        }
        field(5; Totaling; Text[250])
        {
            CaptionML = ENU = 'Totaling', FRA = 'Totalisation';
            TableRelation = IF ("Totaling Type" = CONST("Posting Accounts")) "G/L Account"
            ELSE
            IF ("Totaling Type" = CONST("Total Accounts")) "G/L Account";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(6; "Totaling Type"; Option)
        {
            CaptionML = ENU = 'Totaling Type', FRA = 'Type totalisation';
            OptionCaptionML = ENU = 'Posting Accounts,Total Accounts,Rows', FRA = 'Comptes imputables,Comptes de totalisation,Lignes';
            OptionMembers = "Posting Accounts","Total Accounts",Rows;
        }
        field(7; "New Page"; Boolean)
        {
            CaptionML = ENU = 'New Page', FRA = 'Nouvelle page';
        }
        field(11; "Date Filter"; Date)
        {
            CaptionML = ENU = 'Date Filter', FRA = 'Filtre date';
            FieldClass = FlowFilter;
        }
        field(12; "Dimension 1 Filter"; Code[20])
        {
            CaptionClass = '1,3,1';
            CaptionML = ENU = 'Dimension 1 Filter', FRA = 'Filtre axe 1';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(13; "Dimension 2 Filter"; Code[20])
        {
            CaptionClass = '1,3,2';
            CaptionML = ENU = 'Dimension 2 Filter', FRA = 'Filtre axe 2';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(14; "Budget Filter"; Code[10])
        {
            CaptionML = ENU = 'Budget Filter', FRA = 'Filtre budget';
            FieldClass = FlowFilter;
            TableRelation = "G/L Budget Name";
        }
        field(15; "Business Unit Filter"; Code[20])
        {
            CaptionML = ENU = 'Business Unit Filter', FRA = 'Filtre centre de profit';
            FieldClass = FlowFilter;
            TableRelation = "Business Unit";
        }
        field(480; "Dimension Set ID"; Integer)
        {
            CaptionML = ENU = 'Dimension Set ID', FRA = 'ID ensemble de dimensions';
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup()
            begin
                ShowDimensions;
            end;
        }
        field(10800; "Totaling Debtor"; Text[250])
        {
            CaptionML = ENU = 'Totaling Debtor', FRA = 'Totalisation débiteur';
            TableRelation = IF ("Totaling Type" = CONST("Posting Accounts")) "G/L Account"
            ELSE
            IF ("Totaling Type" = CONST("Total Accounts")) "G/L Account";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(10801; "Totaling Creditor"; Text[250])
        {
            CaptionML = ENU = 'Totaling Creditor', FRA = 'Totalisation créditeur';
            TableRelation = IF ("Totaling Type" = CONST("Posting Accounts")) "G/L Account"
            ELSE
            IF ("Totaling Type" = CONST("Total Accounts")) "G/L Account";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(10802; "Calculate with"; Option)
        {
            CaptionML = ENU = 'Calculate with', FRA = 'Signe calcul';
            OptionCaptionML = ENU = 'Sign,Opposite Sign', FRA = 'Normal,Opposé';
            OptionMembers = Sign,"Opposite Sign";
        }
        field(10803; "Totaling 2"; Text[250])
        {
            CaptionML = ENU = 'Totaling 2', FRA = 'Totalisation 2';
            TableRelation = IF ("Totaling Type" = CONST("Posting Accounts")) "G/L Account"
            ELSE
            IF ("Totaling Type" = CONST("Total Accounts")) "G/L Account";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(10804; "Date Filter 2"; Date)
        {
            CaptionML = ENU = 'Date Filter 2', FRA = 'Filtre date 2';
            FieldClass = FlowFilter;
        }
        field(10810; "G/L Entry Type Filter"; Option)
        {
            CaptionML = ENU = 'G/L Entry Type Filter', FRA = 'Filtre type écriture';
            FieldClass = FlowFilter;
            ObsoleteReason = 'Discontinued feature';
            ObsoleteState = Pending;
            OptionCaptionML = ENU = 'Definitive,Simulation', FRA = 'Définitive,Simulation';
            OptionMembers = Definitive,Simulation;
            ObsoleteTag = '15.0';
        }
    }

    keys
    {
        key(Key1; "Schedule Name", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        if xRec."Line No." = 0 then
            if not AccSchedName.Get("Schedule Name") then begin
                AccSchedName.Init();
                AccSchedName.Name := "Schedule Name";
                if AccSchedName.Name = '' then
                    AccSchedName.Description := Text10800;
                AccSchedName.Insert();
            end;
    end;

    procedure LookupShortcutDimCode(FieldNo: Integer; var ShortcutDimCode: Code[20])
    begin
        DimManagement.LookupDimValueCode(FieldNo, ShortcutDimCode);
    end;

    procedure ValidateShortcutDimCode(FieldNo: Integer; var ShortcutDimCode: Code[20])
    begin
        DimManagement.ValidateShortcutDimValues(FieldNo, ShortcutDimCode, "Dimension Set ID");
    end;

    procedure ShowDimensions()
    begin
        "Dimension Set ID" :=
          DimManagement.EditDimensionSet("Dimension Set ID", StrSubstNo('%1 %2 %3', "Schedule Name", "Line No.", "Row No."));
    end;

    var
        Text10800: TextConst ENU = 'Default Schedule',
                             FRA = 'Tableau d''analyse par défaut';
        AccSchedName: Record "WDC-ED FR Acc. Schedule Name";
        DimManagement: Codeunit DimensionManagement;
}

