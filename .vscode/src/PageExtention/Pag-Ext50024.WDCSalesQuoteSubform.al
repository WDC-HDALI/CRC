pageextension 50024 "WDC Sales Quote Subform" extends "Sales Quote Subform"
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
        modify("Qty. to Assemble to Order")
        {
            Visible = false;
        }
        modify(Quantity)
        {
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
        modify("Substitution Available")
        {
            Visible = false;
        }
        modify("Qty. Assigned")
        {
            Visible = false;
        }
        modify("Qty. to Assign")
        {
            Visible = false;
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
}