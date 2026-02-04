page 50046 "Suivi paiement Web"
{
    PageType = List;
    SourceTable = "Payment Tracking Buffer";
    Caption = 'Suivi paiement Web';
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(EntryNo; Rec."Entry No.")
                {
                    ApplicationArea = All;
                }
                field(DocumentNo; Rec."Document No.")
                {
                    ApplicationArea = All;
                }
                field(CustomerNo; Rec."Customer No.")
                {
                    ApplicationArea = All;
                }
                field(CustomerName; Rec."Customer Name")
                {
                    ApplicationArea = All;
                }
                field(Salesperson; Rec."Salesperson Code")
                {
                    ApplicationArea = All;
                }
                field(PostingDate; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field(ItemNo; Rec."Item No.")
                {
                    ApplicationArea = All;
                }
                field(ItemDescription; Rec."Item Description")
                {
                    ApplicationArea = All;
                }
                field(ItemCategory; Rec."Item Category Code")
                {
                    ApplicationArea = All;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                }
                field(AmountHT; Rec."Amount Excl. VAT")
                {
                    ApplicationArea = All;
                }
                field(AmountTTC; Rec."Amount Incl. VAT")
                {
                    ApplicationArea = All;
                }
                field(PaymentDoc; Rec."Payment Document No.")
                {
                    ApplicationArea = All;
                }
                field(PaymentAmount; Rec."Payment Amount")
                {
                    ApplicationArea = All;
                }
                field(PaymentType; Rec."Payment Type")
                {
                    ApplicationArea = All;
                }
                field(PaymentDate; Rec."Payment Date")
                {
                    ApplicationArea = All;
                }
                field(DueDate; Rec."Due Date")
                {
                    ApplicationArea = All;
                }
                field(UnitCost; Rec."Unit Cost")
                {
                    ApplicationArea = All;
                }
                field(CustomerAmount; Rec."Customer Amount")
                {
                    ApplicationArea = All;
                }
                field(ItemType; Rec."Item Type")
                {
                    ApplicationArea = All;
                }
                field(DocumentType; Rec."Document Type")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
