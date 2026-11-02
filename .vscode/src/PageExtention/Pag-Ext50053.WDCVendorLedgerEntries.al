pageextension 50053 "WDC Vendor Ledger Entries" extends "Vendor Ledger Entries"
/*********************documention**************/
//wdc01  wfc.fs  04/03/2026 Add Montant total DS
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
            //<<wdc01
            field("MontantDSTotal"; MontantDSTotal)
            {
                ApplicationArea = All;
                CaptionML = ENU = 'Total Amount LCY', FRA = 'Total montant DS';
                Editable = false;
            }
            //>>wdc01
        }
    }

    var
        MontantOuvertDSTotal: Decimal;
        MontantDSTotal: Decimal;

    trigger OnAfterGetCurrRecord()
    var
        VendLedgerEntry: Record "Vendor Ledger Entry";
    begin

        VendLedgerEntry.CopyFilters(Rec);


        MontantOuvertDSTotal := 0;
        MontantDSTotal := 0; //wdc01

        if VendLedgerEntry.FindSet() then begin
            repeat
                VendLedgerEntry.CalcFields("Remaining Amt. (LCY)");
                VendLedgerEntry.CalcFields("Amount (LCY)");  //wdc01
                MontantOuvertDSTotal += VendLedgerEntry."Remaining Amt. (LCY)";
                MontantDSTotal += VendLedgerEntry."Amount (LCY)"; //wdc01
            until VendLedgerEntry.Next() = 0;
        end;
    end;
}
