namespace CRC.CRC;

using Microsoft.Finance.GeneralLedger.Journal;
using System.Security.User;
using Microsoft.Sales.Setup;
using Microsoft.Foundation.Company;
using Microsoft.Sales.History;
using Microsoft.Finance.GeneralLedger.Posting;
using Microsoft.Bank.BankAccount;
using Microsoft.Bank.Payment;
using Microsoft.Sales.Receivables;
//***************Documentation*********************
//WDC01 WDC.HG 26/05/2025  Add Payment Process  
page 50010 "WDC Customer Payment"
{
    ApplicationArea = All;
    CaptionML = ENU = 'Customer Payment', FRA = 'Réglement client';
    SourceTable = "Gen. Journal Line";
    AutoSplitKey = true;
    DataCaptionExpression = Rec.DataCaption();
    DelayedInsert = true;
    PageType = Worksheet;
    SaveValues = true;
    UsageCategory = Tasks;
    ShowFilter = false;
    layout
    {
        area(content)
        {
            group(Control2)
            {
                ShowCaption = false;
                field(CurrentJnlBatchName; CurrentJnlBatchName)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Batch Name';
                    Lookup = true;
                    Editable = false;
                }

            }
            repeater(Control1)
            {
                ShowCaption = false;
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = all;
                    Visible = SeePostingDate;
                }
                field("Payment Method Code"; Rec."Payment Method Code")
                {
                    ApplicationArea = Basic, Suite;
                    ShowMandatory = true;
                    trigger OnValidate()
                    var
                        PaymentMethod: record "Payment Method";
                    begin
                        if rec."Payment Method Code" = 'VIREMENT' then
                            editompanyBank := true
                        else begin
                            editompanyBank := false;
                            rec."Company Bank" := '';
                        end;
                        SalesInvHeader.CalcFields("Remaining Amount");
                        if PaymentMethod.get(rec."Payment Method Code") then begin
                            if rec."Payment Method Code" <> 'RS' then begin
                                if (PaymentMethod."Bal. Account Type" = PaymentMethod."Bal. Account Type"::"G/L Account") then
                                    Rec."Bal. Account Type" := PaymentMethod."Bal. Account Type"::"G/L Account"
                                else if (PaymentMethod."Bal. Account Type" = PaymentMethod."Bal. Account Type"::"Bank Account") then begin
                                    Rec."Bal. Account Type" := Rec."Bal. Account Type"::"Bank Account";
                                end;
                                Rec."Bal. Account No." := PaymentMethod."Bal. Account No.";
                            end
                            else begin
                                rec."Document Type" := rec."Document Type"::" ";
                                rec."Account Type" := rec."Account Type"::"G/L Account";
                                rec.validate("Account No.", PaymentMethod."Bal. Account No.");
                                rec."Bal. Account Type" := rec."Bal. Account Type"::Customer;
                                rec."Bal. Account No." := SalesInvHeader."Bill-to Customer No."

                            end;
                            if rec."Payment Amount" = 0 then
                                Rec.validate("Payment Amount", round(SalesInvHeader."Remaining Amount" - calculateAmountPayed(), 0.001, '>'));
                            if rec."Payment Amount" <> 0 then begin
                                if rec."Payment Method Code" <> 'RS' then
                                    rec.validate("Credit Amount", rec."Payment Amount")
                                else
                                    rec.validate("Debit Amount", rec."Payment Amount");
                            end;
                        end;

                    end;
                }
                field("Payment Amount"; Rec."Payment Amount")
                {
                    ApplicationArea = Basic, Suite;
                    ShowMandatory = true;
                    Style = Attention;
                    trigger OnValidate()
                    var
                        myInt: Integer;
                    begin
                        if rec."Payment Method Code" <> 'RS' then
                            rec.validate("Credit Amount", rec."Payment Amount")
                        else
                            rec.validate("Debit Amount", rec."Payment Amount");

                    end;

                }
                field("Payment Reference"; Rec."Payment Reference")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = Basic, Suite;

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
            }
        }
    }

    actions
    {
        area(Processing)
        {

            action(post)
            {
                ApplicationArea = Basic, Suite;
                Captionml = ENU = 'Post Payment ', FRA = 'Valider paiement';
                Image = PostOrder;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    PostJnlLine: Codeunit "Gen. Jnl.-Post Line";
                    lGenJournalLine: record "Gen. Journal Line";
                    lGenJnlPostBatch: Codeunit "Gen. Jnl.-Post Batch";
                    err01: TextConst ENU = 'Unable to validate this payment: the amount entered exceeds the open amount on the invoice.', FRA = 'Impossible de valider ce paiement : le montant saisi dépasse le montant ouvert sur la facture';
                begin
                    SalesInvHeader.CalcFields("Remaining Amount");
                    if calculateAmountPayed() > SalesInvHeader."Remaining Amount" then
                        error(err01);
                    lGenJournalLine.reset();
                    lGenJournalLine.Setrange("Journal Batch Name", 'REGLEMENT');
                    lGenJournalLine.setrange("Journal Template Name", 'PAYMENTS');
                    lGenJournalLine.setrange("Applies-to Doc. No.", SalesInvHeader."No.");
                    if lGenJournalLine.findset() then begin
                        repeat
                            if (lGenJournalLine."Payment Method Code" = 'CHEQUE') or (lGenJournalLine."Payment Method Code" = 'TRAITE') then
                                lGenJournalLine.TestField("Payment Reference");
                            if lGenJournalLine."Payment Method Code" = 'TRAITE' then
                                lGenJournalLine.TestField("Due Date");
                        until lGenJournalLine.next() = 0;
                        lGenJnlPostBatch.Run(lGenJournalLine);
                    end;
                end;
            }

        }
    }
    trigger OnAfterGetRecord()
    begin
        if rec."Payment Method Code" = 'VIREMENT' then
            editompanyBank := true
        else
            editompanyBank := false;
    end;


    trigger OnOpenPage()
    var
        JnlSelected: Boolean;
        GenJnline: record "Gen. Journal Line";
        GenJnlineTemp: record "Gen. Journal Line";
    begin
        UserSetup.Get(USERID);
        SeePostingDate := UserSetup."See Payment Posting Date";

        DocumentNoSerie := 'REG-' + SalesInvHeader."No.";
        CurrentJnlBatchName := 'REGLEMENT';
        JournalTemplateName := 'PAYMENTS';

        SalesInvHeader.CalcFields("Remaining Amount", Amount, "Amount Including VAT");

        Rec.SetFilter("Journal Template Name", JournalTemplateName);
        Rec.SetFilter("Journal Batch Name", CurrentJnlBatchName);
        rec.setfilter("Applies-to Doc. No.", SalesInvHeader."No.");
        rec."Document Type" := rec."Document Type"::Payment;
        rec."Document No." := DocumentNoSerie;
        rec."Posting Date" := WorkDate();
        rec."Account Type" := rec."Account Type"::Customer;
        rec.Validate("Account No.", SalesInvHeader."Bill-to Customer No.");
        rec."Applies-to Doc. Type" := rec."Applies-to Doc. Type"::Invoice;
        rec."Applies-to Doc. No." := SalesInvHeader."No.";
    end;

    trigger OnNewRecord(belowxRec: Boolean)
    var
        GenJnlLineMgt: Codeunit "Gen. Jnl.-Check Line";
        CompanyInfo: Record "Company Information";
        GenJnlineTemp: record "Gen. Journal Line";

    begin
        CompanyInfo.get;
        SalesInvHeader.CalcFields("Remaining Amount", Amount, "Amount Including VAT");
        Rec."Document Type" := Rec."Document Type"::Payment;
        Rec."Document No." := DocumentNoSerie;
        rec."Posting Date" := WorkDate();
        Rec."Account Type" := Rec."Account Type"::Customer;
        Rec.Validate("Account No.", SalesInvHeader."Bill-to Customer No.");
        Rec."Applies-to Doc. Type" := Rec."Applies-to Doc. Type"::Invoice;
        Rec."Applies-to Doc. No." := SalesInvHeader."No.";
    end;

    procedure SetDataFromInvoice(pSalesInvoiceHeader: Record "Sales Invoice Header")
    begin
        SalesInvHeader := pSalesInvoiceHeader;
    end;

    procedure calculateAmountPayed(): Decimal
    var
        pGenJournalLine: record "Gen. Journal Line";
    begin
        Totalpayed := 0;
        pGenJournalLine.reset();
        pGenJournalLine.Setrange("Journal Batch Name", 'REGLEMENT');
        pGenJournalLine.setrange("Journal Template Name", 'PAYMENTS');
        pGenJournalLine.setrange("Applies-to Doc. Type", pGenJournalLine."Applies-to Doc. Type"::Invoice);
        pGenJournalLine.setrange("Applies-to Doc. No.", SalesInvHeader."No.");
        pGenJournalLine.setrange("Document No.", DocumentNoSerie);
        if pGenJournalLine.findset() then
            repeat
                Totalpayed += abs(pGenJournalLine.Amount)
            until pGenJournalLine.Next() = 0;
        exit(Totalpayed);
    end;

    var
        JournalTemplateName: Code[10];
        CurrentJnlBatchName: Code[10];
        SalesInvHeader: Record "Sales Invoice Header";
        Totalpayed: Decimal;
        DocumentNoSerie: Code[20];
        editompanyBank: Boolean;
        UserSetup: Record "User Setup";
        SeePostingDate: Boolean;

}



