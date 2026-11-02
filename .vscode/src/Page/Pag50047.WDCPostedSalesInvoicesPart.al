

Page 50047 "WDC Posted Sales Invoices Part"
{
    ApplicationArea = All;
    CaptionML = ENU = 'Posted Sales Invoices',
                FRA = 'Factures vente enregistrées';
    PageType = ListPart;
    SourceTable = "Sales Invoice Header";
    SourceTableView = sorting("Posting Date") where("Amount Including VAT" = filter(<> 0));
    CardPageId = "Posted Sales Invoice";
    Editable = false;

    layout
    {
        area(Content)
        {

            //<<WDC03

            repeater(General)

            {
                Editable = false;
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                    ApplicationArea = All;
                }
                field("Sell-to Customer Name"; Rec."Sell-to Customer Name")
                {
                    ApplicationArea = All;
                }
                field("Amount Including VAT"; LineAmountIncVat)
                {
                    ApplicationArea = All;
                    DecimalPlaces = 0 : 3;
                    Style = Strong;
                    CaptionML = ENU = 'Amount Incl. VAT', FRA = 'Montant TTC';
                }

                field("Cash Payment"; Rec."Cash Payment")
                {
                    ApplicationArea = All;
                    DecimalPlaces = 0 : 5;
                }

                field("Cheque Payment"; Rec."Cheque Payment")
                {
                    ApplicationArea = All;
                    DecimalPlaces = 0 : 5;
                }
                field("Draft Payment"; Rec."Draft Payment")
                {
                    ApplicationArea = All;
                    DecimalPlaces = 0 : 5;
                }
                field("Transfer Payment"; Rec."Transfer Payment")
                {
                    ApplicationArea = All;
                    DecimalPlaces = 0 : 5;
                }
                field("RS Amount"; Rec."RS Amount")
                {
                    ApplicationArea = All;
                    DecimalPlaces = 0 : 5;
                }
                field("Cr. Memo Amount"; Rec."Cr. Memo Amount")
                {
                    ApplicationArea = All;
                    DecimalPlaces = 0 : 5;
                }


                field(ShippingAgentCode; Rec."Shipping Agent Code")
                {
                    CaptionML = FRA = 'N° camion';
                    ApplicationArea = All;
                }
                field(ShippingAgentServiceCode; Rec."Shipping Agent Service Code")
                {
                    CaptionML = FRA = 'Code chauffeur';
                    ApplicationArea = All;
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ApplicationArea = all;
                    Editable = false;
                }
            }

        }
    }
    //<<WDC04
    actions
    {

        area(Processing)
        {
            action(DirectPrint)
            {
                ApplicationArea = Basic, Suite;
                Captionml = ENU = 'Print', FRA = 'Imprimer';
                Ellipsis = true;
                Image = Print;
                Visible = Not StandardPrintIsVisible;
                trigger OnAction()
                var
                    lPostedSalesInvoice: report "WDC Posted Sales Invoice ";
                    lReportSelection: Record "Report Selections";
                begin
                    lReportSelection.RESET();
                    lReportSelection.SetRange(Usage, lReportSelection.Usage::"S.Invoice");
                    Rec.SetRecFilter();
                    if lReportSelection.FindFirst() then
                        Report.Run(lReportSelection."Report ID", true, true, Rec);
                end;
            }

        }
    }

    trigger OnAfterGetRecord()
    var
        lCustLedgEntris: Record "Cust. Ledger Entry";
    begin
        if lCustLedgEntris.Get(rec."Cust. Ledger Entry No.") then
            lCustLedgEntris.CalcFields("Amount (LCY)");
        LineAmountIncVat := lCustLedgEntris."Amount (LCY)";
    end;

    trigger OnOpenPage()
    var
        SalesSetup: Record "Sales & Receivables Setup";
    begin
        SalesSetup.get();
        StandardPrintIsVisible := SalesSetup."Standard Print Is Visible";
        rec.SetCurrentKey("Posting Date");
    end;

    procedure FilterCurrentPage(pStartDate: Date; pEndDate: Date; pCustomerNo: Code[20])
    var
        Dilog1: Dialog;
    begin
        Dilog1.open('Encours..');
        if (pEndDate <> 0D) and (pStartDate <> 0D) then
            Rec.SetFilter("Posting Date", '%1..%2', pStartDate, pEndDate)
        else if (pStartDate = 0D) and (pEndDate <> 0D) then
            Rec.SetFilter("Posting Date", '..%1', pEndDate)
        else if (pStartDate <> 0D) and (pEndDate = 0D) then
            Rec.SetFilter("Posting Date", '%1..', pStartDate);
        Rec.SetFilter("Bill-to Customer No.", pCustomerNo);
        Dilog1.Close();
        CurrPage.Update(false);

    end;

    var
        StandardPrintIsVisible: Boolean;
        LineAmountIncVat: Decimal;
        CustomerName: Text[100];

}