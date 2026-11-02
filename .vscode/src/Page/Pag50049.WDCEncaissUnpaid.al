Page 50049 "WDC Encaiss Unpaid"
{
    CaptionML = ENU = 'Encaiss Unpaid',
                FRA = 'Encaissement des impayés clients';
    Permissions = TableData "Cust. Ledger Entry" = RIMD,
                  TableData "Detailed Cust. Ledg. Entry" = RIMD;
    ApplicationArea = All;
    SourceTable = "Detailed Cust. Ledg. Entry";
    PageType = StandardDialog;

    layout
    {
        area(content)
        {
            group(Filtres)
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
                field(BankAccount; BankAccount)
                {
                    TableRelation = "Bank Account";
                    CaptionML = ENU = 'Bank Account', FRA = 'Banque';
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnQueryClosePage(CloseAction: Action): Boolean
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
        lPaymentMethode2: record "Payment Method";
        lCustPostingGroup: record "Customer Posting Group";

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
        lText006: TextConst ENU = 'Reference payment is mandatory',
                            FRA = 'La référence du paiement est obligatoire';
        lText007: TextConst ENU = 'Bank account is mandatory',
                            FRA = 'La banque est obligatoire';
    begin
        lCustLedgerEntry.Get(Rec."Cust. Ledger Entry No.");
        // if Not lCustLedgerEntry.Unpaid then
        //     Error(lText003);

        if CloseAction = Action::OK then begin

            if lCustLedgerEntry."Unpaid is Encaissed" then
                Error(lText005);

            lJournalTemplateName := 'PAYMENTS';
            if Rec."Payment Slip Type" = Rec."Payment Slip Type"::Draft then
                lJournalBatchName := 'ENC-TRTIMP'
            else if Rec."Payment Slip Type" = Rec."Payment Slip Type"::Cheque then
                lJournalBatchName := 'ENC-CHQIMP'
            else
                Error(lText001);

            if (PaymentSlipType in [Rec."Payment Slip Type"::Cheque,
                                    Rec."Payment Slip Type"::Draft,
                                    Rec."Payment Slip Type"::Transfer]) Then begin
                if PaymentReference = '' then
                    Error(lText006);
                if BankAccount = '' then
                    Error(lText007);
            end;

            InitGenJournalLine(lJournalBatchName);

            lPaymentMethode.Reset();
            lPaymentMethode.SetRange("Payment Type", PaymentSlipType);
            if lPaymentMethode.FindFirst() then begin
                lGenJournalBatch.Get(lJournalTemplateName, lJournalBatchName);
                if lPaymentMethode2.Get(lGenJournalBatch."Payment Method Code") then
                    if lCustPostingGroup.get(lPaymentMethode2."Posting Group") Then begin
                        lGenJournalLine2.Init();
                        lGenJournalLine2.Validate("Journal Template Name", lJournalTemplateName);
                        lGenJournalLine2.Validate("Journal Batch Name", lJournalBatchName);
                        lGenJournalLine2."Line No." := 10000;
                        if lGenJournalLine2.Insert(True) then begin
                            lGenJournalLine2."Document No." := lSerieNo.GetNextNo(lGenJournalBatch."No. Series", WorkDate());
                            lGenJournalLine2."Account Type" := lGenJournalLine2."Account Type"::Customer;
                            lGenJournalLine2."Account No." := rec."Customer No.";
                            lGenJournalLine2.Validate("Document Type", lGenJournalLine2."Document Type"::Payment);

                            lGenJournalLine2."Bal. Account Type" := lGenJournalLine2."Bal. Account Type"::"Bank Account";
                            if PaymentSlipType in [Rec."Payment Slip Type"::Cheque, Rec."Payment Slip Type"::Draft, Rec."Payment Slip Type"::Transfer] then begin
                                lGenJournalLine2."Bal. Account No." := BankAccount;
                                lGenJournalLine2.Validate("Payment Method Code", lPaymentMethode2."Code");
                                lGenJournalLine2."Payment Reference" := PaymentReference;
                            End
                            else if PaymentSlipType = PaymentSlipType::Cash then begin
                                lGenJournalLine2."Bal. Account No." := 'C-RECETTE'
                            end;
                        end;
                        lGenJournalLine2.Validate("Amount (LCY)", ABS(PaymentAmount) * -1);
                        lGenJournalLine2.Validate("Payment Slip Type", PaymentSlipType);
                        lGenJournalLine2.Validate("Posting Group", lPaymentMethode."Posting Group");
                        lGenJournalLine2."Posting Date" := WorkDate();
                        If lGenJournalLine2.Modify(true) then begin
                            lGenJnlPostBatch.Run(lGenJournalLine2);
                            lCustLedgerEntry."Unpaid is Encaissed" := true;
                            lCustLedgerEntry."Unpaid Enc. Reference" := Rec."Payment Reference";
                            lCustLedgerEntry.Modify();

                            rec."Unpaid is Encaissed" := true;
                            rec.Modify();
                            Message(lText002);
                        end;
                    end;
            end;
        end;
    end;
    // end;

    procedure SetParameters(pPaymentSlipType: Enum "WDC-ST Payment Slip Type"; pPaymentAmount: Decimal; pPaymentReference: Code[50])
    begin
        PaymentSlipType := pPaymentSlipType;
        PaymentAmount := pPaymentAmount;
        PaymentReference := pPaymentReference;
    end;

    procedure InitGenJournalLine(pJournalBatchName: Text[20])
    var
        lGenJournalLine: Record "Gen. Journal Line";
    begin
        lGenJournalLine.Init();
        lGenJournalLine.Validate("Journal Template Name", 'PAYMENTS');
        lGenJournalLine.SetRange("Journal Batch Name", pJournalBatchName);
        lGenJournalLine.DeleteAll();

    end;

    var
        PaymentSlipType: Enum "WDC-ST Payment Slip Type";
        PaymentAmount: Decimal;
        PaymentReference: Code[50];
        BankAccount: Code[20];
}
