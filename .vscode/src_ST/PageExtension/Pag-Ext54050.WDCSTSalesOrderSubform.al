pageextension 54050 "WDC-ST Sales Order Subform" extends "Sales Order Subform"
{
    layout
    {

        modify("Qty. to Assign")
        {
            Visible = false;
        }
        modify("Line Discount %")
        {
            trigger OnAfterValidate()
            begin
                CurrPage.Update();
            end;
        }
        modify("Line Discount Amount")
        {
            trigger OnAfterValidate()
            begin
                CurrPage.Update();
            end;
        }
        modify("Unit Price")
        {
            trigger OnAfterValidate()
            begin
                CurrPage.Update();
            end;
        }
        modify(Quantity)
        {
            trigger OnAfterValidate()
            begin
                CurrPage.Update();
            end;
        }
        modify("Qty. to Ship")
        {
            trigger OnAfterValidate()
            begin
                CurrPage.Update();
            end;
        }

    }

}