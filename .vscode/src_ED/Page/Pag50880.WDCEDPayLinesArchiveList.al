page 50880 "WDC-ED Pay. Lines Archive List"
{
    CaptionML = ENU = 'Payment Lines Archive List', FRA = 'Liste lignes règlements archivés';
    Editable = false;
    PageType = List;
    SourceTable = "WDC-ED Payment Line Archive";

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
                field("SWIFT Code"; Rec."SWIFT Code")
                {
                    ApplicationArea = All;
                }
                field(IBAN; Rec.IBAN)
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
            group(Functions)
            {
                CaptionML = ENU = '&Payment', FRA = 'Règlement';
                action(Card)
                {
                    ApplicationArea = All;
                    CaptionML = ENU = 'Card', FRA = 'Fiche';
                    Image = EditLines;
                    ShortCutKey = 'Shift+F7';

                    trigger OnAction()
                    var
                        Statement: Record "WDC-ED Payment Header Archive";
                        StatementForm: Page "WDC-ED Payment Slip Archive";
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
    }
}

