namespace CRC.CRC;

using Microsoft.Sales.History;

pageextension 50060 "WDC Get Shipment Lines" extends "Get Shipment Lines"
/**********documentation*******************************/
//WDC01  WDC.FS  03/03/2026  Add Total Amount Inc VAt
{
    //<<wdc01
    layout
    {
        addafter("Document No.")
        {
            field("Posting Date"; Rec."Posting Date")
            {
                ApplicationArea = all;
            }
        }
        addlast(Content)
        {
            group(Total)
            {
                field(TotalAmountInclVAT; TotalAmountInclVAT)
                {
                    ApplicationArea = All;
                    CaptionML = ENU = 'Selected Total Incl. VAT', FRA = 'Total montant';
                    Editable = false;
                }
            }
        }

    }
    actions
    {
        addlast(Processing)
        {
            action(CalculateSelectedTotal)
            {
                ApplicationArea = All;
                CaptionML = ENU = 'Refresch Selected Total', FRA = 'Actualiser total sélectionné';
                Image = Calculate;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                InFooterBar = true;
                trigger OnAction()
                begin
                    TotalAmountInclVAT := GetSelectedTotal();
                    CurrPage.Update(false);
                end;
            }
        }
    }

    var
        TotalAmountInclVAT: Decimal;


    local procedure GetSelectedTotal(): Decimal
    var
        SalesShipmentLine: Record "Sales Shipment Line";
        lAmountIncVAT: Decimal;

    begin
        lAmountIncVAT := 0;
        CurrPage.SetSelectionFilter(SalesShipmentLine);

        if SalesShipmentLine.FindSet() then
            repeat
                lAmountIncVAT += (SalesShipmentLine.Quantity * SalesShipmentLine."Unit Price") * (1 + SalesShipmentLine."VAT %" / 100);
            until SalesShipmentLine.Next() = 0;
        exit(lAmountIncVAT);
    end;
    //>>wdc01
}
