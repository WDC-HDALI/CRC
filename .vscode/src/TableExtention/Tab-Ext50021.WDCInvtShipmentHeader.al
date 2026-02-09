namespace CRC.CRC;

using Microsoft.Inventory.History;
using Microsoft.Sales.Customer;
using Microsoft.Inventory.Document;
//*****************Documentation**********************
//WDC01  HG  16/05/2025  Create current object

tableextension 50021 WDCInvtShipmentHeader extends "Invt. Document Header"
{
    fields
    {
        field(50000; CustomerNo; Code[20])
        {
            Captionml = ENU = 'Customer No.', FRA = 'N° client';
            TableRelation = Customer;
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                customer: record Customer;
            begin
                customer.reset();

                if customer.get(CustomerNo) then begin
                    CustomerName := customer.Name;
                    CustomerAddress := customer.Address;
                    CustomerPhoneNo := customer."Phone No.";
                end;



            end;
        }
        field(50001; CustomerName; Text[100])
        {
            CaptionML = ENU = 'Customer Name', FRA = 'Nom du client';
            TableRelation = customer.Name;
            DataClassification = ToBeClassified;
        }
        field(50002; CustomerAddress; Text[100])
        {
            Captionml = ENU = 'Customer Address', FRA = 'Addresse';
            DataClassification = ToBeClassified;
        }
        field(50003; CustomerPhoneNo; Code[20])
        {
            Captionml = ENU = 'Customer Phone No.', FRA = 'N° téléphone';
            DataClassification = ToBeClassified;
        }
        field(50004; "Total HT"; Decimal)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = sum("Invt. Document Line"."Line Amount HT" where("Document Type" = field("Document Type"), "Document No." = field("No.")));
        }
        field(50005; "Total TVA"; Decimal)
        {
            Captionml = ENU = 'Total TVA (TND)', FRA = 'Total TVA (TND)';
            FieldClass = FlowField;
            CalcFormula = sum("Invt. Document Line"."Line VAT Amount" where("Document Type" = field("Document Type"), "Document No." = field("No.")));
            Editable = false;
        }
        field(50006; "Total TTC"; Decimal)
        {
            Captionml = ENU = 'Total TTC (TND)', FRA = 'Total TTC (TND)';
            FieldClass = FlowField;
            CalcFormula = sum("Invt. Document Line"."Amount Including VAT" where("Document Type" = field("Document Type"), "Document No." = field("No.")));
            Editable = false;
        }

    }
}


