codeunit 50000 "WDC Sales Subscribers"
//****************Documentation***************
//WDC01  WDC.HG  26/06/2025  Change Posting Serie No.
//WDC02  WDC.HG  03/07/2025  update "SalesPersonCode" on the Posted Sales  Invoice
//WDC03  WDC.HG  09/07/2025  desable the update  of "VAT Registration No." of customer from the invoice
//WDC04  WDC.FS  24/07/2025  Add fields in Posted Sales Shipment Subform
//WDC05  WDC.HG  29/08/2025  set the "Remain. Qty to Delivery" to negative while undo the shipment
//WDC06  WDC.FS  01/09/2025  Force shipping when posting a sales order for passenger customer
//WDC07  WDC.FS  02/09/2025  Set Posting Date to WorkDate when releasing Sales Order/Sales Invoice/Sales Credit Memo
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
        SalesHeader.TestField("Prices Including VAT", false);
        if SalesHeader."Document Type" = SalesHeader."Document Type"::Order then begin
            if Not Confirm(StrSubstNo(lText001)) then
                Error(lText002);
            DefaultOption := 1;
            HideDialog := true;
            SalesHeader.Ship := true;
        end;
    end;

    //<< enleve le controle d'affectation Frais annexes Vente
    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", OnBeforeInsertICGenJnlLine, '', false, false)]
    // local procedure OnBeforeInsertICGenJnlLine(var ICGenJournalLine: Record "Gen. Journal Line"; SalesHeader: Record "Sales Header"; SalesLine: Record "Sales Line"; CommitIsSuppressed: Boolean)
    // begin
    //     ICGenJournalLine.Description := SalesHeader."Sell-to Customer Name";
    // end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", OnCheckSalesDocumentOnAfterCalcShouldCheckItemCharge, '', false, false)]
    local procedure OnCheckSalesDocumentOnAfterCalcShouldCheckItemCharge(var SalesHeader: Record "Sales Header"; WhseReceive: Boolean; WhseShip: Boolean; var ShouldCheckItemCharge: Boolean; var ModifyHeader: Boolean)
    begin
        ShouldCheckItemCharge := false;
    end;
    //>>

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", OnBeforeSalesShptLineInsert, '', false, false)]
    local procedure OnBeforeSalesStLhpineInsert(var SalesShptLine: Record "Sales Shipment Line"; SalesShptHeader: Record "Sales Shipment Header"; SalesLine: Record "Sales Line"; CommitIsSuppressed: Boolean; PostedWhseShipmentLine: Record "Posted Whse. Shipment Line"; SalesHeader: Record "Sales Header"; WhseShip: Boolean; WhseReceive: Boolean; ItemLedgShptEntryNo: Integer; xSalesLine: record "Sales Line"; var TempSalesLineGlobal: record "Sales Line" temporary; var IsHandled: Boolean)
    var
        lItem: Record Item;
    begin
        if SalesShptLine.Type = SalesShptLine.Type::Item then begin
            if lItem.Get(SalesShptLine."No.") then begin
                if lItem.Type = lItem.Type::Inventory then
                    SalesShptLine."Remain. Qty to Delivery" := SalesShptLine.Quantity;
            end;
        end;
        //<<WDC04
        // SalesShptLine."Line amount" := SalesShptLine.Quantity * SalesShptLine."Unit Price";
        // SalesShptLine."Amount Incl VAT" := SalesLine."amount including VAT";
        // SalesShptLine."Line Discount amount" := SalesLine."Line Discount Amount";
        // SalesShptLine."Shipped Not Inv Amount HT" := SalesLine."Shipped Not Inv. (LCY) No VAT";

        //>>WDC04
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

    //<<WDC03
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Alt. Cust. VAT. Reg. Facade", 'OnBeforeUpdateVATRegNoInCustFromSalesHeader', '', false, false)]
    local procedure OnBeforeUpdateVATRegNoInCustFromSalesHeader(var SalesHeader: Record "Sales Header"; Customer: Record Customer; var ShouldUpdate: Boolean; var IsHandled: Boolean)
    begin
        IsHandled := true;
        ShouldUpdate := False;
    end;
    //>>WDC03

    //<<wdc06
    [EventSubscriber(ObjectType::Codeunit, codeunit::"Sales-Post", 'OnBeforeCheckHeaderPostingType', '', false, false)]
    local procedure OnBeforeCheckHeaderPostingType(var SalesHeader: Record "Sales Header"; var IsHandled: Boolean)
    var
        lCustomer: Record Customer;
        lText001: TextConst ENU = 'You cannot release a sales order for a passenger customer. Instead, click on "Make Invoice".',
                            FRA = 'Vous ne pouvez pas valider une commande de vente pour un client passager. Cliquez plutôt sur "Créer une facture".';
        lText002: TextConst ENU = 'You must enter the salesperson code',
                            FRA = 'Vous devez saisir le code vendeur';
        lUserSetup: Record "User Setup";
    begin
        if SalesHeader."Document Type" = SalesHeader."Document Type"::Order then begin
            if lCustomer.Get(SalesHeader."Sell-to Customer No.") then begin
                if (lCustomer."Customer Posting Group" = 'C-PASSAGER') then begin
                    Error(lText001);
                    IsHandled := true;
                end;
            end;
        end;
        if SalesHeader."Document Type" = SalesHeader."Document Type"::"Credit Memo" then
            if SalesHeader."Salesperson Code" = '' then
                Error(lText002);
        if lUserSetup.Get(UserId) then
            if Not lUserSetup."Allow Upd Sales Posting Date" then
                SalesHeader.Validate("Posting Date", WorkDate());//WDC07
    end;
    //>>wdc06
    var

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

    //<<WDC01
    [EventSubscriber(ObjectType::Table, database::"Sales header", OnAfterOnInsert, '', FALSE, FALSE)]
    local procedure OnAfterOnInsert(var SalesHeader: Record "Sales Header")
    var
        lSalesSetup: record "Sales & Receivables Setup";
    begin
        lSalesSetup.get();
        if SalesHeader."Document Type" = salesheader."Document Type"::Invoice then
            if SalesHeader."Customer Posting Group" = 'C-PASSAGER' then
                SalesHeader.validate("Posting No. Series", lSalesSetup."Posted Cash Invoice No.")
            else
                SalesHeader.validate("Posting No. Series", lSalesSetup."Posted Term Invoice No.");
    end;
    //>>WDC01

    //<<Control Deleting Posted document
    [EventSubscriber(ObjectType::Table, database::"Sales Invoice Header", OnBeforeDeleteEvent, '', FALSE, FALSE)]
    local procedure OnBeforeDeleteEvent(var Rec: Record "Sales Invoice Header")
    var
        ltext001: TextConst ENU = 'You cannot delete a posted document', FRA = 'Vous ne pouvez pas supprimer un document validé';
        luserSetup: Record "User Setup";
    begin
        if luserSetup.Get(UserId) then
            if not luserSetup."Allow Delete sales Invoice" then
                error(ltext001)
    end;

    [EventSubscriber(ObjectType::Table, database::"Sales Cr.Memo Header", OnBeforeDeleteEvent, '', FALSE, FALSE)]
    local procedure OnBeforeDeleteEventCRMemo(var Rec: Record "Sales Cr.Memo Header")
    var
        ltext001: TextConst ENU = 'You cannot delete a posted document', FRA = 'Vous ne pouvez pas supprimer un document validé';
        luserSetup: Record "User Setup";
    begin
        if luserSetup.Get(UserId) then
            if not luserSetup."Allow Delete sales cr memo" then
                error(ltext001)
    end;

    [EventSubscriber(ObjectType::Table, database::"Sales Shipment Header", OnBeforeDeleteEvent, '', FALSE, FALSE)]
    local procedure OnBeforeDeleteEventshp(var Rec: Record "Sales Shipment Header")
    var
        ltext001: TextConst ENU = 'You cannot delete a posted document', FRA = 'Vous ne pouvez pas supprimer un document validé';
        luserSetup: Record "User Setup";
    begin
        if luserSetup.Get(UserId) then
            if not luserSetup."Allow Delete sales Invoice" then
                error(ltext001)
    end;

    [EventSubscriber(ObjectType::Table, database::"Return Receipt Header", OnBeforeDeleteEvent, '', FALSE, FALSE)]
    local procedure OnBeforeDeleteEventRetRec(var Rec: Record "Return Receipt Header")
    var
        ltext001: TextConst ENU = 'You cannot delete a posted document', FRA = 'Vous ne pouvez pas supprimer un document validé';
    begin
        // error(ltext001)
    end;
    //>>Control Deleting Posted document

    [EventSubscriber(ObjectType::Table, database::Customer, OnBeforeModifyEvent, '', FALSE, FALSE)]
    local procedure OnBeforeModifyEventCustomer(var Rec: Record Customer)
    var
        lText001: TextConst ENU = 'You are not allowed to modify customer information.',
                            FRA = 'Vous n''êtes pa autoriser de modifier client';
    begin
        UserSetup.Get(UserId);
        if not UserSetup."Allow Modify Customer" then
            Error(lText001);

    end;
    //<<WDC02
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales Inv. Header - Edit", 'OnRunOnBeforeAssignValues', '', false, false)]
    local procedure OnRunOnBeforeAssignValues(var SalesInvoiceHeader: Record "Sales Invoice Header"; SalesInvoiceHeaderRec: Record "Sales Invoice Header")
    begin
        SalesInvoiceHeader."Bill-to Name" := SalesInvoiceHeaderRec."Bill-to Name";
        SalesInvoiceHeader."Sell-to Customer Name" := SalesInvoiceHeaderRec."Sell-to Customer Name";
    end;

    [EventSubscriber(ObjectType::Page, page::"Posted Sales Inv. - Update", 'OnAfterRecordChanged', '', false, false)]
    local procedure OnAfterRecordChanged(var SalesInvoiceHeader: Record "Sales Invoice Header"; xSalesInvoiceHeader: Record "Sales Invoice Header"; var IsChanged: Boolean)
    begin
        IsChanged := IsChanged OR (SalesInvoiceHeader."Salesperson Code" <> xSalesInvoiceHeader."Salesperson Code") OR
                     (SalesInvoiceHeader."Due Date" <> xSalesInvoiceHeader."Due Date") or
                     (SalesInvoiceHeader."Bill-to Name" <> xSalesInvoiceHeader."Bill-to Name") or
                     (SalesInvoiceHeader."Sell-to Customer Name" <> xSalesInvoiceHeader."Sell-to Customer Name");

    end;

    [EventSubscriber(ObjectType::Page, page::"Pstd. Sales Cr. Memo - Update", 'OnAfterRecordChanged', '', false, false)]
    local procedure OnAfterCrMemoChanged(var SalesCrMemoHeader: Record "Sales Cr.Memo Header"; xSalesCrMemoHeader: Record "Sales Cr.Memo Header"; var IsChanged: Boolean)
    begin
        IsChanged := IsChanged OR (SalesCrMemoHeader."Salesperson Code" <> xSalesCrMemoHeader."Salesperson Code");
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales Inv. Header - Edit", 'OnOnRunOnBeforeTestFieldNo', '', false, false)]
    local procedure OnOnRunOnBeforeTestFieldNo(var SalesInvoiceHeader: Record "Sales Invoice Header"; SalesInvoiceHeaderRec: Record "Sales Invoice Header")
    begin
        SalesInvoiceHeader."Salesperson Code" := SalesInvoiceHeaderRec."Salesperson Code";
        SalesInvoiceHeader."Due Date" := SalesInvoiceHeaderRec."Due Date";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales Credit Memo Hdr. - Edit", 'OnBeforeSalesCrMemoHeaderModify', '', false, false)]
    procedure OnBeforeSalesCrMemoHeaderModify(var SalesCrMemoHeader: Record "Sales Cr.Memo Header"; FromSalesCrMemoHeader: Record "Sales Cr.Memo Header")
    begin
        SalesCrMemoHeader."Salesperson Code" := FromSalesCrMemoHeader."Salesperson Code";
    end;
    //<<WDC03
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterPostGLAndCustomer', '', false, false)]
    local procedure OnAfterPostGLAndCustomer(var SalesHeader: Record "Sales Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; TotalSalesLine: Record "Sales Line"; TotalSalesLineLCY: Record "Sales Line"; CommitIsSuppressed: Boolean;
            WhseShptHeader: Record "Warehouse Shipment Header"; WhseShip: Boolean; var TempWhseShptHeader: Record "Warehouse Shipment Header"; var SalesInvHeader: Record "Sales Invoice Header"; var SalesCrMemoHeader: Record "Sales Cr.Memo Header";
            var CustLedgEntry: Record "Cust. Ledger Entry"; var SrcCode: Code[10]; GenJnlLineDocNo: Code[20]; GenJnlLineExtDocNo: Code[35]; var GenJnlLineDocType: Enum "Gen. Journal Document Type"; PreviewMode: Boolean; DropShipOrder: Boolean)
    var
        lDetCustLedgEnt: record "Detailed Cust. Ledg. Entry";

    begin

        if SalesHeader."Sell-to Customer No." = '9999' then begin
            CustLedgEntry."Customer Name" := SalesHeader."Sell-to Customer Name";
        end;

    end;
    //>>WDC03



    //<<ModificationNomClientComptantDansLesEcritures
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnBeforeCustLedgEntryInsert', '', false, false)]
    local procedure OnBeforeCustLedgEntryInsert(var CustLedgerEntry: Record "Cust. Ledger Entry"; var GenJournalLine: Record "Gen. Journal Line"; GLRegister: Record "G/L Register"; var TempDtldCVLedgEntryBuf: Record "Detailed CV Ledg. Entry Buffer"; var NextEntryNo: Integer)
    var
        lSalesInvoiceHeader: record "Sales Invoice Header";
        lcustomer: record Customer;
        GeneralSetup: record "General Ledger Setup";
    begin
        GeneralSetup.get();
        if GenJournalLine."Document Type" = GenJournalLine."Document Type"::Invoice then begin
            lSalesInvoiceHeader.reset();
            if lSalesInvoiceHeader.get(GenJournalLine."Document No.") then
                if lcustomer.get(lSalesInvoiceHeader."Sell-to Customer No.") then
                    if lcustomer."Customer Posting Group" = 'C-PASSAGER' then
                        CustLedgerEntry."Customer Name" := lSalesInvoiceHeader."Sell-to Customer Name";
        end;
        if GenJournalLine."Journal Batch Name" = GeneralSetup."Payment Sheet" then begin
            if (GenJournalLine."Document Type" = GenJournalLine."Document Type"::Payment) or (GenJournalLine."Document Type" = GenJournalLine."Document Type"::" ") then begin
                if GenJournalLine."Applies-to Doc. Type" = GenJournalLine."Applies-to Doc. Type"::Invoice then begin
                    lSalesInvoiceHeader.reset();
                    if lSalesInvoiceHeader.get(GenJournalLine."Applies-to Doc. No.") then
                        if lcustomer.get(lSalesInvoiceHeader."Sell-to Customer No.") then
                            if lcustomer."Customer Posting Group" = 'C-PASSAGER' then
                                CustLedgerEntry."Customer Name" := lSalesInvoiceHeader."Sell-to Customer Name";
                end;
            end
        end;

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnBeforeInsertDtldCustLedgEntry', '', false, false)]
    local procedure OnBeforeInsertDtldCustLedgEntry(var DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry"; GenJournalLine: Record "Gen. Journal Line"; DtldCVLedgEntryBuffer: Record "Detailed CV Ledg. Entry Buffer"; GLRegister: Record "G/L Register")
    var
        lSalesInvoiceHeader: record "Sales Invoice Header";
        lcustomer: record Customer;
        GeneralSetup: record "General Ledger Setup";
    begin
        GeneralSetup.get();
        if GenJournalLine."Document Type" = GenJournalLine."Document Type"::Invoice then begin
            lSalesInvoiceHeader.reset();
            if lSalesInvoiceHeader.get(GenJournalLine."Document No.") then
                if lcustomer.get(lSalesInvoiceHeader."Sell-to Customer No.") then
                    if lcustomer."Customer Posting Group" = 'C-PASSAGER' then
                        DtldCustLedgEntry."Customer Name" := lSalesInvoiceHeader."Sell-to Customer Name";
        end;

        if GenJournalLine."Journal Batch Name" = GeneralSetup."Payment Sheet" then begin
            if (GenJournalLine."Document Type" = GenJournalLine."Document Type"::Payment) or (GenJournalLine."Document Type" = GenJournalLine."Document Type"::" ") then begin
                if GenJournalLine."Applies-to Doc. Type" = GenJournalLine."Applies-to Doc. Type"::Invoice then begin
                    lSalesInvoiceHeader.reset();
                    if lSalesInvoiceHeader.get(GenJournalLine."Applies-to Doc. No.") then
                        if lcustomer.get(lSalesInvoiceHeader."Sell-to Customer No.") then
                            if lcustomer."Customer Posting Group" = 'C-PASSAGER' then
                                DtldCustLedgEntry."Customer Name" := lSalesInvoiceHeader."Sell-to Customer Name";
                end;
            end
        end;
    end;

    //<<WDC05
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Undo Sales Shipment Line", 'OnBeforeNewSalesShptLineInsert', '', false, false)]
    local procedure OnBeforeNewSalesShptLineInsert(var NewSalesShipmentLine: Record "Sales Shipment Line"; OldSalesShipmentLine: Record "Sales Shipment Line")
    begin
        NewSalesShipmentLine."Remain. Qty to Delivery" := -OldSalesShipmentLine."Remain. Qty to Delivery";
    end;
    //>>WDC05


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnInsertValueEntryOnBeforeRoundAmtValueEntry', '', false, false)]
    local procedure OnInsertValueEntryOnBeforeRoundAmtValueEntry(var ValueEntry: Record "Value Entry"; var ItemLedgEntry: Record "Item Ledger Entry"; ItemJnlLine: Record "Item Journal Line"; TransferItem: Boolean)
    var
        lItemLedgerEntry: record "Item Ledger Entry";
        lUpdateSalesShipmentLine: report "WDC Update Sales Shipment Line";
    begin
        if ValueEntry."Document Type" = ValueEntry."Document Type"::"Sales Credit Memo" then begin
            if lItemLedgerEntry.get(ItemJnlLine."Applies-from Entry") then begin
                if lItemLedgerEntry."Document Type" = lItemLedgerEntry."Document Type"::"Sales Shipment" then
                    lUpdateSalesShipmentLine.UpdateRemainQtyToDeliveryWithReturnedQuantity(lItemLedgerEntry."Document No.", lItemLedgerEntry."Document Line No.", (abs(ItemJnlLine.Quantity)));
            end;
        end;
    end;

    var
        IsEditablee: Boolean;
        UserSetup: Record "User Setup";
}