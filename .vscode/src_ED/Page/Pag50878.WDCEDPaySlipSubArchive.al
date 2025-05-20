page 50878 "WDC-ED Pay. Slip Sub. Archive"
{
    CaptionML = ENU = 'Lines', FRA = 'Lignes';
    Editable = false;
    PageType = ListPart;
    SourceTable = "WDC-ED Payment Line Archive";

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
                }
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = All;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                }
                field("External Document No."; Rec."External Document No.")
                {
                    ApplicationArea = All;
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
                }
                field("Credit Amount"; Rec."Credit Amount")
                {
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                }
                field("Bank Account Code"; Rec."Bank Account Code")
                {
                    ApplicationArea = All;
                }
                field("Acceptation Code"; Rec."Acceptation Code")
                {
                    ApplicationArea = All;
                }
                field("Payment Address Code"; Rec."Payment Address Code")
                {
                    ApplicationArea = All;
                }
                field("Bank Branch No."; Rec."Bank Branch No.")
                {
                    ApplicationArea = All;
                }
                field("Agency Code"; Rec."Agency Code")
                {
                    ApplicationArea = All;
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
                }
                field("Bank Account Name"; Rec."Bank Account Name")
                {
                    ApplicationArea = All;
                }
                field("Bank City"; Rec."Bank City")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("RIB Key"; Rec."RIB Key")
                {
                    ApplicationArea = All;
                }
                field("RIB Checked"; Rec."RIB Checked")
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
            group("&Line")
            {
                CaptionML = ENU = '&Line', FRA = '&Ligne';
                Image = Line;
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
            }
        }
    }

    procedure ShowAccount()
    var
        GenJnlLine: Record "Gen. Journal Line";
    begin
        GenJnlLine."Account Type" := Rec."Account Type";
        GenJnlLine."Account No." := Rec."Account No.";
        CODEUNIT.Run(CODEUNIT::"Gen. Jnl.-Show Card", GenJnlLine);
    end;

    procedure ShowEntries()
    var
        GenJnlLine: Record "Gen. Journal Line";
    begin
        GenJnlLine."Account Type" := Rec."Account Type";
        GenJnlLine."Account No." := Rec."Account No.";
        CODEUNIT.Run(CODEUNIT::"Gen. Jnl.-Show Entries", GenJnlLine);
    end;

    procedure NavigateLine(PostingDate: Date)
    begin
        Navigate.SetDoc(PostingDate, Rec."Document No.");
        Navigate.Run;
    end;

    var
        Navigate: Page Navigate;
}

