namespace CRC.CRC;

using Microsoft.Inventory.History;

tableextension 50024 WDCPostedInvtShipmentLine extends "Invt. Shipment Line"
{
    fields
    {
        field(50000; "Line Discount %"; Decimal)
        {
            Captionml = ENU = 'Line Discount %', FRA = '% Remise ligne';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50001; "VAT %"; Decimal)
        {
            Captionml = ENU = 'VAT %', FRA = '% TVA';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50002; "Line Discount Amount"; Decimal)
        {
            Captionml = ENU = 'Line Discount Amount', FRA = 'Monatant remise ligne';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50003; "Line Amount HT"; Decimal)
        {
            Captionml = ENU = 'Line Amount HT', FRA = 'Montant HT';
            DataClassification = ToBeClassified;
            Editable = false;

        }
        field(50004; "Amount Including VAT"; Decimal)
        {
            Captionml = ENU = 'Amount Including VAT', FRA = 'Montant Inclu TVA';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50005; "Line VAT Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Captionml = ENU = 'Line VAT Amount', FRA = 'Montant TVA ligne';
            Editable = false;
        }

    }
}
