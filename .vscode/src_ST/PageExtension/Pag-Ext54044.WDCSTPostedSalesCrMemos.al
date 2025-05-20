pageextension 54044 "WDC-ST Posted Sales Cr. Memos" extends "Posted Sales Credit Memos"
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
            field(CreditMemoAmount; CreditMemoAmount)
            {
                CaptionML = ENU = 'Credit Memo Amount', FRA = 'Montant Avoir';
                ApplicationArea = All;
                Editable = false;
            }
        }

    }
    trigger OnAfterGetRecord()
    begin
        CreditMemoAmount := Rec."Amount Including VAT" + Rec."Stamp Amount";
    end;

    Var
        CreditMemoAmount: Decimal;
}