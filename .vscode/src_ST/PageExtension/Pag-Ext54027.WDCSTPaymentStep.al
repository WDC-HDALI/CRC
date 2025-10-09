pageextension 54027 "WDC-ST Payment Step" Extends "WDC-ED Payment Steps"
{

    layout
    {
        addlast(Control1)
        {
            field("Mandatory Ext. Doc No."; Rec."Mandatory Ext. Doc No.")
            {
                ApplicationArea = All;
            }
            field("Payment No. Required"; Rec."Payment No. Required")
            {
                ApplicationArea = All;
            }
            field("Comment Required"; Rec."Comment Required")
            {
                ApplicationArea = All;
            }
            field("Mandatory Drawer"; Rec."Mandatory Drawer")
            {
                ApplicationArea = All;
            }
            field("Mandatory Draw"; Rec."Mandatory Draw")
            {
                ApplicationArea = All;
            }
            field("Motif Obligatoire"; Rec."Mandatory Reason Code")
            {
                ApplicationArea = All;
            }
            field("Mandatory Bank Line"; Rec."Mandatory Bank Line")
            {
                ApplicationArea = All;
            }
            field("Mandatory Header Bank"; Rec."Mandatory Header Bank")
            {
                ApplicationArea = All;
            }
        }


    }

}
