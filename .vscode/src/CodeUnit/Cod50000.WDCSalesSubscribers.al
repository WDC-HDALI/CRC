codeunit 50000 "WDC Sales Subscribers"
{

    // Enleve l'option de validation et laisser que l'expédition
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post (Yes/No)", 'OnBeforeConfirmSalesPost', '', FALSE, FALSE)]
    local procedure OnBeforeConfirmSalesPost(var SalesHeader: Record "Sales Header"; var HideDialog: Boolean; var IsHandled: Boolean; var DefaultOption: Integer; var PostAndSend: Boolean)
    var
        lText001: TextConst ENU = 'Do you want to post this order',
                            FRA = 'Voulez-vous valider la commande?';
        lText002: TextConst ENU = 'Operation is cancelled',
                            FRA = 'Opération annulée';
    begin
        if SalesHeader."Document Type" = SalesHeader."Document Type"::Order then begin
            if Not Confirm(StrSubstNo(lText001)) then
                Error(lText002);
            DefaultOption := 1;
            HideDialog := true;
            SalesHeader.Ship := true;
        end;
    end;

    //<< enleve le controle d'affectation Frais annexes Vente
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", OnCheckSalesDocumentOnAfterCalcShouldCheckItemCharge, '', false, false)]
    local procedure OnCheckSalesDocumentOnAfterCalcShouldCheckItemCharge(var SalesHeader: Record "Sales Header"; WhseReceive: Boolean; WhseShip: Boolean; var ShouldCheckItemCharge: Boolean; var ModifyHeader: Boolean)
    begin
        ShouldCheckItemCharge := false;
    end;
    //>>

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", OnBeforeSalesShptLineInsert, '', false, false)]
    local procedure OnBeforeSalesShptLineInsert(var SalesShptLine: Record "Sales Shipment Line"; SalesShptHeader: Record "Sales Shipment Header"; SalesLine: Record "Sales Line"; CommitIsSuppressed: Boolean; PostedWhseShipmentLine: Record "Posted Whse. Shipment Line"; SalesHeader: Record "Sales Header"; WhseShip: Boolean; WhseReceive: Boolean; ItemLedgShptEntryNo: Integer; xSalesLine: record "Sales Line"; var TempSalesLineGlobal: record "Sales Line" temporary; var IsHandled: Boolean)
    var
        lItem: Record Item;
    begin
        if SalesShptLine.Type = SalesShptLine.Type::Item then begin
            if lItem.Get(SalesShptLine."No.") then begin
                if lItem.Type = lItem.Type::Inventory then
                    SalesShptLine."Remain. Qty to Delivery" := SalesShptLine.Quantity;
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Page, page::"Sales Invoice Subform", 'OnDeleteRecordEvent', '', false, false)]
    local procedure OnAfterDeleteSalesInvSubf(VAR Rec: Record "Sales Line")
    var
        lSalesLineTrs: Record "Sales Line";
        lSalesLineRDV: Record "Sales Line";
    begin
        if lSalesLineTrs.Get(Rec."Document Type", Rec."Document No.", rec."Assoc. Transport Line No.") then
            lSalesLineTrs.Delete();

        if lSalesLineRDV.Get(Rec."Document Type", Rec."Document No.", rec."Assoc. Royality Line No.") then
            lSalesLineRDV.Delete();
    end;

    [EventSubscriber(ObjectType::Page, page::"Sales Quote Subform", 'OnDeleteRecordEvent', '', false, false)]
    local procedure OnAfterDeleteSalesQuoteSubf(VAR Rec: Record "Sales Line")
    var
        lSalesLineTrs: Record "Sales Line";
        lSalesLineRDV: Record "Sales Line";
    begin
        if lSalesLineTrs.Get(Rec."Document Type", Rec."Document No.", rec."Assoc. Transport Line No.") then
            lSalesLineTrs.Delete();

        if lSalesLineRDV.Get(Rec."Document Type", Rec."Document No.", rec."Assoc. Royality Line No.") then
            lSalesLineRDV.Delete();
    end;

    [EventSubscriber(ObjectType::Page, page::"Sales Order Subform", 'OnDeleteRecordEvent', '', false, false)]
    local procedure OnAfterDeleteSalesOrderSubf(VAR Rec: Record "Sales Line")
    var
        lSalesLineTrs: Record "Sales Line";
        lSalesLineRDV: Record "Sales Line";
    begin
        if lSalesLineTrs.Get(Rec."Document Type", Rec."Document No.", rec."Assoc. Transport Line No.") then
            lSalesLineTrs.Delete();

        if lSalesLineRDV.Get(Rec."Document Type", Rec."Document No.", rec."Assoc. Royality Line No.") then
            lSalesLineRDV.Delete();
    end;

    var
    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterValidateEvent', 'Quantity', false, false)]
    local procedure OnAfterValidateQuntity(VAR Rec: Record "Sales Line")
    var
        lItem: Record Item;
        lItemTransport: Record Item;
        lSalesLine: Record "Sales Line";
        lSalesLineRDV: Record "Sales Line";
        lText001: TextConst ENU = 'The quantity must be a multiple of Qty per Package : %1',
                            FRA = 'La quantité doit être un multiple de qté par carton : %1';
    begin
        if rec.Quantity <> 0 then begin
            if Rec.Type = Rec.Type::Item then begin
                if lItem.Get(rec."No.") then begin

                    if lItem."Qty per Package" <> 0 then begin
                        if rec.Quantity mod lItem."Qty per Package" <> 0 then begin
                            Error(lText001, lItem."Qty per Package");
                        end;
                    end;

                    if ((Rec."Document Type" = rec."Document Type"::Invoice) and (Rec."Shipment No." = '')) or
                    (Rec."Document Type" = rec."Document Type"::Quote) then begin
                        if lItem."Associed Transport Item No." <> '' Then begin
                            lItem.TestField("Transport Unit Price LCY");
                            CreateTransportSalesLine(Rec, lItem."Associed Transport Item No.", lItem."Transport Unit Price LCY");
                        end;
                        if lItem."Associated Royalty" <> '' then begin
                            lItem.TestField("Royalty Unit Price LCY");
                            CreateRoyaltySalesLine(Rec, lItem."Associated Royalty", lItem."Royalty Unit Price LCY");
                        end;
                    end;
                end;
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterValidateEvent', "Qty. to Ship", false, false)]
    local procedure OnAfterValidateQtyToShip(VAR Rec: Record "Sales Line")
    var
        lItem: Record Item;
        lText001: TextConst ENU = 'The quantity must be a multiple of Qty per Package : %1',
                            FRA = 'La quantité doit être un multiple de qté par carton : %1';
    begin
        if (Rec."Document Type" = rec."Document Type"::Order) and (Rec."Qty. to Ship" <> 0) then begin
            if Rec.Type = Rec.Type::Item then begin
                if lItem.Get(rec."No.") then begin

                    if lItem."Qty per Package" <> 0 then begin
                        if rec."Qty. to Ship" mod lItem."Qty per Package" <> 0 then begin
                            Error(lText001, lItem."Qty per Package");
                        end;
                    end;
                    if lItem."Associed Transport Item No." <> '' Then Begin
                        lItem.TestField("Transport Unit Price LCY");
                        CreateTransportSalesLine(Rec, lItem."Associed Transport Item No.", lItem."Transport Unit Price LCY");
                    End;

                    if lItem."Associated Royalty" <> '' then begin
                        lItem.TestField("Royalty Unit Price LCY");
                        CreateRoyaltySalesLine(Rec, lItem."Associated Royalty", lItem."Royalty Unit Price LCY");
                    end;
                end;
            end;
        end;
    end;

    procedure CreateTransportSalesLine(Var Rec: Record "Sales Line"; pTransportItemNo: Code[20]; TrsUniPrice: Decimal)
    var
        lSalesLine: Record "Sales Line";
        lItemTransport: Record Item;
    begin
        if lItemTransport.Get(pTransportItemNo) then
            if rec."Assoc. Transport Line No." <> 0 then begin
                if lSalesLine.Get(Rec."Document Type", Rec."Document No.", rec."Assoc. Transport Line No.") then begin
                    lSalesLine.Validate(Quantity, Rec.Quantity);
                    lSalesLine.Validate("Qty. to Ship", Rec."Qty. to Ship");
                    lSalesLine.Validate("Unit Price", TrsUniPrice);
                    lSalesLine.Modify();
                end;
            end else begin
                lSalesLine.Init();
                lSalesLine."Document Type" := Rec."Document Type";
                lSalesLine."Document No." := Rec."Document No.";
                lSalesLine."Line No." := Rec."Line No." + 500;
                lSalesLine."Type" := Rec."Type";
                lSalesLine.Validate("No.", lItemTransport."No.");
                lSalesLine."Location Code" := Rec."Location Code";
                lSalesLine.Validate(Quantity, Rec."Qty. to Ship");
                lSalesLine.Validate("Unit Price", TrsUniPrice);
                if lSalesLine.Insert() then
                    rec."Assoc. Transport Line No." := lSalesLine."Line No.";
            end;
    end;

    Procedure CreateRoyaltySalesLine(Var Rec: Record "Sales Line"; pRoyaltyNo: Code[20]; RoyaltyUniPrice: Decimal)
    var
        lSalesLineRDV: Record "Sales Line";
    begin

        if rec."Assoc. Royality Line No." <> 0 then begin
            if lSalesLineRDV.Get(Rec."Document Type", Rec."Document No.", Rec."Assoc. Royality Line No.") then Begin
                lSalesLineRDV.Validate(Quantity, Rec.Quantity);
                lSalesLineRDV.Validate("Qty. to Ship", Rec."Qty. to Ship");
                lSalesLineRDV.Validate("Unit Price", RoyaltyUniPrice);
                lSalesLineRDV.Modify();
            end;
        end else begin
            lSalesLineRDV.Init();
            lSalesLineRDV."Document Type" := Rec."Document Type";
            lSalesLineRDV."Document No." := Rec."Document No.";
            lSalesLineRDV."Line No." := Rec."Line No." + 700;
            lSalesLineRDV."Type" := Rec."Type"::"Charge (Item)";
            lSalesLineRDV.Validate("No.", pRoyaltyNo);
            lSalesLineRDV."Location Code" := Rec."Location Code";
            lSalesLineRDV.Validate(Quantity, Rec."Qty. to Ship");
            lSalesLineRDV.Validate("Unit Price", RoyaltyUniPrice);
            if lSalesLineRDV.Insert() then
                rec."Assoc. Royality Line No." := lSalesLineRDV."Line No.";
        end;
    end;
}