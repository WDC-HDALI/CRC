report 50022 "Rename Invoice"
{
    RDLCLayout = './.vscode/src/Report/RDLC/Update_.rdlc';
    ApplicationArea = All;
    Caption = 'Rename Sales Invoice';
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

                if (OldInvoiceNo = '') or (NewInvoiceNo = '') then
                    Error('Vous devez saisir le N° de la facture');
                lGLEntries.Reset();
                lGLEntries.SetRange("Document No.", OldInvoiceNo);
                if lGLEntries.FindSet() then
                    repeat
                        lGLEntries."Document No." := NewInvoiceNo;
                        lGLEntries.Description := 'Facture ' + NewInvoiceNo;
                        lGLEntries.Modify();
                    until lGLEntries.Next() = 0;

                lVatEntry.Reset();
                lVatEntry.SetRange("Document No.", OldInvoiceNo);
                if lVatEntry.FindSet() then
                    lVatEntry.ModifyAll("Document No.", NewInvoiceNo);

                lValueEntrie.Reset();
                lValueEntrie.SetRange("Document No.", OldInvoiceNo);
                if lValueEntrie.FindSet() then
                    lValueEntrie.ModifyAll("Document No.", NewInvoiceNo);

                lDetCustomerLeg.Reset();
                lDetCustomerLeg.SetRange("Document No.", OldInvoiceNo);
                if lDetCustomerLeg.FindSet() then
                    lDetCustomerLeg.ModifyAll("Document No.", NewInvoiceNo);

                lcustomerLedger.Reset();
                lcustomerLedger.SetRange("Document No.", OldInvoiceNo);
                if lcustomerLedger.FindSet() then
                    repeat
                        lcustomerLedger."Document No." := NewInvoiceNo;
                        lcustomerLedger.Description := 'Facture ' + NewInvoiceNo;
                        lcustomerLedger.Modify();
                    until lcustomerLedger.Next() = 0;

                lItemLedgerEntr.Reset();
                lItemLedgerEntr.SetRange("Document No.", OldInvoiceNo);
                if lItemLedgerEntr.FindSet() then
                    lItemLedgerEntr.ModifyAll("Document No.", NewInvoiceNo);

                lsalesInvoiceLine.Reset();
                lsalesInvoiceLine.SetRange("Document No.", OldInvoiceNo);
                if lsalesInvoiceLine.FindFirst() then
                    repeat
                        lsalesInvoiceLine.Rename(NewInvoiceNo, lsalesInvoiceLine."Line No.");
                    until lsalesInvoiceLine.Next() = 0;

                lsalesInvoice.Reset();
                lsalesInvoice.SetRange("No.", OldInvoiceNo);
                if lsalesInvoice.FindFirst() then begin
                    lsalesInvoice.Rename(NewInvoiceNo);
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
                    field(OldInvoiceNo; OldInvoiceNo)
                    {
                        CaptionML = FRA = 'Ancien Facture No.';
                        ApplicationArea = all;
                    }
                    field(NewInvoiceNo; NewInvoiceNo)
                    {
                        CaptionML = FRA = 'Nouvelle Facture No.';
                        ApplicationArea = all;
                    }
                }
            }
        }

    }
    var
        OldInvoiceNo: Code[20];
        NewInvoiceNo: Code[20];
}
