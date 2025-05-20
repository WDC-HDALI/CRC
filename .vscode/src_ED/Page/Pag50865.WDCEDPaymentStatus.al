page 50865 "WDC-ED Payment Status"
{
    AutoSplitKey = true;
    CaptionML = ENU = 'Payment Status', FRA = 'Statut règlement';
    DelayedInsert = true;
    PageType = List;
    SourceTable = "WDC-ED Payment Status";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Payment Class"; Rec."Payment Class")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(RIB; Rec.RIB)
                {
                    ApplicationArea = All;
                }
                field(Look; Rec.Look)
                {
                    ApplicationArea = All;
                }
                field(ReportMenu; Rec.ReportMenu)
                {
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                }
                field(Debit; Rec.Debit)
                {
                    ApplicationArea = All;
                }
                field(Credit; Rec.Credit)
                {
                    ApplicationArea = All;
                }
                field("Bank Account"; Rec."Bank Account")
                {
                    ApplicationArea = All;
                }
                field("Payment in Progress"; Rec."Payment in Progress")
                {
                    ApplicationArea = All;
                }
                field("Archiving Authorized"; Rec."Archiving Authorized")
                {
                    ApplicationArea = All;
                }
                field(AcceptationCode; Rec."Acceptation Code")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}

