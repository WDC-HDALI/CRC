namespace CRC.CRC;

using Microsoft.Purchases.Document;
using Microsoft.Foundation.Shipping;

tableextension 50032 "WDC Purchase Header" extends "Purchase Header"
{
    fields
    {
        field(50000; "Truck No."; code[10])
        {
            CaptionML = FRA = 'N° camion';
            DataClassification = ToBeClassified;
            TableRelation = "Shipping Agent";
            trigger OnValidate()
            begin
                "Shipping Agent No." := '';
            end;
        }
        field(50001; "Shipping Agent No."; code[10])
        {
            CaptionML = FRA = 'N° Chauffeur';
            DataClassification = ToBeClassified;
            TableRelation = "Shipping Agent Services".Code where("Shipping Agent Code" = field("Truck No."));
        }

    }
}
