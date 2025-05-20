table 50862 "WDC-ED Payment Step"
{
    CaptionML = ENU = 'Payment Step', FRA = 'Etape règlement';
    LookupPageID = "WDC-ED Payment Steps List";

    fields
    {
        field(1; "Payment Class"; Text[30])
        {
            CaptionML = ENU = 'Payment Class', FRA = 'Type de règlement';
            TableRelation = "WDC-ED Payment Class";
        }
        field(2; "Line No."; Integer)
        {
            CaptionML = ENU = 'Line No.', FRA = 'N° Ligne';
        }
        field(3; Name; Text[50])
        {
            CaptionML = ENU = 'Name', FRA = 'Nom';
        }
        field(4; "Previous Status"; Integer)
        {
            CaptionML = ENU = 'Previous Status', FRA = 'Statut précédent';

            TableRelation = "WDC-ED Payment Status"."Line No." WHERE("Payment Class" = FIELD("Payment Class"));
        }
        field(5; "Next Status"; Integer)
        {
            CaptionML = ENU = 'Next Status', FRA = 'Statut suivant';
            TableRelation = "WDC-ED Payment Status"."Line No." WHERE("Payment Class" = FIELD("Payment Class"));
        }
        field(6; "Action Type"; Enum "WDC-ED Action Type")
        {
            CaptionML = ENU = 'Action Type', FRA = 'Type action';
        }
        field(7; "Report No."; Integer)
        {
            CaptionML = ENU = 'Report No.', FRA = 'ID état';
            TableRelation = IF ("Action Type" = CONST(Report)) AllObj."Object ID" WHERE("Object Type" = CONST(Report));
        }
        field(8; "Export No."; Integer)
        {
            CaptionML = ENU = 'Export No.', FRA = 'N° exportation';
            TableRelation = IF ("Action Type" = CONST(File),
                                "Export Type" = CONST(Report)) AllObj."Object ID" WHERE("Object Type" = CONST(Report))
            ELSE
            IF ("Action Type" = CONST(File),
                                         "Export Type" = CONST(XMLport)) AllObj."Object ID" WHERE("Object Type" = CONST(XMLport));
        }
        field(9; "Previous Status Name"; Text[50])
        {
            CalcFormula = Lookup("WDC-ED Payment Status".Name WHERE("Payment Class" = FIELD("Payment Class"),
                                                              "Line No." = FIELD("Previous Status")));
            CaptionML = ENU = 'Previous Status Name', FRA = 'Nom état précédent';
            FieldClass = FlowField;
        }
        field(10; "Next Status Name"; Text[50])
        {
            CalcFormula = Lookup("WDC-ED Payment Status".Name WHERE("Payment Class" = FIELD("Payment Class"),
                                                              "Line No." = FIELD("Next Status")));
            CaptionML = ENU = 'Next Status Name', FRA = 'Nom état suivant';
            FieldClass = FlowField;
        }
        field(11; "Verify Lines RIB"; Boolean)
        {
            CaptionML = ENU = 'Verify Lines RIB', FRA = 'Vérifier RIB lignes';
        }
        field(12; "Header Nos. Series"; Code[20])
        {
            CaptionML = ENU = 'Header Nos. Series', FRA = 'N° de souche en-tête';
            TableRelation = "No. Series";

            trigger OnValidate()
            var
                NoSeriesLine: Record "No. Series Line";
            begin
                if "Header Nos. Series" <> '' then begin
                    NoSeriesLine.SetRange("Series Code", "Header Nos. Series");
                    if NoSeriesLine.FindLast then
                        if (StrLen(NoSeriesLine."Starting No.") > 10) or (StrLen(NoSeriesLine."Ending No.") > 10) then
                            Error(Text001);
                end;
            end;
        }
        field(13; "Reason Code"; Code[10])
        {
            CaptionML = ENU = 'Reason Code', FRA = 'Code motif';
            TableRelation = "Reason Code";
        }
        field(14; "Source Code"; Code[10])
        {
            CaptionML = ENU = 'Source Code', FRA = 'Code journal';
            Editable = true;
            TableRelation = "Source Code";
        }
        field(15; "Acceptation Code<>No"; Boolean)
        {
            CaptionML = ENU = 'Acceptation Code<>No', FRA = 'Code acceptation <> Non';
        }
        field(16; Correction; Boolean)
        {
            CaptionML = ENU = 'Correction', FRA = 'Correction';
        }
        field(17; "Verify Header RIB"; Boolean)
        {
            CaptionML = ENU = 'Verify Header RIB', FRA = 'Vérifier RIB en-tête';
        }
        field(18; "Verify Due Date"; Boolean)
        {
            CaptionML = ENU = 'Verify Due Date', FRA = 'Vérifier date d''échéance';
        }
        field(19; "Realize VAT"; Boolean)
        {
            CaptionML = ENU = 'Realize VAT', FRA = 'Réaliser TVA';
        }
        field(30; "Export Type"; Option)
        {
            CaptionML = ENU = 'Export Type', FRA = 'Type exportation';
            InitValue = "XMLport";
            OptionCaptionML = ENU = ',,,Report,,,XMLport', FRA = ',,,État,,,XMLport';
            OptionMembers = ,,,"Report",,,"XMLport";
            trigger OnValidate()
            begin
                "Export No." := 0;
            end;
        }
    }

    keys
    {
        key(Key1; "Payment Class", "Line No.")
        {
            Clustered = true;
        }
    }

    trigger OnDelete()
    begin
        if "Line No." = 0 then
            Error(Text000);
    end;

    var
        Text000: TextConst ENU = 'Deleting the default report is not allowed.',
                           FRA = 'Vous n''avez pas le droit de supprimer l''état par défaut.';
        Text001: TextConst ENU = 'You cannot assign a number series with numbers longer than 10 characters.',
                           FRA = 'Vous ne pouvez pas affecter des souches de numéros de plus de 10 caractères.';
}

