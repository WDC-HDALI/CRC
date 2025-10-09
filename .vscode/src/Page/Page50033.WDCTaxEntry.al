page 50033 "WDC Tax Ledger Update Page"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Tasks;
    CaptionML = ENU = 'Grouped Tax Entries', FRA = 'Ecritures TVA regroupées';
    layout
    {
        area(Content)
        {
            group(Filters)
            {
                CaptionML = ENU = 'Filters', FRA = 'Filtres';
                field(DateFrom; DateFrom)
                {
                    CaptionML = ENU = 'Start Date', FRA = 'Date début';
                }
                field(DateTo; DateTo)
                {
                    CaptionML = ENU = 'End Date', FRA = 'Date fin';
                }
                field(Purchase; Purchase)
                {
                    CaptionML = ENU = 'Purchase', FRA = 'Achats';
                }
                field(Sales; Sales)
                {
                    CaptionML = ENU = 'Sales', FRA = 'Ventes';
                }
            }

            // 🔹 Ajout de la liste
            part(TaxLedgerEntries; "WDC Details Tax Ledger Entry")
            {
                ApplicationArea = All;

            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Update)
            {
                CaptionML = ENU = 'Apply', FRA = 'Appliquer';
                ApplicationArea = All;
                PromotedCategory = Process;
                Promoted = true;
                PromotedIsBig = true;
                Image = Apply;
                trigger OnAction()
                var
                    TaxUpdate: Codeunit "WDC Tax Ledger Update";
                    Dialog: Dialog;
                begin
                    Dialog.Open('Traitement en cours ..');
                    TaxUpdate.UpdateTaxLedger(DateFrom, DateTo, Purchase, Sales);
                    Dialog.Close();
                    CurrPage.TaxLedgerEntries.PAGE.Update(false);
                end;
            }
        }

    }
    trigger OnOpenPage()
    Var
        TaxEntry: Record "WDC Tax Ledger Entry";
    begin
        Sales := true;
        TaxEntry.DeleteAll();
    end;

    var
        DateFrom: Date;
        DateTo: Date;
        Purchase: Boolean;
        Sales: Boolean;
}
