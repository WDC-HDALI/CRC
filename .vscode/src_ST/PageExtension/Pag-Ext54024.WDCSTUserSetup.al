pageextension 54024 "WDC-ST User Setup" extends "User Setup"
{

    layout
    {
        addafter(Email)
        {
            field("caisse-Depense-par defaut"; Rec."Default Expense Cashier")
            {
                ApplicationArea = All;
            }
            field("Default Recipe Box"; Rec."Default Recipe Box")
            {
                ApplicationArea = All;

            }
            field("Payment Slip Profil"; Rec."Payment Slip Profil")
            {
                ApplicationArea = All;

            }
        }
    }
}





