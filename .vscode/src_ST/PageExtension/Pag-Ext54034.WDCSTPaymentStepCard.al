pageextension 54034 "WDC-ST Payment Step Card" extends "WDC-ED Payment Step Card"
{
    layout
    {
        addafter("Acceptation Code<>No")
        {
            field("Mandatory Header Bank"; Rec."Mandatory Header Bank")
            {
                ApplicationArea = All;
            }
            field("Code_Motif_Obligatoire"; Rec."Mandatory Reason Code")
            {
                ApplicationArea = All;
            }
            field("Cash Balance Check"; Rec."Cash Balance Check")
            {
                ApplicationArea = All;
            }
            field("Mandatory Ext. Doc No."; Rec."Mandatory Ext. Doc No.")
            {
                ApplicationArea = All;
            }
            field("Mandatory Bank Line"; Rec."Mandatory Bank Line")
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

            field("Origin Payment Slip"; Rec."Origin Payment Slip")
            {
                ApplicationArea = All;

            }

        }
    }
}