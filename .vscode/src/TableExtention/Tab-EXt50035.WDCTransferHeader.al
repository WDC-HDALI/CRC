//****************Documentation**********************


tableextension 50035 "WDC Transfer Header" extends "Transfer Header"
{
    fields
    {
        field(50000; "Customer No."; Code[20])
        {
            CaptionML = ENU = 'Customer No.', FRA = 'N° Client';
            DataClassification = ToBeClassified;
            TableRelation = Customer;
        }
        field(50001; "Customer Name"; Text[100])
        {
            CaptionML = ENU = 'Customer Name', FRA = 'Nom du client';
            DataClassification = ToBeClassified;
        }

    }
}