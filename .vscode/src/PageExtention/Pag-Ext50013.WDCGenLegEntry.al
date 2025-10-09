//***************Documentation*********************
//WDC01  WDC.HG  30/05/2025  Show New Fields 

pageextension 50013 "WDC GenLegEntry" extends "General Ledger Entries"
{
    layout
    {
        addafter(Description)
        {
            field("Initial Date"; Rec."Initial Date")
            {
                ApplicationArea = All;
            }
            field("Initial Document No."; Rec."Initial Document No.")
            {
                ApplicationArea = All;
            }
            field(Lettrage; Rec.Lettrage)
            {
                ApplicationArea = All;
            }
            //<<WDC01
            field("Cheque No."; Rec."Cheque No.")
            {
                ApplicationArea = All;
            }
            field("Initial Payment No."; Rec."Initial Payment No.")
            {
                ApplicationArea = All;
            }
            //>>WDC01

        }

    }

    actions
    {

    }
}