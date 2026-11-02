

Page 50039 "WDC Posted Sales Invoices V2"
{
    ApplicationArea = All;
    CaptionML = ENU = 'Posted Sales Invoices V2',
                FRA = 'Factures vente enregistrées V2';
    PageType = Document;
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            group(Filters)
            {
                Editable = true;
                CaptionML = ENU = 'Filters', FRA = 'Filtres';
                group(FilterDate)
                {
                    ShowCaption = False;
                    field(StartDateFilter; StartDateFilter)
                    {
                        ApplicationArea = all;
                        CaptionML = ENU = 'Start Date', FRA = 'Date début';
                        trigger OnValidate()
                        var
                            lText001: TextConst ENU = 'End Date cannot be earlier than Start Date',
                                            FRA = 'La date fin ne peut pas être antérieure à la date début';
                        begin
                            if (EndDateFilter <> 0D) and (StartDateFilter <> 0D) and (EndDateFilter < StartDateFilter) then
                                Error(lText001);
                            CurrPage."WDC Posted Sales Invoices Part".Page.FilterCurrentPage(StartDateFilter, EndDateFilter, CustomerNoFilter);

                            TotalAmountIncVat := GetTotalAmountIncVat;
                            CurrPage.Update(false);
                        end;
                    }
                    field(EndDateFilter; EndDateFilter)
                    {
                        ApplicationArea = all;
                        CaptionML = ENU = 'End Date', FRA = 'Date fin';
                        trigger OnValidate()
                        var
                            lText001: TextConst ENU = 'End Date cannot be earlier than Start Date',
                                            FRA = 'La date fin ne peut pas être antérieure à la date début';
                        begin
                            if (EndDateFilter <> 0D) and (StartDateFilter <> 0D) and (EndDateFilter < StartDateFilter) then
                                Error(lText001);
                            CurrPage."WDC Posted Sales Invoices Part".Page.FilterCurrentPage(StartDateFilter, EndDateFilter, CustomerNoFilter);

                            TotalAmountIncVat := GetTotalAmountIncVat;
                            CurrPage.Update(false);
                        end;
                    }
                }
                group(CustomerFilter)
                {
                    ShowCaption = False;
                    field(CustomerNoFilter; CustomerNoFilter)
                    {
                        ApplicationArea = all;
                        TableRelation = Customer;
                        CaptionML = ENU = 'Customer No.', FRA = 'N° client';
                        trigger OnValidate()
                        var
                            lCustomer: Record Customer;
                        begin
                            CustomerName := '';
                            CurrPage."WDC Posted Sales Invoices Part".Page.FilterCurrentPage(StartDateFilter, EndDateFilter, CustomerNoFilter);
                            TotalAmountIncVat := GetTotalAmountIncVat;
                            if lCustomer.get(CustomerNoFilter) then
                                CustomerName := lCustomer.Name;

                            CurrPage.Update(false);
                        end;
                    }
                    field(CustomerName; CustomerName)
                    {
                        ApplicationArea = all;
                        CaptionML = ENU = 'Customer Name', FRA = 'Nom client';
                        Editable = false;
                    }
                }
                field(TotalAmountIncVat; TotalAmountIncVat)
                {
                    ApplicationArea = all;
                    DecimalPlaces = 0 : 3;
                    Editable = false;
                    Style = StrongAccent;
                    CaptionML = ENU = 'Total Amount Incl. VAT', FRA = 'Total TTC';

                }
            }
            part("WDC Posted Sales Invoices Part"; "WDC Posted Sales Invoices Part")
            {

                ApplicationArea = All;
            }
            //<<WDC03
        }

        //<<WDC04

    }

    trigger OnOpenPage()
    var
        SalesSetup: Record "Sales & Receivables Setup";
    begin
        TotalAmountIncVat := GetTotalAmountIncVat;
        SalesSetup.get();
        StandardPrintIsVisible := SalesSetup."Standard Print Is Visible";
    end;



    procedure GetTotalAmountIncVat(): Decimal
    var
        lSalesInvoiceHeader: Record "Sales Invoice Header";
        lDetCustLedgerEntry: Record "Detailed Cust. Ledg. Entry";

    begin
        TotalAmountIncVat := 0;
        lDetCustLedgerEntry.Reset();
        lDetCustLedgerEntry.SetCurrentKey("Customer No.", "Entry Type", "Posting Date", "Initial Document Type");
        lDetCustLedgerEntry.SetRange("Document Type", lDetCustLedgerEntry."Document Type"::Invoice);
        lDetCustLedgerEntry.SetRange("Entry Type", lDetCustLedgerEntry."Entry Type"::"Initial Entry");
        if (StartDateFilter <> 0D) and (EndDateFilter <> 0D) then
            lDetCustLedgerEntry.SetFilter("Posting Date", '%1..%2', StartDateFilter, EndDateFilter)
        else if (StartDateFilter <> 0D) and (EndDateFilter = 0D) then
            lDetCustLedgerEntry.SetFilter("Posting Date", '%1..', StartDateFilter)
        else if (StartDateFilter = 0D) and (EndDateFilter <> 0D) then
            lDetCustLedgerEntry.SetFilter("Posting Date", '..%1', EndDateFilter);
        if CustomerNoFilter <> '' then
            lDetCustLedgerEntry.SetFilter("Customer No.", CustomerNoFilter);
        lDetCustLedgerEntry.CalcSums("Amount (LCY)");
        exit(lDetCustLedgerEntry."Amount (LCY)");
    End;

    var
        StandardPrintIsVisible: Boolean;
        StartDateFilter: Date;
        EndDateFilter: Date;
        TotalAmountIncVat: Decimal;
        LineAmountIncVat: Decimal;
        CustomerNoFilter: Code[20];
        CustomerName: Text[100];

}