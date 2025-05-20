page 50862 "WDC-ED View/Edit Payment Line"
{
    CaptionML = ENU = 'View/Edit Payment Line', FRA = 'Afficher/Éditer ligne paiement';
    Editable = false;
    PageType = List;
    SourceTable = "WDC-ED Payment Status";
    SourceTableView = WHERE(Look = CONST(true));
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
            action("Payment Lines List")
            {
                ApplicationArea = All;
                CaptionML = ENU = 'Payment Lines List', FRA = 'Liste des lignes règlement';
                Image = ListPage;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "WDC-ED Payment Lines List";
                RunPageLink = "Payment Class" = FIELD("Payment Class"),
                              "Status No." = FIELD("Line No."),
                              "Copied To No." = FILTER('');
            }
        }
    }
}

