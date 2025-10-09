//****************Documentation**********************
//wdc01  WDC.FS  23/06/2025 Edit Price fields if button "Modify Prices" is checked in User Setup
//wdc02  WDC.FS  24/06/2025 Lines cannot be edited 
pageextension 50015 "WDC Sales Order Subform" extends "Sales Order Subform"
{

    layout
    {
        addafter("Unit Price")
        {
            field("Unit Price Incl Discount"; Rec."Unit Price Incl Discount")
            {
                ApplicationArea = all;
                Editable = false;
                BlankZero = true;
            }
        }
        addafter("Line Amount")
        {
            field("Location Item Inventory"; Rec."Location Item Inventory")
            {
                ApplicationArea = all;
            }
        }
        modify("Qty. to Invoice")
        {
            Visible = false;
            Editable = FieldEditable;
            QuickEntry = false;

        }
        modify("Qty. to Assign")
        {
            Visible = false;
            Editable = FieldEditable;
            QuickEntry = false;
        }
        modify("Qty. Assigned")
        {
            Visible = false;
        }
        modify("Reserved Quantity")
        {
            Visible = false;
        }
        modify("Qty. to Assemble to Order")
        {
            Visible = false;
            Editable = FieldEditable;
        }
        modify("Substitution Available")
        {
            Visible = false;
        }
        modify("Qty. to Ship")
        {

            Editable = FieldEditable;
            QuickEntry = false;
            trigger OnAfterValidate()
            var
                lItem: Record Item;
                lText001: TextConst ENU = 'The quantity must be a multiple of Qty per Package : %1',
                            FRA = 'La quantité doit être un multiple de qté par carton : %1';
                SalesSubscriber: Codeunit "WDC Sales Subscribers";
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
                                SalesSubscriber.CreateTransportSalesLine(Rec, lItem."Associed Transport Item No.", lItem."Transport Unit Price LCY");
                            End;

                            if lItem."Associated Royalty" <> '' then begin
                                lItem.TestField("Royalty Unit Price LCY");
                                SalesSubscriber.CreateRoyaltySalesLine(Rec, lItem."Associated Royalty", lItem."Royalty Unit Price LCY");
                            end;
                        end;
                    end;
                end;
            end;
        }
        modify("Shipment Date")
        {

            Editable = FieldEditable;
            QuickEntry = false;
        }
        modify("FA Posting Date")
        {

            Editable = FieldEditable;
            QuickEntry = false;
        }
        modify("Line Discount %")
        {

            Editable = FieldEditable;
            //QuickEntry = false;
        }
        modify("Unit of Measure Code")
        {
            Editable = FieldEditable;
            QuickEntry = false;
        }
        modify(Quantity)
        {
            Editable = FieldEditable;
            //QuickEntry = false;
            trigger OnAfterValidate()
            var
                mm: page 131;
                lItem: Record Item;
                lItemTransport: Record Item;
                lSalesLine: Record "Sales Line";
                lSalesLineRDV: Record "Sales Line";
                lText001: TextConst ENU = 'The quantity must be a multiple of Qty per Package : %1',
                            FRA = 'La quantité doit être un multiple de qté par carton : %1';
                SalesSubscriber: Codeunit "WDC Sales Subscribers";
            begin
                if rec.Quantity <> 0 then begin
                    if Rec.Type = Rec.Type::Item then begin
                        if lItem.Get(rec."No.") then begin

                            if lItem."Qty per Package" <> 0 then begin
                                if rec.Quantity mod lItem."Qty per Package" <> 0 then begin
                                    Error(lText001, lItem."Qty per Package");
                                end;
                            end;

                            if ((Rec."Document Type" = rec."Document Type"::Invoice) and (Rec."Shipment No." = '')) or ((Rec."Document Type" = rec."Document Type"::"Order") and (Rec."Quantity Shipped" = 0)) or
                            (Rec."Document Type" = rec."Document Type"::Quote) then begin
                                if lItem."Associed Transport Item No." <> '' Then begin
                                    lItem.TestField("Transport Unit Price LCY");
                                    SalesSubscriber.CreateTransportSalesLine(Rec, lItem."Associed Transport Item No.", lItem."Transport Unit Price LCY");
                                end;
                                if lItem."Associated Royalty" <> '' then begin
                                    lItem.TestField("Royalty Unit Price LCY");
                                    SalesSubscriber.CreateRoyaltySalesLine(Rec, lItem."Associated Royalty", lItem."Royalty Unit Price LCY");
                                end;
                            end;
                        end;
                    end;
                end;
            end;
        }

        modify("Planned Delivery Date")
        {

            Editable = FieldEditable;
            QuickEntry = false;
        }
        modify("Planned shipment Date")
        {

            Editable = FieldEditable;
            QuickEntry = false;
        }
        modify(Description)
        {
            Editable = FieldEditable;
        }
        modify("location code")
        {
            Editable = FieldEditable;
            QuickEntry = false;
        }
        modify("No.")
        {
            Editable = FieldEditable;
            QuickEntry = true;
        }
        modify(Type)
        {
            Editable = FieldEditable;
            QuickEntry = false;
        }






        //<<wdc01
        modify("Unit Price")
        {
            Editable = UnitPriceEditable;
        }
        modify("Line Amount")
        {
            Editable = UnitPriceEditable;
        }
        modify("Unit Cost (LCY)")
        {
            Editable = UnitPriceEditable;
        }

        modify("Unit of Measure")
        {
            Visible = false;
        }
        moveafter("Line Discount %"; "Line Discount Amount")
        moveafter("Line Discount %"; "Line Amount")
        moveafter("Line Amount"; "Location Code")
        moveafter("Location Code"; "Unit of Measure")
        moveafter(Quantity; "Line Discount %")

    }
    trigger OnOpenPage()
    var
        UserSetup: Record "User Setup";
    begin
        if UserSetup.Get(UserId) then
            CanModifyPrices := UserSetup."Modify Sales Prices"
        else
            CanModifyPrices := false;
    end;


    //<<wdc02
    trigger OnAfterGetCurrRecord()

    var
        lItem: Record Item;
        lItemCharge: Record "Item Charge";
        IsSpecialItem: Boolean;
        IsSpecialCharge: Boolean;
    begin
        FieldEditable := true;

        IsSpecialItem := false;
        IsSpecialCharge := false;

        if Rec."No." <> '' then begin
            if lItem.Get(Rec."No.") then
                IsSpecialItem :=
                    (lItem."Transport Item" and lItem."Associated With Cement") or
                    (lItem."Transport Item" and lItem."Associated with Iron");

            if lItemCharge.Get(Rec."No.") then
                IsSpecialCharge := not lItemCharge."Not Editable in Sales Line";
        end;

        if (IsSpecialItem or IsSpecialCharge) then begin
            FieldEditable := false;
            UnitPriceEditable := FieldEditable
        end
        else
            UnitPriceEditable := CanModifyPrices;
    end;


    var
        CanModifyPrices: Boolean;
        FieldEditable: Boolean;
        UnitPriceEditable: Boolean;


    //<<wdc02

}
