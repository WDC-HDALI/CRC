tableextension 50037 " WdC Item Ledger Entry" extends "Item Ledger Entry"
{

    fields
    {
        field(50000; "Customer No."; Code[20])
        {
            CaptionML = ENU = 'Customer No. Transfer', FRA = 'N° Client Transfert';
            DataClassification = ToBeClassified;
            TableRelation = Customer;
        }
        field(50001; "Customer Name"; Text[100])
        {
            CaptionML = ENU = 'Customer Name Transfer', FRA = 'Nom du client Transfert';
            DataClassification = ToBeClassified;
            Editable = false;
        }

    }
}