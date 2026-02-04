report 50035 "Rename Cr Memo"
{
    ProcessingOnly = true;
    ApplicationArea = All;
    Caption = 'Rename Credit Note';
    UsageCategory = Administration;
    Permissions = TableData "G/L Entry" = rimd,


   TableData "VAT Entry" = rimd,
   TableData "Value Entry" = rimd,
   TableData "Sales Invoice Line" = rimd,
   TableData "Cust. Ledger Entry" = rimd,
   TableData "Detailed Cust. Ledg. Entry" = rimd,
   TableData "Sales Invoice Header" = rimd,
   tableData "Item Ledger Entry" = rimd;

    dataset
    {
        dataitem("Company Information"; 79)
        {
            column(CompanyName; "Company Information".Name)
            {
            }

            trigger OnAfterGetRecord()
            var
                lSalescrMemo: Record 114;
                lSalescrMemoLine: Record 115;
                lGLEntries: Record 17;
                lcustomerLedger: Record 21;
                lDetCustomerLeg: Record 379;
                lVatEntry: Record 254;
                lValueEntrie: Record 5802;
                lItemLedgerEntr: Record 32;

            begin

                if (OldCrMemoNo = '') or (NewCrMemoNo = '') then
                    Error('Vous devez saisir le N° de l''avoir');
                lGLEntries.Reset();
                lGLEntries.SetRange("Document No.", OldCrMemoNo);
                if lGLEntries.FindSet() then
                    repeat
                        lGLEntries."Document No." := NewCrMemoNo;
                        lGLEntries.Description := 'Avoir ' + NewCrMemoNo;
                        lGLEntries.Modify();
                    until lGLEntries.Next() = 0;

                lVatEntry.Reset();
                lVatEntry.SetRange("Document No.", OldCrMemoNo);
                if lVatEntry.FindSet() then
                    lVatEntry.ModifyAll("Document No.", NewCrMemoNo);

                lValueEntrie.Reset();
                lValueEntrie.SetRange("Document No.", OldCrMemoNo);
                if lValueEntrie.FindSet() then
                    lValueEntrie.ModifyAll("Document No.", NewCrMemoNo);

                lDetCustomerLeg.Reset();
                lDetCustomerLeg.SetRange("Document No.", OldCrMemoNo);
                if lDetCustomerLeg.FindSet() then
                    lDetCustomerLeg.ModifyAll("Document No.", NewCrMemoNo);

                lcustomerLedger.Reset();
                lcustomerLedger.SetRange("Document No.", OldCrMemoNo);
                if lcustomerLedger.FindSet() then
                    repeat
                        lcustomerLedger."Document No." := NewCrMemoNo;
                        lcustomerLedger.Description := 'Avoir ' + NewCrMemoNo;
                        lcustomerLedger.Modify();
                    until lcustomerLedger.Next() = 0;

                lItemLedgerEntr.Reset();
                lItemLedgerEntr.SetRange("Document No.", OldCrMemoNo);
                if lItemLedgerEntr.FindSet() then
                    lItemLedgerEntr.ModifyAll("Document No.", NewCrMemoNo);

                lSalescrMemoLine.Reset();
                lSalescrMemoLine.SetRange("Document No.", OldCrMemoNo);
                if lSalescrMemoLine.FindFirst() then
                    repeat
                        lSalescrMemoLine.Rename(NewCrMemoNo, lSalescrMemoLine."Line No.");
                    until lSalescrMemoLine.Next() = 0;

                lSalescrMemo.Reset();
                lSalescrMemo.SetRange("No.", OldCrMemoNo);
                if lSalescrMemo.FindFirst() then begin
                    lSalescrMemo.Rename(NewCrMemoNo);
                end;
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Filter)
                {
                    field(OldCrMemoNo; OldCrMemoNo)
                    {
                        CaptionML = FRA = 'Ancien Avoir No.';
                        ApplicationArea = all;
                    }
                    field(NewCrMemoNo; NewCrMemoNo)
                    {
                        CaptionML = FRA = 'Nouvelle Avoir No.';
                        ApplicationArea = all;
                    }
                }
            }
        }

    }
    var
        OldCrMemoNo: Code[20];
        NewCrMemoNo: Code[20];
}
