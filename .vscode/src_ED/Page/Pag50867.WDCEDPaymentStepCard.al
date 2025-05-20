page 50867 "WDC-ED Payment Step Card"
{
    CaptionML = ENU = 'Payment Step Card', FRA = 'Fiche étape règlement';
    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = "WDC-ED Payment Step";

    layout
    {
        area(content)
        {
            group(Control1)
            {
                ShowCaption = false;
                field("Payment Class"; Rec."Payment Class")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                }
                field("Previous Status"; Rec."Previous Status")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        Rec.CalcFields("Previous Status Name");
                    end;
                }
                field("Previous Status Name"; Rec."Previous Status Name")
                {
                    ApplicationArea = All;
                    DrillDown = false;
                    Editable = false;
                }
                field("Next Status"; Rec."Next Status")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        Rec.CalcFields("Next Status Name");
                    end;
                }
                field("Next Status Name"; Rec."Next Status Name")
                {
                    ApplicationArea = All;
                    DrillDown = false;
                    Editable = false;
                }
                field("Action Type"; Rec."Action Type")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        DisableFields;
                    end;
                }
                field("Report No."; Rec."Report No.")
                {
                    ApplicationArea = All;
                    Enabled = ReportNoEnable;
                }
                field("Export Type"; Rec."Export Type")
                {
                    ApplicationArea = All;
                    Enabled = ExportTypeEnable;
                }
                field("Export No."; Rec."Export No.")
                {
                    ApplicationArea = All;
                    Enabled = ExportNoEnable;
                }
                field("Verify Lines RIB"; Rec."Verify Lines RIB")
                {
                    ApplicationArea = All;
                }
                field("Verify Due Date"; Rec."Verify Due Date")
                {
                    ApplicationArea = All;
                }
                field("Source Code"; Rec."Source Code")
                {
                    ApplicationArea = All;
                    Enabled = SourceCodeEnable;
                }
                field("Reason Code"; Rec."Reason Code")
                {
                    ApplicationArea = All;
                    Enabled = ReasonCodeEnable;
                }
                field("Header Nos. Series"; Rec."Header Nos. Series")
                {
                    ApplicationArea = All;
                    Enabled = HeaderNosSeriesEnable;
                }
                field(Correction; Rec.Correction)
                {
                    ApplicationArea = All;
                    Enabled = CorrectionEnable;
                }
                field("Realize VAT"; Rec."Realize VAT")
                {
                    ApplicationArea = All;
                    Enabled = RealizeVATEnable;
                }
                field("Verify Header RIB"; Rec."Verify Header RIB")
                {
                    ApplicationArea = All;
                }
                field("Acceptation Code<>No"; Rec."Acceptation Code<>No")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Payment Step")
            {
                CaptionML = ENU = 'Payment Step', FRA = 'Étape règlement';
                Image = Installments;
                action(Ledger)
                {
                    ApplicationArea = All;
                    CaptionML = ENU = 'Ledger', FRA = 'Comptabilité';
                    Image = Ledger;
                    RunObject = Page "WDC-ED Pay. Step Ledger List";
                    RunPageLink = "Payment Class" = FIELD("Payment Class"),
                                  "Line No." = FIELD("Line No.");
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        DisableFields;
    end;

    trigger OnInit()
    begin
        CorrectionEnable := true;
        HeaderNosSeriesEnable := true;
        SourceCodeEnable := true;
        ReasonCodeEnable := true;
        ExportNoEnable := true;
        ExportTypeEnable := true;
        ReportNoEnable := true;
    end;

    procedure DisableFields()
    begin
        if Rec."Action Type" = Rec."Action Type"::None then begin
            ReportNoEnable := false;
            ExportTypeEnable := false;
            ExportNoEnable := false;
            ReasonCodeEnable := false;
            SourceCodeEnable := false;
            HeaderNosSeriesEnable := false;
            CorrectionEnable := false;
            RealizeVATEnable := false;
        end else
            if Rec."Action Type" = Rec."Action Type"::Ledger then begin
                ReportNoEnable := false;
                ExportTypeEnable := false;
                ExportNoEnable := false;
                ReasonCodeEnable := true;
                SourceCodeEnable := true;
                HeaderNosSeriesEnable := false;
                CorrectionEnable := true;
                PaymentClass.Get(Rec."Payment Class");
                RealizeVATEnable :=
                  (PaymentClass."Unrealized VAT Reversal" = PaymentClass."Unrealized VAT Reversal"::Delayed);
            end else
                if Rec."Action Type" = Rec."Action Type"::Report then begin
                    ReportNoEnable := true;
                    ExportTypeEnable := false;
                    ExportNoEnable := false;
                    ReasonCodeEnable := false;
                    SourceCodeEnable := false;
                    HeaderNosSeriesEnable := false;
                    CorrectionEnable := false;
                    RealizeVATEnable := false;
                end else
                    if Rec."Action Type" = Rec."Action Type"::File then begin
                        ReportNoEnable := false;
                        ExportTypeEnable := true;
                        ExportNoEnable := true;
                        ReasonCodeEnable := false;
                        SourceCodeEnable := false;
                        HeaderNosSeriesEnable := false;
                        CorrectionEnable := false;
                        RealizeVATEnable := false;
                    end else
                        if Rec."Action Type" = Rec."Action Type"::"Create New Document" then begin
                            ReportNoEnable := false;
                            ExportTypeEnable := false;
                            ExportNoEnable := false;
                            ReasonCodeEnable := false;
                            SourceCodeEnable := false;
                            HeaderNosSeriesEnable := true;
                            CorrectionEnable := false;
                            RealizeVATEnable := false;
                        end;
    end;

    var
        PaymentClass: Record "WDC-ED Payment Class";
        ReportNoEnable: Boolean;
        ExportTypeEnable: Boolean;
        ExportNoEnable: Boolean;
        ReasonCodeEnable: Boolean;
        SourceCodeEnable: Boolean;
        HeaderNosSeriesEnable: Boolean;
        CorrectionEnable: Boolean;
        RealizeVATEnable: Boolean;
}

