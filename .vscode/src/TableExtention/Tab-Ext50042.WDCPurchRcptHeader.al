namespace CRC.CRC;
using Microsoft.Warehouse.Document;
using Microsoft.Sales.History;
using Microsoft.Purchases.History;
//******************Documentation***********************
//WDC01  WDC.HG  11/08/2025  update vendor card to show historics and recpt not invoiced detailes 
tableextension 50042 "WDC Purch. Rcpt. Header" extends "Purch. Rcpt. Header"
{
    fields
    {
        field(50000; Note; Text[250])
        {
            CaptionML = ENU = 'Note', FRA = 'Note';
            DataClassification = ToBeClassified;
        }
        //<<WDC01
        field(50001; "Remain to Invoice"; Boolean)
        {
            CaptionML = ENU = 'Remain to Invoice', FRA = 'Reste à facturer';
            FieldClass = FlowField;
            CalcFormula = exist("Purch. Rcpt. Line" where("Qty. Rcd. Not Invoiced" = filter(<> 0),
            "Document No." = field("No.")));
            Editable = false;
        }
        //<<WDC01
        field(50080; "Bill in advance"; Boolean)
        {
            CaptionML = ENU = 'Bill in advance', FRA = 'Facturer à l"avance';
            DataClassification = ToBeClassified;
        }
        field(50081; "Linked Invoice advance"; Code[20])
        {
            CaptionML = ENU = 'Linked Invoice advance', FRA = 'Facture d"avance liée';
            DataClassification = ToBeClassified;
        }
    }
    var
}
