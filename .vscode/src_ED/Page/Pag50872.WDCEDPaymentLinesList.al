page 50872 "WDC-ED Payment Lines List"
{
    CaptionML = ENU = 'Payment Lines List', FRA = 'Liste des lignes règlement';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "WDC-ED Payment Line";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                }
                field("Amount (LCY)"; Rec."Amount (LCY)")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Account Type"; Rec."Account Type")
                {
                    ApplicationArea = All;
                }
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = All;
                }
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = All;
                }
                field("Payment Class"; Rec."Payment Class")
                {
                    ApplicationArea = All;
                }
                field("Status Name"; Rec."Status Name")
                {
                    ApplicationArea = All;
                }
                field("Status No."; Rec."Status No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Acceptation Code"; Rec."Acceptation Code")
                {
                    ApplicationArea = All;
                }
                field("Drawee Reference"; Rec."Drawee Reference")
                {
                    ApplicationArea = All;
                }
                field("Bank Account Name"; Rec."Bank Account Name")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Bank Branch No."; Rec."Bank Branch No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Agency Code"; Rec."Agency Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(IBAN; Rec.IBAN)
                {
                    ApplicationArea = All;
                }
                field("SWIFT Code"; Rec."SWIFT Code")
                {
                    ApplicationArea = All;
                }
                field("Bank Account No."; Rec."Bank Account No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("RIB Key"; Rec."RIB Key")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Payment in Progress"; Rec."Payment in Progress")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("F&unctions")
            {
                CaptionML = ENU = '&Payment', FRA = '&Règlement';
                action(Card)
                {
                    ApplicationArea = All;
                    CaptionML = ENU = 'Card', FRA = 'Fiche';
                    Image = EditLines;
                    ShortCutKey = 'Shift+F7';

                    trigger OnAction()
                    var
                        Statement: Record "WDC-ED Payment Header";
                        StatementForm: Page "WDC-ED Payment Slip";
                    begin
                        if Statement.Get(Rec."No.") then begin
                            Statement.SetRange("No.", Rec."No.");
                            StatementForm.SetTableView(Statement);
                            StatementForm.Run;
                        end;
                    end;
                }
            }
        }
        area(processing)
        {
            group("F&unctions2")
            {
                CaptionML = ENU = 'F&unctions', FRA = 'Fonction&s';
                Image = "Action";
                action(Modify)
                {
                    ApplicationArea = All;
                    CaptionML = ENU = 'Modify', FRA = 'Modifier';
                    Image = EditFilter;

                    trigger OnAction()
                    var
                        PaymentLine: Record "WDC-ED Payment Line";
                        Consult: Page "WDC-ED Pay. Line Modification";
                    begin
                        PaymentLine.Copy(Rec);
                        PaymentLine.SetRange("No.", Rec."No.");
                        PaymentLine.SetRange("Line No.", Rec."Line No.");
                        Consult.SetTableView(PaymentLine);
                        Consult.RunModal;
                    end;
                }
            }
        }
    }

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if CloseAction = ACTION::LookupOK then
            LookupOKOnPush;
    end;

    procedure SetSteps(Step: Integer)
    begin
        Steps := Step;
    end;

    procedure SetNumBor(N: Code[20])
    begin
        PayNum := N;
    end;

    procedure GetNumBor() N: Code[20]
    begin
        N := PayNum;
    end;

    local procedure LookupOKOnPush()
    var
        StatementLine: Record "WDC-ED Payment Line";
        PostingStatement: Codeunit "WDC-ED Payment Management";
    begin
        CurrPage.SetSelectionFilter(StatementLine);
        PostingStatement.CopyLigBor(StatementLine, Steps, PayNum);
        CurrPage.Close;
    end;

    var
        Steps: Integer;
        PayNum: Code[20];
}

