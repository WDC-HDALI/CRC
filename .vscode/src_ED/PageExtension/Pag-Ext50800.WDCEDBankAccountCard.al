pageextension 50800 "WDC-ED Bank Account Card" extends "Bank Account Card"
{
    layout
    {
        addafter(Transfer)
        {
            group(" R.I.B")
            {
                CaptionML = ENU = ' R.I.B', FRA = 'R.I.B';
                field("Bank Branch No.3"; Rec."Bank Branch No.")
                {
                    ApplicationArea = All;
                }
                field("Agency Code"; Rec."Agency Code")
                {
                    ApplicationArea = All;
                }
                field("Bank Account No.3"; Rec."Bank Account No.")
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
}