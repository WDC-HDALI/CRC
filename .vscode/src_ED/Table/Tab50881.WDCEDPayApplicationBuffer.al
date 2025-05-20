table 50881 "WDC-ED Pay. Application Buffer"
{
    CaptionML = ENU = 'Payment Application Buffer', FRA = 'Tampon d''application de paiement';

    fields
    {
        field(1; "Invoice Entry No."; Integer)
        {
            CaptionML = ENU = 'Invoice Entry No.', FRA = 'N° écriture facture';
        }
        field(2; "Pmt. Entry No."; Integer)
        {
            CaptionML = ENU = 'Pmt. Entry No.', FRA = 'N° écriture payment';
        }
        field(3; "Posting Date"; Date)
        {
            CaptionML = ENU = 'Posting Date', FRA = 'Date comptabilisation';
        }
        field(4; "Document Type"; Enum "Gen. Journal Document Type")
        {
            CaptionML = ENU = 'Document Type', FRA = 'Type document';
        }
        field(5; "Due Date"; Date)
        {
            CaptionML = ENU = 'Due Date', FRA = 'Date d''échéance';
        }
        field(6; "Pmt. Posting Date"; Date)
        {
            CaptionML = ENU = 'Pmt. Posting Date', FRA = 'Date comptabilisation payment';
        }
        field(7; "Invoice Is Open"; Boolean)
        {
            CaptionML = ENU = 'Invoice Is Open', FRA = 'La facture est ouverte';
        }
        field(10; "Invoice Doc. No."; Code[20])
        {
            CaptionML = ENU = 'Invoice Doc. No.', FRA = 'N° document facture';
        }
        field(11; "CV No."; Code[20])
        {
            CaptionML = ENU = 'CV No.', FRA = 'N° cv';
        }
        field(12; "Inv. External Document No."; Code[35])
        {
            CaptionML = ENU = 'Inv. External Document No.', FRA = 'N° document externe facture';
        }
        field(13; "Pmt. Doc. No."; Code[20])
        {
            CaptionML = ENU = 'Pmt. Doc. No.', FRA = 'N° document payment';
        }
        field(20; "Entry Amount (LCY)"; Decimal)
        {
            CaptionML = ENU = 'Entry Amount (LCY)', FRA = 'Montant écriture';
        }
        field(21; "Pmt. Amount (LCY)"; Decimal)
        {
            CaptionML = ENU = 'Pmt. Amount (LCY)', FRA = 'Montant payment';
        }
        field(22; "Remaining Amount (LCY)"; Decimal)
        {
            CaptionML = ENU = 'Remaining Amount (LCY)', FRA = 'Montant restant';
        }
        field(23; "Entry Amount Corrected (LCY)"; Decimal)
        {
            CaptionML = ENU = 'Entry Amount Corrected (LCY)', FRA = 'Montant d''entrée corrigé';
        }
        field(30; "Days Since Due Date"; Integer)
        {
            CaptionML = ENU = 'Days Since Due Date', FRA = 'Jours depuis la date d''échéance';
        }
        field(31; "Pmt. Days Delayed"; Integer)
        {
            CaptionML = ENU = 'Pmt. Days Delayed', FRA = 'Jours de retard payment';
        }
    }

    keys
    {
        key(Key1; "Invoice Entry No.", "Pmt. Entry No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    procedure InsertVendorInvoice(VendorLedgerEntry: Record "Vendor Ledger Entry"; TotalPmtAmount: Decimal; CorrectionAmount: Decimal)
    begin
        Init;
        "Pmt. Entry No." := 0;
        CopyFromInvoiceVendLedgEntry(VendorLedgerEntry);
        InsertInvoice(TotalPmtAmount, CorrectionAmount);
    end;

    procedure InsertCustomerInvoice(CustLedgerEntry: Record "Cust. Ledger Entry"; TotalPmtAmount: Decimal; CorrectionAmount: Decimal)
    begin
        Init;
        "Pmt. Entry No." := 0;
        CopyFromInvoiceCustLedgEntry(CustLedgerEntry);
        InsertInvoice(TotalPmtAmount, CorrectionAmount);
    end;

    local procedure InsertInvoice(TotalPmtAmount: Decimal; CorrectionAmount: Decimal)
    begin
        "Days Since Due Date" := WorkDate - "Due Date";
        if "Days Since Due Date" < 0 then
            "Days Since Due Date" := 0;
        "Pmt. Amount (LCY)" := TotalPmtAmount;
        "Entry Amount Corrected (LCY)" := "Entry Amount (LCY)" + CorrectionAmount;
        "Remaining Amount (LCY)" := "Entry Amount Corrected (LCY)" + "Pmt. Amount (LCY)";
        Insert;
    end;

    procedure InsertVendorPayment(InvVendorLedgerEntry: Record "Vendor Ledger Entry"; PmtDtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry")
    begin
        Init;
        CopyFromInvoiceVendLedgEntry(InvVendorLedgerEntry);
        InsertPayment(
          PmtDtldVendLedgEntry."Entry No.", PmtDtldVendLedgEntry."Posting Date",
          PmtDtldVendLedgEntry."Document No.", PmtDtldVendLedgEntry."Amount (LCY)");
    end;

    procedure InsertCustomerPayment(InvCustLedgerEntry: Record "Cust. Ledger Entry"; PmtDtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry")
    begin
        Init;
        CopyFromInvoiceCustLedgEntry(InvCustLedgerEntry);
        InsertPayment(
          PmtDtldCustLedgEntry."Entry No.", PmtDtldCustLedgEntry."Posting Date",
          PmtDtldCustLedgEntry."Document No.", PmtDtldCustLedgEntry."Amount (LCY)");
    end;

    local procedure InsertPayment(EntryNo: Integer; PmtPostingDate: Date; PmtDocNo: Code[20]; PmtAmount: Decimal)
    begin
        "Pmt. Entry No." := EntryNo;
        "Pmt. Posting Date" := PmtPostingDate;
        "Pmt. Doc. No." := PmtDocNo;
        "Pmt. Days Delayed" := "Pmt. Posting Date" - "Due Date";
        if "Pmt. Days Delayed" < 0 then
            "Pmt. Days Delayed" := 0;
        "Pmt. Amount (LCY)" := PmtAmount;
        Insert;
    end;

    procedure CalcSumOfAmountFields()
    begin
        CalcSums("Remaining Amount (LCY)", "Pmt. Amount (LCY)");
    end;

    local procedure CopyFromInvoiceVendLedgEntry(VendorLedgerEntry: Record "Vendor Ledger Entry")
    begin
        "Invoice Entry No." := VendorLedgerEntry."Entry No.";
        "CV No." := VendorLedgerEntry."Vendor No.";
        "Inv. External Document No." := VendorLedgerEntry."External Document No.";
        "Invoice Doc. No." := VendorLedgerEntry."Document No.";
        "Document Type" := VendorLedgerEntry."Document Type";
        "Posting Date" := VendorLedgerEntry."Posting Date";
        "Due Date" := VendorLedgerEntry."Due Date";
        "Invoice Is Open" := VendorLedgerEntry.Open;
        VendorLedgerEntry.CalcFields("Amount (LCY)");
        "Entry Amount (LCY)" := VendorLedgerEntry."Amount (LCY)";
    end;

    local procedure CopyFromInvoiceCustLedgEntry(CustLedgerEntry: Record "Cust. Ledger Entry")
    begin
        "Invoice Entry No." := CustLedgerEntry."Entry No.";
        "CV No." := CustLedgerEntry."Customer No.";
        "Invoice Doc. No." := CustLedgerEntry."Document No.";
        "Document Type" := CustLedgerEntry."Document Type";
        "Posting Date" := CustLedgerEntry."Posting Date";
        "Due Date" := CustLedgerEntry."Due Date";
        "Invoice Is Open" := CustLedgerEntry.Open;
        CustLedgerEntry.CalcFields("Amount (LCY)");
        "Entry Amount (LCY)" := CustLedgerEntry."Amount (LCY)";
    end;
}

