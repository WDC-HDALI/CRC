table 50860 "WDC-ED Payment Class"
{
    CaptionML = ENU = 'Payment Class', FRA = 'Type de règlement';
    LookupPageID = "WDC-ED Payment Class List";

    fields
    {
        field(1; "Code"; Code[20])
        {
            CaptionML = ENU = 'Code', FRA = 'Code';
            NotBlank = true;

            trigger OnValidate()
            begin
                if Name = '' then
                    Name := Code;
            end;
        }
        field(2; Name; Text[100])
        {
            CaptionML = ENU = 'Name', FRA = 'Nom';
        }
        field(3; "Header No. Series"; Code[20])
        {
            CaptionML = ENU = 'Header No. Series', FRA = 'N° de souche en-tête';
            TableRelation = "No. Series";

            trigger OnValidate()
            var
                NoSeriesLine: Record "No. Series Line";
            begin
                if "Header No. Series" <> '' then begin
                    NoSeriesLine.SetRange("Series Code", "Header No. Series");
                    if NoSeriesLine.FindLast then
                        if (StrLen(NoSeriesLine."Starting No.") > 10) or (StrLen(NoSeriesLine."Ending No.") > 10) then
                            Error(Text002);
                end;
            end;
        }
        field(4; Enable; Boolean)
        {
            CaptionML = ENU = 'Enable', FRA = 'Activer';
            InitValue = true;
        }
        field(5; "Line No. Series"; Code[20])
        {
            CaptionML = ENU = 'Line No. Series', FRA = 'N° de souche lignes';
            TableRelation = "No. Series";

            trigger OnValidate()
            var
                NoSeriesLine: Record "No. Series Line";
            begin
                if "Line No. Series" <> '' then begin
                    NoSeriesLine.SetRange("Series Code", "Line No. Series");
                    if NoSeriesLine.FindLast then
                        if (StrLen(NoSeriesLine."Starting No.") > 10) or (StrLen(NoSeriesLine."Ending No.") > 10) then
                            Error(Text002);
                end;
            end;
        }
        field(6; Suggestions; Enum "WDC-ST Suggestion")
        {
            CaptionML = ENU = 'Suggestions', FRA = 'Propositions';
        }
        field(10; "Is Create Document"; Boolean)
        {
            CalcFormula = Exist("WDC-ED Payment Step" WHERE("Payment Class" = FIELD(Code),
                                                      "Action Type" = CONST("Create New Document")));
            CaptionML = ENU = 'Is Create Document', FRA = 'Création de document';
            Editable = false;
            FieldClass = FlowField;
        }
        field(11; "Unrealized VAT Reversal"; Option)
        {
            CaptionML = ENU = 'Unrealized VAT Reversal', FRA = 'Contrepassation de TVA sur encaissement';
            OptionCaptionML = ENU = 'Application,Delayed', FRA = 'Lettrage,Différé';
            OptionMembers = Application,Delayed;

            trigger OnValidate()
            begin
                if "Unrealized VAT Reversal" = "Unrealized VAT Reversal"::Delayed then begin
                    GLSetup.Get();
                    GLSetup.TestField("Unrealized VAT", true);
                end else begin
                    PaymentStep.SetRange("Payment Class", Code);
                    PaymentStep.SetRange("Realize VAT", true);
                    if PaymentStep.FindFirst then
                        Error(
                          Text003, TableCaption, Code,
                          PaymentStep.TableCaption, PaymentStep.FieldCaption("Realize VAT"));
                end;
            end;
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Code", Name)
        {
        }
    }

    trigger OnDelete()
    var
        Status: Record "WDC-ED Payment Status";
        Step: Record "WDC-ED Payment Step";
        StepLedger: Record "WDC-ED Payment Step Ledger";
        PaymentHeader: Record "WDC-ED Payment Header";
        PaymentLine: Record "WDC-ED Payment Line";
    begin
        PaymentHeader.SetRange("Payment Class", Code);
        PaymentLine.SetRange("Payment Class", Code);
        if PaymentHeader.FindFirst then
            Error(Text001);
        if PaymentLine.FindFirst then
            Error(Text001);
        Status.SetRange("Payment Class", Code);
        Status.DeleteAll();
        Step.SetRange("Payment Class", Code);
        Step.DeleteAll();
        StepLedger.SetRange("Payment Class", Code);
        StepLedger.DeleteAll();
    end;

    trigger OnInsert()
    begin
        FeatureTelemetry.LogUptake('1000HP1', FRPaymentSlipTok, Enum::"Feature Uptake Status"::"Set up");
    end;

    var
        FeatureTelemetry: Codeunit "Feature Telemetry";
        PaymentStep: Record "WDC-ED Payment Step";
        GLSetup: Record "General Ledger Setup";
        FRPaymentSlipTok: Label 'FR Create Payment Slips', Locked = true;
        Text001: TextConst ENU = 'You cannot delete this Payment Class because it is already in use.',
                           FRA = 'Vous ne pouvez pas supprimer ce type de règlement car il est déjà utilisé.';
        Text002: TextConst ENU = 'You cannot assign numbers longer than 10 characters.',
                           FRA = 'Vous ne pouvez pas affecter des nombres de plus de 10 caractères.';
        Text003: TextConst ENU = '%1 %2 has at least one %3 for which %4 is checked.',
                           FRA = '%1 %2 a au moins un %3 pour lequel %4 est contrôlé.';
}

