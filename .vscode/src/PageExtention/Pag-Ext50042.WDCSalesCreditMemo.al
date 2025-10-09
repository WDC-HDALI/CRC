//****************Documentation**********************
//wdc01  WDC.FS  23/06/2025 Edit Price fields if button "Modify Prices" is checked in User Setup
pageextension 50042 "WDC Sales Credit Memo" extends "Sales Cr. Memo Subform"
{
    layout
    {

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


        modify("Line Discount %")
        {

            Editable = FieldEditable;
            QuickEntry = false;
        }
        modify("Unit of Measure Code")
        {
            Editable = FieldEditable;
        }


        modify(Description)
        {
            Editable = FieldEditable;
        }
        modify("location code")
        {
            Editable = FieldEditable;
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
    }
    trigger OnOpenPage();
    var
        UserSetup: Record "User Setup";
    begin
        if UserSetup.Get(UserId) then
            CanModifyPrices := UserSetup."Modify Sales Prices"
        else
            CanModifyPrices := false;
    end;

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


    //<<wdc01
}