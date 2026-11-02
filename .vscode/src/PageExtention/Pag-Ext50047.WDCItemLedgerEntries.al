//****************Documentation**********************
//wdc01  WDC.FS  26/06/2025 add Customer No. field to Item Ledger Entries page
//wdc02  WDC.FS  24/02/2026 Access to Posted Document while Click on Document No
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
        //<<wdc02
        modify("Document No.")
        {
            trigger OnDrillDown()
            var
                PurchRcptHeader: Record "Purch. Rcpt. Header";
                SalesShipmentHeader: Record "Sales Shipment Header";
            begin
                if Rec."Document Type" = Rec."Document Type"::"Purchase Receipt" then begin
                    PurchRcptHeader.RESET;
                    PurchRcptHeader.SetRange("No.", Rec."Document No.");
                    if PurchRcptHeader.FindFirst() then
                        Page.Run(Page::"Posted Purchase Receipt", PurchRcptHeader);
                end;
                if Rec."Document Type" = Rec."Document Type"::"Sales Shipment" then begin
                    SalesShipmentHeader.RESET;
                    SalesShipmentHeader.SetRange("No.", Rec."Document No.");
                    if SalesShipmentHeader.FindFirst() then
                        Page.Run(Page::"Posted Sales Shipment", SalesShipmentHeader);
                end;
            end;
        }
        //>>wdc02

    }
}