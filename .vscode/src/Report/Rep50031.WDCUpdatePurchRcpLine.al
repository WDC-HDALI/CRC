namespace CRC.CRC;

using Microsoft.Purchases.History;
using Microsoft.Purchases.Document;

report 50031 "WDC Update Purch. RcpLine"
{
    CaptionML = ENU = 'Invoice Purchase Receipt', FRA = 'Facturer réception d"achat';
    Permissions = tabledata "Purch. Rcpt. Line" = RIMD, tabledata "Purchase Line" = RIMD;
    ProcessingOnly = true;
    ApplicationArea = All;
    // UsageCategory = Lists;
    UseRequestPage = true;

    dataset
    {
        dataitem(PurchRcptHeader; "Purch. Rcpt. Header")
        {
            DataItemTableView = sorting("No.") order(ascending);

            dataitem(PurchRcptLine; "Purch. Rcpt. Line")
            {
                DataItemTableView = sorting("Line No.") order(ascending);
                DataItemLink = "Document No." = field("No.");
                trigger OnAfterGetRecord()
                var

                begin
                    if PurchRcptLine.Type = PurchRcptLine.Type::" " then
                        CurrReport.Skip();
                    if PurchRcptLine.Quantity = 0 then
                        CurrReport.Skip();

                    "Qty. Rcd. Not Invoiced" := 0;
                    "Quantity Invoiced" := Quantity;
                    "Qty. Invoiced (Base)" := Quantity;
                    if Modify() then
                        UpdatePurchLine("Order No.", "Order Line No.", Quantity);
                end;
            }
            trigger OnAfterGetRecord()
            begin
                PurchRcptHeader."Bill in advance" := true;
                PurchRcptHeader."Linked Invoice advance" := InvoiceNo;
                PurchRcptHeader.Modify();
            end;
        }

    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(filtres)
                {
                    field(InvoiceNo; InvoiceNo)
                    {
                        ApplicationArea = all;
                        CaptionML = ENU = 'Linked Invoice advance', FRA = 'Facture d"avance liée';
                        TableRelation = "Purch. Inv. Header";
                    }
                }
            }
        }
    }
    local procedure UpdatePurchLine(pOrderNo: Code[20]; pOrderLineNo: Integer; pQtyReceived: Decimal)
    var
        lPurchLine: Record "Purchase Line";
    begin
        lPurchLine.Reset();
        if not lPurchLine.get(lPurchLine."Document Type"::Order, pOrderNo, pOrderLineNo) then
            exit;

        lPurchLine."Qty. to Invoice" := 0;
        lPurchLine."Qty. to Invoice (Base)" := 0;
        if lPurchLine."Qty. Rcd. Not Invoiced" <= pQtyReceived Then
            lPurchLine."Qty. Rcd. Not Invoiced" := 0
        else
            lPurchLine."Qty. Rcd. Not Invoiced" -= pQtyReceived;

        lPurchLine."Qty. Rcd. Not Invoiced (Base)" := lPurchLine."Qty. Rcd. Not Invoiced";
        lPurchLine."Quantity Invoiced" += pQtyReceived;
        lPurchLine."Qty. Invoiced (Base)" := lPurchLine."Quantity Invoiced";
        lPurchLine.Modify();
    end;

    var
        InvoiceNo: code[20];
}
