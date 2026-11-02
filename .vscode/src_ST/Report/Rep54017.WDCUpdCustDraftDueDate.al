//********************Documentation********************************
//WDC01  WDC.HG  31/07/2025  Create Current Object to modify due date for draft
namespace CRC.CRC;
using Microsoft.Purchases.Payables;
using Microsoft.Sales.Receivables;

report 54017 "WDC Upd. Cust. Draft Due Date "
{
    ApplicationArea = All;
    CaptionML = ENU = 'Update Due Date ', FRA = 'Modifier date d''échéance';
    UsageCategory = Lists;
    ProcessingOnly = true;
    Permissions = TableData "Cust. Ledger Entry" = rimd,
   TableData "Detailed Cust. Ledg. Entry" = rimd;
    dataset
    {
        dataitem("Detailed Cust. Ledg. Entry"; "Detailed Cust. Ledg. Entry")
        {
            column(EntryNo; "Entry No.")
            {
            }

            trigger OnAfterGetRecord()
            var
                lCustLedgEntri: record "Cust. Ledger Entry";
                lDetailedCustLedgerEntry: record "Detailed Cust. Ledg. Entry";
            begin

                if NewDueDate <> 0D then begin

                    if lCustLedgEntri.get("Detailed Cust. Ledg. Entry"."Cust. Ledger Entry No.") then begin
                        lCustLedgEntri."Due Date" := NewDueDate;
                        lCustLedgEntri.Modify();

                        if lDetailedCustLedgerEntry.Get("Detailed Cust. Ledg. Entry"."Entry No.") then begin
                            lDetailedCustLedgerEntry."Initial Entry Due Date" := NewDueDate;
                            lDetailedCustLedgerEntry.Modify();
                        end
                    end;
                end;

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
                    // field(NewPaymentRef; NewPaymentRef)
                    // {
                    //     ApplicationArea = All;
                    //     Captionml = ENU = 'New Payment Reference', FRA = 'Nouvelle référence paiement';
                    // }
                }
            }
        }
        trigger OnOpenPage()
        begin
            Clear(NewDueDate);
            //Clear(NewPaymentRef);
        end;

    }
    trigger OnPreReport()
    begin
        if NewDueDate = 0D then
            Error(err01);
    end;



    var
        NewDueDate: date;
        //NewPaymentRef: Code[50];
        err01: TextConst ENU = 'You must enter a new due date.', FRA = 'Vous devez entrer une nouvelle date d''échéance.';
        err02: TextConst ENU = 'you cannot change the due date for this case', FRA = 'vous ne pouvez pas modifier la date d''échéance pour ce cas';
}
