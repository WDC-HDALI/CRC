report 50010 "WDC DN not invoiced - lines"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;
    DefaultLayout = RDLC;
    RDLCLayout = './.vscode/src/Report/RDLC/DNnotinvoicedlines.rdlc';

    CaptionML = ENU = 'DN not invoiced lines', FRA = 'BL non facturés';

    dataset
    {
        dataitem(Customer; Customer)
        {
            DataItemTableView = SORTING("No.");
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.";
            column(COMPANYNAME; COMPANYNAME)
            {
            }

            column("Nomabrégé_Customer"; Customer.Name)
            {
            }
            column(PaymentTermsCode_Customer; Customer."Payment Terms Code")
            {
            }
            column(No_Customer; Customer."No.")
            {
            }
            dataitem("Sales Shipment Line"; "Sales Shipment Line")
            {
                DataItemLink = "Bill-to Customer No." = FIELD("No.");
                DataItemTableView = SORTING("Sell-to Customer No.")
                                    ORDER(Ascending);
                RequestFilterFields = "Shortcut Dimension 1 Code";
                column(No_SalesShipmentLine; "Sales Shipment Line"."No.")
                {
                }
                column(DocumentNo_SalesShipmentLine; "Sales Shipment Line"."Document No.")
                {
                }
                column(dateliv; dateliv)
                {
                }
                column(QtyShippedNotInvoiced_SalesShipmentLine; "Sales Shipment Line"."Qty. Shipped Not Invoiced")
                {
                }
                column(Description_SalesShipmentLine; "Sales Shipment Line".Description)
                {
                }
                column(OrderNo_SalesShipmentLine; "Sales Shipment Line"."Order No.")
                {
                }
                column(UnitPrice_SalesShipmentLine; "Sales Shipment Line"."Unit Price")
                {
                    DecimalPlaces = 2 : 2;
                }
                column(Montant; Montant)
                {
                }
                column(SelltoCustomerNo_SalesShipmentLine; "Sales Shipment Line"."Sell-to Customer No.")
                {
                }
                column(ClientCode; ClientCode)
                {
                }
                column(SendByPlane_SalesShipmentLine; Send_By_Plane_G)
                {
                }
                column(Incoterm; Incoterm)
                {
                }
                column(SelltoCountryCode_SalesShipmentLine; salesshipheader."Sell-to Country/Region Code")
                {
                }
                column(BillToClientCode; BillToClientCode)
                {
                }
                column(ItemChargeBaseAmount_SalesShipmentLine; "Sales Shipment Line"."Item Charge Base Amount")
                {
                }
                column(TotalClient_1; TotalClient)
                {
                }
                column(TotalGlobal_1; TotalGlobal)
                {
                }
                column(SOPrice; SOPrice)
                {
                    DecimalPlaces = 0 : 4;
                }
                column(FactureDouane; FactureDouane)
                {
                }

                trigger OnAfterGetRecord()
                var
                    LCustomer: Record 18;
                begin
                    FactureDouane := '';
                    salesshipheader.SETRANGE("No.", "Document No.");
                    IF salesshipheader.FIND('-') THEN BEGIN
                        dateliv := salesshipheader."Posting Date";
                        //FactureDouane := salesshipheader."N° Facture douane";
                    END;
                    //TC +
                    CLEAR(SOPrice);
                    CLEAR(SalesLine);
                    IF SalesLine.GET(SalesLine."Document Type"::Order, "Order No.", "Order Line No.") THEN
                        SOPrice := SalesLine."Unit Price";
                    //TC -
                    //>>BEGIN 12042012
                    IF (DateDbt <> 0D) AND (DateFin <> 0D) THEN
                        IF (dateliv < DateDbt) OR (dateliv > DateFin) THEN
                            CurrReport.SKIP;
                    //<<END 12042012


                    IF "Sales Shipment Line"."Item Charge Base Amount" <> 0 THEN
                        Montant := "Sales Shipment Line"."Item Charge Base Amount"
                    ELSE BEGIN //TC +
                               //Montant := "Sales Shipment Line"."Unit Price" * "Sales Shipment Line".Quantity;
                        IF (Type = Type::Item) AND ("Unit Price" = 0) THEN
                            Montant := "Qty. Shipped Not Invoiced" * SOPrice
                        ELSE
                            Montant := "Sales Shipment Line"."Unit Price" * "Sales Shipment Line"."Qty. Shipped Not Invoiced";

                    END; //TC -
                    //IF "Sales Shipment Line"."Sell-to Customer No." <> '' THEN BEGIN
                    //Customer.GET("Sales Shipment Line"."Sell-to Customer No.");
                    //NomClient := Customer.Name;
                    //END

                    //BEGIN 040413
                    SalesLine.RESET;
                    SalesLine.SETCURRENTKEY(SalesLine."Shipment No.", SalesLine."Shipment Line No.");
                    SalesLine.SETRANGE(SalesLine."Document Type", SalesLine."Document Type"::Invoice);
                    SalesLine.SETRANGE(SalesLine."Shipment No.", "Sales Shipment Line"."Document No.");
                    SalesLine.SETRANGE(SalesLine."Shipment Line No.", "Sales Shipment Line"."Line No.");
                    IF SalesLine.FINDFIRST THEN
                        CurrReport.SKIP;
                    //END 040413

                    // Begin 002
                    CLEAR(ClientCode);
                    IF "Sell-to Customer No." <> '' THEN
                        IF LCustomer.GET("Sell-to Customer No.") THEN
                            ClientCode := LCustomer.Name;
                    // End 002

                    // Begin 005
                    CLEAR(BillToClientCode);
                    IF "Bill-to Customer No." <> '' THEN
                        IF LCustomer.GET("Bill-to Customer No.") THEN
                            BillToClientCode := LCustomer.Name;
                    // End 005


                    // Incoterm := "Incoterm Code";
                    // IF Incoterm = '' THEN BEGIN
                    //     // Begin 003
                    //     CLEAR(Incoterm);
                    //     SalesPrice.RESET;
                    //     SalesPrice.SETRANGE("Sell To Customer No.", "Sell-to Customer No.");
                    //     SalesPrice.SETRANGE("Item No.", "No.");
                    //     SalesPrice.SETFILTER("Incoterm Code", '<>%1', '');
                    //     IF SalesPrice.FINDLAST THEN
                    //         Incoterm := SalesPrice."Incoterm Code";
                    //     // End 003
                    // END;
                    //MIG001
                    // IF "Sales Shipment Line"."Send By Plane" THEN
                    //     Send_By_Plane_G := 'YES'
                    // ELSE
                    //     Send_By_Plane_G := 'NO';
                    //MIG001
                    TotalClient += "Item Charge Base Amount";
                    TotalGlobal += "Item Charge Base Amount";
                end;

                trigger OnPreDataItem()
                begin
                    "Sales Shipment Line".SETFILTER("Sales Shipment Line"."Qty. Shipped Not Invoiced", '<>%1', 0);
                    CurrReport.CREATETOTALS(Montant); // 004
                end;
            }
            dataitem("Return Receipt Line"; "Return Receipt Line")
            {
                DataItemLink = "Bill-to Customer No." = FIELD("No.");
                DataItemTableView = SORTING("Sell-to Customer No.")
                                    ORDER(Ascending)
                                    WHERE("Return Qty. Rcd. Not Invd." = FILTER(<> 0));
                RequestFilterFields = "Shortcut Dimension 1 Code";
                column(DocumentNo_ReturnReceiptLine; "Return Receipt Line"."Document No.")
                {
                }
                column(No_ReturnReceiptLine; "Return Receipt Line"."No.")
                {
                }
                column(Description_ReturnReceiptLine; "Return Receipt Line".Description)
                {
                }
                column(UnitPrice_ReturnReceiptLine; "Return Receipt Line"."Unit Price")
                {
                    DecimalPlaces = 2 : 2;
                }
                column(ItemChargeBaseAmount_ReturnReceiptLine; "Return Receipt Line"."Item Charge Base Amount")
                {
                }
                column(Quantity_ReturnReceiptLine; "Return Receipt Line".Quantity)
                {
                }
                column(PostingDate_ReturnReceiptLine; "Return Receipt Line"."Posting Date")
                {
                }
                column(SelltoCustomerNo_ReturnReceiptLine; "Return Receipt Line"."Sell-to Customer No.")
                {
                }
                column(SelltoCountryCode_ReturnReceiptLine; ReturnRecHeader."Sell-to Country/Region Code")
                {
                }
                column(TotalClient; TotalClient)
                {
                }
                column(TotalGlobal; TotalGlobal)
                {
                }

                trigger OnAfterGetRecord()
                var
                    LCustomer: Record 18;
                begin

                    // //>>BEGIN 130513
                    // IF ReturnRecHeader.GET("Return Receipt Line"."Document No.") THEN
                    //     IF ReturnRecHeader."Non facturable" THEN
                    //         CurrReport.SKIP;
                    // //<<END 130513


                    //>>BEGIN 12042012
                    IF (DateDbt <> 0D) AND (DateFin <> 0D) THEN
                        IF ("Return Receipt Line"."Posting Date" < DateDbt) OR ("Return Receipt Line"."Posting Date" > DateFin) THEN
                            CurrReport.SKIP;
                    //<<END 12042012

                    //BEGIN 040413
                    SalesLine.RESET;
                    SalesLine.SETCURRENTKEY(SalesLine."Return Receipt No.", SalesLine."Return Receipt Line No.");
                    SalesLine.SETRANGE(SalesLine."Document Type", SalesLine."Document Type"::"Credit Memo");
                    SalesLine.SETRANGE(SalesLine."Return Receipt No.", "Return Receipt Line"."Document No.");
                    SalesLine.SETRANGE(SalesLine."Return Receipt Line No.", "Return Receipt Line"."Line No.");
                    IF SalesLine.FINDFIRST THEN
                        CurrReport.SKIP;
                    //END 040413

                    // Begin 002
                    CLEAR(ClientCode);
                    IF "Sell-to Customer No." <> '' THEN
                        IF LCustomer.GET("Sell-to Customer No.") THEN
                            ClientCode := LCustomer.Name;
                    // End 002

                    // Begin 005
                    CLEAR(BillToClientCode);
                    IF "Bill-to Customer No." <> '' THEN
                        IF LCustomer.GET("Bill-to Customer No.") THEN
                            BillToClientCode := LCustomer.Name;
                    // End 005


                    //Incoterm := "Incoterm Code";
                    // IF Incoterm = '' THEN BEGIN
                    //     // Begin 003
                    //     CLEAR(Incoterm);
                    //     SalesPrice.RESET;
                    //     SalesPrice.SETRANGE("Sell To Customer No.", "Sell-to Customer No.");
                    //     SalesPrice.SETRANGE("Item No.", "No.");
                    //     SalesPrice.SETFILTER("Incoterm Code", '<>%1', '');
                    //     IF SalesPrice.FINDLAST THEN
                    //         Incoterm := SalesPrice."Incoterm Code";
                    //     // End 003
                    // END;
                    TotalClient += "Item Charge Base Amount";
                    TotalGlobal += "Item Charge Base Amount";
                end;

                trigger OnPreDataItem()
                begin
                    //"Return Receipt Line".SETRANGE("Posting Date",DateDbt,DateFin);
                end;
            }

            trigger OnPreDataItem()
            begin
                TotalClient := 0;
                TotalGlobal := 0;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(DateDbt; DateDbt)
                {
                    CaptionML = ENU = 'Date Begin', FRA = 'Date début';
                    ApplicationArea = all;
                }
                field(DateFin; DateFin)
                {
                    CaptionML = ENU = 'Date End', FRA = 'Date fin';
                    ApplicationArea = all;
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
        title = 'Liste BL non facturées';
        //Page = 'Page';
        Amount_Euro = 'Montant';
        Qty_Ship_Not_invoiced = 'Qté. expédiée non facturée';
        Unit_Price_Euro = 'Prix Unitaire';
        Description = 'Description';
        Order_No = 'N° commande';
        Item_No = 'N° article';
        Delivery_Date = 'Date de livraison';
        Sell_to_clt_code = 'Nom client';
        Sell_to_No = 'N° client';
        Bill_To_clt_code = 'Code client facturé';
        DN_No = 'N° DN';
        Payment_Terms = 'Conditions de paiement';
        Tot_Clt_euro = 'Total Client';
        Tot_Global_euro = 'Total Global';
    }

    var
        NomClient: Text[50];
        Cust: Record 18;
        dateliv: Date;
        salesshipheader: Record 110;
        MontantRetour: Decimal;
        TotalClient: Decimal;
        TotalGlobal: Decimal;
        Montant: Decimal;
        DateDbt: Date;
        DateFin: Date;
        SalesLine: Record 37;
        ReturnRecHeader: Record 6660;
        ExcelBuf: Record 370 temporary;
        PrintToExcel: Boolean;
        ClientCode: Text[100];
        Incoterm: Text[30];
        BillToClientCode: Text[100];
        SOPrice: Decimal;
        Send_By_Plane_G: Text;
        FactureDouane: Code[20];
}

