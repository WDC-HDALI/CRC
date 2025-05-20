table 50863 "WDC-ED Payment Step Ledger"
{
    CaptionML = ENU = 'Payment Step Ledger', FRA = 'Etape comptabilisation règlement';

    fields
    {
        field(1; "Payment Class"; Text[30])
        {
            CaptionML = ENU = 'Payment Class', FRA = 'Type règlement';
            TableRelation = "WDC-ED Payment Class";
        }
        field(2; "Line No."; Integer)
        {
            CaptionML = ENU = '"Line No."', FRA = 'N° Ligne';
        }
        field(3; Sign; Option)
        {
            CaptionML = ENU = 'Sign', FRA = 'Sens';
            OptionCaptionML = ENU = 'Debit,Credit', FRA = 'Débit,Crédit';
            OptionMembers = Debit,Credit;
        }
        field(4; Description; Text[100])
        {
            CaptionML = ENU = 'Description', FRA = 'Description';
        }
        field(5; "Accounting Type"; Option)
        {
            CaptionML = ENU = 'Accounting Type', FRA = 'Type comptabilisation';
            OptionCaptionML = ENU = 'Payment Line Account,Associated G/L Account,Setup Account,G/L Account / Month,G/L Account / Week,Bal. Account Previous Entry,Header Payment Account',
                            FRA = 'Compte ligne paiement,Compte général associé,Compte paramétré,Compte général par mois échéance,Compte général par semaine échéance,Extourne écriture précédente,Compte en-tête';
            OptionMembers = "Payment Line Account","Associated G/L Account","Setup Account","G/L Account / Month","G/L Account / Week","Bal. Account Previous Entry","Header Payment Account";


            trigger OnValidate()
            begin
                Validate(Root);
            end;
        }
        field(6; "Account Type"; enum "Gen. Journal Account Type")
        {
            CaptionML = ENU = 'Account Type', FRA = 'Type compte';
        }
        field(7; "Account No."; Code[20])
        {
            CaptionML = ENU = 'Account No.', FRA = 'N° compte';
            TableRelation = IF ("Account Type" = CONST("G/L Account")) "G/L Account"
            ELSE
            IF ("Account Type" = CONST(Customer)) Customer
            ELSE
            IF ("Account Type" = CONST(Vendor)) Vendor
            ELSE
            IF ("Account Type" = CONST("Bank Account")) "Bank Account"
            ELSE
            IF ("Account Type" = CONST("Fixed Asset")) "Fixed Asset";
            ValidateTableRelation = true;
        }
        field(8; "Customer Posting Group"; Code[20])
        {
            CaptionML = ENU = 'Customer Posting Group', FRA = 'Groupe compta. client';
            TableRelation = "Customer Posting Group";
        }
        field(9; "Vendor Posting Group"; Code[20])
        {
            CaptionML = ENU = 'Vendor Posting Group', FRA = 'Groupe compta. fournisseur';
            TableRelation = "Vendor Posting Group";
        }
        field(10; Root; Code[20])
        {
            CaptionML = ENU = 'Root', FRA = 'Racine';
        }
        field(11; "Detail Level"; Option)
        {
            CaptionML = ENU = 'Detail Level', FRA = 'Détail niveau';
            OptionCaptionML = ENU = 'Line,Account,Due Date', FRA = 'Ligne,Compte,Date d''échéance';
            OptionMembers = Line,Account,"Due Date";
        }
        field(12; Application; Option)
        {
            CaptionML = ENU = 'Application', FRA = 'Lettrage';
            OptionCaptionML = ENU = 'None,Applied Entry,Entry Previous Step,Memorized Entry',
                              FRA = 'Aucun,Ecriture en cours,Ecriture statut précédent,Ecriture mémorisée';
            OptionMembers = "None","Applied Entry","Entry Previous Step","Memorized Entry";
        }
        field(13; "Memorize Entry"; Boolean)
        {
            CaptionML = ENU = 'Memorize Entry', FRA = 'Mémoriser écriture';
        }
        field(14; "Document Type"; Enum "Gen. Journal Document Type")
        {
            CaptionML = ENU = 'Document Type', FRA = 'Type document';
        }
        field(15; "Document No."; Option)
        {
            CaptionML = ENU = 'Document No.', FRA = 'N° document';
            OptionCaptionML = ENU = 'Header No.,Document ID Line', FRA = 'N° en-tête,N° document ligne';
            OptionMembers = "Header No.","Document ID Line";
        }
        field(16; "Posting RS"; Boolean)
        {
            CaptionML = ENU = 'Posting RS', FRA = 'Compta. retenue à la source';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                Step1: Record 50862;
                Step2: Record 50862;
            begin
                CLEAR(PaymentStepLedger);
                PaymentStepLedger.RESET;
                PaymentStepLedger.SETCURRENTKEY("Payment Class", "Posting RS", "Posting RS On VAT", "Line No.");
                PaymentStepLedger.SETFILTER("Payment Class", "Payment Class");
                PaymentStepLedger.SETRANGE("Posting RS", TRUE);
                CLEAR(Step1);
                CLEAR(Step2);
                Step1.GET("Payment Class", "Line No.");

                IF "Posting RS" THEN
                    IF PaymentStepLedger.FindFirst() AND ((PaymentStepLedger."Line No." <> "Line No.") OR (PaymentStepLedger.Sign <> Sign)) THEN BEGIN
                        Step2.GET("Payment Class", "Line No.");
                        IF Step1."Previous Status" <> Step2."Previous Status" THEN
                            ERROR(Error001);
                    END;
                IF NOT "Posting RS" THEN
                    "RS Account No." := '';
            end;
        }
        field(17; "RS Account No."; Code[20])
        {
            CaptionML = ENU = 'RS Account No.', FRA = 'N° Compte RS';
            TableRelation = "G/L Account";
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                lText001: TextConst ENU = 'Posting RS must be cheked',
                                    FRA = 'Compta. retenue à la source doit être coché';
            begin
                if (Rec."RS Account No." <> '') and (Not "Posting RS") then
                    error(lText001);
            end;
        }
        field(18; "Posting RS On VAT"; Boolean)
        {
            CaptionML = ENU = 'Posting RS On VAT', FRA = 'Compta. retenue Sur TVA';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                CLEAR(PaymentStepLedger);
                PaymentStepLedger.RESET;
                PaymentStepLedger.SETCURRENTKEY("Payment Class", "Posting RS", "Posting RS On VAT", "Line No.");
                PaymentStepLedger.SETFILTER("Payment Class", "Payment Class");
                PaymentStepLedger.SETRANGE("Posting RS On VAT", TRUE);
                IF "Posting RS On VAT" THEN
                    IF PaymentStepLedger.Findfirst AND ((PaymentStepLedger."Line No." <> "Line No.") OR (PaymentStepLedger.Sign <> Sign)) THEN
                        ERROR(Error002);
                IF NOT "Posting RS On VAT" THEN
                    "Compte Retenue Sur TVA" := '';
            end;
        }
        field(19; "Compte Retenue Sur TVA"; Code[20])
        {
            CaptionML = ENU = 'RS Account No. On VAT', FRA = 'Compte Retenue Sur TVA';
            TableRelation = "G/L Account";
            DataClassification = ToBeClassified;

        }
        field(20; "Include Commission"; Boolean)
        {
            CaptionML = ENU = 'Include Commission', FRA = 'Inclure Commission';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                CLEAR(PaymentStepLedger);
                PaymentStepLedger.RESET;
                PaymentStepLedger.SETCURRENTKEY("Payment Class", "Include Commission", "Line No.");
                PaymentStepLedger.SETFILTER("Payment Class", "Payment Class");
                PaymentStepLedger.SETRANGE("Include Commission", TRUE);
                IF "Include Commission" THEN
                    IF PaymentStepLedger.Findfirst AND ((PaymentStepLedger."Line No." <> "Line No.") OR (PaymentStepLedger.Sign <> Sign)) THEN
                        ERROR(Error003)
                    ELSE BEGIN
                        "Commission Account No." := '';
                        "Commission VAT Account No." := '';
                    END;
            end;
        }
        field(21; "Commission Account No."; Code[20])
        {
            CaptionML = ENU = 'Commission Account No.', FRA = 'N° Compte Commission';
            TableRelation = "G/L Account";
            DataClassification = ToBeClassified;

        }
        field(22; "Commission VAT Account No."; Code[20])
        {
            CaptionML = ENU = 'Commission VAT Account No.', FRA = 'N° Compte TVA/Commission';
            TableRelation = "G/L Account";
            DataClassification = ToBeClassified;

        }
        field(23; "VAT %"; Decimal)
        {
            CaptionML = ENU = 'VAT %', FRA = 'Taux TVA';
            DataClassification = ToBeClassified;
        }
        field(24; "Cancel Posting RS"; Boolean)
        {
            CaptionML = ENU = 'Cancel Posting RS', FRA = 'Annuler Compta Retn. à la Source';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                CLEAR(PaymentStepLedger);
                PaymentStepLedger.RESET;
                PaymentStepLedger.SETCURRENTKEY("Payment Class", "Cancel Posting RS", "Line No.");
                PaymentStepLedger.SETFILTER("Payment Class", "Payment Class");
                PaymentStepLedger.SETRANGE("Cancel Posting RS", TRUE);
                IF "Posting RS" THEN
                    IF PaymentStepLedger.Findfirst AND ((PaymentStepLedger."Line No." <> "Line No.") OR (PaymentStepLedger.Sign <> Sign)) THEN
                        ERROR(Error004);
                IF "Cancel Posting RS" THEN
                    "Posting RS" := FALSE;
            end;
        }
        field(25; "RS On Guarantee"; Boolean)
        {
            CaptionML = ENU = 'RS On Guarantee', FRA = 'Retenue sur Garantie';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                CLEAR(PaymentStepLedger);
                PaymentStepLedger.RESET;
                PaymentStepLedger.SETCURRENTKEY("Payment Class", "Posting RS", "Posting RS On VAT", "Line No.");
                PaymentStepLedger.SETFILTER("Payment Class", "Payment Class");
                PaymentStepLedger.SETRANGE("RS On Guarantee", TRUE);
                IF "RS On Guarantee" THEN
                    IF PaymentStepLedger.FindFirst() AND ((PaymentStepLedger."Line No." <> "Line No.") OR (PaymentStepLedger.Sign <> Sign)) THEN
                        ERROR(Error005);
            end;
        }
    }

    keys
    {
        key(Key1; "Payment Class", "Line No.", Sign)
        {
            Clustered = true;
        }
    }
    var
        PaymentStepLedger: Record 50863;
        Error001: Label 'Vous avez déjà spécifié la Retenu à la Source !';
        Error002: Label 'Vous avez déjà spécifié la Retenu Sur T.V.A !';
        Error003: Label 'Vous avez déjà spécifié la Commission !';
        Error004: Label 'Vous avez déjà Annuler la Retenu à la Source !';
        Error005: Label 'Vous avez déjà spécifier la Retenu de Garantie !';
}

