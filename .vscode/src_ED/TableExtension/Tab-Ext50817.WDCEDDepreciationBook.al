tableextension 50817 "WDC-ED Depreciation Book" extends "Depreciation Book"
{
    fields
    {
        field(50800; "Derogatory Calculation"; Code[10])
        {
            CaptionML = ENU = 'Derogatory Calculation', FRA = 'Calcul dérogatoire';
            TableRelation = "Depreciation Book";

            trigger OnValidate()
            var
                DeprBook: Record "Depreciation Book";
                FADeprBook: Record "FA Depreciation Book";
            begin
                if ("Derogatory Calculation" <> xRec."Derogatory Calculation") then begin
                    if xRec."Derogatory Calculation" <> '' then begin
                        FADeprBook.SetRange("Depreciation Book Code", xRec."Derogatory Calculation");
                        if FADeprBook.Find('-') then
                            repeat
                                FADeprBook.CalcFields(Derogatory);
                                FADeprBook.TestField(Derogatory, 0);
                            until FADeprBook.Next = 0;
                    end else begin
                        DeprBook.SetRange("Derogatory Calculation", "Derogatory Calculation");
                        if DeprBook.Find('-') then
                            if DeprBook.Code <> Code then
                                Error(Text003, "Derogatory Calculation", DeprBook.Code);
                        DeprBook.SetRange("Derogatory Calculation");
                        DeprBook.SetRange(Code, "Derogatory Calculation");
                        if DeprBook.Find('-') then
                            if (DeprBook."Derogatory Calculation" <> '') then
                                Error(Text005, "Derogatory Calculation");
                    end;
                    if ("Derogatory Calculation" <> xRec."Derogatory Calculation") then
                        if "Used with Derogatory Book" <> '' then
                            Error(Text001, Code);

                end;


                if "Derogatory Calculation" = Code then
                    Error(Text002, "Derogatory Calculation", Code);

                // CheckIntegrationFields; //FIXME:
            end;
        }
        field(50801; "Used with Derogatory Book"; Code[10])
        {
            CalcFormula = Lookup("Depreciation Book".Code WHERE("Derogatory Calculation" = FIELD(Code)));
            CaptionML = ENU = 'Used with Derogatory Book', FRA = 'Utilisé avec la loi dérogatoire';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50802; "G/L Integration - Derogatory"; Boolean)
        {
            CaptionML = ENU = 'G/L Integration - Derogatory', FRA = 'Utilisé avec la loi dérogatoire';

            trigger OnValidate()
            begin
                // CheckIntegrationFields; FIXME:
            end;
        }
    }

    var
        Text001: TextConst ENU = 'The depreciation book %1 is an accounting book and cannot be set up as a derogatory depreciation book.',
                           FRA = 'La loi d''amortissement %1 est un document comptable qui ne peut pas être défini comme loi d''amortissement dérogatoire.';
        Text002: TextConst ENU = 'The depreciation book %1 cannot be set up as derogatory for depreciation book %2.',
                           FRA = 'La loi d''amortissement %1 est un document comptable qui ne peut pas être défini comme dérogatoire pour la loi d''amortissement %2.';
        Text003: TextConst ENU = 'The depreciation book %1 is already set up in combination with derogatory depreciation book %2.',
                           FRA = 'La loi d''amortissement %1 est déjà définie avec la loi d''amortissement dérogatoire %2.';
        Text004: TextConst ENU = 'Derogatory depreciation books cannot be integrated with the general ledger. Please make sure that none of the fields on the Integration tab are checked.',
                           FRA = 'Des lois d''amortissement dérogatoires ne peuvent pas être intégrées à la comptabilité. Vérifiez qu''aucun des champs de l''onglet Intégration n''est sélectionné.';
        Text005: TextConst ENU = 'The depreciation book %1 is a derogatory depreciation book.',
                           FRA = 'Les lois d''amortissement %1 sont des lois d''amortissement dérogatoires.';

}