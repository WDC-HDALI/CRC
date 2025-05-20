page 50861 "WDC-ED Payment Status List"
{
    AutoSplitKey = true;
    CaptionML = ENU = 'Payment Status List', FRA = 'Liste des statuts règlement';
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
                field(Look; Rec.Look)
                {
                    ApplicationArea = All;
                }
                field(ReportMenu; Rec.ReportMenu)
                {
                    ApplicationArea = All;
                }
                field(RIB; Rec.RIB)
                {
                    ApplicationArea = All;
                }
                field("Acceptation Code"; Rec."Acceptation Code")
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
                field("Payment in Progress"; Rec."Payment in Progress")
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

