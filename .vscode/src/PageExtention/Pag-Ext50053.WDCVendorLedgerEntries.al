pageextension 50053 "WDC Vendor Ledger Entries" extends "Vendor Ledger Entries"
{
    layout
    {
        addlast(Content)
        {
            field("MontantOuvertDSTotal"; MontantOuvertDSTotal)
            {
                ApplicationArea = All;
                CaptionML = ENU = 'Total Open Amount LCY', FRA = 'Total montant ouvert DS';
                Editable = false;
            }
        }
    }

    var
        MontantOuvertDSTotal: Decimal;

    trigger OnAfterGetCurrRecord()
    var
        VendLedgerEntry: Record "Vendor Ledger Entry";
    begin

        VendLedgerEntry.CopyFilters(Rec);


        MontantOuvertDSTotal := 0;


        if VendLedgerEntry.FindSet() then begin
            repeat
                VendLedgerEntry.CalcFields("Remaining Amt. (LCY)");
                MontantOuvertDSTotal += VendLedgerEntry."Remaining Amt. (LCY)";
            until VendLedgerEntry.Next() = 0;
        end;
    end;
}
