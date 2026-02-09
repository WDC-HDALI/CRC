report 50011 "WDC Not Invoiced Whse Receipt"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;
    DefaultLayout = RDLC;
    RDLCLayout = './.vscode/src/Report/RDLC/NotInvoicedWarehouseReceipt.rdlc';

    CaptionML = ENU = 'Not Invoiced Warehouse Receipt', FRA = 'Réceptions achat non facturés';

    dataset
    {
        dataitem(Vendor; Vendor)
        {
            DataItemTableView = SORTING("No.");
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.";
            column(CompanyInfo_Name; CompanyInfo.Name)
            {
            }
            column(CompanyInfo_Address; CompanyInfo.Address)
            {
            }
            column(Vendor_No; Vendor."No.")
            {
            }
            column("Vendor_NomAbrégé"; Vendor.Name)
            {
            }
            column(Vendor_PayTermsCode; Vendor."Payment Terms Code")
            {
            }
            dataitem("Purch. Rcpt. Line"; "Purch. Rcpt. Line")
            {
                DataItemLink = "Pay-to Vendor No." = FIELD("No.");
                DataItemTableView = SORTING("Document No.", "Line No.")
                                    ORDER(Ascending);
                column(PurchRcptLine_DocumentNo; "Purch. Rcpt. Line"."Document No.")
                {
                }
                column(dateRec; dateRec)
                {
                }
                column(PurchRcptLine_No; "Purch. Rcpt. Line"."No.")
                {
                }
                column(PurchRcptLine_Description; "Purch. Rcpt. Line".Description)
                {
                }
                column(PurchRcptLine_OrderNo; "Purch. Rcpt. Line"."Order No.")
                {
                }
                column(PurchRcptLine_QtyRcdNotInvoiced; "Purch. Rcpt. Line"."Qty. Rcd. Not Invoiced")
                {
                }
                column(UnitCostEur; UnitCostEur)
                {
                }
                column(MontantRecEUR; MontantRecEUR)
                {
                }

                trigger OnAfterGetRecord()
                begin

                    // //>>BEGIN 170412
                    // IF PurchRecheader.GET("Purch. Rcpt. Line"."Document No.") THEN
                    //     IF PurchRecheader."Non facturable" THEN
                    //         CurrReport.SKIP;
                    // //<<END 170412

                    PurchRecheader.SETRANGE("No.", "Document No.");
                    IF PurchRecheader.FIND('-') THEN
                        dateRec := PurchRecheader."Posting Date";

                    //>>BEGIN 12042012
                    IF (DateDbt <> 0D) AND (DateFin <> 0D) THEN
                        IF (dateRec < DateDbt) OR (dateRec > DateFin) THEN
                            CurrReport.SKIP;
                    //<<END 12042012



                    //>>BEGIN 02052012 Gestion du code devise et affichage du montant en EUR
                    MontantRec :=
                    ROUND(("Qty. Rcd. Not Invoiced" * "Unit Cost (LCY)" *
                              (1 - ("Line Discount %" / 100))), 0.001, '>');

                    //ROUND("Purch. Rcpt. Line"."Qty. Rcd. Not Invoiced" * "Purch. Rcpt. Line"."Unit Cost (LCY)",0.001,'>');

                    //<<003
                    MontantRecEUR := ROUND(MontantRec, 0.001, '>');
                    UnitCostEur := "Purch. Rcpt. Line"."Unit Cost (LCY)";
                    /*
                    // Begin
                    CALCFIELDS("Currency Code");
                    IF "Currency Code" = 'EUR' THEN BEGIN
                      MontantRecEUR := ROUND("Qty. Rcd. Not Invoiced" * "Direct Unit Cost",0.001,'>');
                      UnitCostEur := "Direct Unit Cost";
                    END ELSE BEGIN
                    // End
                    
                    Rec330.RESET;
                    Rec330.SETRANGE(Rec330."Currency Code",'EUR');
                    IF Rec330.FINDLAST THEN BEGIN
                      //Rec39.RESET;
                      //Rec39.SETRANGE(Rec39."Document Type",Rec39."Document Type"::Order);
                      //Rec39.SETRANGE(Rec39."Document No.","Purch. Rcpt. Line"."Order No.");
                      //Rec39.SETRANGE(Rec39."Line No.","Purch. Rcpt. Line"."Order Line No.");
                      //IF Rec39.FINDFIRST THEN BEGIN
                        MontantRecEUR := ROUND(MontantRec / Rec330."Relational Exch. Rate Amount",0.001,'>');
                        UnitCostEur := "Purch. Rcpt. Line"."Unit Cost (LCY)" / Rec330."Relational Exch. Rate Amount";
                        //MontantRecEUR := Rec39.Amount;
                        //UnitCostEur := Rec39."Direct Unit Cost";
                      //END;
                    END;
                    //<<END 02052012 Gestion du code devise et affichage du montant en EUR
                    END;
                    */
                    //>>003
                    Vend.GET("Purch. Rcpt. Line"."Buy-from Vendor No.");
                    NomAbrege := Vend.Name;

                    //BEGIN 040413
                    PurchLine.RESET;
                    PurchLine.SETRANGE(PurchLine."Document Type", PurchLine."Document Type"::Invoice);
                    PurchLine.SETRANGE(PurchLine."Receipt No.", "Purch. Rcpt. Line"."Document No.");
                    PurchLine.SETRANGE(PurchLine."Receipt Line No.", "Purch. Rcpt. Line"."Line No.");
                    IF PurchLine.FINDFIRST THEN
                        CurrReport.SKIP;
                    //END 040413


                    TotalFour += MontantRecEUR;
                    TotalGlobal += MontantRecEUR;

                end;

                trigger OnPreDataItem()
                begin
                    "Purch. Rcpt. Line".SETFILTER("Qty. Rcd. Not Invoiced", '<>%1', 0)
                end;
            }

            trigger OnAfterGetRecord()
            begin

                TotalFour := 0;

                PurchRcptLine.RESET;
                PurchRcptLine.SETCURRENTKEY("Buy-from Vendor No.");
                PurchRcptLine.SETRANGE(PurchRcptLine."Buy-from Vendor No.", Vendor."No.");
                PurchRcptLine.SETFILTER("Qty. Rcd. Not Invoiced", '<>%1', 0);
                IF PurchRcptLine.FINDFIRST THEN
                    Afficher := TRUE
                ELSE
                    Afficher := FALSE;
            end;

            trigger OnPreDataItem()
            begin
                CompanyInfo.GET;
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
                    CaptionML = ENU = 'Starting Date', FRA = 'Date de début';
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
    }

    var
        dateRec: Date;
        PurchRecheader: Record 120;
        CompanyInfo: Record 79;
        TotalFour: Decimal;
        MontantRec: Decimal;
        MontantRecEUR: Decimal;
        TotalGlobal: Decimal;
        MontantReturn: Decimal;
        MontantReturnEUR: Decimal;
        Rec39: Record 39;
        DateDbt: Date;
        DateFin: Date;
        Rec330: Record 330;
        UnitCostEur: Decimal;
        RetUnitCostEur: Decimal;
        ReturnShipHeader: Record 6650;
        ExcelBuf: Record 370 temporary;
        PrintToExcel: Boolean;
        PurchRcptLine: Record 121;
        Afficher: Boolean;
        Vend: Record 23;
        NomAbrege: Code[10];
        PurchLine: Record 39;
}

