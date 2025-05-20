table 50200 "WDC-TF Item Charge Trans. Fold"
{
    CaptionML = ENU = 'Item Charge Transit Folders', FRA = 'Frais dossier d''importation';
    LookupPageID = "WDC-TF Transit Folders";
    DrillDownPageId = "WDC-TF Transit Folders";
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Transit Folder No."; Code[20])
        {
            CaptionML = ENU = 'Transit Folder No.', FRA = 'N° Dossier';
            Editable = true;
        }
        field(2; "Charge Code"; code[20])
        {
            CaptionML = ENU = 'Charge Code', FRA = 'Code frais';
            TableRelation = "Item Charge"."No.";
        }
        field(3; "Affected Charge Amount"; Decimal)
        {
            CaptionML = ENU = 'Affected Charge Amount', FRA = 'Montant frais affectés';
            FieldClass = FlowField;
            CalcFormula = Sum("Value Entry"."Cost Amount (Actual)" WHERE("Transit Folder No." = FIELD("Transit Folder No."), "Item Charge No." = FIELD("Charge Code")));
            Editable = False;
        }
        field(4; "Not Included"; Boolean)
        {
            CaptionML = ENU = 'Not included', FRA = 'Non inclus';
            trigger OnValidate()
            BEGIN
                IF "Not included" THEN BEGIN
                    CALCFIELDS("Affected Charge Amount");
                    TESTFIELD("Affected Charge Amount", 0);
                END
            END;
        }
        field(5; Description; Text[100])
        { }
        field(6; Assignable; Boolean)
        {
            CaptionML = ENU = 'Assignable', FRA = 'Affectable';
        }
    }
    keys
    {
        key(PK; "Transit Folder No.", "Charge Code")
        {
            Clustered = true;
        }
    }
}
