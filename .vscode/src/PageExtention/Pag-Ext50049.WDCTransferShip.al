//****************Documentation**********************
//wdc01  WDC.FS  26/06/2025 add Customer No. field to Item Ledger Entries page
pageextension 50049 "WDC Posted Transfer Shipment " extends "Posted Transfer Shipment"
{
    layout
    {
        addafter("Posting Date")
        {
            field("Customer No."; Rec."Customer No.")
            {
                ApplicationArea = All;
                CaptionML = ENU = 'Customer No. Transfer', FRA = 'N° Client Transfert';
            }
            field("Customer Name"; Rec."Customer Name")
            {
                ApplicationArea = All;
                CaptionML = ENU = 'Customer Name Transfer', FRA = 'Nom du client Transfert';
                Editable = false;
            }
        }

    }
}