//****************Documentation***************
//WDC01  WDC.HG 29/07/2025 Continuation of  valuation of posted sales shipment
//WDC02  WDC.HG 02/09/2025  Distinct the canceled shipment line from the customer shipment 
namespace CRC.CRC;

using Microsoft.Sales.History;
using Microsoft.Sales.Document;
using Microsoft.Inventory.Ledger;
tableextension 50012 "WDC Sales Shipment Line" extends "Sales Shipment Line"

{
    fields
    {
        field(50000; "Assoc. Transport Line No."; Integer)
        {
            CaptionML = ENU = 'Assoc. Transport Line No.', FRA = 'N° ligne Transport associée';
            DataClassification = ToBeClassified;
        }
        field(50001; "Assoc. Royality Line No."; Integer)
        {
            CaptionML = ENU = 'Assoc. Royality Line No.', FRA = 'N° ligne Redevance associée';
            DataClassification = ToBeClassified;
        }
        field(50900; "Qty Totally Delivered"; Boolean)
        {
            CaptionML = ENU = 'Qty Totally Delivered', FRA = 'Qté totalement livrée';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50901; "Real Delivered Qty"; Decimal)
        {
            CaptionML = ENU = 'Real Delivered Qty', FRA = 'Qté réellement livrée';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(50902; "Remain. Qty to Delivery"; Decimal)
        {
            CaptionML = ENU = 'Remain. Qty to Delivery', FRA = 'Qté reste à livrer';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        //<<WDC02
        field(50903; "Totally Cancelled"; Boolean)
        {
            CaptionML = ENU = 'Totally Cancelled', FRA = 'Totallement annulée';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = exist("Item Ledger Entry" where("Document No." = field("Document No."), "Document Line No." = field("Line No."), "Shipped Qty. Not Returned" = filter(0)));
        }
        //<<WDC02
        // WDC01
        // field(50018; "Line Amount"; Decimal)
        // {
        //     CaptionML = ENU = 'Total Line Amount HT', FRA = 'Montant Total ligne HT';
        //     FieldClass = FlowField;
        //     CalcFormula = Lookup("Sales Line"."Line Amount" WHERE("Document Type" = const(Order),
        //                                                            "Document No." = field("Order No."),
        //                                                            "Line No." = field("Order Line No.")));
        // }
        // field(50019; "Amount Incl VAT"; Decimal)
        // {
        //     CaptionML = ENU = 'Amount Incl. VAT', FRA = 'Montant TTC';
        //     FieldClass = FlowField;
        //     CalcFormula = Lookup("Sales Line"."Amount Including VAT" WHERE("Document Type" = const(Order),
        //                                                            "Document No." = field("Order No."),
        //                                                            "Line No." = field("Order Line No.")));
        // }
        // field(50020; "Line Discount amount"; Decimal)
        // {
        //     CaptionML = ENU = 'Line Discount amount', FRA = 'Montant remise ligne';
        //     FieldClass = FlowField;
        //     CalcFormula = Lookup("Sales Line"."Line Discount Amount" WHERE("Document Type" = const(Order),
        //                                                            "Document No." = field("Order No."),
        //                                                            "Line No." = field("Order Line No.")));
        // }
        field(50021; "Line Amount"; Decimal)
        {
            CaptionML = ENU = 'Line Amount HT', FRA = 'Montant ligne HT';
            DataClassification = ToBeClassified;

        }

        //>>WDC01
    }

    keys
    {
        key("Remain. Qty to Delivery"; "Qty Totally Delivered")
        {
        }
    }

}
