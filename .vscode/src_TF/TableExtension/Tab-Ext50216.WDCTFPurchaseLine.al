tableextension 50216 "WDC-TF Purchase Line" extends "Purchase Line"
{
    fields
    {
        field(50200; "Transit Folder No."; Code[20])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Purchase Header"."Transit Folder No." where("No." = field("Document No."), "Document Type" = field("Document Type")));
            CaptionML = ENU = 'Transit folder No.', FRA = 'N° dossier import';
        }
        field(50201; "Tariff No."; code[20])
        {
            TableRelation = "Tariff Number"."No.";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Tariff No.', FRA = 'N° tarif';
            trigger OnValidate()
            var
                lReceiptLine: Record 121;
                TotalNGP: Decimal;
                Error001: TextConst FRA = 'Aucune réception n''a été trouvée sur le dossier %1 pour le code NGP %2';
            BEGIN
                IF "Tariff No." <> '' THEN BEGIN
                    IF Type = Type::"Charge (Item)" THEN BEGIN
                        TESTFIELD("Tariff No.");
                        TESTFIELD("Transit Folder No.");
                        CalcFields("Transit Folder No.");
                        lReceiptLine.SETCURRENTKEY("Transit Folder No.", "Type", "Tariff No.");
                        lReceiptLine.SETRANGE(lReceiptLine.Type, lReceiptLine.Type::Item);
                        lReceiptLine.SETRANGE("Transit Folder No.", "Transit Folder No.");
                        lReceiptLine.SETRANGE("Tariff No.", "Tariff No.");
                        lReceiptLine.CALCSUMS(lReceiptLine."NGP Value");
                        TotalNGP := lReceiptLine."NGP Value";
                        IF TotalNGP = 0 THEN
                            ERROR(Error001, "Transit Folder No.", "Tariff No.");
                        IF lReceiptLine.FINDSET THEN
                            REPEAT
                                lReceiptLine."Line NGP Value" := "Line Amount" * Rec."NGP Value" / TotalNGP;
                                lReceiptLine.MODIFY;
                            UNTIL lReceiptLine.NEXT = 0;
                    END;
                END;
            END;
        }
        field(50202; "NGP Value"; Decimal)
        {
            CaptionML = ENU = 'NGP Value', FRA = 'Valeur NGP';
            DataClassification = ToBeClassified;
        }
        field(50203; "Non Conformance Line No."; Integer)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Non Conformance Line No.', FRA = 'N° ligne NC';
            Editable = false;
        }

    }
}