table 50865 "WDC-ED Payment Header"
{
    CaptionML = ENU = 'Payment Header', FRA = 'En-tête bordereau';
    DrillDownPageID = "WDC-ED Payment Slip List";
    LookupPageID = "WDC-ED Payment Slip List";

    fields
    {
        field(1; "No."; Code[20])
        {
            CaptionML = ENU = 'No.', FRA = 'N°';
            Editable = false;

            trigger OnValidate()
            begin
                if "No." <> xRec."No." then begin
                    PaymentClass := PaymentClass2;
                    NoSeriesMgt.TestManual(PaymentClass2."Header No. Series");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; "Currency Code"; Code[10])
        {
            CaptionML = ENU = 'Currency Code', FRA = 'Code devise';
            TableRelation = Currency;

            trigger OnValidate()
            var
                PaymentLine: Record "WDC-ED Payment Line";
                CompanyBank: Record "Bank Account";
            begin
                if "Account Type" = "Account Type"::"Bank Account" then
                    if CompanyBank.Get("Account No.") then
                        if CompanyBank."Currency Code" <> '' then
                            Error(Text008, CompanyBank."Currency Code");

                if CurrFieldNo <> FieldNo("Currency Code") then
                    UpdateCurrencyFactor
                else
                    if "Currency Code" <> xRec."Currency Code" then begin
                        PaymentLine.SetRange("No.", "No.");
                        if PaymentLine.FindFirst then
                            Error(Text002);
                        UpdateCurrencyFactor;
                    end else
                        if "Currency Code" <> '' then begin
                            UpdateCurrencyFactor;
                            if "Currency Factor" <> xRec."Currency Factor" then
                                ConfirmUpdateCurrencyFactor;
                        end;
                if "Currency Code" <> xRec."Currency Code" then begin
                    PaymentLine.Init();
                    PaymentLine.SetRange("No.", "No.");
                    PaymentLine.ModifyAll("Currency Code", "Currency Code");
                    PaymentLine.ModifyAll("Currency Factor", "Currency Factor");
                end;
            end;
        }
        field(3; "Currency Factor"; Decimal)
        {
            CaptionML = ENU = 'Currency Factor', FRA = 'Facteur devise';
            DecimalPlaces = 0 : 15;

            trigger OnValidate()
            var
                PaymentLine: Record "WDC-ED Payment Line";
            begin
                PaymentLine.SetRange("No.", "No.");
                if PaymentLine.FindSet then
                    repeat
                        PaymentLine."Currency Factor" := "Currency Factor";
                        PaymentLine.Validate(Amount);
                        PaymentLine.Modify();
                    until PaymentLine.Next = 0;
            end;
        }
        field(4; "Posting Date"; Date)
        {
            CaptionML = ENU = 'Posting Date', FRA = 'Date comptabilisation';

            trigger OnValidate()
            var
                PaymentLine: Record "WDC-ED Payment Line";
            begin
                if "Posting Date" <> xRec."Posting Date" then begin
                    PaymentLine.Reset();
                    PaymentLine.SetRange("No.", "No.");
                    PaymentLine.ModifyAll("Posting Date", "Posting Date");
                end;
            end;
        }
        field(5; "Document Date"; Date)
        {
            CaptionML = ENU = 'Document Date', FRA = 'Date document';

            trigger OnValidate()
            var
                PaymentLine: Record "WDC-ED Payment Line";
            begin
                if "Document Date" <> xRec."Document Date" then begin
                    PaymentLine.Reset();
                    PaymentLine.SetRange("No.", "No.");
                    if PaymentLine.FindSet then
                        repeat
                            PaymentLine.UpdateDueDate("Document Date");
                        until PaymentLine.Next = 0;
                end;
            end;
        }
        field(6; "Payment Class"; Text[30])
        {
            CaptionML = ENU = 'Payment Class', FRA = 'Type de règlement';
            TableRelation = "WDC-ED Payment Class";

            trigger OnValidate()
            begin
                Validate("Status No.");
            end;
        }
        field(7; "Status No."; Integer)
        {
            CaptionML = ENU = 'Status No.', FRA = 'N° statut';
            TableRelation = "WDC-ED Payment Status"."Line No." WHERE("Payment Class" = FIELD("Payment Class"));

            trigger OnValidate()
            var
                PaymentStep: Record "WDC-ED Payment Step";
                PaymentStatus: Record "WDC-ED Payment Status";
            begin
                PaymentStep.SetRange("Payment Class", "Payment Class");
                PaymentStep.SetFilter("Next Status", '>%1', "Status No.");
                PaymentStep.SetRange("Action Type", PaymentStep."Action Type"::Ledger);
                if PaymentStep.FindFirst then
                    "Source Code" := PaymentStep."Source Code";
                PaymentStatus.Get("Payment Class", "Status No.");
                "Archiving Authorized" := PaymentStatus."Archiving Authorized";
            end;
        }
        field(8; "Status Name"; Text[50])
        {
            CalcFormula = Lookup("WDC-ED Payment Status".Name WHERE("Payment Class" = FIELD("Payment Class"),
                                                              "Line No." = FIELD("Status No.")));
            CaptionML = ENU = 'Status Name', FRA = 'Nom statut';
            Editable = false;
            FieldClass = FlowField;
        }
        field(9; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            CaptionML = ENU = 'Shortcut Dimension 1 Code', FRA = 'Code raccourci axe 1';

            trigger OnLookup()
            begin
                LookupShortcutDimCode(1, "Shortcut Dimension 1 Code");
                Validate("Shortcut Dimension 1 Code");
            end;

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
                Modify;
            end;
        }
        field(10; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            CaptionML = ENU = 'Shortcut Dimension 2 Code', FRA = 'Code raccourci axe 2';
            trigger OnLookup()
            begin
                LookupShortcutDimCode(2, "Shortcut Dimension 2 Code");
                Validate("Shortcut Dimension 2 Code");
            end;

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
                Modify;
            end;
        }
        field(11; "Payment Class Name"; Text[100])
        {
            CalcFormula = Lookup("WDC-ED Payment Class".Name WHERE(Code = FIELD("Payment Class")));
            CaptionML = ENU = 'Payment Class Name', FRA = 'Nom type de règlement';
            Editable = false;
            FieldClass = FlowField;
        }
        field(12; "No. Series"; Code[20])
        {
            CaptionML = ENU = 'No. Series', FRA = 'Souches de n°';
            TableRelation = "No. Series";
        }
        field(13; "Source Code"; Code[10])
        {
            CaptionML = ENU = 'Source Code', FRA = 'Code journal';
            TableRelation = "Source Code";
        }
        field(14; "Account Type"; enum "Gen. Journal Account Type")
        {
            CaptionML = ENU = 'Account Type', FRA = 'Type compte';

            trigger OnValidate()
            begin
                if "Account Type" <> xRec."Account Type" then begin
                    Validate("Account No.", '');
                    "Dimension Set ID" := 0;
                    DimensionManagement.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code",
                      "Shortcut Dimension 2 Code");
                end;
            end;
        }
        field(15; "Account No."; Code[20])
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

            trigger OnValidate()
            begin
                if "Account No." <> xRec."Account No." then begin
                    "Dimension Set ID" := 0;
                    DimensionManagement.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code",
                      "Shortcut Dimension 2 Code");
                    if "Account No." <> '' then
                        DimensionSetup;
                end;
                if "Account Type" = "Account Type"::"Bank Account" then begin
                    if CompanyBankAccount.Get("Account No.") then begin
                        if "Currency Code" = '' then
                            if CompanyBankAccount."Currency Code" <> '' then
                                Error(Text006);
                        if "Currency Code" <> '' then
                            if (CompanyBankAccount."Currency Code" <> "Currency Code") and (CompanyBankAccount."Currency Code" <> '') then
                                Error(Text007, "Currency Code");
                        "Bank Branch No." := CompanyBankAccount."Bank Branch No.";
                        "Bank Account No." := CompanyBankAccount."Bank Account No.";
                        IBAN := CompanyBankAccount.IBAN;
                        "SWIFT Code" := CompanyBankAccount."SWIFT Code";
                        "Bank Country/Region Code" := CompanyBankAccount."Country/Region Code";
                        "Agency Code" := CompanyBankAccount."Agency Code";
                        "RIB Key" := CompanyBankAccount."RIB Key";
                        "RIB Checked" := CompanyBankAccount."RIB Checked";
                        "Bank Name" := CompanyBankAccount.Name;
                        "Bank Post Code" := CompanyBankAccount."Post Code";
                        "Bank City" := CompanyBankAccount.City;
                        "Bank Name 2" := CompanyBankAccount."Name 2";
                        "Bank Address" := CompanyBankAccount.Address;
                        "Bank Address 2" := CompanyBankAccount."Address 2";
                        "National Issuer No." := CompanyBankAccount."National Issuer No.";
                    end else
                        InitBankAccount;
                end else
                    InitBankAccount;
            end;
        }
        field(16; "Amount (LCY)"; Decimal)
        {
            CalcFormula = Sum("WDC-ED Payment Line"."Amount (LCY)" WHERE("No." = FIELD("No.")));
            CaptionML = ENU = 'Amount (LCY)', FRA = 'Montant DS';
            Editable = false;
            FieldClass = FlowField;
        }
        field(17; Amount; Decimal)
        {
            CalcFormula = Sum("WDC-ED Payment Line".Amount WHERE("No." = FIELD("No.")));
            CaptionML = ENU = 'Amount', FRA = 'Montant';
            Editable = false;
            FieldClass = FlowField;
        }
        field(18; "Bank Branch No."; Text[20])
        {
            CaptionML = ENU = 'Bank Branch No.', FRA = 'Code établissement';

            trigger OnValidate()
            begin
                "RIB Checked" := RibKey.Check("Bank Branch No.", "Agency Code", "Bank Account No.", "RIB Key");
            end;
        }
        field(19; "Bank Account No."; Text[30])
        {
            CaptionML = ENU = 'Bank Account No.', FRA = 'N° compte bancaire';

            trigger OnValidate()
            begin
                "RIB Checked" := RibKey.Check("Bank Branch No.", "Agency Code", "Bank Account No.", "RIB Key");
            end;
        }
        field(20; "Agency Code"; Text[20])
        {
            CaptionML = ENU = 'Agency Code', FRA = 'Code agence';

            trigger OnValidate()
            begin
                "RIB Checked" := RibKey.Check("Bank Branch No.", "Agency Code", "Bank Account No.", "RIB Key");
            end;
        }
        field(21; "RIB Key"; Integer)
        {
            CaptionML = ENU = 'RIB Key', FRA = 'Clé RIB';

            trigger OnValidate()
            begin
                "RIB Checked" := RibKey.Check("Bank Branch No.", "Agency Code", "Bank Account No.", "RIB Key");
            end;
        }
        field(22; "RIB Checked"; Boolean)
        {
            CaptionML = ENU = 'RIB Checked', FRA = 'Vérification RIB';
            Editable = false;
        }
        field(23; "Bank Name"; Text[100])
        {
            CaptionML = ENU = 'Bank Name', FRA = 'Nom de la banque';
        }
        field(24; "Bank Post Code"; Code[20])
        {
            CaptionML = ENU = 'Bank Post Code', FRA = 'Code postal banque';
            TableRelation = IF ("Bank Country/Region Code" = CONST('')) "Post Code"
            ELSE
            IF ("Bank Country/Region Code" = FILTER(<> '')) "Post Code" WHERE("Country/Region Code" = FIELD("Bank Country/Region Code"));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                PostCode.ValidatePostCode(
                  "Bank City", "Bank Post Code", "Bank County", "Bank Country/Region Code", (CurrFieldNo <> 0) and GuiAllowed);
            end;
        }
        field(25; "Bank City"; Text[30])
        {
            CaptionML = ENU = 'Bank City', FRA = 'Ville banque';
            TableRelation = IF ("Bank Country/Region Code" = CONST('')) "Post Code".City
            ELSE
            IF ("Bank Country/Region Code" = FILTER(<> '')) "Post Code".City WHERE("Country/Region Code" = FIELD("Bank Country/Region Code"));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                PostCode.ValidatePostCode(
                  "Bank City", "Bank Post Code", "Bank County", "Bank Country/Region Code", (CurrFieldNo <> 0) and GuiAllowed);
            end;
        }
        field(26; "Bank Name 2"; Text[50])
        {
            CaptionML = ENU = 'Bank Name 2', FRA = 'Nom 2 banque';
        }
        field(27; "Bank Address"; Text[100])
        {
            CaptionML = ENU = 'Bank Address', FRA = 'Adresse banque';
        }
        field(28; "Bank Address 2"; Text[50])
        {
            CaptionML = ENU = 'Bank Address 2', FRA = 'Adresse banque (2ème ligne)';
        }
        field(29; "Bank Contact"; Text[100])
        {
            CaptionML = ENU = 'Bank Contact', FRA = 'Contact banque';
        }
        field(30; "Bank County"; Text[30])
        {
            CaptionML = ENU = 'Bank County', FRA = 'Région banque';
        }
        field(31; "Bank Country/Region Code"; Code[10])
        {
            CaptionML = ENU = 'Bank Country/Region Code', FRA = 'Code pays/région banque';
            TableRelation = "Country/Region";
        }
        field(32; "National Issuer No."; Code[6])
        {
            CaptionML = ENU = 'National Issuer No.', FRA = 'N° émetteur national';
            Numeric = true;
        }
        field(40; "File Export Completed"; Boolean)
        {
            CaptionML = ENU = 'File Export Completed', FRA = 'Exportation du fichier terminée';
            Editable = false;
        }
        field(41; "No. of Lines"; Integer)
        {
            CalcFormula = Count("WDC-ED Payment Line" WHERE("No." = FIELD("No.")));
            CaptionML = ENU = 'No. of Lines', FRA = 'Nbre de lignes';
            Editable = false;
            FieldClass = FlowField;
        }
        field(42; "No. of Unposted Lines"; Integer)
        {
            CalcFormula = Count("WDC-ED Payment Line" WHERE("No." = FIELD("No."),
                                                      Posted = CONST(false)));
            CaptionML = ENU = 'No. of Unposted Lines', FRA = 'Nombre de lignes non validées';
            Editable = false;
            FieldClass = FlowField;
        }
        field(43; "Archiving Authorized"; Boolean)
        {
            CalcFormula = Lookup("WDC-ED Payment Status"."Archiving Authorized" WHERE("Payment Class" = FIELD("Payment Class"),
                                                                                "Line No." = FIELD("Status No.")));
            CaptionML = ENU = 'Archiving Authorized', FRA = 'Archivage autorisé';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50; IBAN; Code[50])
        {
            CaptionML = ENU = 'IBAN', FRA = 'N° compte bancaire international';

            trigger OnValidate()
            var
                CompanyInfo: Record "Company Information";
            begin
                CompanyInfo.CheckIBAN(IBAN);
            end;
        }
        field(51; "SWIFT Code"; Code[20])
        {
            CaptionML = ENU = 'SWIFT Code', FRA = 'Code SWIFT';
        }
        field(132; "Partner Type"; Enum "Partner Type")
        {
            CaptionML = ENU = 'Partner Type', FRA = 'Type partenaire';
        }
        field(480; "Dimension Set ID"; Integer)
        {
            CaptionML = ENU = 'Dimension Set ID', FRA = 'ID ensemble de dimensions';
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup()
            begin
                ShowDocDim;
            end;

            trigger OnValidate()
            var
                DimMgt: Codeunit DimensionManagement;
            begin
                DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
            end;
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
        key(Key2; "Posting Date")
        {
        }
        key(Key3; "Posting Date", "No.")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "No.", "Payment Class Name", "Amount (LCY)", "Posting Date")
        {
        }
    }

    trigger OnDelete()
    var
        PaymentLine: Record "WDC-ED Payment Line";
    begin
        if "Status No." > 0 then
            Error(Text000);

        PaymentLine.SetRange("No.", "No.");
        PaymentLine.SetFilter("Copied To No.", '<>''''');
        if PaymentLine.FindFirst then
            Error(Text000);
        PaymentLine.SetRange("Copied To No.");
        PaymentLine.DeleteAll(true);
    end;

    trigger OnInsert()
    begin
        if Rec."No." = '' then begin
            if PAGE.RunModal(PAGE::"WDC-ED Payment Class List", PaymentClass2) = ACTION::LookupOK then
                PaymentClass := PaymentClass2;
            PaymentClass.TestField("Header No. Series");
            Rec."No." := NoSeriesMgt.GetNextNo(PaymentClass."Header No. Series");
            Rec.Validate("Payment Class", PaymentClass.Code);

        end;
        InitHeader;
        //InitFirstPaymentLine(); //Cette fonction a fait un problème de comptabilisation
    end;

    // Procedure InitFirstPaymentLine()
    // var
    //     lPaymentClass: record "WDC-ED Payment Class";
    //     lpaymentLines: Record "WDC-ED Payment Line";
    // begin
    //     if lPaymentClass.Get(rec."Payment Class") then
    //         if lPaymentClass.Suggestions <> lPaymentClass.Suggestions::None then begin
    //             lpaymentLines.Init();
    //             lpaymentLines."No." := Rec."No.";
    //             lpaymentLines."Line No." := 10000;
    //             lpaymentLines.Validate("Account Type", lPaymentClass.Suggestions);
    //             lpaymentLines.Insert();
    //         end;
    // end;

    procedure LookupShortcutDimCode(FieldNo: Integer; var ShortcutDimCode: Code[20])
    begin
        DimensionManagement.LookupDimValueCode(FieldNo, ShortcutDimCode);
        DimensionManagement.ValidateShortcutDimValues(FieldNo, ShortcutDimCode, "Dimension Set ID");
    end;

    procedure ValidateShortcutDimCode(FieldNo: Integer; var ShortcutDimCode: Code[20])
    begin
        DimensionManagement.ValidateShortcutDimValues(FieldNo, ShortcutDimCode, "Dimension Set ID");
        if xRec."Dimension Set ID" <> "Dimension Set ID" then
            if PaymentLinesExist then
                UpdateAllLineDim("Dimension Set ID", xRec."Dimension Set ID");
    end;

    procedure AssistEdit(OldPaymentHeader: Record "WDC-ED Payment Header"): Boolean
    begin
        //with PaymentHeader do begin
        PaymentHeader := Rec;
        PaymentClass := PaymentClass2;

        PaymentClass.TestField("Header No. Series");
        if NoSeriesMgt.LookupRelatedNoSeries(PaymentClass."Header No. Series", OldPaymentHeader."No. Series", "No. Series") then begin
            PaymentClass := PaymentClass2;
            PaymentClass.TestField("Header No. Series");
            NoSeriesMgt.GetNextNo("No.");
            Rec := PaymentHeader;
            exit(true);
        end;
        //end;
    end;

    local procedure UpdateCurrencyFactor()
    begin
        if "Currency Code" <> '' then begin
            CurrencyDate := WorkDate;
            "Currency Factor" := CurrencyExchangeRate.ExchangeRate(CurrencyDate, "Currency Code");
        end else
            "Currency Factor" := 1;
    end;

    local procedure ConfirmUpdateCurrencyFactor()
    begin
        "Currency Factor" := xRec."Currency Factor";
    end;

    procedure InitBankAccount()
    begin
        "Bank Branch No." := '';
        "Bank Account No." := '';
        IBAN := '';
        "SWIFT Code" := '';
        "Agency Code" := '';
        "RIB Key" := 0;
        "RIB Checked" := false;
        "Bank Name" := '';
        "Bank Post Code" := '';
        "Bank City" := '';
        "Bank Name 2" := '';
        "Bank Address" := '';
        "Bank Address 2" := '';
        "Bank Contact" := '';
        "Bank County" := '';
        "Bank Country/Region Code" := '';
        "National Issuer No." := '';
    end;

    procedure TestNbOfLines()
    begin
        CalcFields("No. of Lines");
        if "No. of Lines" = 0 then
            Error(Text001);
    end;

    procedure InitHeader()
    begin
        Rec."Posting Date" := WORKDATE;
        Rec."Document Date" := WORKDATE;
        Rec.VALIDATE("Account Type", "Account Type"::"Bank Account");
    end;

    procedure DimensionSetup()
    begin
        DimensionCreate;
    end;

    procedure DimensionCreate()
    var
        DefaultDimSource: List of [Dictionary of [Integer, Code[20]]];
        OldDimSetID: Integer;
    begin
        DimensionManagement.AddDimSource(DefaultDimSource, DimensionManagement.TypeToTableID1("Account Type".AsInteger()), Rec."Account No.");
        "Shortcut Dimension 1 Code" := '';
        "Shortcut Dimension 2 Code" := '';
        OldDimSetID := "Dimension Set ID";

        "Dimension Set ID" :=
          DimensionManagement.GetRecDefaultDimID(
            Rec, CurrFieldNo, DefaultDimSource, "Source Code", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", 0, 0);

        if OldDimSetID <> "Dimension Set ID" then begin
            Modify();
            if PaymentLinesExist() then
                UpdateAllLineDim("Dimension Set ID", OldDimSetID);
        end;
    end;

    procedure ShowDocDim()
    var
        OldDimSetID: Integer;
    begin
        OldDimSetID := "Dimension Set ID";
        "Dimension Set ID" :=
          DimensionManagement.EditDimensionSet(
            "Dimension Set ID", StrSubstNo('%1 %2', 'Payment: ', "No."),
            "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");

        if OldDimSetID <> "Dimension Set ID" then begin
            Modify;
            if PaymentLinesExist then
                UpdateAllLineDim("Dimension Set ID", OldDimSetID);
        end;
    end;

    procedure PaymentLinesExist(): Boolean
    var
        PaymentLine: Record "WDC-ED Payment Line";
    begin
        PaymentLine.Reset();
        PaymentLine.SetRange("No.", "No.");
        exit(PaymentLine.FindFirst);
    end;

    local procedure UpdateAllLineDim(NewParentDimSetID: Integer; OldParentDimSetID: Integer)
    var
        PaymentLine: Record "WDC-ED Payment Line";
        NewDimSetID: Integer;
    begin
        // Update all lines with changed dimensions.

        if NewParentDimSetID = OldParentDimSetID then
            exit;
        if not Confirm(Text009) then
            exit;

        PaymentLine.Reset();
        PaymentLine.SetRange("No.", "No.");
        PaymentLine.LockTable();
        if PaymentLine.FindSet() then
            repeat
                NewDimSetID := DimensionManagement.GetDeltaDimSetID(PaymentLine."Dimension Set ID", NewParentDimSetID, OldParentDimSetID);
                if PaymentLine."Dimension Set ID" <> NewDimSetID then begin
                    PaymentLine."Dimension Set ID" := NewDimSetID;
                    PaymentLine.Modify();
                end;
            until PaymentLine.Next = 0;
    end;

    var
        PaymentClass: Record "WDC-ED Payment Class";
        PaymentHeader: Record "WDC-ED Payment Header";
        PaymentClass2: Record "WDC-ED Payment Class";
        CurrencyExchangeRate: Record "Currency Exchange Rate";
        CompanyBankAccount: Record "Bank Account";
        PostCode: Record "Post Code";
        DimensionManagement: Codeunit DimensionManagement;
        NoSeriesMgt: Codeunit "No. Series";
        RibKey: Codeunit "WDC-ED RIB Key";
        CurrencyDate: Date;
        Text000: TextConst ENU = 'Deleting the line is not allowed.',
                           FRA = 'Vous n''avez pas le droit de supprimer la ligne.';
        Text001: TextConst ENU = 'There is no line to treat.',
                           FRA = 'Il n''y aucune ligne à traiter.';
        Text002: TextConst ENU = 'You cannot modify Currency Code because the Payment Header contains lines.',
                           FRA = 'Impossible de modifier le code devise sur un bordereau contenant des lignes.';
        Text006: TextConst ENU = 'The currency code for the document is the LCY Code.\\Please select a bank for which the currency code is the LCY Code.',
                           FRA = 'Le code devise du document est la devise société.\\Sélectionnez une banque dont le code devise est la devise société.';
        Text007: TextConst ENU = 'The currency code for the document is %1.\\Please select a bank for which the currency code is %1 or the LCY Code.',
                           FRA = 'Le code devise du document est %1.\\Sélectionnez une banque dont le code devise est %1 ou la devise société.';
        Text008: TextConst ENU = 'Your bank''s currency code is %1.\\You must change the bank account code before modifying the currency code.',
                           FRA = 'La devise de votre banque est %1.\\Vous devez changer de code banque avant de modifier le code devise.';
        Text009: TextConst ENU = 'You may have changed a dimension.\\Do you want to update the lines?',
                           FRA = 'Vous avez probablement modifié un axe analytique.\\Souhaitez-vous mettre à jour les lignes ?';
}

