pageextension 50022 "WDC Transfer Order Subform" extends "Transfer Order Subform"
{
    layout
    {

        // modify("Qty. to Ship")
        // {
        //     trigger OnAfterValidate()
        //     begin
        //         rec.validate("Qty. to Receive", rec."Qty. to Ship");
        //     end;
        // }
        modify("Qty. to Receive")
        {
            Visible = false;
        }
        modify("Reserved Quantity Inbnd.")
        {
            Visible = false;
        }
        modify("Reserved Quantity Outbnd.")
        {
            Visible = false;
        }
        modify("Reserved Quantity Shipped")
        {
            Visible = false;
        }


    }
}