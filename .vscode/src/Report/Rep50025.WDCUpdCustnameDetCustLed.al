namespace CRC.CRC;

using Microsoft.Sales.History;
using Microsoft.Sales.Receivables;
using Microsoft.Sales.Customer;

report 50025 "WDC Upd Cust name Det Cust_Led"
{
    Caption = 'Update Update Det Cust Ledger';
    RDLCLayout = './.vscode/src/Report/RDLC/UpdtDetCust.rdl';
    // UseRequestPage = false;
    Permissions = tabledata "Detailed Cust. Ledg. Entry" = RIMD,
                  tabledata "Cust. Ledger Entry" = RIMD;
    ApplicationArea = All;
    UsageCategory = Lists;
    dataset
    {

        dataitem("Detailed Cust. Ledg. Entry"; "Detailed Cust. Ledg. Entry")
        {
            RequestFilterFields = "Entry No.";
            column(Entry_No_; "Entry No.")
            {
            }
        }
    }

    procedure UpdateDetCustLedgEntri()
    Var
        lPostedSalesInv: Record 112;
        InvoiceNo: code[20];
        lcustomer: record Customer;
        lDetCustLedgerEntry: Record "Detailed Cust. Ledg. Entry";
        lPostedCrMemo: Record 114;
        lCrMemoNo: Code[20];
    begin
        // if lDetCustLedgerEntry.get(pDetCustEntrieNo) then begin

        //     if (lDetCustLedgerEntry."Customer Name" = '') or (lDetCustLedgerEntry."Customer Name" = 'CLIENTS AU COMPTANT')
        //     or (lDetCustLedgerEntry."Customer Name" = 'MR MUSTAPHA') then begin
        //         if (StrLen(lDetCustLedgerEntry."Document No.") > 5) and (CopyStr(lDetCustLedgerEntry."Document No.", 1, 4) = 'REG-') then
        //             InvoiceNo := CopyStr(lDetCustLedgerEntry."Document No.", 5, StrLen(lDetCustLedgerEntry."Document No."))
        //         else if lDetCustLedgerEntry."Document Type" = lDetCustLedgerEntry."Document Type"::Invoice then
        //             InvoiceNo := lDetCustLedgerEntry."Document No."
        //         else if lDetCustLedgerEntry."Document Type" = lDetCustLedgerEntry."Document Type"::"Credit Memo" then
        //             lCrMemoNo := lDetCustLedgerEntry."Document No.";

        //         if InvoiceNo <> '' then begin
        //             lPostedSalesInv.Reset();
        //             lPostedSalesInv.SetFilter("No.", InvoiceNo);
        //             if lPostedSalesInv.FindFirst() then begin
        //                 lDetCustLedgerEntry."Customer Name" := lPostedSalesInv."Sell-to Customer Name";
        //                 lDetCustLedgerEntry.Modify();
        //             end;
        //         end;

        //         if lCrMemoNo <> '' then begin
        //             lPostedCrMemo.Reset();
        //             lPostedCrMemo.SetFilter("No.", lCrMemoNo);
        //             if lPostedCrMemo.FindFirst() then begin
        //                 lDetCustLedgerEntry."Customer Name" := lPostedCrMemo."Sell-to Customer Name";
        //                 lDetCustLedgerEntry.Modify();
        //             end;
        //         end;

        //     end;

        // if (lDetCustLedgerEntry."Customer Name" = '') or (lDetCustLedgerEntry."Customer Name" = 'MR MUSTAPHA') then begin
        //     if lcustomer.get(lDetCustLedgerEntry."Customer No.") then begin
        //         lDetCustLedgerEntry."Customer Name" := lcustomer.Name;
        //         lDetCustLedgerEntry.Modify();
        //     end;
        // end;
        // end;
        lDetCustLedgerEntry.reset;
        lDetCustLedgerEntry.SetCurrentKey("Customer No.", "Entry Type", "Posting Date", "Initial Document Type");
        lDetCustLedgerEntry.SetFilter("Customer Name", '');
        lDetCustLedgerEntry.SetFilter("Customer No.", '<>9999');
        if lDetCustLedgerEntry.FindSet() then
            repeat
                if lcustomer.get(lDetCustLedgerEntry."Customer No.") then begin
                    lDetCustLedgerEntry."Customer Name" := lcustomer.Name;
                    lDetCustLedgerEntry.Modify();
                end;
            until lDetCustLedgerEntry.Next() = 0;
    end;

    procedure UpdateCustLedgEntri(pCustEntrieNo: Integer)
    Var
        lPostedSalesInv: Record 112;
        lPostedCrMemo: Record 114;
        InvoiceNo: code[20];
        lcustomer: record Customer;
        lCustLedgerEntry: Record "Cust. Ledger Entry";
        lCrMemoNo: Code[20];
    begin
        // if lCustLedgerEntry.get(pCustEntrieNo) then begin

        //     if (lCustLedgerEntry."Customer Name" = '') or (lCustLedgerEntry."Customer Name" = 'CLIENTS AU COMPTANT')
        //     or (lCustLedgerEntry."Customer Name" = 'MR MUSTAPHA') then begin

        //         if (lCustLedgerEntry."Document Type" = lCustLedgerEntry."Document Type"::Payment) and (StrLen(lCustLedgerEntry."Document No.") > 5) and (CopyStr(lCustLedgerEntry."Document No.", 1, 4) = 'REG-') then
        //             InvoiceNo := CopyStr(lCustLedgerEntry."Document No.", 5, StrLen(lCustLedgerEntry."Document No."))
        //         else if lCustLedgerEntry."Document Type" = lCustLedgerEntry."Document Type"::Invoice then
        //             InvoiceNo := lCustLedgerEntry."Document No."
        //         else if lCustLedgerEntry."Document Type" = lCustLedgerEntry."Document Type"::"Credit Memo" then
        //             lCrMemoNo := lCustLedgerEntry."Document No.";

        //         if InvoiceNo <> '' then begin
        //             lPostedSalesInv.Reset();
        //             lPostedSalesInv.SetFilter("No.", InvoiceNo);
        //             if lPostedSalesInv.FindFirst() then begin
        //                 lCustLedgerEntry."Customer Name" := lPostedSalesInv."Sell-to Customer Name";
        //                 lCustLedgerEntry.Modify();
        //             end;
        //         end;

        //         if lCrMemoNo <> '' then begin
        //             lPostedCrMemo.Reset();
        //             lPostedCrMemo.SetFilter("No.", lCrMemoNo);
        //             if lPostedCrMemo.FindFirst() then begin
        //                 lCustLedgerEntry."Customer Name" := lPostedCrMemo."Sell-to Customer Name";
        //                 lCustLedgerEntry.Modify();
        //             end;
        //         end;
        //     end;

        //     if (lCustLedgerEntry."Customer Name" = '') or ((lCustLedgerEntry."Customer Name" = 'MR MUSTAPHA')) then begin

        //         if lcustomer.get(lCustLedgerEntry."Customer No.") then begin
        //             lCustLedgerEntry."Customer Name" := lcustomer.Name;
        //             lCustLedgerEntry.Modify();
        //         end;
        //     end;
        //     if lCustLedgerEntry."Document Type" = lCustLedgerEntry."Document Type"::"Payment" then begin
        //         lCustLedgerEntry.Description := 'Reçu N° ' + lCustLedgerEntry."Document No." + ' / ' + Format(lCustLedgerEntry."Payment Slip Type") + ' Du ' + Format(lCustLedgerEntry."Due Date");
        //         lCustLedgerEntry.Modify();
        //     end;

        // end;
    end;

}
