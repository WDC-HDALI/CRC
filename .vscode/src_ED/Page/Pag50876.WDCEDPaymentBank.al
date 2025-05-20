page 50876 "WDC-ED Payment Bank"
{
    CaptionML = ENU = 'Bank Account Card', FRA = 'Fiche compte bancaire';
    PageType = Card;
    SourceTable = "WDC-ED Payment Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                CaptionML = ENU = 'General', FRA = 'Général';
                field("Bank Name"; Rec."Bank Name")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
                field("Bank Address"; Rec."Bank Address")
                {
                    ApplicationArea = All;
                }
                field("Bank Address 2"; Rec."Bank Address 2")
                {
                    ApplicationArea = All;
                }
                field("Bank Post Code"; Rec."Bank Post Code")
                {
                    ApplicationArea = All;
                }
                field("Bank City"; Rec."Bank City")
                {
                    ApplicationArea = All;
                }
                field("Bank Country/Region Code"; Rec."Bank Country/Region Code")
                {
                    ApplicationArea = All;
                }
                field("Bank Contact"; Rec."Bank Contact")
                {
                    ApplicationArea = All;
                }
                field("Bank Branch No."; Rec."Bank Branch No.")
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
            }
            group("R.I.B.")
            {
                CaptionML = ENU = 'R.I.B.', FRA = 'R.I.B.';
                field("Bank Branch No.2"; Rec."Bank Branch No.")
                {
                    ApplicationArea = All;
                }
                field("Agency Code"; Rec."Agency Code")
                {
                    ApplicationArea = All;
                }
                field("Bank Account No.2"; Rec."Bank Account No.")
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
                field("National Issuer No."; Rec."National Issuer No.")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}

