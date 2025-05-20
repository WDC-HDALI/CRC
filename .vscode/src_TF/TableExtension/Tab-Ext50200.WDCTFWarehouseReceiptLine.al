tableextension 50200 "WDC-TF Warehouse Receipt Line" extends "Warehouse Receipt Line"
{
    fields
    {
        field(50200; "Transit Folder No."; Code[20])
        {
            CaptionML = ENU = 'Transit Folder No', FRA = 'N° dossier import';
            DataClassification = ToBeClassified;
            TableRelation = "WDC-TF Transit Folder";
        }
        field(50201; "Tarif No."; code[20])
        {
            TableRelation = "Tariff Number"."No.";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Tariff No.', FRA = 'Code NGP';
            trigger OnValidate()
            var
                lReceiptLine: Record 121;
                TotalNGP: Decimal;
                Error001: TextConst FRA = 'Aucune réception n''a été trouvée sur le dossier %1 pour le code NGP %2';
            BEGIN
            END;
        }
        field(50202; "Declaration No."; code[10])
        {
            DataClassification = ToBeClassified;
            captionML = ENU = 'Declaration No.', FRA = 'N° Déclaration';
        }
        field(50203; "Declaration Date"; Date)
        {
            DataClassification = ToBeClassified;
            captionML = ENU = 'Declaration Date', FRA = 'Date Déclaration';
        }
        field(50204; "Colis No."; code[20])
        {
            DataClassification = ToBeClassified;
            captionML = ENU = 'Colis No.', FRA = 'N° colis';
        }
    }
}
