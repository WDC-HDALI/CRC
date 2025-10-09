namespace CRC.CRC;

using Microsoft.Foundation.Company;

pageextension 50011 "WDC Company Information" extends "Company Information"
{
    layout
    {
        addafter(BankAccountPostingGroup)
        {
            field("Company Bank Account No."; Rec."Company Bank Account No.")
            {
                ApplicationArea = All;
            }
        }
    }
}
