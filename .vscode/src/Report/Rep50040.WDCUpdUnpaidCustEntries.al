report 50040 "WDC Upd Unpaid Cust. Entries"
{
    CaptionML = ENU = 'Update Unpaid Customer Ledger Entries',
                FRA = 'Mise à jour des écritures clients impayées';
    ProcessingOnly = true;
    Permissions = TableData "Cust. Ledger Entry" = RIMD,
                  tabledata "Detailed Cust. Ledg. Entry" = RIMD;
    ApplicationArea = All;

    dataset
    {
        dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
        {

            DataItemTableView = sorting("Entry No.");
            ;
            trigger OnPreDataItem()
            var
            begin
                SetRange("Entry No.", EntryNo);
            end;

            trigger OnAfterGetRecord()
            var
                lDetCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
            begin

                lDetCustLedgEntry.Reset();
                lDetCustLedgEntry.SetCurrentKey("Cust. Ledger Entry No.", "Posting Date", "Ledger Entry Amount");
                lDetCustLedgEntry.SetRange("Cust. Ledger Entry No.", "Entry No.");
                lDetCustLedgEntry.SetRange("Entry Type", lDetCustLedgEntry."Entry Type"::"Initial Entry");
                if lDetCustLedgEntry.FindFirst() then begin
                    lDetCustLedgEntry.Unpaid := true;
                    lDetCustLedgEntry.Modify();
                end;
                "Cust. Ledger Entry".Unpaid := true;
                "Cust. Ledger Entry".Modify();
            end;
        }
    }
    procedure GetCustLedgerEntriesNo(pEntryNo: Integer)
    begin
        EntryNo := pEntryNo;
    end;

    var
        EntryNo: Integer;
}
