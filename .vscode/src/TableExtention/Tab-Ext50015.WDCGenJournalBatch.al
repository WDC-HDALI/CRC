
//***************Documentation********************
//WDC01  WDC.HG  24/07/2025  ADD "Payment Method Code"  field 
Tableextension 50015 "WDC Gen. Journal Batch" extends 232
{
    fields
    {
        field(50001; "Account Type"; Enum "Gen. Journal Account Type")
        {
            trigger OnValidate()
            begin
                if ("Account Type" in ["Account Type"::Customer, "Account Type"::Vendor, "Account Type"::"Fixed Asset",
                                       "Account Type"::"IC Partner", "Account Type"::Employee]) and
                   ("Bal. Account Type" in ["Bal. Account Type"::Customer, "Bal. Account Type"::Vendor, "Bal. Account Type"::"Fixed Asset",
                                            "Bal. Account Type"::"IC Partner", "Bal. Account Type"::Employee])
                then
                    Error(
                      'Only the %1 field can be filled in on recurring journals.',
                      FieldCaption("Account Type"), FieldCaption("Bal. Account Type"));
            end;
        }
        field(50002; "Account No."; Code[20])
        {
            Caption = 'Account No.';
            TableRelation = IF ("Account Type" = CONST("G/L Account")) "G/L Account" WHERE("Account Type" = CONST(Posting),
                                                                                          Blocked = CONST(false))
            ELSE
            IF ("Account Type" = CONST(Customer)) Customer
            ELSE
            IF ("Account Type" = CONST(Vendor)) Vendor
            ELSE
            IF ("Account Type" = CONST("Bank Account")) "Bank Account"
            ELSE
            IF ("Account Type" = CONST("Fixed Asset")) "Fixed Asset"
            ELSE
            IF ("Account Type" = CONST("IC Partner")) "IC Partner"
            ELSE
            IF ("Account Type" = CONST(Employee)) Employee;



        }
        //<<WDC01
        field(50003; "Payment Method Code"; Code[10])
        {
            Caption = 'Payment Method Code';
            TableRelation = "Payment Method";
        }
        //<<WDC01
    }
}