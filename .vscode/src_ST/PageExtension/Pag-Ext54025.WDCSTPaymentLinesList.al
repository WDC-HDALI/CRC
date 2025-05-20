pageextension 54025 "WDC-ST Payment Lines List" extends "WDC-ED Payment Lines List"
{
    layout
    {
        addafter("Acceptation Code")
        {

            field("Copied To No."; Rec."Copied To No.")
            {
                ApplicationArea = all;
            }
            field("Payment Label"; Rec."Payment Label")
            {
                ApplicationArea = all;
            }
            field("External Document No."; Rec."External Document No.")
            {
                ApplicationArea = all;
            }

            field("Created from No."; Rec."Created from No.")
            {
                ApplicationArea = all;
            }
            field("Bank Account Code"; Rec."Bank Account Code")
            {
                ApplicationArea = all;
            }
            field("Drawer/Beneficiary"; Rec."Drawer/Beneficiary")
            {
                ApplicationArea = all;
            }
            field("RS Amount"; Rec."RS Amount")
            {
                ApplicationArea = all;
            }
            field("Validated RS Amount"; Rec."Validated RS Amount")
            {
                ApplicationArea = all;
            }
            field("RS VAT Amount"; Rec."RS VAT Amount")
            {
                ApplicationArea = all;
            }
            field("Validated RS VAT Amount"; Rec."Validated RS VAT Amount")
            {
                ApplicationArea = all;
            }

            field("Commission Amount"; Rec."Commission Amount")
            {
                ApplicationArea = all;
            }
        }
    }

    var
        UserSetup: Record 91;







}

