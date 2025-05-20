namespace CRC.CRC;

using Microsoft.Sales.History;
using Microsoft.Inventory.Item;

tableextension 50004 "WDC Item" extends Item
{
    fields
    {
        field(50000; "Sold Qty not Delivered"; Decimal)
        {
            CaptionML = ENU = 'Sold Qty not Delivered', FRA = 'Stock vendu non livré';
            Editable = false;
            FieldClass = FlowField;
            DecimalPlaces = 0 : 5;
            CalcFormula = Sum("Sales Shipment Line"."Remain. Qty to Delivery" WHERE("No." = FIELD("No."),
            Type = CONST(Item),
            "Remain. Qty to Delivery" = FILTER('<>0')));
        }

        field(50004; "Qty per Package"; Decimal)
        {
            CaptionML = ENU = 'Qty per Package', FRA = 'Qté par paquet';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
        }
        field(50005; "SubCategorie"; Code[20])
        {
            CaptionML = FRA = 'Code sous catégorie', ENU = 'SubCategorie Code';
            DataClassification = ToBeClassified;
            TableRelation = "WDC SubCategory Item".Code where("Item Category Code" = FIELD("Item Category Code"));
        }

        field(50006; "Transport Item"; Boolean)
        {
            CaptionML = ENU = 'Transport Item', FRA = 'Article de transport';
            DataClassification = ToBeClassified;
        }
        field(50007; "Associed Transport Item No."; Code[20])
        {
            CaptionML = ENU = 'Associed Transport Item No', FRA = 'N° Article transport associé';
            DataClassification = ToBeClassified;
            TableRelation = Item where("Transport Item" = const(true));
        }
        field(50008; "Transport Unit Price LCY"; Decimal)
        {
            CaptionML = ENU = 'Transport Unit Price LCY', FRA = 'Prix Unitaire transport DS';
            DataClassification = ToBeClassified;
        }
        field(50009; "Associated Royalty"; Code[20])
        {
            CaptionML = ENU = 'Associated Royalty', FRA = 'Redevance associé';
            DataClassification = ToBeClassified;
            TableRelation = "Item Charge";
        }
        field(50010; "Royalty Unit Price LCY"; Decimal)
        {
            CaptionML = ENU = 'Royalty Unit Price LCY', FRA = 'Prix Unit. Redevance DS';
            DataClassification = ToBeClassified;
        }
    }

}
