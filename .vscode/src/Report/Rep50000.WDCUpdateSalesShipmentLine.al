namespace CRC.CRC;

using Microsoft.Sales.History;

report 50000 "WDC Update Sales Shipment Line"
{
    Caption = 'Update Sales Shipment Line';
    UseRequestPage = false;
    Permissions = tabledata "Sales Shipment Line" = RIMD;
    ApplicationArea = All;
    dataset
    {

        dataitem(SalesShipmentLine; "Sales Shipment Line")
        {

            column(DocumentNo; "Document No.")
            {
            }
            column(LineNo; "Line No.")
            {
            }
        }
    }
    procedure UpdateSalesShipmentLine(pDocumentNo: Code[20]; pLineNo: Integer; pQty: Decimal)
    var
        lSalesShipmentLine: Record "Sales Shipment Line";
    begin
        if lSalesShipmentLine.get(pDocumentNo, pLineNo) then begin
            lSalesShipmentLine."Real Delivered Qty" += pQty;
            lSalesShipmentLine."Remain. Qty to Delivery" -= pQty;
            if lSalesShipmentLine."Real Delivered Qty" >= lSalesShipmentLine.Quantity then
                lSalesShipmentLine."Qty Totally Delivered" := true;
            lSalesShipmentLine.Modify();
        end;
    end;

    procedure UpdateRemainQtyToDeliveryWithReturnedQuantity(pDocumentNo: Code[20]; pLineNo: Integer; pQty: Decimal)
    var
        lSalesShipmentLine: Record "Sales Shipment Line";
    begin
        if lSalesShipmentLine.get(pDocumentNo, pLineNo) then begin
            if pQty < lSalesShipmentLine."Remain. Qty to Delivery" then
                lSalesShipmentLine."Remain. Qty to Delivery" := lSalesShipmentLine."Remain. Qty to Delivery" - pQty
            else
                lSalesShipmentLine."Remain. Qty to Delivery" := 0;
            lSalesShipmentLine.modify();


        end;
    end;
}
