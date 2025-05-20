page 50869 "WDC-ED Payment Slip Subform"
{
    AutoSplitKey = true;
    CaptionML = ENU = 'Lines', FRA = 'Lignes';
    DelayedInsert = true;
    PageType = ListPart;
    SourceTable = "WDC-ED Payment Line";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Account Type"; Rec."Account Type")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        BankInfoEditable := IsBankInfoEditable;
                    end;
                }
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = All;
                    Style = Strong;
                    StyleExpr = AccountNoEmphasize;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                }
                field("External Document No."; Rec."External Document No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Drawee Reference"; Rec."Drawee Reference")
                {
                    ApplicationArea = All;
                }
                field("Posting Group"; Rec."Posting Group")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = All;
                }
                field("Debit Amount"; Rec."Debit Amount")
                {
                    ApplicationArea = All;
                    Visible = DebitAmountVisible;
                }
                field("Credit Amount"; Rec."Credit Amount")
                {
                    ApplicationArea = All;
                    Visible = CreditAmountVisible;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    Visible = AmountVisible;
                }
                field(IBAN; Rec.IBAN)
                {
                    ApplicationArea = All;
                    Editable = BankInfoEditable;
                }
                field("SWIFT Code"; Rec."SWIFT Code")
                {
                    ApplicationArea = All;
                    Editable = BankInfoEditable;
                }
                field("Bank Account Code"; Rec."Bank Account Code")
                {
                    ApplicationArea = All;
                    Visible = BankAccountCodeVisible;
                }
                field("Acceptation Code"; Rec."Acceptation Code")
                {
                    ApplicationArea = All;
                    Visible = AcceptationCodeVisible;
                }
                field("Payment Address Code"; Rec."Payment Address Code")
                {
                    ApplicationArea = All;
                }
                field("Bank Branch No."; Rec."Bank Branch No.")
                {
                    ApplicationArea = All;
                    Editable = BankInfoEditable;
                    Visible = RIBVisible;
                }
                field("Agency Code"; Rec."Agency Code")
                {
                    ApplicationArea = All;
                    Editable = BankInfoEditable;
                    Visible = RIBVisible;
                }
                field("Bank Account No."; Rec."Bank Account No.")
                {
                    ApplicationArea = All;
                    Editable = BankInfoEditable;
                    Visible = RIBVisible;
                }
                field("Bank Account Name"; Rec."Bank Account Name")
                {
                    ApplicationArea = All;
                    Editable = BankInfoEditable;
                    Visible = RIBVisible;
                }
                field("Bank City"; Rec."Bank City")
                {
                    ApplicationArea = All;
                    Editable = BankInfoEditable;
                    Visible = false;
                }
                field("RIB Key"; Rec."RIB Key")
                {
                    ApplicationArea = All;
                    Editable = BankInfoEditable;
                    Visible = RIBVisible;
                }
                field("RIB Checked"; Rec."RIB Checked")
                {
                    ApplicationArea = All;
                    Visible = RIBVisible;
                }
                field("Has Payment Export Error"; Rec."Has Payment Export Error")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("F&unctions")
            {
                CaptionML = ENU = 'F&unctions', FRA = 'Fonction&s';
                Image = "Action";
                action("Set Document ID")
                {
                    ApplicationArea = All;
                    CaptionML = ENU = 'Set Document ID', FRA = 'Attribuer n° document';

                    trigger OnAction()
                    begin
                        SetDocumentID;
                    end;
                }
            }
            group("&Line")
            {
                CaptionML = ENU = '&Line', FRA = '&Ligne';
                Image = Line;
                action(Application)
                {
                    ApplicationArea = All;
                    CaptionML = ENU = '&Application', FRA = 'Lettr&age';
                    ShortCutKey = 'Shift+F11';

                    trigger OnAction()
                    begin
                        ApplyPayment();
                    end;
                }
                action(Dimensions)
                {
                    ApplicationArea = All;
                    CaptionML = ENU = 'Dimensions', FRA = 'Axes analytiques';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';

                    trigger OnAction()
                    begin
                        Rec.ShowDimensions;
                    end;
                }
                action(Modify)
                {
                    ApplicationArea = All;
                    CaptionML = ENU = 'Modify', FRA = 'Modifier';
                    Image = EditFilter;

                    trigger OnAction()
                    begin
                        OnModify;
                    end;
                }
                action(Insert)
                {
                    ApplicationArea = All;
                    CaptionML = ENU = 'Insert', FRA = 'Insertion';

                    trigger OnAction()
                    begin
                        OnInsert;
                    end;
                }
                action(Remove)
                {
                    ApplicationArea = All;
                    CaptionML = ENU = 'Remove', FRA = 'Supprimer';
                    Image = Cancel;

                    trigger OnAction()
                    begin
                        OnDelete;
                    end;
                }
                group("A&ccount")
                {
                    CaptionML = ENU = 'A&ccount', FRA = '&Compte';
                    Image = ChartOfAccounts;
                    action(Card)
                    {
                        ApplicationArea = All;
                        CaptionML = ENU = 'Card', FRA = 'Fiche';
                        Image = EditLines;
                        ShortCutKey = 'Shift+F7';

                        trigger OnAction()
                        begin
                            ShowAccount;
                        end;
                    }
                    action("Ledger E&ntries")
                    {
                        ApplicationArea = All;
                        CaptionML = ENU = 'Ledger E&ntries', FRA = 'É&critures comptables';
                        ShortCutKey = 'Ctrl+F7';

                        trigger OnAction()
                        begin
                            ShowEntries;
                        end;
                    }
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        ActivateControls;
        BankInfoEditable := IsBankInfoEditable;
        AccountNoEmphasize := Rec."Copied To No." <> '';
    end;

    trigger OnInit()
    begin
        BankAccountCodeVisible := true;
        CreditAmountVisible := true;
        DebitAmountVisible := true;
        AmountVisible := true;
        AcceptationCodeVisible := true;
        RIBVisible := true;
    end;

    trigger OnAfterGetCurrRecord()
    begin
        // rec."Account Type" := AccType;
        // CurrPage.Update(true);
    end;

    // trigger (Steps: Integer): Integer
    // var
    //     paymentheader: Record "WDC-ED Payment Header";
    // begin
    //     if paymentheader.Get(rec."No.") then
    //         Rec."Account Type" := paymentheader.Suggestions;
    //     CurrPage.Update();
    // end;

    local procedure ApplyPayment()
    begin
        CODEUNIT.Run(CODEUNIT::"WDc-ED Payment-Apply", Rec);
    end;

    local procedure DisableFields()
    begin
        if Header.Get(Rec."No.") then
            CurrPage.Editable((Header."Status No." = 0) and (Rec."Copied To No." = ''));
    end;

    local procedure OnModify()
    var
        PaymentLine: Record "WDC-ED Payment Line";
        PaymentModification: Page "WDC-ED Pay. Line Modification";
    begin
        if Rec."Line No." = 0 then
            Message(Text001)
        else
            if not Rec.Posted then begin
                PaymentLine.Copy(Rec);
                PaymentLine.SetRange("No.", Rec."No.");
                PaymentLine.SetRange("Line No.", Rec."Line No.");
                PaymentModification.SetTableView(PaymentLine);
                PaymentModification.RunModal;
            end else
                Message(Text002);
    end;

    local procedure OnInsert()
    var
        PaymentManagement: Codeunit "WDC-ED Payment Management";
    begin
        PaymentManagement.LinesInsert(Rec."No.");
    end;

    local procedure OnDelete()
    var
        StatementLine: Record "WDC-ED Payment Line";
        PostingStatement: Codeunit "WDC-ED Payment Management";
    begin
        StatementLine.Copy(Rec);
        CurrPage.SetSelectionFilter(StatementLine);
        PostingStatement.DeleteLigBorCopy(StatementLine);
    end;

    local procedure SetDocumentID()
    var
        StatementLine: Record "WDC-ED Payment Line";
        PostingStatement: Codeunit "WDC-ED Payment Management";
        No: Code[20];
    begin
        if Rec."Status No." <> 0 then begin
            Message(Text003);
            exit;
        end;
        if Confirm(Text000) then begin
            CurrPage.SetSelectionFilter(StatementLine);
            StatementLine.MarkedOnly(true);
            if not StatementLine.FindSet() then
                StatementLine.MarkedOnly(false);
            if StatementLine.FindSet() then begin
                No := StatementLine."Document No.";
                while StatementLine.Next <> 0 do begin
                    PostingStatement.IncrementNoText(No, 1);
                    StatementLine."Document No." := No;
                    StatementLine.Modify();
                end;
            end;
        end;
    end;

    local procedure ShowAccount()
    var
        GenJnlLine: Record "Gen. Journal Line";
    begin
        GenJnlLine."Account Type" := Rec."Account Type";
        GenJnlLine."Account No." := Rec."Account No.";
        CODEUNIT.Run(CODEUNIT::"Gen. Jnl.-Show Card", GenJnlLine);
    end;

    local procedure ShowEntries()
    var
        GenJnlLine: Record "Gen. Journal Line";
    begin
        GenJnlLine."Account Type" := Rec."Account Type";
        GenJnlLine."Account No." := Rec."Account No.";
        CODEUNIT.Run(CODEUNIT::"Gen. Jnl.-Show Entries", GenJnlLine);
    end;

    procedure MarkLines(ToMark: Boolean)
    var
        LineCopy: Record "WDC-ED Payment Line";
        NumLines: Integer;
    begin
        if ToMark then begin
            CurrPage.SetSelectionFilter(LineCopy);
            NumLines := LineCopy.Count();
            if NumLines > 0 then begin
                LineCopy.FindSet();
                repeat
                    LineCopy.Marked := true;
                    LineCopy.Modify();
                until LineCopy.Next = 0;
            end else
                LineCopy.Reset();
            LineCopy.SetRange("No.", Rec."No.");
            LineCopy.ModifyAll(Marked, true);
        end else begin
            LineCopy.SetRange("No.", Rec."No.");
            LineCopy.ModifyAll(Marked, false);
        end;
        Commit();
    end;

    local procedure ActivateControls()
    begin
        if Header.Get(Rec."No.") then begin
            Status.Get(Header."Payment Class", Header."Status No.");
            RIBVisible := Status.RIB;
            AcceptationCodeVisible := Status."Acceptation Code";
            AmountVisible := Status.Amount;
            DebitAmountVisible := Status.Debit;
            CreditAmountVisible := Status.Credit;
            BankAccountCodeVisible := Status."Bank Account";
            DisableFields;
        end;
    end;

    procedure NavigateLine(PostingDate: Date)
    begin
        Navigate.SetDoc(PostingDate, Rec."Document No.");
        Navigate.Run;
    end;

    local procedure IsBankInfoEditable(): Boolean
    begin
        exit(not (Rec."Account Type" in [Rec."Account Type"::Customer, Rec."Account Type"::Vendor]));
    end;

    procedure SetAccountType(pAccType: Enum "Gen. Journal Account Type")
    begin
        Rec."Account Type" := pAccType;
        CurrPage.Update(true);
        //CurrPage.SaveRecord();

    end;

    var
        AccType: Enum "Gen. Journal Account Type";
        Header: Record "WDC-ED Payment Header";
        Status: Record "WDC-ED Payment Status";
        Navigate: Page Navigate;
        AccountNoEmphasize: Boolean;
        AcceptationCodeVisible: Boolean;
        AmountVisible: Boolean;
        BankAccountCodeVisible: Boolean;
        BankInfoEditable: Boolean;
        CreditAmountVisible: Boolean;
        DebitAmountVisible: Boolean;
        RIBVisible: Boolean;
        Text000: TextConst ENU = 'Assign No. ?',
                           FRA = 'Affectation des n° ?';
        Text001: TextConst ENU = 'There is no line to modify.',
                           FRA = 'Il n''y a pas de ligne à modifier.';
        Text002: TextConst ENU = 'A posted line cannot be modified.',
                           FRA = 'Une ligne validée ne peut pas être modifiée.';
        Text003: TextConst ENU = 'You cannot assign numbers to a posted header.',
                           FRA = 'Vous ne pouvez pas affecter de numéros à un bordereau validé.';
}

