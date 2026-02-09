report 50024 "Update Posting Date Invoice"
{
    RDLCLayout = './.vscode/src/Report/RDLC/UpdateDate_.rdlc';
    ApplicationArea = All;
    Caption = 'Update Invoice Date';
    UsageCategory = Lists;
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
                lsalesInvoice: Record 112;
                lsalesInvoiceLine: Record 113;
                lGLEntries: Record 17;
                lcustomerLedger: Record 21;
                lDetCustomerLeg: Record 379;
                lVatEntry: Record 254;
                lValueEntrie: Record 5802;
                lItemLedgerEntr: Record 32;

            begin
                if NewPostingDate = 0D then
                    Error('Vous devez saisir la date de la facture');
                if InvoiceNo = '' then
                    Error('Vous devez saisir le N° de la facture');
                lGLEntries.Reset();
                lGLEntries.SetRange("Document No.", InvoiceNo);
                if lGLEntries.FindSet() then
                    repeat
                        lGLEntries."Posting Date" := NewPostingDate;
                        lGLEntries.Modify();
                    until lGLEntries.Next() = 0;

                lVatEntry.Reset();
                lVatEntry.SetRange("Document No.", InvoiceNo);
                if lVatEntry.FindSet() then
                    repeat
                        lVatEntry."Posting Date" := NewPostingDate;
                        lVatEntry.Modify();
                    until lVatEntry.Next() = 0;

                lValueEntrie.Reset();
                lValueEntrie.SetRange("Document No.", InvoiceNo);
                if lValueEntrie.FindSet() then
                    repeat
                        lValueEntrie."Posting Date" := NewPostingDate;
                        lValueEntrie.Modify();
                    until lValueEntrie.Next() = 0;

                lDetCustomerLeg.Reset();
                lDetCustomerLeg.SetRange("Document No.", InvoiceNo);
                if lDetCustomerLeg.FindSet() then
                    repeat
                        lDetCustomerLeg."Posting Date" := NewPostingDate;
                        lDetCustomerLeg.Modify();
                    until lDetCustomerLeg.Next() = 0;

                lcustomerLedger.Reset();
                lcustomerLedger.SetRange("Document No.", InvoiceNo);
                if lcustomerLedger.FindSet() then
                    repeat
                        lcustomerLedger."Posting Date" := NewPostingDate;
                        lcustomerLedger.Modify();
                    until lcustomerLedger.Next() = 0;

                lItemLedgerEntr.Reset();
                lItemLedgerEntr.SetRange("Document No.", InvoiceNo);
                if lItemLedgerEntr.FindSet() then
                    repeat
                        lItemLedgerEntr."Posting Date" := NewPostingDate;
                        lItemLedgerEntr.Modify();
                    Until lItemLedgerEntr.Next() = 0;

                lsalesInvoiceLine.Reset();
                lsalesInvoiceLine.SetRange("Document No.", InvoiceNo);
                if lsalesInvoiceLine.FindFirst() then
                    repeat
                        lsalesInvoiceLine."Posting Date" := NewPostingDate;
                        lsalesInvoiceLine.Modify();
                    until lsalesInvoiceLine.Next() = 0;

                lsalesInvoice.Reset();
                lsalesInvoice.SetRange("No.", InvoiceNo);
                if lsalesInvoice.FindFirst() then begin
                    lsalesInvoice."Posting Date" := NewPostingDate;
                    lsalesInvoice.Modify();
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
                    field(InvoiceNo; InvoiceNo)
                    {
                        CaptionML = FRA = 'Facture No.';
                        ApplicationArea = all;
                    }
                    field(NewPostingDate; NewPostingDate)
                    {
                        CaptionML = FRA = 'Nouvelle Date';
                        ApplicationArea = all;
                    }
                }
            }
        }

    }
    var
        InvoiceNo: Code[20];
        NewPostingDate: Date;
}
