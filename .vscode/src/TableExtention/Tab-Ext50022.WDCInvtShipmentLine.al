namespace CRC.CRC;

using Microsoft.Inventory.Document;
using Microsoft.Sales.Document;
using Microsoft.Sales.Customer;
using Microsoft.Inventory.Item;
using Microsoft.Finance.VAT.Setup;
//*****************Documentation**********************
//WDC01  HG  16/05/2025  Create current object
tableextension 50022 WDCInvtShipmentLine extends "Invt. Document Line"
{
    fields
    {
        field(50000; "Line Discount %"; Decimal)
        {
            Captionml = ENU = 'Line Discount %', FRA = '% Remise Ligne ';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                if "Line Discount %" = 100 then
                    "Line Discount Amount" := Amount
                else if "Line Discount %" = 0 then
                    "Line Discount Amount" := 0
                else
                    "Line Discount Amount" := Round(Amount * "Line Discount %" / 100, 0.001, '=');
                "Line Amount HT" := Amount - "Line Discount Amount";
                "Line VAT Amount" := "Line Amount HT" * ("VAT %" / 100);
                "Amount Including VAT" := "Line Amount HT" * (1 + "VAT %" / 100);
            end;




        }
        field(50001; "VAT %"; Decimal)
        {
            Captionml = ENU = 'VAT %', FRA = '% TVA';
            DataClassification = ToBeClassified;
        }
        field(50002; "Line Discount Amount"; Decimal)
        {
            Captionml = ENU = 'Line Discount Amount', FRA = 'Monatant remise ligne';
            DataClassification = ToBeClassified;
        }
        field(50003; "Line Amount HT"; Decimal)
        {
            Captionml = ENU = 'Line Amount HT', FRA = 'Montant ligne HT';
            DataClassification = ToBeClassified;

        }
        field(50004; "Amount Including VAT"; Decimal)
        {
            Captionml = ENU = 'Amount Including VAT', FRA = 'Montant Inclu TVA';
            DataClassification = ToBeClassified;
        }
        field(50005; "Line VAT Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Captionml = ENU = 'Line VAT Amount', FRA = 'Montant TVA ligne';
        }

        modify("Item No.")
        {
            trigger OnAfterValidate()
            var
                VItem: record Item;
                VCustomer: record Customer;
                VInvDocumentHeader: Record "Invt. Document Header";
                VVATPostingGroup: record "VAT Posting Setup";
            begin
                VItem.reset();
                VCustomer.reset();
                VInvDocumentHeader.reset();
                if VInvDocumentHeader.get("Document Type"::Shipment, "Document No.") then
                    if VCustomer.get(VInvDocumentHeader.CustomerNo) then
                        if VItem.get("Item No.") then begin
                            rec.validate("Unit Amount", VItem."Unit Cost");
                            if VVATPostingGroup.Get(VCustomer."VAT Bus. Posting Group", VItem."VAT Prod. Posting Group") then begin
                                "VAT %" := VVATPostingGroup."VAT %";
                            end;
                        end;
            end;
        }
        modify("Unit Amount")
        {
            trigger OnAfterValidate()
            begin
                "Line Amount HT" := Amount;
                "Line VAT Amount" := "Line Amount HT" * ("VAT %" / 100);
                "Amount Including VAT" := "Line Amount HT" * (1 + "VAT %" / 100);
            end;


        }
        modify("Amount")
        {
            trigger OnAfterValidate()
            begin
                "Line Amount HT" := Amount;
                "Line VAT Amount" := "Line Amount HT" * ("VAT %" / 100);
                "Amount Including VAT" := "Line Amount HT" * (1 + "VAT %" / 100);
            end;
        }
        modify("Quantity")
        {
            trigger OnAfterValidate()
            begin
                "Line Amount HT" := Amount;
                "Line VAT Amount" := "Line Amount HT" * ("VAT %" / 100);
                "Amount Including VAT" := "Line Amount HT" * (1 + "VAT %" / 100);
            end;
        }


    }
}
