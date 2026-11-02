report 50039 "Upd Posting Date CustLegEntr"
{
    ApplicationArea = All;
    Caption = 'Update Cust. Ledger Entry Posting Date';
    UsageCategory = Lists;
    ProcessingOnly = true;
    Permissions = TableData "G/L Entry" = rimd,
   TableData "VAT Entry" = rimd,
   TableData "Value Entry" = rimd,
   TableData "Cust. Ledger Entry" = rimd,
   TableData "Detailed Cust. Ledg. Entry" = rimd,
   TableData "Bank Account Ledger Entry" = rimd;

    dataset
    {
        dataitem("Company Information"; 79)
        {
            column(CompanyName; "Company Information".Name)
            {
            }

            trigger OnAfterGetRecord()
            var
                lGLEntries: Record 17;
                lcustomerLedger: Record 21;
                lDetCustomerLeg: Record 379;
                lBankLedger: Record 271;
                lVatEntry: Record 254;
                lValueEntrie: Record 5802;

            begin
                if NewPostingDate = 0D then
                    Error('Vous devez saisir la date d''ecriture');
                if DocumentNo = '' then
                    Error('Vous devez saisir le N° du document');
                lGLEntries.Reset();
                lGLEntries.SetRange("Document No.", DocumentNo);
                if lGLEntries.FindSet() then
                    repeat
                        lGLEntries."Posting Date" := NewPostingDate;
                        lGLEntries.Modify();
                    until lGLEntries.Next() = 0;

                lVatEntry.Reset();
                lVatEntry.SetRange("Document No.", DocumentNo);
                if lVatEntry.FindSet() then
                    repeat
                        lVatEntry."Posting Date" := NewPostingDate;
                        lVatEntry.Modify();
                    until lVatEntry.Next() = 0;

                lValueEntrie.Reset();
                lValueEntrie.SetRange("Document No.", DocumentNo);
                if lValueEntrie.FindSet() then
                    repeat
                        lValueEntrie."Posting Date" := NewPostingDate;
                        lValueEntrie.Modify();
                    until lValueEntrie.Next() = 0;

                lDetCustomerLeg.Reset();
                lDetCustomerLeg.SetRange("Document No.", DocumentNo);
                if lDetCustomerLeg.FindSet() then
                    repeat
                        lDetCustomerLeg."Posting Date" := NewPostingDate;
                        lDetCustomerLeg.Modify();
                    until lDetCustomerLeg.Next() = 0;

                lcustomerLedger.Reset();
                lcustomerLedger.SetRange("Document No.", DocumentNo);
                if lcustomerLedger.FindSet() then
                    repeat

                        if lcustomerLedger."Document Type" = lcustomerLedger."Document Type"::Payment then begin
                            lBankLedger.Reset();
                            lBankLedger.SetRange("Document No.", DocumentNo);
                            if lBankLedger.FindSet() then
                                repeat
                                    lBankLedger."Posting Date" := NewPostingDate;
                                    lBankLedger.Modify();
                                Until lBankLedger.Next() = 0;
                        end;
                        lcustomerLedger."Posting Date" := NewPostingDate;
                        lcustomerLedger.Modify();


                    until lcustomerLedger.Next() = 0;

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
                    field(DocumentNo; DocumentNo)
                    {
                        CaptionML = FRA = 'Document No.';
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
        DocumentNo: Code[20];
        NewPostingDate: Date;
}
