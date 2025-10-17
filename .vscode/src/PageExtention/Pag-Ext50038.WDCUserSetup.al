//****************Documentation**********************
//wdc01  WDC.FS  18/06/2025 create WDC User Setup 
pageextension 50038 "WDC User Setup" extends "User Setup"
{
    layout
    {
        addafter("User ID")
        {
            field("Display Purchase Cost"; Rec."Display Purchase Cost")
            {
                ApplicationArea = all;
            }
            field("Modify Sales Prices"; Rec."Modify Sales Prices")
            {
                ApplicationArea = all;
            }
            field("View Sales Margin"; Rec."View Sales Margin")
            {
                ApplicationArea = all;
            }
            field("Allow Modify Customer"; Rec."Allow Modify Customer")
            {
                ApplicationArea = all;
            }
            field("Allow Modify Item"; Rec."Allow Modify Item")
            {
                ApplicationArea = all;
            }
            field("Allow Modify Vendor"; Rec."Allow Modify Vendor")
            {
                ApplicationArea = all;
            }
            field("Allow Delete sales Invoice"; Rec."Allow Delete sales Invoice")
            {
                ApplicationArea = all;
            }
            field("Allow Delete sales cr memo"; Rec."Allow Delete sales cr memo")
            {
                ApplicationArea = all;
            }
            field("Allow Upd Sales Posting Date"; Rec."Allow Upd Sales Posting Date")
            {
                ApplicationArea = all;
            }
            field("See Payment Posting Date"; Rec."See Payment Posting Date")
            {
                ApplicationArea = all;
            }
            field("Use REGLEMENT Pay. Journ."; Rec."Use REGLEMENT Pay. Journ.")
            {
                ApplicationArea = all;
            }
        }
    }
}