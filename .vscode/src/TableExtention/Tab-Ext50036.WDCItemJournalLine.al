tableextension 50036 " WdC Item Journal Line" extends "Item Journal Line"
{

    fields
    {
        field(50000; "Customer No."; Code[20])
        {
            CaptionML = ENU = 'Customer No. Transfer', FRA = 'N° Client transfert';
            DataClassification = ToBeClassified;
            TableRelation = Customer;
        }
        field(50001; "Customer Name"; Text[100])
        {
            CaptionML = ENU = 'Customer Name Transfer', FRA = 'Nom du client transfert';
            DataClassification = ToBeClassified;
            Editable = false;
        }

    }
}