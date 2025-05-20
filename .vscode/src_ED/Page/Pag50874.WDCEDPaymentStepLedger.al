page 50874 "WDC-ED Payment Step Ledger"
{
    CaptionML = ENU = 'Payment Step Ledger', FRA = 'Etape règlement : Comptabilisation';
    PageType = Card;
    SourceTable = "WDC-ED Payment Step Ledger";

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
                    Enabled = false;
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    Enabled = false;
                }
                field(Sign; Rec.Sign)
                {
                    ApplicationArea = All;
                    Enabled = SignEnable;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Accounting Type"; Rec."Accounting Type")
                {
                    ApplicationArea = All;
                    Enabled = AccountingTypeEnable;

                    trigger OnValidate()
                    begin
                        DisableFields;
                    end;
                }
                field("Account Type"; Rec."Account Type")
                {
                    ApplicationArea = All;
                    Enabled = AccountTypeEnable;

                    trigger OnValidate()
                    begin
                        DisableFields;
                    end;
                }
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = All;
                    Enabled = AccountNoEnable;

                    trigger OnValidate()
                    begin
                        DisableFields;
                    end;
                }
                field("Customer Posting Group"; Rec."Customer Posting Group")
                {
                    ApplicationArea = All;
                    Enabled = CustomerPostingGroupEnable;

                    trigger OnValidate()
                    begin
                        DisableFields;
                    end;
                }
                field("Vendor Posting Group"; Rec."Vendor Posting Group")
                {
                    ApplicationArea = All;
                    Enabled = VendorPostingGroupEnable;

                    trigger OnValidate()
                    begin
                        DisableFields;
                    end;
                }
                field(Root; Rec.Root)
                {
                    ApplicationArea = All;
                    Enabled = RootEnable;

                    trigger OnValidate()
                    begin
                        DisableFields;
                    end;
                }
                field("Memorize Entry"; Rec."Memorize Entry")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        DisableFields;
                    end;
                }
                field(Application; Rec.Application)
                {
                    ApplicationArea = All;
                    Enabled = ApplicationEnable;

                    trigger OnValidate()
                    begin
                        DisableFields;
                    end;
                }
                field("Detail Level"; Rec."Detail Level")
                {
                    ApplicationArea = All;
                    Enabled = DetailLevelEnable;

                    trigger OnValidate()
                    begin
                        DisableFields;
                    end;
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        DisableFields;
    end;

    trigger OnInit()
    begin
        DetailLevelEnable := true;
        RootEnable := true;
        VendorPostingGroupEnable := true;
        CustomerPostingGroupEnable := true;
        AccountNoEnable := true;
        AccountTypeEnable := true;
        ApplicationEnable := true;
        SignEnable := true;
        AccountingTypeEnable := true;
    end;

    procedure DisableFields()
    begin
        AccountingTypeEnable := true;
        SignEnable := true;
        ApplicationEnable := true;
        if Rec."Accounting Type" = Rec."Accounting Type"::"Setup Account" then begin
            AccountTypeEnable := true;
            AccountNoEnable := true;
            if Rec."Account Type" = Rec."Account Type"::Customer then begin
                CustomerPostingGroupEnable := true;
                VendorPostingGroupEnable := false;
            end else
                if Rec."Account Type" = Rec."Account Type"::Vendor then begin
                    CustomerPostingGroupEnable := false;
                    VendorPostingGroupEnable := true;
                end else begin
                    CustomerPostingGroupEnable := false;
                    VendorPostingGroupEnable := false;
                end;
            RootEnable := false;
        end else begin
            AccountTypeEnable := false;
            AccountNoEnable := false;
            if Rec."Accounting Type" in [Rec."Accounting Type"::"G/L Account / Month", Rec."Accounting Type"::"G/L Account / Week"] then begin
                RootEnable := true;
                CustomerPostingGroupEnable := false;
                VendorPostingGroupEnable := false;
            end else begin
                RootEnable := false;
                CustomerPostingGroupEnable := true;
                VendorPostingGroupEnable := true;
            end;
        end;
        if Rec."Accounting Type" = Rec."Accounting Type"::"Bal. Account Previous Entry" then begin
            CustomerPostingGroupEnable := false;
            VendorPostingGroupEnable := false;
        end;
        if Rec."Memorize Entry" or (Rec.Application <> Rec.Application::None) then begin
            Rec."Detail Level" := Rec."Detail Level"::Line;
            DetailLevelEnable := false;
        end else
            DetailLevelEnable := true;
    end;

    var
        AccountingTypeEnable: Boolean;
        SignEnable: Boolean;
        ApplicationEnable: Boolean;
        AccountTypeEnable: Boolean;
        AccountNoEnable: Boolean;
        CustomerPostingGroupEnable: Boolean;
        VendorPostingGroupEnable: Boolean;
        RootEnable: Boolean;
        DetailLevelEnable: Boolean;
}

