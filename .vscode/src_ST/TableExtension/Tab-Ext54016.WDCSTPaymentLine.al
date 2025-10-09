tableextension 54016 "WDC-ST Payment Line" extends "WDC-ED Payment Line"
{
    fields
    {
        modify(Amount)
        {
            trigger OnAfterValidate()
            var
                CurrExchRate: Record 330;
            begin
                Paramcpta.GET;
                IF ("RS Amount" = 0) AND ("Validated RS Amount" = 0) AND ("RS VAT Amount" = 0)
                    AND ("Validated RS VAT Amount" = 0) AND ("Commission Amount" = 0) AND ("Validated Commission Amount" = 0)
                    AND ("Commission VAT Amount" = 0) AND ("Validated VAt Amt Commission" = 0) AND ("Guarantee RS Amount" = 0)
                    AND ("Validated Guarantee RS Amount" = 0)
                     THEN BEGIN
                    "Initial Amount" := Amount;
                    "Assiette RS" := "Initial Amount";
                    "Initial Amount LCY" := "Amount (LCY)";
                END;

                IF Amount >= Paramcpta."Min RS Amount LCY" THEN BEGIN
                    IF "RS Code" <> '' THEN
                        VALIDATE("RS Code", "RS Code");
                end else begin
                    Validate("RS Code", '');
                    "RS Amount" := 0;
                    "Validated RS Amount" := 0;
                    "RS Amount LCY" := 0;
                    "Validated RS Amount LCY" := 0;
                    "RS VAT Amount" := 0;
                    "Validated RS VAT Amount" := 0;
                    "RS VAT Amount LCY" := 0;
                    "Validated RS VAT Amount LCY" := 0;
                    "Guarantee RS Code" := '';
                    "Guarantee RS Amount" := 0;
                    "Validated Guarantee RS Amount" := 0;
                    "Guarantee RS Amount LCY" := 0;
                    "Valid Guarantee RS Amount LCY" := 0;
                END;

                // ELSE BEGIN
                // IF "Account Type" = "Account Type"::Vendor THEN BEGIN
                //     CLEAR(Vend);
                //     Vend.GET("Account No.");
                //IF Vend."Exempt RS" = FALSE THEN BEGIN

                // IF Vend."RS Code" = '' THEN BEGIN
                //     Paramcpta.TESTFIELD("Default RS");
                //     VALIDATE("RS Code", Paramcpta."Default RS");
                // END;
                //END;
                //END;
                // END;

            end;
        }

        modify("Account No.")
        {
            trigger OnAfterValidate()
            var
                ltext001: Label 'Fournisseur Bloqué';
            begin

                Vendor.RESET;
                Customer.RESET;
                GLAccount.RESET;
                Employee.RESET;
                BankAccount.RESET;
                "Payment Label" := '';
                IF "Account No." <> '' THEN
                    CASE "Account Type" OF
                        "Account Type"::Vendor:
                            BEGIN
                                IF Vendor.GET("Account No.") THEN BEGIN
                                    IF Vendor.Blocked = Vendor.Blocked::Payment THEN
                                        ERROR(Ltext001);

                                    "Posting Group" := Vendor."Vendor Posting Group";
                                    "Payment Label" := Vendor.Name;
                                    VALIDATE("RS Code", Vendor."RS Code");
                                    // Code_Mode_Règlement := FORMAT(Vendor."Payment Method Code");
                                    "Payment Methode Code" := Vendor."Payment Method Code"; //HD2204 :Update Code_Mode_Règlement
                                END;
                            END;
                        "Account Type"::"G/L Account":
                            BEGIN
                                IF GLAccount.GET("Account No.") THEN
                                    "Payment Label" := GLAccount.Name;
                            END;

                        "Account Type"::Customer:
                            BEGIN
                                IF Customer.GET("Account No.") THEN BEGIN

                                    "Posting Group" := Customer."Customer Posting Group";
                                    "Payment Label" := Customer.Name;
                                    Draw := "Payment Label";
                                END
                            END;
                        "Account Type"::"Bank Account":
                            BEGIN
                                IF BankAccount.GET("Account No.") THEN
                                    "Payment Label" := BankAccount.Name;

                            END;

                    END;
                IF "Account Type" = "Account Type"::Vendor THEN BEGIN
                    Vendor.RESET;
                    Vendor.SETRANGE("No.", "Account No.");
                    IF Vendor.FINDFIRST THEN
                        "Payment Label" := Vendor.Name;
                END;
                IF "Account Type" = "Account Type"::Customer THEN BEGIN
                    Customer.RESET;
                    Customer.SETRANGE("No.", "Account No.");
                    IF Customer.FINDFIRST THEN
                        "Payment Label" := Customer.Name;
                END;
                GLAccount.RESET;
                GLAccount.SETRANGE("No.", "Account No.");
                IF GLAccount.FINDFIRST THEN
                    "Payment Label" := GLAccount.Name;

                CLEAR(paymentheader);
                paymentheader.GET("No.");
                "Header Account Type" := paymentheader."Account Type";
                "Header Account No." := paymentheader."Account No.";

                IF PaymentClass.GET("Payment Class") THEN
                    IF (PaymentClass."Line Account Type" = PaymentClass."Line Account Type"::"Expense Cash") AND ("Account Type" = "Account Type"::"Bank Account") THEN
                        IF banqe.GET("Account No.") THEN
                            IF banqe."Caisse Type" <> banqe."Caisse Type"::Expense THEN
                                ERROR('Veuiller choisir une caisse dépense');
            end;
        }
        field(54000; "RS Code"; Code[10])
        {
            CaptionML = ENU = 'RS Code', FRA = 'Code RS';
            TableRelation = IF ("Account Type" = CONST(Customer)) "WDC-ST Retained Group".Code WHERE("Type Retenue" = FILTER("à la source"),
            "RS Type" = const(Customer))
            ELSE IF ("Account Type" = CONST(Vendor)) "WDC-ST Retained Group".Code WHERE("Type Retenue" = FILTER("à la source"),
            "RS Type" = const(Vendor));
            trigger OnValidate()
            begin
                IF "Account Type" = "Account Type"::Vendor THEN
                    IF "RS Code" <> '' THEN BEGIN
                        CLEAR(Vend);
                        Vend.GET("Account No.");
                        Vend.TESTFIELD("Exempt RS", FALSE);
                    END;
            end;

        }
        field(54001; "RS Amount"; Decimal)
        {
            CaptionML = ENU = 'RS Amount', FRA = 'Montant RS';
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;

            trigger OnValidate()
            var
                RecGCurrency: Record Currency;
                RecGCurrencyExchangeRate: Record "Currency Exchange Rate";
                RecGPaymentStatus: Record "WDC-ED Payment Status";
                RecGGeneralLedgerSetup: Record "General Ledger Setup";
            begin
                IF ((Amount > 0) AND ("RS Amount" > 0)) OR ((Amount < 0) AND ("RS Amount" < 0)) THEN
                    "RS Amount" := -"RS Amount";

                // Calc Montant Retenu
                IF "Currency Code" <> '' THEN RecGCurrency.GET("Currency Code");
                IF ("RS Amount" <> 0) AND ("Validated RS Amount" = 0) AND (RecGPaymentStatus."Calculate RS") THEN BEGIN
                    IF "Currency Code" <> '' THEN
                        "RS Amount LCY" := ROUND(RecGCurrencyExchangeRate.ExchangeAmtFCYToLCY("Posting Date",
                        "Currency Code", "RS Amount", "Currency Factor")
                        , RecGCurrency."Amount Rounding Precision")
                    ELSE
                        "RS Amount LCY" := ROUND("RS Amount", RecGGeneralLedgerSetup."Amount Rounding Precision");
                END;
            end;
        }
        field(54002; "Validated RS Amount"; Decimal)
        {
            CaptionML = ENU = 'Validated RS Amount', FRA = 'Montant RS validé';
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
        }
        field(54003; "RS Amount LCY"; Decimal)
        {
            CaptionML = ENU = 'RS Amount LCY', FRA = 'Montant Retenue DS';
            AutoFormatType = 2;
        }
        field(54004; "Validated RS Amount LCY"; Decimal)
        {
            CaptionML = ENU = 'Validated RS Amount LCY', FRA = 'Montant RS validé DS';
            AutoFormatType = 2;

        }
        field(54005; "RS VAT Amount"; Decimal)
        {
            CaptionML = ENU = 'RS VAT Amount', FRA = 'Montant Retenue TVA';
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            trigger OnValidate()
            begin
                IF ((Amount > 0) AND ("RS VAT Amount" > 0)) OR ((Amount < 0) AND ("RS VAT Amount" < 0)) THEN
                    "RS VAT Amount" := -"RS VAT Amount";
            end;
        }
        field(54006; "Validated RS VAT Amount"; Decimal)
        {
            CaptionML = ENU = 'Validated RS VAT Amount', FRA = 'Montant Retenue TVA validé';
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;

        }
        field(54007; "RS VAT Amount LCY"; Decimal)
        {
            CaptionML = ENU = 'RS VAT Amount LCY', FRA = 'Montant Retenue TVA DS';
            AutoFormatType = 2;

        }
        field(54008; "Validated RS VAT Amount LCY"; Decimal)
        {
            CaptionML = ENU = 'Validated RS VAT Amount LCY', FRA = 'Montant Retenue TVA validé DS';
            AutoFormatType = 2;
        }
        field(54009; "Guarantee RS Code"; Code[10])
        {
            CaptionML = ENU = 'Guarantee RS Code', FRA = 'Code RS Garantie';
            TableRelation = "WDC-ST Retained Group".Code WHERE("Type Retenue" = FILTER("de garantie"));

            trigger OnValidate()
            VAR
                RecGCurrency: Record Currency;
                RecGCurrencyExchangeRate: Record "Currency Exchange Rate";
                RecGPaymentStatus: Record "WDC-ED Payment Status";
                RecGGeneralLedgerSetup: Record "General Ledger Setup";
            begin
                IF ((Amount > 0) AND ("Guarantee RS Amount" > 0)) OR ((Amount < 0) AND ("Guarantee RS Amount" < 0)) THEN
                    "Guarantee RS Amount" := -"Guarantee RS Amount";

                // Calc Montant Retenue G.
                IF "Currency Code" <> '' THEN RecGCurrency.GET("Currency Code");
                IF ("Guarantee RS Amount" <> 0) AND ("Validated Guarantee RS Amount" = 0) AND
                (RecGPaymentStatus."Calc. RS On Guarrantee") THEN BEGIN
                    IF "Currency Code" <> '' THEN
                        "Guarantee RS Amount LCY" := ROUND(RecGCurrencyExchangeRate.ExchangeAmtFCYToLCY("Posting Date",
                        "Currency Code", "Guarantee RS Amount", "Currency Factor")
                        , RecGCurrency."Amount Rounding Precision")
                    ELSE
                        "Guarantee RS Amount LCY" := ROUND("Guarantee RS Amount", RecGGeneralLedgerSetup."Amount Rounding Precision");
                END;
            end;
        }
        field(54010; "Guarantee RS Amount"; Decimal)
        {
            CaptionML = ENU = 'Guarantee RS Amount', FRA = 'Montant Rs Garantie';
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;

            trigger OnValidate()
            begin
                IF ((Amount > 0) AND ("Guarantee RS Amount" > 0)) OR ((Amount < 0) AND ("Guarantee RS Amount" < 0)) THEN
                    "Guarantee RS Amount" := -"Guarantee RS Amount";
            end;
        }
        field(54011; "Validated Guarantee RS Amount"; Decimal)
        {
            CaptionML = ENU = 'Validated Guarantee RS Amount', FRA = 'Montant Retenue G. Validé';
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;

        }
        field(54012; "Guarantee RS Amount LCY"; Decimal)
        {
            CaptionML = ENU = 'Guarantee RS Amount LCY', FRA = 'Montant Rs Garantie';
            AutoFormatType = 2;

        }
        field(54013; "Valid Guarantee RS Amount LCY"; Decimal)
        {
            CaptionML = ENU = 'Valid Guarantee RS Amount LCY', FRA = 'Montant Rs Garantie validé DS';
            AutoFormatType = 2;

        }
        field(54014; "Apply RS"; Boolean)
        {
            CaptionML = ENU = 'Apply RS', FRA = 'Appliquer RS';
            DataClassification = ToBeClassified;
        }
        field(54015; "Commission Amount"; Decimal)
        {
            CaptionML = ENU = 'Commission Amount', FRA = 'Montant Commission';
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;

            trigger OnValidate()
            begin
                IF (((Amount > 0) AND ("Commission Amount" <= 0)) OR ((Amount < 0) AND ("Commission Amount" >= 0)))
                  AND ("Account Type" = "Account Type"::Vendor) THEN BEGIN
                    "Commission Amount" := -"Commission Amount";
                    MODIFY;
                END
                ELSE
                    IF (((Amount > 0) AND ("Commission Amount" >= 0)) OR ((Amount < 0) AND ("Commission Amount" <= 0)))
                      AND ("Account Type" = "Account Type"::Customer) THEN
                        "Commission Amount" := -"Commission Amount";
                "Commission VAT Amount" := 0;
                "Commission VAT Amount LCY" := 0;
            end;
        }
        field(54016; "Commission Amount LCY"; Decimal)
        {
            CaptionML = ENU = 'Commission Amount LCY', FRA = 'Montant Commission DS';
            AutoFormatType = 2;
            trigger OnValidate()
            begin
                IF (((Amount > 0) AND ("Commission Amount LCY" <= 0)) OR ((Amount < 0) AND ("Commission Amount LCY" >= 0)))
                  AND ("Account Type" = "Account Type"::Vendor) THEN
                    "Commission Amount LCY" := -"Commission Amount LCY"
                ELSE
                    IF (((Amount > 0) AND ("Commission Amount LCY" >= 0)) OR ((Amount < 0) AND ("Commission Amount LCY" <= 0)))
                      AND ("Account Type" = "Account Type"::Customer) THEN
                        "Commission Amount LCY" := -"Commission Amount LCY";
                "Commission VAT Amount" := 0;
                "Commission VAT Amount LCY" := 0;
            end;
        }
        field(54017; "Commission VAT Amount"; Decimal)
        {
            CaptionML = ENU = 'Commission VAT Amount', FRA = 'Montant TVA Commission';
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            trigger OnValidate()
            begin

                IF (((Amount > 0) AND ("Commission VAT Amount" < 0)) OR ((Amount < 0) AND ("Commission VAT Amount" > 0)))
                  AND ("Account Type" = "Account Type"::Vendor) THEN
                    "Commission VAT Amount" := -"Commission VAT Amount"
                ELSE
                    IF (((Amount > 0) AND ("Commission VAT Amount" > 0)) OR ((Amount < 0) AND ("Commission VAT Amount" < 0)))
                      AND ("Account Type" = "Account Type"::Customer) THEN
                        "Commission VAT Amount" := -"Commission VAT Amount";
            end;
        }
        field(54018; "Commission VAT Amount LCY"; Decimal)
        {
            CaptionML = ENU = 'Commission VAT Amount LCY', FRA = 'Montant DS TVA Commission';
            AutoFormatType = 2;
            trigger OnValidate()
            begin
                IF (((Amount > 0) AND ("Commission VAT Amount LCY" < 0)) OR ((Amount < 0) AND ("Commission VAT Amount LCY" > 0)))
                  AND ("Account Type" = "Account Type"::Vendor) THEN
                    "Commission VAT Amount LCY" := -"Commission VAT Amount LCY"
                ELSE
                    IF (((Amount > 0) AND ("Commission VAT Amount LCY" > 0)) OR ((Amount < 0) AND ("Commission VAT Amount LCY" < 0)))
                      AND ("Account Type" = "Account Type"::Customer) THEN
                        "Commission VAT Amount LCY" := -"Commission VAT Amount LCY";
            end;
        }
        field(54019; "Initial Amount"; Decimal)
        {
            CaptionML = ENU = 'Initial Amount', FRA = 'Montant Initial';
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;

        }
        field(54020; "Initial Amount LCY"; Decimal)
        {
            CaptionML = ENU = 'Initial Amount LCY', FRA = 'Montant Initial DS';
            AutoFormatType = 2;

        }
        field(54021; "Validated Commission Amount"; Decimal)
        {
            CaptionML = ENU = 'Validated Commission Amount', FRA = 'Montant Commission validé';
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;

        }
        field(54022; "Valid Commission Amount LCY"; Decimal)
        {
            CaptionML = ENU = 'Validated Commission Amount LCY', FRA = 'Montant Commission validé DS';
            AutoFormatType = 2;

        }
        field(54023; "Validated VAt Amt Commission"; Decimal)
        {
            CaptionML = ENU = 'Validated VAt Amt Commission', FRA = 'Montant TVA sur Commission validé';
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;

        }
        field(54024; "Validated Commission Amt LCY"; Decimal)
        {
            CaptionML = ENU = 'Validated Commission Amt LCY', FRA = 'Montant DS Commission validé ';
            AutoFormatType = 2;

        }
        field(54025; "Drawee Reference1"; Text[50])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Drawee Reference', FRA = 'Reférence tireur';
        }

        field(54026; "Payment Label"; Text[100])
        {
            CaptionML = ENU = 'Payment Label', FRA = 'Libellé';
            DataClassification = ToBeClassified;
        }
        field(54027; Comments; Text[50])
        {
            CaptionML = ENU = 'Comments', FRA = 'Commentaires';
            DataClassification = ToBeClassified;

        }
        field(54028; "Payment Object"; Text[100])
        {
            CaptionML = ENU = 'Payment Object', FRA = 'Objet du paiement';
            DataClassification = ToBeClassified;

        }
        field(54029; "External Invoice No."; Code[20])
        {
            CaptionML = ENU = 'External Invoice No.', FRA = 'N° Facture Externe';
            DataClassification = ToBeClassified;

        }
        field(54030; "In Bank"; Boolean)
        {
            CaptionML = ENU = 'In Bank', FRA = 'En Banque';
            DataClassification = ToBeClassified;

            Editable = false;
        }
        field(54031; Cancelation; Boolean)
        {
            CaptionML = ENU = 'Cancelation', FRA = 'Annulation';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(54032; "Payment Amount Type"; Enum "WDC-ST Payment Amount Type")
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Payment Amount Type', FRA = 'Type Montant';
        }


        field(54033; "Payment Slip No."; Code[20])
        {
            CaptionML = ENU = 'Payment Slip No.', FRA = 'N° Bordereau';
            DataClassification = ToBeClassified;

            Editable = false;
        }
        field(54034; Replaced; Boolean)
        {
            CaptionML = ENU = 'Replaced', FRA = 'Remplacé';
            DataClassification = ToBeClassified;
        }

        field(54035; "Payment Credit"; Boolean)
        {
            CaptionML = ENU = 'Payment Credit', FRA = 'Crédit paiement';
            DataClassification = ToBeClassified;

        }
        field(54036; "Header Account Type"; Enum "Gen. Journal Account Type")
        {
            CaptionML = ENU = 'Header Account Type', FRA = 'Type compte entête';
            DataClassification = ToBeClassified;

            Editable = false;
        }
        field(54037; "Header Account No."; Code[20])
        {
            CaptionML = ENU = 'Header Account No.', FRA = 'N° Compte entête';
            DataClassification = ToBeClassified;

            Editable = false;
            TableRelation = IF ("Header Account Type" = CONST("G/L Account")) "G/L Account"
            ELSE
            IF ("Header Account Type" = CONST(Customer)) Customer
            ELSE
            IF ("Header Account Type" = CONST(Vendor)) Vendor
            ELSE
            IF ("Header Account Type" = CONST("Bank Account")) "Bank Account"
            ELSE
            IF ("Header Account Type" = CONST("Fixed Asset")) "Fixed Asset";
        }
        field(54038; "Open Advance"; Boolean)
        {
            CaptionML = ENU = 'Open Advance', FRA = 'Avance ouvert';
            DataClassification = ToBeClassified;

        }
        field(54039; "Open Amount"; Decimal)
        {
            CaptionML = ENU = 'Open Amount', FRA = 'Montant Ouvert';
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            DataClassification = ToBeClassified;

        }
        field(54040; "Open Amount LCY"; Decimal)
        {
            CaptionML = ENU = 'Open Amount LCY', FRA = 'Montant Ouvert DS';
            AutoFormatType = 2;
            DataClassification = ToBeClassified;

        }
        field(54041; "Job No."; Code[20])
        {
            CaptionML = ENU = 'Job No.', FRA = 'N° Projet';
            DataClassification = ToBeClassified;

        }

        field(54042; "Counterparty Payment Line"; Code[20])
        {
            CaptionML = ENU = 'Counterparty Payment Line', FRA = 'Contrepartie Ligne paiement';
            DataClassification = ToBeClassified;

            TableRelation = IF ("Counterparty Account Type" = CONST("G/L Account")) "G/L Account"
            ELSE
            IF ("Counterparty Account Type" = CONST(Customer)) Customer
            ELSE
            IF ("Counterparty Account Type" = CONST(Vendor)) Vendor
            ELSE
            IF ("Counterparty Account Type" = CONST("Bank Account")) "Bank Account";
        }
        field(54043; "Counterparty Account Type"; Enum "Gen. Journal Account Type")
        {
            CaptionML = ENU = 'Counterparty Account Type', FRA = 'Type Compte Contrepartie';
            DataClassification = ToBeClassified;

        }
        field(54044; "Contr. Associ. Acc. LP Type"; Enum "Gen. Journal Account Type")
        {
            CaptionML = ENU = 'Contr. Associ. Acc. LP Type', FRA = 'Type Cpt. Ass. Contrepartie Lp';
            DataClassification = ToBeClassified;
        }
        field(54045; "Contr. Associ. Acc. LP No."; Code[10])
        {
            CaptionML = ENU = 'Contr. Associ. Acc. LP No.', FRA = 'N° Cpt. Ass. Contrepartie Lp';
            DataClassification = ToBeClassified;

            TableRelation = IF ("Counterparty Account Type" = CONST("G/L Account")) "G/L Account"
            ELSE
            IF ("Counterparty Account Type" = CONST(Customer)) Customer
            ELSE
            IF ("Counterparty Account Type" = CONST(Vendor)) Vendor
            ELSE
            IF ("Counterparty Account Type" = CONST("Bank Account")) "Bank Account";
        }
        field(54046; "Payment State"; Enum "WDC-ST Payment State")
        {
            CaptionML = ENU = 'Payment State', FRA = 'Etat Paiement';
            DataClassification = ToBeClassified;
        }
        field(54047; "Invoice Source No."; Code[200])
        {
            CaptionML = ENU = 'Invoice Source No.', FRA = 'No. Facture Source';
            DataClassification = ToBeClassified;
        }
        // field(54048; "Code_Mode_Règlement"; Text[30])
        // {
        //     DataClassification = ToBeClassified;

        // }
        field(54049; "Header RIB"; Code[20])
        {
            CaptionML = ENU = 'Header RIB', FRA = 'RIB Entête';
            DataClassification = ToBeClassified;

        }

        field(54052; "Montant Frais a Déduire"; Decimal)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin

                "Assiette RS" := "Initial Amount" - "Montant Frais a Déduire" + "Mnt Déduction";
            end;
        }
        field(54053; "Assiette RS"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 3 : 3;
            trigger OnValidate()
            begin
                "Montant Frais a Déduire" := 0;
                "Montant Frais a Déduire" := "Initial Amount" - "Assiette RS" + "Mnt Déduction";
            end;
        }
        field(54054; "Mnt Déduction"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 3 : 3;


            trigger OnValidate()
            begin
                "Assiette RS" := "Initial Amount" - "Montant Frais a Déduire" + "Mnt Déduction";
            end;
        }
        field(54055; "Date de validation"; DateTime)
        {
            DataClassification = ToBeClassified;

        }

        field(54057; "Référence chèque"; Code[20])
        {
            DataClassification = ToBeClassified;

            Editable = false;
            TableRelation = "Bank Account";
        }
        field(54058; "Petite Dépense"; Code[20])
        {
            DataClassification = ToBeClassified;

            TableRelation = "Item Charge"."No." WHERE("Petty Cash" = CONST(true));

            trigger OnValidate()
            var
                ltext001: label 'Paramétrage groupe de validation produit %1, groupe compta marché = %2 est manquant';
            begin
                IF ItemCharge.GET("Petite Dépense") THEN
                    IF GenPostingSetup.GET('', ItemCharge."Gen. Prod. Posting Group") THEN BEGIN
                        VALIDATE("Account Type", "Account Type"::"G/L Account");
                        VALIDATE("Account No.", GenPostingSetup."Purch. Account");
                    END
                    ELSE
                        ERROR(Ltext001, ItemCharge."Gen. Prod. Posting Group", '');
            end;
        }
        field(54059; "ED Type"; Enum "WDC-ST ED Type")
        {
            CaptionML = ENU = 'ED Type', FRA = 'Type ED';
            DataClassification = ToBeClassified;

        }
        field(54061; "Payment Methode Code"; Code[10])
        {
            CaptionML = ENU = 'Payment Methode Code', FRA = 'Code mode règlement';
            DataClassification = ToBeClassified;
        }
        field(54062; Situation; Enum "WDC-ST Payment Situation")
        {
            CaptionML = ENU = 'Situation', FRA = 'Situation';
            DataClassification = ToBeClassified;
        }
        field(54065; "Drawer/Beneficiary"; Code[20])
        {
            CaptionML = ENU = 'Drawer/Beneficiary', FRA = 'Tireur/Beneficiaire';
            DataClassification = ToBeClassified;

        }
        field(54066; "Draw"; Code[80])
        {
            CaptionML = ENU = 'Draw', FRA = 'Tiré';
            DataClassification = ToBeClassified;

        }
        field(54069; "Cession No."; Code[20])
        {
            CaptionML = ENU = 'Cession No.', FRA = 'N° Cession';
            DataClassification = ToBeClassified;
        }

        field(54071; "Commande No."; Code[20])
        {
            CaptionML = ENU = 'Order No.', FRA = 'N° Commande';
            DataClassification = ToBeClassified;

            TableRelation = "Sales Header"."No." WHERE("Document Type" = FILTER(Order),
                                                      "Bill-to Customer No." = FIELD("Account No."));
            trigger OnValidate()
            begin
                TESTFIELD(Posted, FALSE);
                Montantcommande := 0;
                IF SalesOrder.GET(SalesOrder."Document Type"::Order, "Commande No.") THEN BEGIN
                    SalesOrder.CALCFIELDS(SalesOrder."Payment Amount (LCY)", SalesOrder."Amount Including VAT");
                    IF SalesOrder."Payment Amount (LCY)" = 0 THEN BEGIN
                        IF SalesOrder."Prep. Amount" <> 0 THEN
                            Montantcommande := SalesOrder."Prep. Amount"
                        ELSE BEGIN
                            IF SalesOrder."% Prep. Amount" <> 0 THEN
                                Montantcommande := ROUND(((SalesOrder."Amount Including VAT" + SalesOrder."Stamp Amount") * SalesOrder."% Prep. Amount" / 100), 0.001, '=')
                            ELSE
                                Montantcommande := SalesOrder."Amount Including VAT" + SalesOrder."Stamp Amount" - SalesOrder."Payment Amount (LCY)";
                        END;
                    END ELSE
                        Montantcommande := SalesOrder."Amount Including VAT" + SalesOrder."Stamp Amount" - SalesOrder."Payment Amount (LCY)";
                END;

                VALIDATE(Amount, -Montantcommande);
            end;
        }

        field(54072; "Invoice No."; Code[20])
        {
            CaptionML = ENU = 'Invoice No.', FRA = 'N° Facture';
            DataClassification = ToBeClassified;

        }
        field(54074; "Reason Code"; Code[10])
        {
            CaptionML = ENU = 'Reason Code', FRA = 'Code Motif';
            DataClassification = ToBeClassified;

            TableRelation = "Reason Code".Code;
        }

        field(54075; "Payment Slip Type"; Enum "WDC-ST Payment Slip Type")
        {
            CaptionML = ENU = 'Payment Slip Type', FRA = 'Type bordoreau';
            Editable = false;
        }
        field(54076; "Payment Reference"; Code[20])
        {
            CaptionML = ENU = 'Payment Reference', FRA = 'N° Paiement';
            DataClassification = ToBeClassified;

        }

    }
    trigger OnInsert()
    var
        statement: record "WDC-ED Payment Header";
    begin
        paymentheader.GET("No.");
        "Payment Slip Type" := paymentheader."Payment Slip Type";
        Statement.GET(Rec."No.");
        "ED Type" := Statement."ED Type";
        "Payment Methode Code" := Statement."Payment Methode Code";

        IF PaymentStatus.GET(Rec."Payment Class", Rec."Status No.") THEN
            Situation := PaymentStatus.Situation;

        IF "Currency Code" <> '' THEN
            Currency.GET("Currency Code");
        PaymentStatus.RESET;
        PaymentStatus.SETRANGE("Payment Class", "Payment Class");
        PaymentStatus.SETRANGE("Line No.", "Status No.");
        PaymentStatus.SETRANGE(Cancelation, TRUE);
        IF PaymentStatus.FINDFIRST THEN
            Cancelation := TRUE;

        IF "Status No." = 0 THEN
            IF ("Due Date" < "Posting Date") AND ("Due Date" <> 0D) THEN ERROR('Date echéance erronée');
    end;

    var
        Currency: record Currency;
        PaymentClass: record "WDC-ED Payment Class";
        Customer: record Customer;
        Vendor: record Vendor;
        PaymentStatus: record "WDC-ED Payment Status";
        GLAccount: record "G/L Account";
        Employee: record Employee;
        BankAccount: record "Bank Account";
        Vend: record Vendor;
        Paramcpta: record "General Ledger Setup";
        paymentheader: record "WDC-ED Payment Header";
        ItemCharge: record "Item Charge";
        GenPostingSetup: record "General Posting Setup";
        banqe: record "Bank Account";
        SalesOrder: record "Sales Header";
        Montantcommande: decimal;

    procedure CalcAmount()
    var
        MntRGart: Decimal;
        Custledger: Record "Cust. Ledger Entry";
        MntRet: Decimal;
        MntRetenu: Decimal;
        MntTva: Decimal;
        MntComm: Decimal;
        MntTvaComm: Decimal;
        RecGGLSetup: Record "General Ledger Setup";
        RecGCurrency: Record Currency;
        RecGPaymentStatus: Record "WDC-ED Payment Status";
        RecGGeneralLedgerSetup: Record "General Ledger Setup";
        RecGPaymentStatus1: Record "WDC-ED Payment Status";
        RecGCurrency1: Record Currency;
        RecGCurrencyExchangeRate: Record "Currency Exchange Rate";
    begin
        MntRetenu := 0;
        MntRGart := 0;
        MntRet := 0;
        MntTva := 0;
        MntComm := 0;
        MntTvaComm := 0;
        IF RecGPaymentStatus1.GET("Payment Class", "Status No.") THEN;
        RecGGeneralLedgerSetup.GET;
        IF "Currency Code" <> '' THEN RecGCurrency1.GET("Currency Code");
        IF ("RS VAT Amount" <> 0) AND ("Validated RS VAT Amount" = 0) AND (RecGPaymentStatus1."Calc. RS On VAT") THEN BEGIN
            IF "Currency Code" <> '' THEN
                "RS VAT Amount LCY" := ROUND(RecGCurrencyExchangeRate.ExchangeAmtFCYToLCY
                ("Posting Date", "Currency Code", "RS VAT Amount",
        "Currency Factor")
                , RecGCurrency1."Amount Rounding Precision")
            ELSE
                "RS VAT Amount LCY" := ROUND("RS VAT Amount", RecGGeneralLedgerSetup."Amount Rounding Precision");
        END;
        // Calcul Montant Commission DS
        IF "Currency Code" <> '' THEN RecGCurrency1.GET("Currency Code");
        IF ("Commission Amount LCY" <> 0) AND ("Validated Commission Amount" = 0) AND (RecGPaymentStatus1.Commission) THEN BEGIN
            IF "Currency Code" <> '' THEN
                "Commission Amount" := ROUND(RecGCurrencyExchangeRate.ExchangeAmtLCYToFCY("Posting Date",
                "Currency Code", "Commission Amount LCY",
                "Currency Factor"), RecGCurrency1."Amount Rounding Precision")
            ELSE
                "Commission Amount" := ROUND("Commission Amount LCY", RecGGeneralLedgerSetup."Amount Rounding Precision");
        END ELSE
            IF ("Commission Amount" <> 0) AND ("Validated Commission Amount" = 0) AND (RecGPaymentStatus1.Commission) THEN BEGIN
                IF "Currency Code" <> '' THEN
                    "Commission Amount LCY" := ROUND(RecGCurrencyExchangeRate.ExchangeAmtFCYToLCY("Posting Date",
                    "Currency Code", "Commission Amount",
                    "Currency Factor"), RecGCurrency1."Amount Rounding Precision")
                ELSE
                    "Commission Amount LCY" := ROUND("Commission Amount", RecGGeneralLedgerSetup."Amount Rounding Precision");
            END;

        // Calcul Montant TVA sur Commission DS
        IF "Currency Code" <> '' THEN RecGCurrency1.GET("Currency Code");
        IF ("Commission VAT Amount LCY" <> 0) AND ("Validated VAt Amt Commission" = 0) AND
        (RecGPaymentStatus1."VAT On Commission") THEN BEGIN
            IF "Currency Code" <> '' THEN
                "Commission VAT Amount" := ROUND(RecGCurrencyExchangeRate.ExchangeAmtLCYToFCY("Posting Date",
                "Currency Code", "Commission VAT Amount LCY",
                "Currency Factor"), RecGCurrency1."Amount Rounding Precision")
            ELSE
                "Commission VAT Amount" := ROUND("Commission VAT Amount LCY", RecGGeneralLedgerSetup."Amount Rounding Precision");
        END ELSE
            IF ("Commission VAT Amount" <> 0) AND ("Validated VAt Amt Commission" = 0) AND
            (RecGPaymentStatus1."VAT On Commission") THEN BEGIN
                IF "Currency Code" <> '' THEN
                    "Commission VAT Amount LCY" := ROUND(RecGCurrencyExchangeRate.ExchangeAmtFCYToLCY("Posting Date",
                    "Currency Code", "Commission VAT Amount",
                    "Currency Factor"), RecGCurrency1."Amount Rounding Precision")
                ELSE
                    "Commission VAT Amount LCY" := ROUND("Commission VAT Amount", RecGGeneralLedgerSetup."Amount Rounding Precision");
            END;
        // Calcul Retenu sur Garantie
        IF "Currency Code" <> '' THEN RecGCurrency1.GET("Currency Code");
        IF ("Guarantee RS Amount LCY" <> 0) AND ("Validated Guarantee RS Amount" = 0) AND
        (RecGPaymentStatus1."Calc. RS On Guarrantee") THEN BEGIN
            IF "Currency Code" <> '' THEN
                "Guarantee RS Amount" := ROUND(RecGCurrencyExchangeRate.ExchangeAmtLCYToFCY("Posting Date",
                "Currency Code", "Guarantee RS Amount LCY",
                "Currency Factor"), RecGCurrency1."Amount Rounding Precision")
            ELSE
                "Guarantee RS Amount" := ROUND("Guarantee RS Amount LCY", RecGGeneralLedgerSetup."Amount Rounding Precision");
        END ELSE
            IF ("Guarantee RS Amount" <> 0) AND ("Validated Guarantee RS Amount" = 0) AND
            (RecGPaymentStatus1."Calc. RS On Guarrantee") THEN BEGIN
                IF "Currency Code" <> '' THEN
                    "Guarantee RS Amount LCY" := ROUND(RecGCurrencyExchangeRate.ExchangeAmtFCYToLCY("Posting Date",
                    "Currency Code", "Guarantee RS Amount",
                    "Currency Factor"), RecGCurrency1."Amount Rounding Precision")
                ELSE
                    "Guarantee RS Amount LCY" := ROUND("Guarantee RS Amount", RecGGeneralLedgerSetup."Amount Rounding Precision");
            END;

        IF RecGPaymentStatus1."Calc. RS On Guarrantee" THEN
            MntRGart := "Guarantee RS Amount";
        IF RecGPaymentStatus1."Calculate RS" THEN
            MntRetenu := "RS Amount";
        IF RecGPaymentStatus1."Calc. RS On VAT" THEN
            MntTva := "RS VAT Amount";
        MntTva := "RS VAT Amount" + "Validated RS VAT Amount";
        IF RecGPaymentStatus1.Commission THEN
            MntComm := "Commission Amount" + "Validated Commission Amount";
        IF RecGPaymentStatus1."VAT On Commission" THEN
            MntTvaComm := "Commission VAT Amount" + "Validated VAt Amt Commission";
        VALIDATE(Amount, "Initial Amount" + (MntRetenu + MntTva + MntRGart));
    end;

    procedure CalcRetenu()
    var
        GroupeRetenu: Record "WDC-ST Retained Group";
        RecGPaymentStatus1: Record "WDC-ED Payment Status";
        RecGGeneralLedgerSetup: Record "General Ledger Setup";
        RecGCurrency1: Record Currency;
        RecGPaymentStepLedger: Record "WDC-ED Payment Step Ledger";
        "VarD%Retenue": Decimal;
        RecGPaymentStatus: Record "WDC-ED Payment Status";
    begin
        RecGGeneralLedgerSetup.GET;
        IF "Currency Code" <> '' THEN RecGCurrency1.GET("Currency Code");
        RecGPaymentStepLedger.RESET;
        RecGPaymentStepLedger.SETFILTER("Payment Class", "Payment Class");
        IF (RecGPaymentStepLedger.Findfirst) AND (("Commission VAT Amount" = 0) AND ("Commission VAT Amount LCY" = 0)) THEN BEGIN
            IF "Commission Amount LCY" <> 0 THEN BEGIN
                "Commission VAT Amount LCY" := ROUND("Commission Amount LCY" * RecGPaymentStepLedger."VAT %" / 100,
                RecGGeneralLedgerSetup."Amount Rounding Precision");
                "Commission Amount LCY" := "Commission Amount LCY" - "Commission VAT Amount LCY";
            END ELSE
                IF "Commission Amount" <> 0 THEN BEGIN
                    IF "Currency Code" <> '' THEN
                        "Commission VAT Amount" := ROUND("Commission Amount" *
                        RecGPaymentStepLedger."VAT %" / 100, RecGCurrency1."Amount Rounding Precision")
                    ELSE
                        "Commission VAT Amount" := ROUND("Commission Amount" * RecGPaymentStepLedger."VAT %" / 100,
                        RecGGeneralLedgerSetup."Amount Rounding Precision");

                    "Commission Amount" := "Commission Amount" - "Commission VAT Amount";
                END;
        END;


        "VarD%Retenue" := 0;
        IF GroupeRetenu.GET(0, "RS Code") THEN;
        "VarD%Retenue" := GroupeRetenu."Retention %";
        IF "RS Amount LCY" = 0 THEN
            "RS Amount LCY" := -ROUND("Initial Amount LCY" * ("VarD%Retenue" / 100),
            RecGGeneralLedgerSetup."Amount Rounding Precision");

        IF RecGPaymentStatus1.GET("Payment Class", "Status No.") THEN
            IF ("RS Amount" = 0) AND ("Validated RS Amount" = 0) AND (RecGPaymentStatus1."Calculate RS") THEN BEGIN
                "VarD%Retenue" := GroupeRetenu."Retention %";
                IF "Currency Code" <> '' THEN
                    "RS Amount" := -ROUND("Initial Amount" * ("VarD%Retenue" / 100), RecGCurrency1."Amount Rounding Precision")
                ELSE
                    "RS Amount" := -ROUND("Initial Amount" * ("VarD%Retenue" / 100),
                    RecGGeneralLedgerSetup."Amount Rounding Precision");
                "RS Amount LCY" := -ROUND("Initial Amount LCY" * ("VarD%Retenue" / 100),
                RecGGeneralLedgerSetup."Amount Rounding Precision");
                CalcAmount;

            END;

        "VarD%Retenue" := 0;
        IF GroupeRetenu.GET(1, "Guarantee RS Code") THEN;
        "VarD%Retenue" := GroupeRetenu."Retention %";
        IF RecGPaymentStatus1.GET("Payment Class", "Status No.") THEN
            IF ("Guarantee RS Amount" = 0) AND ("Validated Guarantee RS Amount" = 0) AND
               (RecGPaymentStatus."Calc. RS On Guarrantee") THEN BEGIN
                "VarD%Retenue" := GroupeRetenu."Retention %";
                IF "Currency Code" <> '' THEN
                    "Guarantee RS Amount" := -ROUND("Initial Amount" * ("VarD%Retenue" / 100), RecGCurrency1."Amount Rounding Precision")
                ELSE
                    "Guarantee RS Amount" := -ROUND("Initial Amount" * ("VarD%Retenue" / 100),
                    RecGGeneralLedgerSetup."Amount Rounding Precision");
                CalcAmount;
            END;
    end;
}