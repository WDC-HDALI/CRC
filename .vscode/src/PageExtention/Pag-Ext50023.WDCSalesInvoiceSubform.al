pageextension 50023 "WDC Sales Invoice Subform" extends "Sales Invoice Subform"
{
    layout
    {
        modify(Quantity)
        {
            trigger OnAfterValidate()
            begin
                CurrPage.Update();
            end;
        }


    }
}