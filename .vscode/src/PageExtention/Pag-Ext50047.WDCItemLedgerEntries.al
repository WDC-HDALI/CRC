//****************Documentation**********************
//wdc01  WDC.FS  26/06/2025 add Customer No. field to Item Ledger Entries page
pageextension 50047 "WDC Item Ledger Entries" extends "Item Ledger Entries"
{
    layout
    {
        addafter("Item No.")
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