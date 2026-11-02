report 50041 "WDC Encaiss Unpaid"
{
    CaptionML = ENU = 'Update Unpaid Customer Ledger Entries',
                FRA = 'Mise à jour des écritures clients impayées';
    ProcessingOnly = true;
    Permissions = TableData "Cust. Ledger Entry" = RIMD,
                  tabledata "Detailed Cust. Ledg. Entry" = RIMD;
    ApplicationArea = All;

    dataset
    {
        dataitem("Detailed Cust. Ledg. Entry"; "Detailed Cust. Ledg. Entry")
        {

            DataItemTableView = sorting("Entry No.");
            trigger OnPreDataItem()
            var
                ltext001: TextConst ENU = 'Reference payment is mandatory',
                                        FRA = 'Réference paiement est obligatoire';
            begin
                if (PaymentSlipType in ["Detailed Cust. Ledg. Entry"."Payment Slip Type"::Cheque,
                        "Detailed Cust. Ledg. Entry"."Payment Slip Type"::Draft,
                        "Detailed Cust. Ledg. Entry"."Payment Slip Type"::Transfer]) and (PaymentReference = '') then
                    Error(lText001);
            end;

            trigger OnAfterGetRecord()
            var
                lGenJournalLine: Record "Gen. Journal Line";
                lGenJournalLine2: Record "Gen. Journal Line";
                lGenJournalBatch: Record "Gen. Journal Batch";
                lGenJnlPostBatch: Codeunit "Gen. Jnl.-Post Batch";
                lSerieNo: Codeunit "No. Series";
                lNextLineNo: Integer;
                lJournalTemplateName: Text[20];
                lJournalBatchName: Text[20];
                lCustLedgerEntry: Record "Cust. Ledger Entry";
                lReportEncaissUnpaid: Report "WDC Encaiss Unpaid";
                lPaymentMethode: record "Payment Method";
                lText001: TextConst ENU = 'You can only mark encaiss payments Cheque or Draft',
                                        FRA = 'Vous ne pouvez encisser que les paiements de type traite ou chèque';
                lText002: TextConst ENU = 'Payment encaissed successfully',
                                        FRA = 'Paiement encaissé avec succès';
                lText003: TextConst ENU = 'This payment is not marked as unpaid',
                                        FRA = 'Ce paiement n''est pas marqué comme impayé';
                lText004: TextConst ENU = 'Are you sure you want to encaiss this payment?',
                                        FRA = 'Voulez-vous vraiment encaisser ce paiement ?';
                lText005: TextConst ENU = 'This payment is already encaissed',
                                        FRA = 'Ce paiement est déjà encaissé';
            begin
                // lCustLedgerEntry.Get("Detailed Cust. Ledg. Entry"."Cust. Ledger Entry No.");
                // if Not lCustLedgerEntry.Unpaid then
                //     Error(lText003);

                if lCustLedgerEntry."Unpaid is Encaissed" then
                    Error(lText005);

                lJournalTemplateName := 'PAYMENTS';
                if "Detailed Cust. Ledg. Entry"."Payment Slip Type" = "Detailed Cust. Ledg. Entry"."Payment Slip Type"::Draft then
                    lJournalBatchName := 'ENC-TRTIMP'
                else if "Detailed Cust. Ledg. Entry"."Payment Slip Type" = "Detailed Cust. Ledg. Entry"."Payment Slip Type"::Cheque then
                    lJournalBatchName := 'ENC-CHQIMP'
                else
                    Error(lText001);
                lPaymentMethode.Reset();
                lPaymentMethode.SetRange("Payment Type", PaymentSlipType);
                if lPaymentMethode.FindFirst() then begin
                    lGenJournalBatch.Get(lJournalTemplateName, lJournalBatchName);
                    lGenJournalLine2.Init();
                    lGenJournalLine2.Validate("Journal Template Name", lJournalTemplateName);
                    lGenJournalLine2.Validate("Journal Batch Name", lJournalBatchName);
                    lGenJournalLine2."Line No." := 10000;
                    if lGenJournalLine2.Insert() then begin
                        lGenJournalLine2."Document No." := lSerieNo.GetNextNo(lGenJournalBatch."No. Series", WorkDate());
                        lGenJournalLine2."Account Type" := lGenJournalBatch."Account Type";
                        lGenJournalLine2.Validate("Account No.", "Detailed Cust. Ledg. Entry"."Customer No.");
                        lGenJournalLine2.Validate("Document Type", lGenJournalLine2."Document Type"::Payment);
                        lGenJournalLine2.Validate("Payment Method Code", lPaymentMethode."Code");
                        if PaymentSlipType in ["Detailed Cust. Ledg. Entry"."Payment Slip Type"::Cheque,
                                                "Detailed Cust. Ledg. Entry"."Payment Slip Type"::Draft,
                                                "Detailed Cust. Ledg. Entry"."Payment Slip Type"::Transfer] then
                            lGenJournalLine2."Payment Reference" := PaymentReference;

                        lGenJournalLine2.Validate("Credit Amount", PaymentAmount);
                        lGenJournalLine2.Validate("Payment Slip Type", PaymentSlipType);
                        lGenJournalLine2.Validate("Posting Group", lPaymentMethode."Posting Group");
                        lGenJournalLine2."Bal. Account Type" := lGenJournalBatch."Bal. Account Type";
                        lGenJournalLine2."Bal. Account No." := lGenJournalBatch."Bal. Account No.";
                        lGenJournalLine2."Posting Date" := WorkDate();
                        If lGenJournalLine2.Modify() then begin
                            lGenJnlPostBatch.Run(lGenJournalLine2);
                            lCustLedgerEntry."Unpaid is Encaissed" := true;
                            lCustLedgerEntry."Unpaid Enc. Reference" := "Detailed Cust. Ledg. Entry"."Payment Reference";
                            lCustLedgerEntry.Modify();
                            Message(lText002);
                        end;
                    end;
                end;
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(Group)
                {
                    field(PaymentSlipType; PaymentSlipType)
                    {
                        ApplicationArea = All;
                        CaptionML = ENU = 'Payment Slip Type', FRA = 'Type paiement';
                    }
                    field(Amount; PaymentAmount)
                    {
                        ApplicationArea = All;
                        CaptionML = ENU = 'Amount', FRA = 'Montant';
                    }
                    field(PaymentReference; PaymentReference)
                    {
                        ApplicationArea = All;
                        CaptionML = ENU = 'Payment Reference', FRA = 'Référence paiement';
                    }
                }
            }
        }
    }

    // trigger OnInitReport()
    // begin
    //     PaymentSlipType := "Detailed Cust. Ledg. Entry"."Payment Slip Type";
    //     PaymentAmount := "Detailed Cust. Ledg. Entry"."Debit Amount";
    // end;

    procedure SetParameters(pPaymentSlipType: Enum "WDC-ST Payment Slip Type"; pPaymentAmount: Decimal; pPaymentReference: Code[50])
    begin
        PaymentSlipType := pPaymentSlipType;
        PaymentAmount := pPaymentAmount;
        PaymentReference := pPaymentReference;
    end;

    var
        PaymentSlipType: Enum "WDC-ST Payment Slip Type";
        PaymentAmount: Decimal;
        PaymentReference: Code[50];
}
