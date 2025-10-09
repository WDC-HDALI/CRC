report 50023 "Delete Ent"
{
    RDLCLayout = './.vscode/src/Report/RDLC/UpdateDate_.rdlc';
    ApplicationArea = All;
    Caption = 'Delete Vendor Ent';
    UsageCategory = Lists;
    Permissions = TableData "G/L Entry" = rimd,
   TableData "Detailed Vendor Ledg. Entry" = rimd,
   TableData "Vendor Ledger Entry" = rimd;

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
                lVendorLedger: Record "Vendor Ledger Entry";
                lVendorLedger1: Record "Vendor Ledger Entry";
                lDetVendLedg: Record "Detailed Vendor Ledg. Entry";


            begin
                lGLEntries.Reset();
                lGLEntries.SetFilter("Entry No.", '%1|%2', 2405, 2406);
                if lGLEntries.FindSet() then
                    repeat
                        lGLEntries.Delete();
                    until lGLEntries.Next() = 0;


                lDetVendLedg.Reset();
                lDetVendLedg.SetFilter("Entry No.", '%1|%2|%3', 839, 840, 841);
                if lDetVendLedg.FindSet() then
                    repeat
                        lDetVendLedg.Delete();
                    until lDetVendLedg.Next() = 0;

                lVendorLedger.Reset();
                lVendorLedger.SetFilter("Entry No.", '%1', 2406);
                if lVendorLedger.FindSet() then
                    lVendorLedger.Delete();

                lVendorLedger1.Reset();
                lVendorLedger1.SetFilter("Entry No.", '%1', 2403);
                if lVendorLedger1.FindSet() then begin
                    lVendorLedger1.Open := true;
                    lVendorLedger1.Modify();
                end;

            end;
        }
    }
    // requestpage
    // {
    //     layout
    //     {
    //         area(Content)
    //         {
    //             group(Filter)
    //             {
    //                 field(InvoiceNo; InvoiceNo)
    //                 {
    //                     CaptionML = FRA = 'Facture No.';
    //                     ApplicationArea = all;
    //                 }
    //                 field(NewPostingDate; NewPostingDate)
    //                 {
    //                     CaptionML = FRA = 'Nouvelle Date';
    //                     ApplicationArea = all;
    //                 }
    //             }
    //         }
    //     }

    // }
    var
        InvoiceNo: Code[20];
        NewPostingDate: Date;
}
