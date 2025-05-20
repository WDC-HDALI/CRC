pageextension 50015 "WDC Sales Order Subform" extends "Sales Order Subform"
{
    layout
    {
        modify("Qty. to Invoice")
        {
            Visible = false;
        }
        modify("Qty. to Assign")
        {
            Visible = false;
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
        }
        modify("Substitution Available")
        {
            Visible = false;
        }

        moveafter(Quantity; "Qty. to Ship")
        moveafter("Qty. to Ship"; "Qty. to Invoice")
        moveafter(Description; "Unit of Measure")
        moveafter("Line Amount"; "Quantity Shipped")
        moveafter("Quantity Shipped"; "Quantity Invoiced")
        moveafter("Quantity Invoiced"; "Planned Shipment Date")

    }
}