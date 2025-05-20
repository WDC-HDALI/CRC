page 50860 "WDC-ED Payment Class List"
{
    CaptionML = ENU = 'Payment Class List', FRA = 'Liste des types de règlement';
    Editable = false;
    PageType = List;
    SourceTable = "WDC-ED Payment Class";
    SourceTableView = WHERE(Enable = CONST(true));

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Code"; Rec.Code)
                {
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                }
                field(Enable; Rec.Enable)
                {
                    ApplicationArea = All;
                }
                field("Header No. Series"; Rec."Header No. Series")
                {
                    ApplicationArea = All;
                }
                field("Line No. Series"; Rec."Line No. Series")
                {
                    ApplicationArea = All;
                }
                field(Suggestions; Rec.Suggestions)
                {
                    ApplicationArea = All;
                }
                field("Is Create Document"; Rec."Is Create Document")
                {
                    ApplicationArea = All;
                }
                field("Unrealized VAT Reversal"; Rec."Unrealized VAT Reversal")
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

