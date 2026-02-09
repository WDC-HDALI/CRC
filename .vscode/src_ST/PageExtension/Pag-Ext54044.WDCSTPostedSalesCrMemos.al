pageextension 54044 "WDC-ST Posted Sales Cr. Memos" extends "Posted Sales Credit Memos"
{
    layout
    {
        modify("Posting Date")
        {
            Visible = true;
        }
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
                Style = Strong;
                Editable = false;
            }
        }

    }
    trigger OnAfterGetRecord()
    begin
        CreditMemoAmount := Rec."Amount Including VAT" + Rec."Stamp Amount";
    end;

    trigger OnOpenPage()
    begin
        rec.SetCurrentKey("Posting Date");
    end;

    Var
        CreditMemoAmount: Decimal;
}