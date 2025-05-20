pageextension 54043 "WDC-ST Posted Sales Invoices" extends "Posted Sales Invoices"
{
    layout
    {
        addafter("Amount Including VAT")
        {
            field("Stamp Amount"; Rec."Stamp Amount")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field(InvoiceAmount; InvoiceAmount)
            {
                CaptionML = ENU = 'Invoice Amount', FRA = 'Montant facture';
                ApplicationArea = All;
                Editable = false;
            }
        }

    }
    trigger OnAfterGetRecord()
    begin
        InvoiceAmount := Rec."Amount Including VAT" + Rec."Stamp Amount";
    end;

    Var
        InvoiceAmount: Decimal;
}