namespace CRC.CRC;

using Microsoft.Foundation.Company;
using Microsoft.Bank.BankAccount;

tableextension 50020 "WDC Company Information" extends "Company Information"
{
    fields
    {
        field(50000; "Company Bank Account No."; Code[20])
        {
            CaptionML = ENU = 'Company Bank Account No.', FRA = 'N° compte bancaire société';
            DataClassification = ToBeClassified;
            TableRelation = "Bank Account";
        }
    }
}
