namespace CRC.CRC;

using Microsoft.Inventory.History;

tableextension 50023 WDCPostedInvtShipmentHeader extends "Invt. Shipment Header"
{
    fields
    {
        field(50000; CustomerNo; Code[20])
        {
            Captionml = ENU = 'Customer No.', FRA = 'N° client';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50001; CustomerName; Text[100])
        {
            CaptionML = ENU = 'Customer Name', FRA = 'Nom du client';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50002; CustomerAddress; Text[100])
        {
            Captionml = ENU = 'Customer Address', FRA = 'Addresse';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50003; CustomerPhoneNo; Code[20])
        {
            Captionml = ENU = 'Customer Phone No.', FRA = 'N° téléphone';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50004; "Total HT"; Decimal)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = sum("Invt. Shipment Line"."Line Amount HT" where("Document No." = field("No.")));
        }
        field(50005; "Total TVA"; Decimal)
        {
            Captionml = ENU = 'Total TVA (TND)', FRA = 'Total TVA (TND)';
            FieldClass = FlowField;
            CalcFormula = sum("Invt. Shipment Line"."Line VAT Amount" where("Document No." = field("No.")));
            Editable = false;
        }
        field(50006; "Total TTC"; Decimal)
        {
            Captionml = ENU = 'Total TTC (TND)', FRA = 'Total TTC (TND)';
            FieldClass = FlowField;
            CalcFormula = sum("Invt. Shipment Line"."Amount Including VAT" where("Document No." = field("No.")));
            Editable = false;
        }
    }
}