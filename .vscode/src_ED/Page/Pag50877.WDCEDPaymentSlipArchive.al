page 50877 "WDC-ED Payment Slip Archive"
{
    CaptionML = ENU = 'Payment Slip Archive', FRA = 'Archives bordereau paiement';
    Editable = false;
    PageType = Document;
    SourceTable = "WDC-ED Payment Header Archive";

    layout
    {
        area(content)
        {
            group(General)
            {
                CaptionML = ENU = 'General', FRA = 'Général';
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    AssistEdit = false;
                }
                field("Payment Class"; Rec."Payment Class")
                {
                    ApplicationArea = All;
                    Lookup = false;
                }
                field("Payment Class Name"; Rec."Payment Class Name")
                {
                    ApplicationArea = All;
                    DrillDown = false;
                    Importance = Promoted;
                }
                field("Status Name"; Rec."Status Name")
                {
                    ApplicationArea = All;
                    DrillDown = false;
                    Importance = Promoted;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        DocumentDateOnAfterValidate;
                    end;
                }
                field("Amount (LCY)"; Rec."Amount (LCY)")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
            }
            part(Lines; "WDC-ED Pay. Slip Sub. Archive")
            {
                ApplicationArea = All;
                SubPageLink = "No." = FIELD("No.");
            }
            group(Posting)
            {
                CaptionML = ENU = 'Posting', FRA = 'Validation';
                field("Source Code"; Rec."Source Code")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
                }
                field("Account Type"; Rec."Account Type")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Header")
            {
                CaptionML = ENU = '&Header', FRA = '&Bordereau';
                Image = DepositSlip;
                action(Dimensions)
                {
                    ApplicationArea = All;
                    CaptionML = ENU = 'Dimensions', FRA = 'Axes analytiques';
                    Image = Dimensions;

                    trigger OnAction()
                    begin
                        Rec.ShowDimensions;
                    end;
                }
                action("Header RIB")
                {
                    ApplicationArea = All;
                    CaptionML = ENU = 'Header RIB', FRA = 'Relevé d''identité bancaire';
                    Image = Check;
                    RunObject = Page "WDC-ED Payment Bank Archive";
                    RunPageLink = "No." = FIELD("No.");
                }
            }
            group("&Navigate")
            {
                CaptionML = ENU = '&Navigate', FRA = 'Navi&guer';
                action(Header)
                {
                    ApplicationArea = All;
                    CaptionML = ENU = 'Header', FRA = 'En-tête';
                    Image = DepositSlip;

                    trigger OnAction()
                    begin
                        Navigate.SetDoc(Rec."Posting Date", Rec."No.");
                        Navigate.Run;
                    end;
                }
                action(Line)
                {
                    ApplicationArea = All;
                    CaptionML = ENU = 'Line', FRA = 'Ligne';
                    Image = Line;

                    trigger OnAction()
                    begin
                        CurrPage.Lines.PAGE.NavigateLine(Rec."Posting Date");
                    end;
                }
            }
        }
    }

    local procedure DocumentDateOnAfterValidate()
    begin
        CurrPage.Update;
    end;

    var
        Navigate: Page Navigate;
}

