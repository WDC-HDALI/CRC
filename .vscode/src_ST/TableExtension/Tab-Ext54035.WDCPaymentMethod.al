namespace CRC.CRC;

using Microsoft.Bank.BankAccount;
using Microsoft.Sales.Customer;

tableextension 54035 "WDC Payment Method" extends "Payment Method"
{
    fields
    {
        field(50000; "Payment Type"; Enum "WDC-ST Payment Slip Type")
        {
            CaptionML = ENU = 'Payment Type', FRA = 'Type paiement';
            DataClassification = ToBeClassified;
        }
        field(50001; Unpaid; Boolean)
        {
            CaptionML = ENU = 'Unpaid', FRA = 'Impayé';
            DataClassification = ToBeClassified;
        }
        field(50002; "Posting Group"; Code[20])
        {
            Caption = 'Posting Group';
            TableRelation = "Customer Posting Group";
            //     else
            //     if ("Account Type" = const(Vendor)) "Vendor Posting Group"
            //     else
            //     if ("Account Type" = const("Fixed Asset")) "FA Posting Group";
        }

    }
}
