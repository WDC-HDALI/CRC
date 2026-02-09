namespace CRC.CRC;

using Microsoft.Finance.GeneralLedger.Journal;
using Microsoft.Bank.BankAccount;
using Microsoft.Foundation.NoSeries;
using Microsoft.Finance.GeneralLedger.Setup;
using Microsoft.Sales.Receivables;
using System.Security.User;
//***************Documentation*******************
//WDC01  WDC.HG  29/05/2025  Create Current Object
//WDC02  WDC.HG  24/07/2025  customize default account type 

pageextension 50029 "WDC Payment Journal" extends "Payment Journal"
{
    layout
    {
        modify(CurrentJnlBatchName)
        {
            trigger OnAfterValidate()
            var
                luserSetup: Record "User Setup";
                ltext001: TextConst ENU = 'You cannot use this payment journal',
                                    FRA = 'Vous ne pouvez pas utiliser cette feuille';
            begin
                if CurrentJnlBatchName = 'REGLEMENT' then begin
                    luserSetup.Get(UserId);
                    if not luserSetup."Use REGLEMENT Pay. Journ." then
                        Error(ltext001);
                end;
            end;
        }

        modify("Posting Group")
        {
            Editable = true;
            Visible = true;
        }
        //<<WDC02
        modify("Account No.")
        {
            trigger OnAfterValidate()
            var
                lGenJournalBatch: record "Gen. Journal Batch";
                PaymentMethod: record "Payment Method";
            begin
                if lGenJournalBatch.get(rec."Journal Template Name", rec."Journal Batch Name") then
                    if lGenJournalBatch."Payment Method Code" <> '' then
                        if PaymentMethod.get(lGenJournalBatch."Payment Method Code") then
                            if PaymentMethod.Unpaid = true then begin
                                rec."Payment Method Code" := lGenJournalBatch."Payment Method Code";
                                rec."Posting Group" := PaymentMethod."Posting Group";
                            end

            end;

        }
        //>>WDC02

        modify("External Document No.")
        {
            Visible = false;
        }

        modify("Payment Method Code")
        {
            trigger OnAfterValidate()
            var
                PaymentMethod: record "Payment Method";
                lGeneraLLedgerSetup: record "General Ledger Setup";
            begin
                lGeneraLLedgerSetup.get();
                if (rec."Journal Batch Name" = 'DEFAULT') and (rec."Journal Template Name" = 'PAYMENTS') and (rec."Account Type" = rec."Account Type"::Customer) then begin
                    if PaymentMethod.get(rec."Payment Method Code") then begin
                        if (PaymentMethod."Bal. Account Type" = PaymentMethod."Bal. Account Type"::"G/L Account") then
                            Rec."Bal. Account Type" := PaymentMethod."Bal. Account Type"::"G/L Account"
                        else if (PaymentMethod."Bal. Account Type" = PaymentMethod."Bal. Account Type"::"Bank Account") then
                            Rec."Bal. Account Type" := Rec."Bal. Account Type"::"Bank Account";
                        Rec."Bal. Account No." := PaymentMethod."Bal. Account No.";

                    end;
                end;
                //<<WDC02
                if rec."Journal Batch Name" <> lGeneraLLedgerSetup."Payment Sheet" then begin
                    if rec."Payment Method Code" <> '' then begin
                        if PaymentMethod.get(rec."Payment Method Code") then begin
                            if PaymentMethod.Unpaid = true then begin
                                rec."Posting Group" := PaymentMethod."Posting Group";
                                rec.Modify()
                            end
                        end
                    end
                end
                //>>WDC02
            end;
        }
        addafter(Amount)
        {
            field("Due Date"; Rec."Due Date")
            {
                ApplicationArea = all;
            }
            field("Bank Name"; Rec."Bank Name")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Company Bank"; Rec."Company Bank")
            {
                ApplicationArea = Basic, Suite;
                Editable = editompanyBank;
                trigger OnValidate()
                begin
                    if rec."Payment Method Code" = 'VIREMENT' then
                        rec."Bal. Account No." := rec."Company Bank";
                end;
            }
            field("Taux RS"; Rec."Taux RS")
            {
                ApplicationArea = Basic, Suite;
                trigger OnValidate()
                var
                    RSSetup: record "WDC-ST Retained Group";
                begin
                    if (rec."Taux RS" <> '') then begin
                        RSSetup.reset();
                        if RSSetup.get(RSSetup."Type Retenue"::"à la source", rec."Taux RS") then
                            rec."Rs Amount" := (abs(rec.Amount) * (RSSetup."Retention %" / 100));
                        rec."Rs Amount" := round(rec."Rs Amount", 0.001, '>');
                        rec.validate(Amount, (abs(rec.Amount) - rec."Rs Amount") * -1);
                    end else if (rec."Taux RS" = '') and (rec."Rs Amount" <> 0) then begin
                        rec.validate(Amount, (abs(rec.Amount) + rec."Rs Amount") * -1);
                        rec."Rs Amount" := 0;
                    end;
                end;
            }
            field("Rs Amount"; Rec."Rs Amount")
            {
                ApplicationArea = Basic, Suite;
                ShowMandatory = true;
                Editable = false;
            }

            field("Posting Group_"; Rec."Posting Group")
            {
                ApplicationArea = all;
            }

        }
    }
    actions
    {
        addlast(processing)
        {
            action(ExtractPaymentLine)
            {
                ApplicationArea = All;
                CaptionML = FRA = 'Versement des paiements en banque', ENU = ' Bank deposit of payments';
                Image = ReverseLines;
                PromotedCategory = Process;
                Promoted = true;
                PromotedIsBig = true;
                visible = setvisible;


                trigger OnAction()
                var
                    lPayementLine: page "WDC Payment Lines";

                begin
                    clear(lPayementLine);
                    lPayementLine.LookupMode := true;
                    lPayementLine.SetPaymentJournalName(CurrentJnlBatchName);
                    if lPayementLine.RunModal() = Action::LookupOK then
                        lPayementLine.InsertSelectedJournalLine();
                end;

            }
        }
    }

    local procedure SetsetvisibleExtrairePaymentLine()
    var
        lGeneraLLedgerSetup: record "General Ledger Setup";
    begin
        lGeneraLLedgerSetup.get();
        if (CurrentJnlBatchName = lGeneraLLedgerSetup."Check Slip Sheet") or (CurrentJnlBatchName = lGeneraLLedgerSetup."Bank Draft Slip Sheet") then
            setvisible := true
        else
            setvisible := false
    end;

    trigger OnOpenPage()
    var
        lGenJournalBatch: record "Gen. Journal Batch";
    begin
        SetsetvisibleExtrairePaymentLine();


    end;

    trigger OnAfterGetRecord()
    begin
        if rec."Payment Method Code" = 'VIREMENT' then
            editompanyBank := true
        else
            editompanyBank := false;
    end;

    trigger OnAfterGetCurrRecord()
    var
        myInt: Integer;
    begin
        SetsetvisibleExtrairePaymentLine();
        CurrPage.update(false);

    end;

    trigger OnDeleteRecord(): Boolean
    var
        lcustomerledgerentry: record "Cust. Ledger Entry";
    begin
        lcustomerledgerentry.reset();
        lcustomerledgerentry.SetCurrentKey("Document No.");
        lcustomerledgerentry.SetRange("Document No.", rec."Applies-to Doc. No.");
        if lcustomerledgerentry.FindSet() then begin
            lcustomerledgerentry.IsInserted := false;
            lcustomerledgerentry.modify();
        end;

    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        lGeneraLLedgerSetup: record "General Ledger Setup";
        lGenJournalBatch: record "Gen. Journal Batch";
    begin
        //>>WDC02
        if CurrentJnlBatchName <> lGeneraLLedgerSetup."Payment Sheet" then
            SetDefaultconfig();
        //>>WDC02
        lGenJournalBatch.get('PAYMENTS', CurrentJnlBatchName);
        lGeneraLLedgerSetup.get();
        if (CurrentJnlBatchName = lGeneraLLedgerSetup."Check Slip Sheet") or (CurrentJnlBatchName = lGeneraLLedgerSetup."Bank Draft Slip Sheet") then
            Rec."Document No." := NoSeries.PeekNextNo(lGenJournalBatch."No. Series", WorkDate);


    end;

    //WDC02
    local procedure SetDefaultconfig()
    var
        GenJournalBatch: Record "Gen. Journal Batch";
        PaymentMethod: record "Payment Method";
    begin
        if GenJournalBatch.Get(Rec."Journal Template Name", Rec."Journal Batch Name") then begin
            Rec."Account Type" := GenJournalBatch."Account Type";
            Rec."Account No." := GenJournalBatch."Account No.";
            if GenJournalBatch."Payment Method Code" <> '' then
                if PaymentMethod.get(GenJournalBatch."Payment Method Code") then begin
                    rec."Payment Method Code" := GenJournalBatch."Payment Method Code";
                    rec."Posting Group" := PaymentMethod."Posting Group";
                end;
        end;
    end;
    //<<WDC02

    var
        DocNo: Code[20];
        NoSeries: Codeunit "No. Series";
        setvisible: Boolean;
        editompanyBank: Boolean;

}