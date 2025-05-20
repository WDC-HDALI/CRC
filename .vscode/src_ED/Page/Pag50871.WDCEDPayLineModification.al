page 50871 "WDC-ED Pay. Line Modification"
{
    CaptionML = ENU = 'Payment Line Modification', FRA = 'Modification ligne règlement';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = "WDC-ED Payment Line";

    layout
    {
        area(content)
        {
            group(Control1)
            {
                ShowCaption = false;
                field("External Document No."; Rec."External Document No.")
                {
                    ApplicationArea = All;
                }
                field("Drawee Reference"; Rec."Drawee Reference")
                {
                    ApplicationArea = All;
                }
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = All;
                }
                field("Acceptation Code"; Rec."Acceptation Code")
                {
                    ApplicationArea = All;
                }
                field("Bank Account Code"; Rec."Bank Account Code")
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
                field("Bank Account No."; Rec."Bank Account No.")
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
    }

    trigger OnInit()
    begin
        CurrPage.LookupMode := true;
    end;
}

