

Page 50040 "WDC Sales Shipments"
{
    ApplicationArea = All;
    CaptionML = ENU = 'Sales Shipments', FRA = 'Bons de livraison';
    PageType = Document;
    Editable = true;
    UsageCategory = Lists;
    layout
    {
        area(Content)
        {

            group(Filters)
            {
                Editable = true;
                CaptionML = ENU = 'Filters', FRA = 'Filtres';
                group(FilterByDate)
                {
                    CaptionML = ENU = 'Filter by Date', FRA = 'Filtrer par date';
                    ShowCaption = false;
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
                            CurrPage."WDC Sales Shipments Part".Page.FilterCurrentPage(StartDateFilter, EndDateFilter, CustomerNoFilter);
                            TotalAmountIncVat := 0;
                            TotalAmountIncVat := GetTotalAmountIncVat(StartDateFilter, EndDateFilter);
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
                            CurrPage."WDC Sales Shipments Part".Page.FilterCurrentPage(StartDateFilter, EndDateFilter, CustomerNoFilter);
                            TotalAmountIncVat := 0;
                            TotalAmountIncVat := GetTotalAmountIncVat(StartDateFilter, EndDateFilter);
                            CurrPage.Update(false);
                        end;
                    }
                }
                group(FilterByCustomer)
                {
                    ShowCaption = false;
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
                            // Rec.SetFilter("Sell-to Customer No.", CustomerNoFilter);
                            CurrPage."WDC Sales Shipments Part".Page.FilterCurrentPage(StartDateFilter, EndDateFilter, CustomerNoFilter);
                            TotalAmountIncVat := GetTotalAmountIncVat(StartDateFilter, EndDateFilter);
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

            part("WDC Sales Shipments Part"; "WDC Sales Shipments Part")
            {
                ApplicationArea = All;
            }

            //<<WDC03
        }

    }

    trigger OnOpenPage()
    var

    begin
        SalesSetup.get();
        GenLedgSetup.Get();
        StartDateFilter := DMY2Date(1, Date2DMY(WorkDate, 2), Date2DMY(WorkDate, 3));
        EndDateFilter := CALCDATE('<CM>', StartDateFilter);
        CurrPage."WDC Sales Shipments Part".Page.FilterCurrentPage(StartDateFilter, EndDateFilter, CustomerNoFilter);
        TotalAmountIncVat := GetTotalAmountIncVat(StartDateFilter, EndDateFilter);
        CurrPage.Update(false);
    end;

    procedure GetTotalAmountIncVat(pStartDate: Date; pEndDate: Date): Decimal
    var
        lsalesline: record "Sales Line";
        lSalesShipHeader: record "Sales Shipment Header";
        VSalesshipmentline: record "Sales Shipment Line";
        TotalBrut: Decimal;
        totalRemise: Decimal;
        TotalNetvcRemise: decimal;
        MontantTva7: Decimal;
        MontantTva19: Decimal;
        MontantTva13: Decimal;
        lLineAmountInclVat: Decimal;
        TotalSansTva: decimal;
        item: record Item;
        TotalTransport: Decimal;
        ChargeItem: record "Item Charge";
        TotalRedevance: decimal;
        SalesHeader: record "Sales Header";
        MontantTva: Decimal;
    begin

        TotalAmountIncVat := 0;
        lSalesShipHeader.Reset();
        lSalesShipHeader.SetCurrentKey("Posting Date", "Sell-to Customer No.");
        lSalesShipHeader.CalcFields("Remain to Invoice", "Not Totally Canceled");
        lSalesShipHeader.SetRange("Not Totally Canceled", true);
        lSalesShipHeader.SetFilter("Customer Posting Group", '<>%1', 'C-PASSAGER');
        if CustomerNoFilter <> '' then
            lSalesShipHeader.Setfilter("Sell-to Customer No.", CustomerNoFilter)
        else
            lSalesShipHeader.Setfilter("Sell-to Customer No.", '<>%1', '9999');

        if (pStartDate <> 0D) and (pEndDate <> 0D) then
            lSalesShipHeader.SetFilter("Posting Date", '%1..%2', pStartDate, pEndDate)
        else if (pStartDate <> 0D) and (pEndDate = 0D) then
            lSalesShipHeader.SetFilter("Posting Date", '%1..', pStartDate)
        else if (pStartDate = 0D) and (pEndDate <> 0D) then
            lSalesShipHeader.SetFilter("Posting Date", '..%1', pEndDate);
        if lSalesShipHeader.FindSet() then
            repeat
                MontantTva7 := 0;
                MontantTva13 := 0;
                MontantTva19 := 0;
                TotalRedevance := 0;
                TotalTransport := 0;
                TotalBrut := 0;
                TotalNetvcRemise := 0;
                TotalNetvcRemise := 0;
                TotalSansTva := 0;
                lLineAmountInclVat := 0;
                if lSalesShipHeader."Order No." <> '' then begin
                    SalesHeader.reset();
                    if SalesHeader.get(SalesHeader."Document Type"::Order, lSalesShipHeader."Order No.") then;
                end;

                VSalesshipmentline.reset();
                VSalesshipmentline.SetCurrentKey("Document No.", "Line No.");
                VSalesshipmentline.setrange("Document No.", lSalesShipHeader."No.");
                if VSalesshipmentline.FindSet() then
                    repeat
                        if VSalesshipmentline.Quantity < 0 then begin
                            VSalesshipmentline."Item Charge Base Amount" := VSalesshipmentline."Item Charge Base Amount" * (-1);
                            vsalesshipmentline."VAT Base Amount" := vsalesshipmentline."VAT Base Amount" * (-1)
                        end;
                        if VSalesshipmentline.type = VSalesshipmentline.type::"Charge (Item)" then begin
                            ChargeItem.reset();
                            if ChargeItem.Get(VSalesshipmentline."No.") then
                                if ChargeItem."Gen. Prod. Posting Group" = 'REDEVANCE' then
                                    if VSalesshipmentline."VAT Base Amount" <> 0 then
                                        TotalRedevance += VSalesshipmentline."VAT Base Amount"
                                    else if VSalesshipmentline."Item Charge Base Amount" <> 0 then
                                        TotalRedevance += VSalesshipmentline."Item Charge Base Amount"
                                    else
                                        TotalRedevance += VSalesshipmentline.Quantity * VSalesshipmentline."Unit Price";
                        end;
                        if item.get(VSalesshipmentline."No.") then
                            if (item."Associated With Iron" = true) or (item."Associated With Cement" = true) then begin
                                if VSalesshipmentline."VAT Base Amount" <> 0 then
                                    TotalTransport += VSalesshipmentline."VAT Base Amount"
                                else if VSalesshipmentline."Item Charge Base Amount" <> 0 then
                                    TotalTransport += VSalesshipmentline."Item Charge Base Amount"
                                else if VSalesshipmentline."Item Charge Base Amount" <> 0 then
                                    TotalTransport += VSalesshipmentline."Item Charge Base Amount"
                                else
                                    TotalTransport += VSalesshipmentline.Quantity * VSalesshipmentline."Unit Price";
                            end
                            else begin
                                TotalBrut += VSalesshipmentline.Quantity * VSalesshipmentline."Unit Price";
                                totalRemise += (VSalesshipmentline.Quantity * VSalesshipmentline."Unit Price") - VSalesshipmentline."Item Charge Base Amount";
                                if VSalesshipmentline."VAT Base Amount" <> 0 then
                                    TotalNetvcRemise += VSalesshipmentline."VAT Base Amount"
                                else
                                    TotalNetvcRemise += VSalesshipmentline."Item Charge Base Amount";
                            end;
                        if SalesHeader."Invoice Discount Value" <> 0 then begin
                            if lsalesline.get(lsalesline."Document Type"::Order, VSalesshipmentline."Order No.", VSalesshipmentline."Line No.") then begin
                                if VSalesshipmentline."VAT %" = 7 then
                                    MontantTva7 += lsalesline.Amount * (VSalesshipmentline."VAT %" / 100);
                                if VSalesshipmentline."VAT %" = 19 then
                                    MontantTva19 += lsalesline.Amount * (VSalesshipmentline."VAT %" / 100);
                                if VSalesshipmentline."VAT %" = 13 then
                                    MontantTva13 += lsalesline.Amount * (VSalesshipmentline."VAT %" / 100);
                            end;
                        end
                        else begin
                            if VSalesshipmentline."VAT %" = 7 then begin
                                if VSalesshipmentline."VAT Base Amount" <> 0 then
                                    MontantTva7 += VSalesshipmentline."VAT Base Amount" * (VSalesshipmentline."VAT %" / 100)
                                else
                                    MontantTva7 += VSalesshipmentline."Item Charge Base Amount" * (VSalesshipmentline."VAT %" / 100);
                            end;
                            if VSalesshipmentline."VAT %" = 19 then begin
                                if VSalesshipmentline."VAT Base Amount" <> 0 then
                                    MontantTva19 += VSalesshipmentline."VAT Base Amount" * (VSalesshipmentline."VAT %" / 100)
                                else
                                    MontantTva19 += VSalesshipmentline."Item Charge Base Amount" * (VSalesshipmentline."VAT %" / 100);
                            end;
                            if VSalesshipmentline."VAT %" = 13 then begin
                                if VSalesshipmentline."VAT Base Amount" <> 0 then
                                    MontantTva13 += VSalesshipmentline."VAT Base Amount" * (VSalesshipmentline."VAT %" / 100)
                                else
                                    MontantTva13 += VSalesshipmentline."Item Charge Base Amount" * (VSalesshipmentline."VAT %" / 100);
                            end;
                        end;
                    until VSalesshipmentline.Next() = 0;
                TotalSansTva += TotalNetvcRemise + TotalTransport + TotalRedevance;
                if SalesHeader."Invoice Discount value" <> 0 then
                    TotalSansTva := TotalSansTva - SalesHeader."Invoice Discount value";
                lLineAmountInclVat := TotalSansTva + MontantTva7 + MontantTva19 + MontantTva13;
                TotalAmountIncVat += lLineAmountInclVat;
            until lSalesShipHeader.Next() = 0;
        exit(TotalAmountIncVat);
    end;

    var
        StartDateFilter: Date;
        EndDateFilter: Date;
        LineAmountInclVat: Decimal;
        TotalAmountIncVat: Decimal;
        CustomerNoFilter: Code[20];
        CustomerName: Text[100];
        SalespersonFilter: Code[20];
        SalesSetup: Record "Sales & Receivables Setup";
        GenLedgSetup: Record "General Ledger Setup";
}