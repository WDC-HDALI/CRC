namespace CRC.CRC;

using Microsoft.Purchases.History;
using Microsoft.Purchases.Document;
//******************Documentation***********************
//WDC01  WDC.HG  11/08/2025  Create current object : update vendor card to show historics and recpt not invoiced detailes
page 50028 "WDC Purch. Recept Not Invoiced"
{
    ApplicationArea = All;
    CaptionML = ENU = 'Purchase Receipt Not Inv.', FRA = 'RCA non facturées';
    PageType = ListPart;
    SourceTable = "Purch. Rcpt. Header";
    SourceTableView = where("Remain to Invoice" = const(true));
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = all;
                    TableRelation = "Purch. Inv. Header";
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }


                field("Buy-from Vendor No"; Rec."Buy-from Vendor No.")
                {
                    ApplicationArea = All;
                }
                field("Buy-from Vendor Name"; Rec."Buy-from Vendor Name")
                {
                    ApplicationArea = All;
                }
                field("Order No."; Rec."Order No.")
                {
                    ApplicationArea = All;
                }
                field(Note; Rec.Note)
                {
                    ApplicationArea = All;
                }

                field(TotalPayer; TotalPayer)
                {
                    CaptionML = ENU = 'Amount Including VAT', FRA = 'Montant TTC';
                    ApplicationArea = all;
                    Style = StrongAccent;
                }
                field(RemainToInvoice; RemainToInvoice)
                {
                    CaptionML = ENU = 'Remain to Invoice', FRA = 'Reste à facturer';
                    ApplicationArea = all;
                    Style = StrongAccent;
                }

            }
        }
    }
    trigger OnAfterGetRecord()
    var
        lPurchaseLine: record "Purchase Line";
    begin
        RemainToInvoice := 0;
        totalpayer := 0;
        PurchRecieptLine.reset();
        PurchRecieptLine.SetCurrentKey("Document No.", "Line No.");
        PurchRecieptLine.setrange("Document No.", Rec."No.");
        //PurchRecieptLine.Setfilter("Qty. Rcd. Not Invoiced", '<>%1', 0);
        if PurchRecieptLine.FindSet() then
            repeat
                lPurchaseLine.get(lPurchaseLine."Document Type"::Order, PurchRecieptLine."Order No.", PurchRecieptLine."Order Line No.");
                if (lPurchaseLine."VAT Bus. Posting Group" = 'ASSUJETTI') or (lPurchaseLine."VAT %" = 0) then
                    totalpayer += lPurchaseLine.Amount * (1 + (lPurchaseLine."VAT %" / 100))
                else
                    totalpayer += lPurchaseLine.Amount;
                RemainToInvoice += lPurchaseLine."Amt. Rcd. Not Invoiced (LCY)";
            until PurchRecieptLine.Next() = 0;
    end;


    var
        totalpayer: Decimal;
        RemainToInvoice: Decimal;
        PurchRecieptLine: record "Purch. Rcpt. Line";


}
