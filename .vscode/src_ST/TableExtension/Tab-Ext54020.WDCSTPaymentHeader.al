tableextension 54020 "WDC-ST Payment Header" extends "WDC-ED Payment Header"
{
    fields
    {
        modify("Source Code")
        {

            trigger OnAfterValidate()
            begin
                IF "Source Code" <> '' THEN
                    IF Rec."Source Code" <> xRec."Source Code" THEN BEGIN
                        CLEAR(PayStat);
                        PayStat.GET("Payment Class", "Status No.");
                        PayStat.TESTFIELD("Allow Header Modification");
                    END;
            end;
        }
        modify("Account Type")
        {
            trigger OnAfterValidate()
            begin


                CLEAR(PaymentStatus);
                IF PaymentStatus.GET("Payment Class", "Status No.") THEN;
                PayLine.RESET;
                PayLine.SETRANGE("No.", "No.");
                IF PayLine.FINDSET THEN
                    PayLine.MODIFYALL("Header Account Type", "Account Type");

            end;
        }
        modify("Account No.")
        {

            trigger OnAfterValidate()
            begin
                IF "Account No." <> '' THEN
                    IF Rec."Account No." <> xRec."Account No." THEN BEGIN
                        CLEAR(PayStat);
                        PayStat.GET("Payment Class", "Status No.");
                    END;
                CLEAR(PaymentStatus);
                IF PaymentStatus.GET("Payment Class", "Status No.") THEN;
                PayLine.RESET;
                PayLine.SETRANGE("No.", "No.");
                IF PayLine.FINDSET THEN
                    PayLine.MODIFYALL("Header Account Type", "Account Type");

                IF ("Account Type" = "Account Type"::"Bank Account") AND ("Account No." <> '') THEN BEGIN
                    BEGIN
                        BankAccount.RESET;
                        BankAccount.GET("Account No.");
                        "Source Code" := BankAccount."Source Code";
                        PayLine.RESET;
                        PayLine.SETRANGE("No.", rec."No.");
                        IF PayLine.FINDSET THEN BEGIN
                            PayLine.MODIFYALL(PayLine."Header RIB", "Bank Account No.");
                            //PayLine.MODIFYALL(PayLine."Compte_Entête", "Account No."); //HD22042025 Modif PayLine."Compte_Entête"
                            PayLine.ModifyAll("Header Account Type", "Account Type");
                            PayLine.MODIFYALL("Header Account No.", "Account No.");
                        END;
                    END;

                END;

                CLEAR(PayStat);
                PayStat.GET("Payment Class", "Status No.");

                IF xRec."Account No." <> '' THEN
                    IF NOT PayStat."Allow Header Modification" THEN
                        IF Rec."Account No." <> xRec."Account No." THEN
                            ERROR('Impossible de modifer la banque entête Bordereau');

                IF "Account Type" = "Account Type"::"Bank Account" THEN BEGIN
                    usersetup.GET(USERID);
                    PaymentClass.GET("Payment Class");
                    IF ("Account No." <> '') AND (PaymentClass."Default Caisse" <> PaymentClass."Default Caisse"::" ") THEN BEGIN
                        IF PaymentClass."Default Caisse" = PaymentClass."Default Caisse"::Expense THEN
                            IF usersetup."Default Expense Cashier" <> '' THEN
                                IF usersetup."Default Expense Cashier" <> "Account No." THEN
                                    ERROR('Caisse dépense non modifiable!');

                        IF (PaymentClass."Default Caisse" = PaymentClass."Default Caisse"::Income) AND NOT PayStat."Allow Header Modification" THEN
                            IF usersetup."Default Recipe Box" <> '' THEN
                                IF usersetup."Default Recipe Box" <> "Account No." THEN
                                    ERROR('Caisse recette non modifiable!');
                    END;
                END;
            end;
        }


        field(54000; "No. Bordereau"; Code[20])
        {
            CaptionML = ENU = 'Payment Slip No.', FRA = 'No. Bordereau';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                CLEAR(PaymentStatus);
                IF PaymentStatus.GET("Payment Class", "Status No.") THEN;

                PayLine.RESET;
                PayLine.SETRANGE("No.", "No.");
                IF PayLine.FINDSET THEN BEGIN
                    PayLine.MODIFYALL("Payment Slip No.", "No. Bordereau");
                END;
            end;
        }
        field(54001; "Date Création"; DateTime)
        {
            CaptionML = ENU = 'Creation Date', FRA = 'Date Création';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(54002; "Créer par"; Code[50])
        {
            CaptionML = ENU = 'Created by', FRA = 'Créer par';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(54003; "Modifié le"; DateTime)
        {
            CaptionML = ENU = 'Modified Date', FRA = 'Modifié le';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(54004; "Modifié par"; Code[10])
        {
            CaptionML = ENU = 'Modified by', FRA = 'Modifié par';
            DataClassification = ToBeClassified;

            Editable = false;
        }
        field(54005; Cash; Boolean)
        {
            CaptionML = ENU = 'Cash', FRA = 'Caisse';
            DataClassification = ToBeClassified;

        }
        field(54006; "Payment Amount Type"; Enum "WDC-ST Payment Amount Type")
        {
            CaptionML = ENU = 'Payment Amount Type', FRA = 'Type montant paiement';
            DataClassification = ToBeClassified;

            Editable = true;


            trigger OnValidate()
            var
                PayLine: Record "WDC-ED Payment Line";
            begin

                PayLine.SETRANGE("No.", "No.");
                IF PayLine.FINDFIRST THEN
                    REPEAT
                        PayLine."Payment Amount Type" := PayLine."Payment Amount Type"::Avance;
                    UNTIL PayLine.NEXT = 0;
            end;
        }
        field(54007; Beneficiary; Text[50])
        {
            CaptionML = ENU = 'Beneficiary', FRA = 'Bénéficiaire';
            DataClassification = ToBeClassified;

        }
        field(54008; Quality; Text[50])
        {
            CaptionML = ENU = 'Quality', FRA = 'Qualité';
            DataClassification = ToBeClassified;

        }
        field(54009; Object; Enum "WDC-ST Payment Object")
        {
            CaptionML = ENU = 'Object', FRA = 'Objet';
            DataClassification = ToBeClassified;
        }
        field(54010; Justificatifs; Enum "WDC-ST Payment Justificatifs")
        {
            CaptionML = ENU = 'Justificatifs', FRA = 'Justificatifs';
            DataClassification = ToBeClassified;
        }
        field(54011; "Print Number"; Integer)
        {
            CaptionML = ENU = 'Print Number', FRA = 'Nombre Impression';
            DataClassification = ToBeClassified;

        }
        field(54012; "Nom Tiers"; Text[100])
        {
            CaptionML = ENU = 'Third-Party Name', FRA = 'Nom Tiers';
            CalcFormula = Lookup("WDC-ED Payment Line"."Payment Label" WHERE("No." = FIELD("No.")));

            Editable = false;
            FieldClass = FlowField;
        }
        field(54013; "Vendor posting group"; Code[10])
        {
            CaptionML = ENU = 'Vendor Posting Group', FRA = 'Groupe compta fournisseur';
            DataClassification = ToBeClassified;
            TableRelation = "Vendor Posting Group";
        }
        field(54014; "Generate Check No."; Integer)
        {
            CaptionML = ENU = 'Generate Check No.', FRA = 'Générer No. Chèque';
            DataClassification = ToBeClassified;
        }
        field(54015; "Vendor Agent"; Code[20])
        {
            CaptionML = ENU = 'Vendor Agent', FRA = 'Agent Frs';
            CalcFormula = Lookup("WDC-ED Payment Line"."Account No." WHERE("No." = FIELD("No."),
                                                                     "Payment Class" = FILTER('DEC-CHEQ|ENC-CHQ')));
            FieldClass = FlowField;
        }
        field(54016; "Vendor Agent CIN"; Code[8])
        {
            CaptionML = ENU = 'Vendor Agent CIN', FRA = 'CIN Agent Frs';
            DataClassification = ToBeClassified;

        }
        field(54017; Suggestions; Enum "WDC-ST Suggestion")
        {
            CaptionML = ENU = 'Suggestions', FRA = 'Suggestions';
            DataClassification = ToBeClassified;
        }
        field(54018; "Payment Methode Code"; Code[10])
        {
            CaptionML = ENU = 'Payment Methode Code', FRA = 'Code mode règlement';
            DataClassification = ToBeClassified;

        }
        field(54020; "Exter. Payment Slip No."; Code[35])
        {
            CaptionML = ENU = 'Exter. Payment Slip No.', FRA = 'No. Bordereau Externe';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = Lookup("WDC-ED Payment Line"."External Document No." WHERE("No." = FIELD("No."),
                                                                               "Payment Class" = FILTER('DEC-CHEQ|ENC-CHQ')));
        }
        field(54022; "Validation Date"; DateTime)
        {
            CaptionML = ENU = 'Validation Date', FRA = 'Date Validation';
            DataClassification = ToBeClassified;
        }
        field(54023; "Reason Code"; Code[10])
        {
            CaptionML = ENU = 'Reason Code', FRA = 'Code Motif';
            DataClassification = ToBeClassified;

            TableRelation = "Reason Code".Code;
        }
        field(54024; "ED Type"; Enum "WDC-ST ED Type")
        {
            CaptionML = ENU = 'ED Type', FRA = 'Type ED';
            DataClassification = ToBeClassified;
        }
        field(54026; "Cession No."; Code[20])
        {
            CaptionML = ENU = 'Cession No.', FRA = 'N° Cession';
            DataClassification = ToBeClassified;
        }
        field(54027; RIB; Code[30])
        {
            CaptionML = ENU = 'RIB', FRA = 'RIB';
            CalcFormula = Lookup("WDC-ED Payment Line"."Bank Account No." WHERE("No." = FIELD("No.")));
            FieldClass = FlowField;
        }
        field(54028; "Banque RIB"; Text[100])
        {
            CaptionML = ENU = 'Bank RIB', FRA = 'Banque RIB';
            CalcFormula = Lookup("WDC-ED Payment Line"."Bank Account Name" WHERE("No." = FIELD("No.")));
            FieldClass = FlowField;
        }
        field(54029; "Payment Slip Type"; Enum "WDC-ST Payment Slip Type")
        {
            CaptionML = ENU = 'Payment Slip Type', FRA = 'Type bordoreau';
            CalcFormula = Lookup("WDC-ED Payment Class"."Payment Methode Type" WHERE(Code = FIELD("Payment Class")));
            FieldClass = FlowField;
            Editable = false;
        }

    }
    trigger OnInsert()

    begin
        If Process.Get(Rec."Payment Class") Then begin
            VALIDATE("Account Type", Process."Header Account Type");
            Rec.Suggestions := Process.Suggestions;
            "Payment Methode Code" := FORMAT(Process."Payment Methode Type");

            InitPaymentHeader;

            Process.Get("Payment Class");
            IF Process."Default Caisse" = Process."Default Caisse"::Expense THEN BEGIN
                usersetup.GET(USERID);
                IF "Account Type" = "Account Type"::"Bank Account" THEN
                    VALIDATE("Account No.", usersetup."Default Expense Cashier");
            END;
            IF Process."Default Caisse" = Process."Default Caisse"::Income THEN BEGIN
                usersetup.GET(USERID);
                IF Rec."Account Type" = "Account Type"::"Bank Account" THEN
                    Rec.VALIDATE("Account No.", usersetup."Default Recipe Box");
            END;
        end;
    end;

    var
        PayLine: Record 50866;
        BankAccount: Record 270;
        PaymentStatus: Record 50861;
        usersetup: Record 91;
        PaymentClass: Record 50860;
        PaymentLigne: Record 50866;
        Process: Record "WDC-ED Payment Class";
        GetProcess: Record "WDC-ED Payment Class";
        PayStat: Record "WDC-ED Payment Status";

    procedure InitPaymentHeader()
    begin
        "ED Type" := Process."ED Type";
        "Account Type" := "Account Type"::"Bank Account";
        IF usersetup.GET(USERID) THEN begin
        end;
        "Date Création" := CURRENTDATETIME;
        "Créer par" := USERID;
    end;



}

