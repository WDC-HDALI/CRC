page 50819 "WDC-ED Allowed Posting Range"
{
    CaptionML = ENU = 'Allowed Posting Range', FRA = 'Plage de validation autorisée';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "General Ledger Setup";

    layout
    {
        area(content)
        {
            group(Control1)
            {
                ShowCaption = false;
                field("Posting Allowed From"; Rec."Posting Allowed From")
                {
                    ApplicationArea = All;
                    CaptionML = ENU = 'Posting Allowed From', FRA = 'Début validation autorisée';
                    DrillDown = false;
                    Editable = false;
                }
                field(PostingAllowedTo; CalcDate('<-1D>', Rec."Posting Allowed To"))
                {
                    ApplicationArea = All;
                    CaptionML = ENU = 'Posting Allowed To', FRA = 'Fin validation autorisée';
                    Editable = false;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        Rec.CalcFields("Posting Allowed To");
    end;
}

