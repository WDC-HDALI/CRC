tableextension 54021 "WDC-ST User Setup" extends "User Setup"
{

    fields
    {

        field(54001; "Default Expense Cashier"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Bank Account"."No.";
            CaptionML = ENU = 'Default Expense Cashier', FRA = 'Caisse dépense par défaut';
        }
        field(54002; "Default Recipe Box"; Code[20])
        {
            CaptionML = ENU = 'Default Recipe Box', FRA = 'Caisse recette par défaut';
            DataClassification = ToBeClassified;
            TableRelation = "Bank Account"."No.";
        }
        field(54003; "Payment Slip Profil"; Enum "WDC-ST Profil Payment Slip")
        {
            CaptionML = ENU = 'Payment Slip Profil', FRA = 'Profil Bordereau';
            DataClassification = ToBeClassified;
        }

    }




}

