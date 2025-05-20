pageextension 54029 "WDC-ST Payment Class" Extends "WDC-ED Payment Class"
{

    layout
    {
        addbefore("Header No. Series")
        {
            field("Header Account Type"; Rec."Header Account Type")
            {
                ApplicationArea = All;
            }
            field("ED Type"; Rec."ED Type")
            {
                ApplicationArea = All;
            }
            field("Payment Methode Type"; Rec."Payment Methode Type")
            {
                ApplicationArea = All;
            }
        }
        addlast(Control1)
        {
            field("Small expense"; Rec."Small expense")
            {
                ApplicationArea = All;
            }

            field("Default Caisse"; Rec."Default Caisse")
            {
                ApplicationArea = All;
            }
            field("Line Account Type"; Rec."Line Account Type")
            {
                ApplicationArea = All;
            }
            field(Observation; Rec.Observation)
            {
                ApplicationArea = All;
            }
        }


    }





}
