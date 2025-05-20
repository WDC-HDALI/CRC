page 50863 "WDC-ED Payment Report"
{
    CaptionML = ENU = 'Payment Report', FRA = 'Etat règlement';
    Editable = false;
    PageType = List;
    SourceTable = "WDC-ED Payment Status";
    SourceTableView = WHERE(ReportMenu = CONST(true));
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Payment Class"; Rec."Payment Class")
                {
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(OK)
            {
                ApplicationArea = All;
                CaptionML = ENU = '&Print', FRA = '&Imprimer';
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    PaymentLine: Record "WDC-ED Payment Line";
                begin
                    PaymentLine.SetRange("Payment Class", Rec."Payment Class");
                    PaymentLine.SetRange("Status No.", Rec."Line No.");
                    REPORT.RunModal(REPORT::"WDC-ED Payment List", true, true, PaymentLine);
                end;
            }
        }
    }
}

