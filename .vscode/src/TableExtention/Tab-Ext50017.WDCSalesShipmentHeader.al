namespace CRC.CRC;

using Microsoft.Sales.History;
using Microsoft.Inventory.Ledger;
using Microsoft.Foundation.Shipping;
//****************Documentation**********************
//wdc01  WDC.FS  25/06/2025 Add field "Invoice No." to Sales Shipment Header
//WDC02  WDC.HG  01/07/2025  Add the No. of the posted invoice
//WDC03  WDC.HG  29/08/2025  Distinct Undo Shipment
//WDC04  WDC.FS  05/01/2026  Add Fields
tableextension 50017 "WDC Sales Shipment Header" extends "Sales Shipment Header"
{
    fields
    {
        field(50000; "Remain to Delivery"; Boolean)
        {
            CaptionML = ENU = 'Remain to Delivery', FRA = 'Reste à livrer';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = exist("Sales Shipment Line" where("Document No." = field("No."),
            "Remain. Qty to Delivery" = filter(<> 0), Correction = filter(false)));//WDC03
        }
        field(50001; "Invoiced Order No."; Code[20])
        {
            CaptionML = ENU = 'Invoiced Order No.', FRA = 'N° commande facturée';
            DataClassification = ToBeClassified;
        }
        //<<WDC02
        field(50002; "Posted description"; Code[20])
        {
            CaptionML = ENU = 'Posted description', FRA = 'Libellé écriture';
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Invoice Header"."No." where("Posting Description" = field("Posting Description")));
            Editable = false;
        }
        //>>WDC02
        //<<WDC03

        field(50003; "Not Totally Canceled"; Boolean)
        {
            CaptionML = ENU = 'Not Totally Canceled', FRA = 'Non totalement annulée';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = exist("Item Ledger Entry" where("Document No." = field("No."), "Shipped Qty. Not Returned" = filter(<> 0)));
        }

        //>>WDC03
        // field(50009; Canceled; Boolean) //Reservéééééé

        //field(50010; "Replacment Invoice No."; Code[20]) //Reservéééééé


        field(50015; DestinationAddress; Text[250])
        {
            CaptionML = ENU = 'Destination', FRA = 'Destination';
            DataClassification = ToBeClassified;
        }
        field(50016; "Remain to Invoice"; Boolean)
        {
            CaptionML = ENU = 'Remain to Invoice', FRA = 'Reste à facturer';
            FieldClass = FlowField;
            CalcFormula = exist("Sales Shipment Line" where("Qty. Shipped Not Invoiced" = filter(<> 0),
            "Document No." = field("No.")));
            Editable = false;
        }
        //<<wdc04
        field(50017; "Truck No."; Code[20])
        {
            CaptionML = ENU = 'Truck No.', FRA = 'N° camion';
            DataClassification = ToBeClassified;


        }
        field(50018; "Driver Name"; Text[100])
        {
            CaptionML = ENU = 'Driver Name', FRA = 'Nom chauffeur';
            DataClassification = ToBeClassified;

        }
        //>>wdc04
    }
}
