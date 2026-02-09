namespace CRC.CRC;
using Microsoft.Warehouse.Document;
using Microsoft.Purchases.History;

tableextension 50040 "WDC Warehouse Receipt Header" extends "Warehouse Receipt Header"
{
    fields
    {
        modify("Vendor Shipment No.")
        {
            trigger OnAfterValidate()
            var
                lPurchReceiptHeader: Record "Purch. Rcpt. Header";
                lText001: TextConst ENU = 'Shipment No. is used in receipt %1',
                                     FRA = ' Ce numéro de BL deja utilisé dans la réception %1';
            begin
                lPurchReceiptHeader.reset();
                lPurchReceiptHeader.SetRange("Vendor Shipment No.", Rec."Vendor Shipment No.");
                lPurchReceiptHeader.setfilter("No.", '<>%1', Rec."No.");
                if lPurchReceiptHeader.FindFirst() then
                    Error(lText001, lPurchReceiptHeader."No.");
            end;
        }
        field(50000; Note; Text[250])
        {
            CaptionML = ENU = 'Note', FRA = 'Note';
            DataClassification = ToBeClassified;
        }
    }
}
