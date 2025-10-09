namespace CRC.CRC;
using Microsoft.Sales.History;
using Microsoft.Inventory.Item;
using Microsoft.Inventory.Ledger;
//*************Documentation*************************
//WDC01  WDC.HG  02/09/2025  Distinct Undo Shipment

page 50001 "WDC Customer Delivery"
{
    ApplicationArea = All;
    CaptionML = ENU = 'Customer Delivery', FRA = 'Livraison client';
    PageType = Document;
    SourceTable = "WDC Customer Shipment Header";
    Permissions = tabledata "Sales Shipment Line" = rimd; //WDC01
    layout
    {
        area(Content)
        {
            group(General)
            {
                CaptionML = ENU = 'General', FRA = 'Général';
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }

                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                    ApplicationArea = All;
                }

                field("Sell-to Customer Name"; Rec."Sell-to Customer Name")
                {
                    ApplicationArea = All;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                }
                field("Shipment No."; Rec."Shipment No.")
                {
                    ApplicationArea = All;
                }
                field("Ship-to Address"; Rec."Ship-to Address")
                {
                    ApplicationArea = All;
                }
                field("Ship-to Address 2"; Rec."Ship-to Address 2")
                {
                    ApplicationArea = All;
                }
                field("Ship-to City"; Rec."Ship-to City")
                {
                    ApplicationArea = All;
                }
                field("Ship-to Post Code"; Rec."Ship-to Post Code")
                {
                    ApplicationArea = All;
                }
                field("Transport Method"; Rec."Transport Method")
                {
                    ApplicationArea = All;
                }
                field("Shipping Agent Code"; Rec."Shipping Agent Code")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }

            }
            part("Customer Shipment Lines"; "WDC Customer Delivery Lines")
            {
                ApplicationArea = All;
                CaptionML = ENU = 'Lines', FRA = 'Lignes';
                SubPageLink = "Document No." = field("No.");
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Select Shipment")
            {
                ApplicationArea = All;
                CaptionML = ENU = 'Select Shipment to Post', FRA = 'Choisir la livraison à valider';
                Image = SelectLineToApply;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                begin
                    SelecShipmentToDeliver();
                end;
            }
            action(Post)
            {
                ApplicationArea = All;
                CaptionML = ENU = 'Post', FRA = 'Valider';
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    lText001: TextConst ENU = 'do you want to post this delevery ?',
                FRA = 'Voulez-vous valider cette livraison ?';
                begin
                    if Confirm(lText001) then begin
                        PostDelivery();
                    end;

                end;
            }
        }
    }
    procedure SelecShipmentToDeliver()
    var
        lText001: TextConst ENU = 'No Document found for customer %1',
                            FRA = 'Aucune document trouvé pour le client %1';
        lWDCustomerShipmentHeader: Record "WDC Customer Shipment Header";
        lWDCustShpHeader: Record "WDC Customer Shipment Header";
        lWDCustomerShipmentLine: Record "WDC Customer Shipment Lines";
        lSalesShipmentLine: Record "Sales Shipment Line";
        lSalesShipmentHeader: Record "Sales Shipment Header";
        lSalesShipmentHeader2: Record "Sales Shipment Header";
        lPostedSalesShipmentPage: Page "Sales Shipments to Post";
        lItem: Record Item;
        lItemLedgerEntry: record "Item Ledger Entry";
    begin
        lSalesShipmentHeader.Reset();
        lSalesShipmentHeader.CalcFields("Not Totally Canceled", "Remain to Delivery");
        lSalesShipmentHeader.SetRange("Sell-to Customer No.", Rec."Sell-to Customer No.");
        if lSalesShipmentHeader.Findset() then begin
            repeat
                if HasLinesToDeliver(lSalesShipmentHeader) then
                    lSalesShipmentHeader.Mark(true);
            until lSalesShipmentHeader.next() = 0;
            lSalesShipmentHeader.MarkedOnly(true);
            lPostedSalesShipmentPage.SetTableView(lSalesShipmentHeader);
            if lPostedSalesShipmentPage.RunModal() = Action::OK then begin
                lPostedSalesShipmentPage.GETRECORD(lSalesShipmentHeader2);
                Rec.TransferFields(lSalesShipmentHeader2);
                lSalesShipmentLine.Reset();
                lSalesShipmentLine.CalcFields("Totally Cancelled");
                lSalesShipmentLine.SetRange("Document No.", lSalesShipmentHeader2."No.");
                lSalesShipmentLine.SetRange(type, lSalesShipmentLine.Type::Item);
                lSalesShipmentLine.SetRange("Qty Totally Delivered", false);
                lSalesShipmentLine.setrange("Totally Cancelled", false);//WDC01
                if lSalesShipmentLine.FindSet() then begin
                    repeat
                        if lItem.Get(lSalesShipmentLine."No.") then
                            if lItem.Type = lItem.Type::Inventory then begin
                                //<<WDC01
                                lItemLedgerEntry.reset();
                                lItemLedgerEntry.setrange("Document No.", lSalesShipmentLine."Document No.");
                                lItemLedgerEntry.setrange("Document Line No.", lSalesShipmentLine."Line No.");
                                if lItemLedgerEntry.FindSet() then;
                                //<<WDC01
                                lWDCustomerShipmentLine.Init();
                                lWDCustomerShipmentLine."Document No." := rec."No.";
                                lWDCustomerShipmentLine."Shipment No." := lSalesShipmentHeader2."No.";
                                lWDCustomerShipmentLine.TransferFields(lSalesShipmentLine);
                                lWDCustomerShipmentLine.Quantity := abs(lItemLedgerEntry."Shipped Qty. Not Returned");//WDC01
                                lWDCustomerShipmentLine."Qty to Ship" := lWDCustomerShipmentLine.Quantity - lSalesShipmentLine."Real Delivered Qty";
                                lWDCustomerShipmentLine."Shipment Line No." := lSalesShipmentLine."Line No.";
                                lWDCustomerShipmentLine.Insert();
                            end;
                    until lSalesShipmentLine.Next() = 0;
                end;
            end;
        end else
            Message(StrSubstNo(lText001, Rec."Sell-to Customer No."));
    end;

    procedure PostDelivery()
    var
        lCustomerShipmentLine: Record "WDC Customer Shipment Lines";
        lsalesShipmentLine: Record "Sales Shipment Line";
        WDCUpdateSalesInvLine: Report "WDC Update Sales Shipment Line";
        NotTottalyDelivred: Boolean;

    begin
        lCustomerShipmentLine.Reset();
        lCustomerShipmentLine.SetRange("Document No.", Rec."No.");
        lCustomerShipmentLine.Setfilter("Qty to Ship", '<>%1', 0);
        if lCustomerShipmentLine.FindSet() then begin
            repeat
                if lCustomerShipmentLine."Shipment No." <> '' then begin
                    CheckValidateLine(lCustomerShipmentLine."Shipment No.", lCustomerShipmentLine."Line No.");
                    lCustomerShipmentLine."Qty Shipped" += lCustomerShipmentLine."Qty to Ship";
                    WDCUpdateSalesInvLine.UpdateSalesShipmentLine(lCustomerShipmentLine."Shipment No.", lCustomerShipmentLine."Line No.", lCustomerShipmentLine."Qty to Ship");
                    lCustomerShipmentLine."Qty to Ship" := lCustomerShipmentLine.Quantity - lCustomerShipmentLine."Qty Shipped";
                    lCustomerShipmentLine.Modify();
                    if lCustomerShipmentLine.Quantity > lCustomerShipmentLine."Qty Shipped" then
                        NotTottalyDelivred := true;
                end;

            until lCustomerShipmentLine.Next() = 0;
        end;
        if NotTottalyDelivred then
            Rec."Status" := Rec."Status"::"Partially delivered"
        else
            Rec."Status" := Rec."Status"::"Tottaly delivered";
    end;

    procedure CheckValidateLine(pShpNo: Code[20]; LineNo: Integer)
    var
        lCustShpLine: Record "WDC Customer Shipment Lines";
        lText001: TextConst ENU = 'Line %1 already exist in the shipment %1',
                            FRA = 'La ligne %1 existe déjà dans la livraison %2';
    begin
        lCustShpLine.Reset();
        lCustShpLine.SetRange("Shipment No.", pShpNo);
        lCustShpLine.SetRange("Line No.", LineNo);
        lCustShpLine.SetFilter("Document No.", '<>%1', rec."No.");
        if lCustShpLine.FindFirst() then
            Error(lText001, lCustShpLine."Line No.", lCustShpLine."Document No.");
    end;
    //<<WDC01
    procedure HasLinesToDeliver(ShipmentHeader: Record "Sales Shipment Header"): Boolean
    var
        ShipmentLine: Record "Sales Shipment Line";
        Item: Record Item;
        ItemLedgerEntry: Record "Item Ledger Entry";
        CustomerQtyToShip: Decimal;
    begin
        ShipmentLine.Reset();
        ShipmentLine.SetRange("Document No.", ShipmentHeader."No.");
        ShipmentLine.SetRange(Type, ShipmentLine.Type::Item);
        ShipmentLine.SetRange("Qty Totally Delivered", false);
        ShipmentLine.SetRange("Totally Cancelled", false);
        if ShipmentLine.FindSet() then
            repeat
                if Item.Get(ShipmentLine."No.") then
                    if Item.Type = Item.Type::Inventory then begin
                        ItemLedgerEntry.Reset();
                        ItemLedgerEntry.SetRange("Document No.", ShipmentLine."Document No.");
                        ItemLedgerEntry.SetRange("Document Line No.", ShipmentLine."Line No.");
                        if ItemLedgerEntry.FindFirst() then begin
                            CustomerQtyToShip := Abs(ItemLedgerEntry."Shipped Qty. Not Returned") - ShipmentLine."Real Delivered Qty";
                            if CustomerQtyToShip > 0 then
                                exit(true);
                        end;
                    end;
            until ShipmentLine.Next() = 0;

        exit(false);
    end;
    //>>WDC01
    var
    tt : page 133;
}