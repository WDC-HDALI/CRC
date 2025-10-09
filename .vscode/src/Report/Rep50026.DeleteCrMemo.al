report 50026 "Delete Cr Memo"
{
    RDLCLayout = './.vscode/src/Report/RDLC/Updatecrmemo_.rdlc';
    ApplicationArea = All;
    CaptionML = ENU = 'Delete Credit Note', FRA = 'Supprimer Avoir';
    UsageCategory = Lists;
    Permissions = TableData "G/L Entry" = rimd,
   TableData "VAT Entry" = rimd,
   TableData "Value Entry" = rimd,
   TableData "Cust. Ledger Entry" = rimd,
   TableData "Detailed Cust. Ledg. Entry" = rimd,
   TableData "Sales Cr.Memo Header" = rimd,
   TableData "Sales Cr.Memo Line" = rimd,
   TableData "Item Ledger Entry" = rimd;

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
                if confirm('Voulez-vous vriament supprimer l''avoir ' + CrMemoNo + '?') then begin
                    if (CrMemoNo = '') then
                        Error('Vous devez saisir le N° de l''avoir');
                    lGLEntries.Reset();
                    lGLEntries.SetRange("Document No.", CrMemoNo);
                    if lGLEntries.FindSet() then
                        repeat
                            lGLEntries.Delete();
                        until lGLEntries.Next() = 0;

                    lVatEntry.Reset();
                    lVatEntry.SetRange("Document No.", CrMemoNo);
                    if lVatEntry.FindSet() then
                        lVatEntry.DeleteAll();

                    lValueEntrie.Reset();
                    lValueEntrie.SetRange("Document No.", CrMemoNo);
                    if lValueEntrie.FindSet() then
                        lValueEntrie.DeleteAll();

                    lDetCustomerLeg.Reset();
                    lDetCustomerLeg.SetRange("Document No.", CrMemoNo);
                    if lDetCustomerLeg.FindSet() then
                        lDetCustomerLeg.DeleteAll();

                    lcustomerLedger.Reset();
                    lcustomerLedger.SetRange("Document No.", CrMemoNo);
                    if lcustomerLedger.FindSet() then
                        repeat
                            lcustomerLedger.Delete()
                        until lcustomerLedger.Next() = 0;

                    lItemLedgerEntr.Reset();
                    lItemLedgerEntr.SetRange("Document No.", CrMemoNo);
                    if lItemLedgerEntr.FindSet() then
                        lItemLedgerEntr.DeleteAll();

                    lSalescrMemoLine.Reset();
                    lSalescrMemoLine.SetRange("Document No.", CrMemoNo);
                    if lSalescrMemoLine.FindFirst() then
                        repeat
                            lSalescrMemoLine.Delete();
                        until lSalescrMemoLine.Next() = 0;

                    lSalescrMemo.Reset();
                    lSalescrMemo.SetRange("No.", CrMemoNo);
                    if lSalescrMemo.FindFirst() then begin
                        lSalescrMemo.Delete();
                    end;
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
                    field(CrMemoNo; CrMemoNo)
                    {
                        CaptionML = FRA = 'N° Avoir';
                        TableRelation = "Sales Cr.Memo Header";
                        ApplicationArea = all;
                    }
                }
            }
        }

    }
    var
        CrMemoNo: Code[20];
}
