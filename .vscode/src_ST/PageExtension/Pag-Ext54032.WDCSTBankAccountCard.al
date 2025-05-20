pageextension 54032 "WDC-ST Bank Account Card" extends "Bank Account Card"
{
    layout
    {
        addafter(Blocked)
        {
            field("Source Code"; Rec."Source Code")
            {
                ApplicationArea = All;
            }

            field("Modèle chèques"; Rec."Modèle chèques")
            {
                ApplicationArea = All;
            }
            field("Nb Lines Deposit Pay. Slip"; Rec."Nb Lines Deposit Pay. Slip")
            {
                ApplicationArea = All;
            }

        }
    }


}