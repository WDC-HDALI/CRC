namespace CRC.CRC;

using Microsoft.Finance.GeneralLedger.Setup;
//****************Documentation*******************************
//WDC01 WDC.HG  09/06/2025  Create Current object 

pageextension 50030 "WDC General Ledger Setup" extends "General Ledger Setup"
{
    layout
    {
        addlast(content)
        {
            group("Sheet Name")
            {
                CaptionML = ENU = 'Journal Name', FRA = 'Nom feuilles';
                field("Check Slip Sheet"; Rec."Check Slip Sheet")
                {
                    ApplicationArea = all;
                }
                field("Bank Draft Slip Sheet"; Rec."Bank Draft Slip Sheet")
                {
                    ApplicationArea = all;
                }
                field("Payment Sheet"; Rec."Payment Sheet")
                {
                    ApplicationArea = all;
                }

            }


        }
        addafter("LCY Code")
        {
            field("Go Live Date"; Rec."Go Live Date")
            {
                ApplicationArea = all;
            }
        }
    }

}
