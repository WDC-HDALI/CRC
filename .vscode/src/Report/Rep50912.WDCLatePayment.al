report 50912 "WDC Late Payment"
{
    ApplicationArea = All;
    CaptionML = ENU = 'Late Payment', FRA = 'Reçu paiement en retard';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    Permissions = tabledata "Sales Invoice Header" = rimd;
    RDLCLayout = './.vscode/src/Report/RDLC/LatePayment.rdlc';

    dataset
    {
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            DataItemTableView = Sorting("Posting Date") where("Customer Posting Group" = filter('C-PASSAGER'));
            column(No_; "No.")
            {
            }
            column(Posting_Date; "Posting Date")
            {
            }
            column(CustomerNo; "Sell-to Customer No.")
            {
            }
            column(CustomerName; "Sell-to Customer Name")
            {
            }
            column(COMPANYNAME; COMPANYNAME)
            {
            }
            column(CompInfo_Picture; CompInfo.Picture)
            {
            }
            column(StartingDate; StartingDate)
            {
            }
            column(EndingDate; EndingDate)
            {
            }
            dataitem(CustLedgerEntry; "Cust. Ledger Entry")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemTableView = sorting("Posting Date") where("Document Type" = filter(Invoice));
                dataitem("Detailed Cust. Ledg. Entry"; "Detailed Cust. Ledg. Entry")
                {
                    DataItemLink = "Cust. Ledger Entry No." = field("Entry No.");
                    DataItemTableView = sorting("Posting Date") where("Document Type" = filter(Payment | Invoice | " "));
                    column(PayementType; PaymentTypeText)//"Payment Slip Type")
                    {
                    }
                    column(Document_No_; DocumentNo)//"Document No.")
                    {
                    }
                    column(Payment_Date; "Posting Date")
                    {
                    }
                    column(Payment_Amount; "Credit Amount")
                    {
                    }
                    trigger OnPreDataItem()
                    begin
                        SetFilter("Posting Date", '>%1', "Sales Invoice Header"."Posting Date");
                    end;

                    trigger OnAfterGetRecord()
                    begin
                        PaymentTypeText := '';
                        DocumentNo := '';
                        IsACreditMemo := false;
                        if "Detailed Cust. Ledg. Entry"."Document Type" = "Detailed Cust. Ledg. Entry"."Document Type"::Payment then BEGIN
                            PaymentTypeText := Format("Payment Slip Type");
                            DocumentNo := "Detailed Cust. Ledg. Entry"."Document No.";
                        end Else if ("Detailed Cust. Ledg. Entry"."Document Type" = "Detailed Cust. Ledg. Entry"."Document Type"::" ") And
                                    ("Detailed Cust. Ledg. Entry"."Payment Slip Type" = "Detailed Cust. Ledg. Entry"."Payment Slip Type"::RS) then begin
                            PaymentTypeText := 'RS';
                            DocumentNo := "Detailed Cust. Ledg. Entry"."Document No.";
                        End else if (GetDocumentNo("Detailed Cust. Ledg. Entry"."Document No.", "Detailed Cust. Ledg. Entry"."Applied Cust. Ledger Entry No.") <> '') And IsACreditMemo then begin
                            PaymentTypeText := 'Avoir';


                        end;//Else
                            // CurrReport.Skip();
                    end;
                }
            }
            trigger OnPreDataItem()
            begin
                if (StartingDate <> 0D) And (EndingDate <> 0D) then
                    SetRange("Posting Date", StartingDate, EndingDate)
                else if StartingDate <> 0D then
                    SetFilter("Posting Date", '>=%1', StartingDate)
                else if EndingDate <> 0D then
                    SetFilter("Posting Date", '<=%1', EndingDate);
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Filters)
                {
                    field(StartingDate; StartingDate)
                    {
                        ApplicationArea = all;
                        CaptionML = ENU = 'Starting Date', FRA = 'Date début';
                    }
                    field(EndingDate; EndingDate)
                    {
                        ApplicationArea = all;
                        Captionml = ENU = 'Ending Date', FRA = 'Date fin';
                    }

                }
            }
        }
    }

    trigger OnPreReport()
    begin
        CompInfo.get;
        CompInfo.CalcFields(Picture);
    end;

    local procedure GetDocumentNo(pDocumentNo: code[20]; pAppCustLedEntry: Integer): Code[20]
    var
        lDetCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        lCustLedgerEntry: Record "Cust. Ledger Entry";
    begin
        lDetCustLedgEntry.Reset();
        lDetCustLedgEntry.SetRange("Document No.", pDocumentNo);
        lDetCustLedgEntry.SetRange("Initial Document Type", lDetCustLedgEntry."Initial Document Type"::"Credit Memo");
        lDetCustLedgEntry.SetRange("Applied Cust. Ledger Entry No.", pAppCustLedEntry);
        if lDetCustLedgEntry.FindSet() then begin
            lCustLedgerEntry.Get(lDetCustLedgEntry."Cust. Ledger Entry No.");
            if lCustLedgerEntry."Document Type" = lCustLedgerEntry."Document Type"::"Credit Memo" then Begin
                IsACreditMemo := true;
                DocumentNo := lCustLedgerEntry."Document No.";
            End;
        end;
        Exit(lCustLedgerEntry."Document No.");
    end;

    var
        CompInfo: Record "Company Information";
        StartingDate: Date;
        EndingDate: Date;
        PaymentTypeText: Text;
        DocumentNo: code[20];
        IsACreditMemo: Boolean;

}
