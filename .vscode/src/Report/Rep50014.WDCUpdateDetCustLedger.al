namespace CRC.CRC;

using Microsoft.Sales.History;
using Microsoft.Sales.Receivables;

report 50014 "WDC Update Det Cust Ledger"
{
    CaptionML = ENU = 'Update Update Det Cust Ledger', FRA = 'Modif écritures clients détaillées';
    RDLCLayout = './.vscode/src/Report/RDLC/Updt.rdl';
    // UseRequestPage = false;
    Permissions = tabledata "Detailed Cust. Ledg. Entry" = RIMD;
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
            column(Cust__Ledger_Entry_No_; "Cust. Ledger Entry No.")
            {
            }
            trigger OnAfterGetRecord()
            begin
                If Not Confirm(StrSubstNo('Voulez vous modifier l''ecriture %1', "Detailed Cust. Ledg. Entry"."Document No."))
             then
                    Error('C''est validé');
                if PaymentSlipType <> "Detailed Cust. Ledg. Entry"."Payment Slip Type"::" " then
                    "Detailed Cust. Ledg. Entry"."Payment Slip Type" := PaymentSlipType;

                if NewPostingDate <> 0D then
                    "Detailed Cust. Ledg. Entry"."Posting Date" := NewPostingDate;

                "Detailed Cust. Ledg. Entry".Modify();
                UpdateDetCustLedgEntri("Detailed Cust. Ledg. Entry"."Cust. Ledger Entry No.");
            end;

        }

    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                field(PaymentSlipType; PaymentSlipType)
                {
                    CaptionML = ENU = 'Payment Type', FRA = 'Type paiement';
                    ApplicationArea = all;
                }
                field(NewPostingDate; NewPostingDate)
                {
                    CaptionML = ENU = 'New Posting Date', FRA = 'Nouvelle date de comptabilisation';
                    ApplicationArea = all;
                }
            }

        }
    }
    procedure UpdateDetCustLedgEntri(pCustEntrieNo: Integer)
    var
        lCustLedgerEntry: Record "Cust. Ledger Entry";
    begin
        if lCustLedgerEntry.get(pCustEntrieNo) then begin
            if NewPostingDate <> 0D then
                lCustLedgerEntry."Posting Date" := NewPostingDate;
            if PaymentSlipType <> lCustLedgerEntry."Payment Slip Type"::" " then
                lCustLedgerEntry."Payment Slip Type" := PaymentSlipType;
            lCustLedgerEntry.Modify();
        end;
    end;

    var
        PaymentSlipType: Enum "WDC-ST Payment Slip Type";
        NewPostingDate: Date;



}