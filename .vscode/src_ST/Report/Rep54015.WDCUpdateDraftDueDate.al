//********************Documentation********************************
//WDC01  WDC.HG  31/07/2025  Create Current Object to modify due date for draft
namespace CRC.CRC;
using Microsoft.Purchases.Payables;

report 54015 "WDC Update Draft Due Date "
{
    ApplicationArea = All;
    CaptionML = ENU = 'Update Due Date ', FRA = 'Modifier date d''échéance';
    UsageCategory = Lists;
    ProcessingOnly = true;
    Permissions = TableData "Vendor Ledger Entry" = rimd,
   TableData "Detailed Vendor Ledg. Entry" = rimd;
    dataset
    {
        dataitem(paymentLine; "WDC-ED Payment Line")
        {
            DataItemTableView = sorting("No.", "Line No.");
            column("No_"; "No.")
            {
            }
            trigger OnAfterGetRecord()
            var
                lVenderLedgerEntry: record "Vendor Ledger Entry";
                lDetailedVendorLedgerEntry: record "Detailed Vendor Ledg. Entry";
            begin

                if NewDueDate <> 0D then begin
                    paymentLine."Due Date" := NewDueDate;
                    paymentLine.Modify();
                    lVenderLedgerEntry.reset();
                    lVenderLedgerEntry.setrange("Document No.", paymentLine."No.");
                    lVenderLedgerEntry.SetRange("Vendor No.", paymentLine."Account No.");
                    lVenderLedgerEntry.SetRange("Payment Reference", paymentLine."Payment Reference");
                    if lVenderLedgerEntry.FindSet() then begin
                        lVenderLedgerEntry."Due Date" := NewDueDate;
                        lVenderLedgerEntry.Modify();

                        lDetailedVendorLedgerEntry.reset();
                        lDetailedVendorLedgerEntry.setrange("Document No.", paymentLine."No.");
                        lDetailedVendorLedgerEntry.SetRange("Vendor No.", paymentLine."Account No.");
                        lDetailedVendorLedgerEntry.SetRange("Vendor Ledger Entry No.", lVenderLedgerEntry."Entry No.");
                        if lDetailedVendorLedgerEntry.FindSet() then begin
                            repeat
                                lDetailedVendorLedgerEntry."Initial Entry Due Date" := NewDueDate;
                                lDetailedVendorLedgerEntry.Modify();
                            until lDetailedVendorLedgerEntry.Next() = 0;
                        end
                    end;
                end;
                if NewPaymentRef <> '' then
                    UpdatePaymentreference();
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    CaptionML = ENU = 'Update Due Date', FRA = 'Modifier la date d''échéance';
                    field(NewDueDate; NewDueDate)
                    {
                        ApplicationArea = All;
                        Captionml = ENU = 'New Due Date', FRA = 'Nouvelle date d''échéance';
                    }
                    field(NewPaymentRef; NewPaymentRef)
                    {
                        ApplicationArea = All;
                        Captionml = ENU = 'New Payment Reference', FRA = 'Nouvelle référence paiement';
                    }
                }
            }
        }
        trigger OnOpenPage()
        begin
            Clear(NewDueDate);
            Clear(NewPaymentRef);
        end;

    }
    trigger OnPreReport()
    begin
        if NewDueDate = 0D then
            Error(err01);
    end;

    procedure UpdatePaymentreference()
    var
        lVenderLedgerEntry: record "Vendor Ledger Entry";
        lDetailedVendorLedgerEntry: record "Detailed Vendor Ledg. Entry";
    begin

        //if (paymentLine."Payment Methode Code" <> 'TRAITE') then
        //error(err02);

        if NewPaymentRef <> '' then begin
            paymentLine."Payment Reference" := NewPaymentRef;
            paymentLine.Modify();
            lVenderLedgerEntry.reset();
            lVenderLedgerEntry.setrange("Document No.", paymentLine."No.");
            lVenderLedgerEntry.SetRange("Vendor No.", paymentLine."Account No.");
            if lVenderLedgerEntry.FindSet() then begin
                lVenderLedgerEntry."Payment Reference" := NewPaymentRef;
                lVenderLedgerEntry.Modify();
            end;
            lDetailedVendorLedgerEntry.reset();
            lDetailedVendorLedgerEntry.setrange("Document No.", paymentLine."No.");
            lDetailedVendorLedgerEntry.SetRange("Vendor No.", paymentLine."Account No.");
            if lDetailedVendorLedgerEntry.FindSet() then begin
                lDetailedVendorLedgerEntry."Payment Reference" := NewPaymentRef;
                lDetailedVendorLedgerEntry.Modify();
            end
        end;
    end;

    var
        NewDueDate: date;
        NewPaymentRef: Code[50];
        err01: TextConst ENU = 'You must enter a new due date.', FRA = 'Vous devez entrer une nouvelle date d''échéance.';
        err02: TextConst ENU = 'you cannot change the due date for this case', FRA = 'vous ne pouvez pas modifier la date d''échéance pour ce cas';
}
