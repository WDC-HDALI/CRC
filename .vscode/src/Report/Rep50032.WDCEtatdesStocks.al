report 50032 "WDC Etat des Stocks"
{
    //***********Documentation*****************
    // WDC01 21/08/2024 :comment Serilys
    DefaultLayout = RDLC;
    RDLCLayout = './.vscode/src/report/RDLC/EtatdesStocks.rdl';
    ApplicationArea = Basic, Suite;
    Caption = 'Etat des stocks';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(Item; Item)
        {
            DataItemTableView = WHERE(Type = FILTER(Inventory));

            RequestFilterFields = "No.", "Inventory Posting Group", "Gen. Prod. Posting Group";
            column(FORMATTODAY04; FORMAT(TODAY, 0, 4))
            {
            }
            column(COMPANYNAME; COMPANYNAME)
            {
            }

            // column(CompanyPicture; CompanyInfo.Picture)
            // {
            // }
            column(StandardCost; "Standard Cost")
            {
            }


            column(FiltersText; FiltersText)
            {
            }
            column(USERID; USERID)
            {
            }
            column(Date_Stock_Text001; Text0001 + ' ' + FORMAT(DateStock))
            {
            }
            column(No; "No.")
            {
            }
            column(Description; Description)
            {
            }
            column(Baseunitofmesure; "Base Unit of Measure")
            {
                //OptionCaption = 'Unit of Mesure';
            }
            column(QteStock; QteStock)
            {
            }
            column(Blocked; Item.Blocked)
            {
            }
            column(CUTotal; CUTotal)
            {
                //DecimalPlaces = 4 : 4;
                DecimalPlaces = 5; //WDC.HG
            }
            column(NewTotStockVal; NewTotStockVal)
            {
            }
            column(RepSystem; Item."Replenishment System")
            {
            }
            column(Counter; Counter)
            {
            }
            dataitem(ItemLedgerEntry; "Item Ledger Entry")
            {
                DataItemLink = "Item No." = FIELD("No.");
                //DataItemTableView = SORTING("Location Code");   //SAT
                DataItemTableView = SORTING("Item No.", "Location Code", "Lot No.");   //SAT
                RequestFilterFields = "Location Code", "Lot No.";

                column(ItemNo; "Item No.")
                {
                }
                column(LocationCode; Location.Code)
                {
                }
                column(Quantity; Quantity)
                {
                }
                column(LotNo; "Lot No.")
                {
                }
                //column(ExpirationDate; "Expiration Date")
                column(ExpirationDate; DateExp)
                {
                }
                column(ReControlDate; DateReControl)
                {
                }
                column(sumCUTotal; sumCUTotal)
                {
                }
                trigger OnAfterGetRecord()
                var
                    myInt: Integer;

                begin

                    if Location.Get("Location Code") then;
                    //<< Cmt WDC01
                    // if (Owner <> '') and (UpperCase(Location.Owner) <> UpperCase(Owner)) then
                    //     CurrReport.SKIP;
                    //>> Cmt WDC01
                    IF StockNul AND (Item.Inventory = 0) THEN
                        CurrReport.SKIP;
                    StockVal := Quantity * Item."Unit Cost";


                    sumCUTotal := CUTotal * Quantity;
                    //<<Cmt WDC01
                    // //SAT
                    // if (OldLocation <> "Location Code") OR (OldLot <> "Lot No.") or (OldItem <> "Item No.") then begin
                    //     clear(DateExp);
                    //     clear(DateReControl);
                    //     clear(ItemLedgerEntry4);
                    //     ItemLedgerEntry4.SetCurrentKey("Item No.", "Location Code", "Lot No.");
                    //     ItemLedgerEntry4.SetRange("Item No.", "Item No.");
                    //     ItemLedgerEntry4.setrange("Location Code", "Location Code");
                    //     ItemLedgerEntry4.setrange("Lot No.", "Lot No.");
                    //     ItemLedgerEntry4.SetRange(Open, true);
                    //     ItemLedgerEntry4.SetFilter("Expiration Date", '<>%1', 0D);
                    //     if ItemLedgerEntry4.FindLast() then begin
                    //         DateExp := ItemLedgerEntry4."Expiration Date";
                    //         DateReControl := ItemLedgerEntry4."Re-check Date";
                    //     end else begin
                    //         clear(ItemLedgerEntry4);
                    //         ItemLedgerEntry4.SetCurrentKey("Item No.", "Location Code", "Lot No.");
                    //         ItemLedgerEntry4.SetRange("Item No.", "Item No.");
                    //         ItemLedgerEntry4.setrange("Location Code", "Location Code");
                    //         ItemLedgerEntry4.setrange("Lot No.", "Lot No.");
                    //         ItemLedgerEntry4.SetFilter("Expiration Date", '<>%1', 0D);
                    //         if ItemLedgerEntry4.FindLast() then begin
                    //             DateExp := ItemLedgerEntry4."Expiration Date";
                    //             DateReControl := ItemLedgerEntry4."Re-check Date";
                    //         end else begin
                    //             clear(ItemLedgerEntry4);
                    //             ItemLedgerEntry4.SetCurrentKey("Item No.", "Location Code", "Lot No.");
                    //             ItemLedgerEntry4.SetRange("Item No.", "Item No.");
                    //             ItemLedgerEntry4.setrange("Location Code", "Location Code");
                    //             ItemLedgerEntry4.setrange("Lot No.", "Lot No.");
                    //             ItemLedgerEntry4.SetRange(Open, true);
                    //             if ItemLedgerEntry4.FindLast() then begin
                    //                 DateExp := ItemLedgerEntry4."Expiration Date";
                    //                 DateReControl := ItemLedgerEntry4."Re-check Date";
                    //             end else begin
                    //                 clear(ItemLedgerEntry4);
                    //                 ItemLedgerEntry4.SetCurrentKey("Item No.", "Location Code", "Lot No.");
                    //                 ItemLedgerEntry4.SetRange("Item No.", "Item No.");
                    //                 ItemLedgerEntry4.setrange("Location Code", "Location Code");
                    //                 ItemLedgerEntry4.setrange("Lot No.", "Lot No.");
                    //                 if ItemLedgerEntry4.FindLast() then begin
                    //                     DateExp := ItemLedgerEntry4."Expiration Date";
                    //                     DateReControl := ItemLedgerEntry4."Re-check Date";
                    //                 end;
                    //             end;
                    //             OldLocation := "Location Code";
                    //             OldLot := "Lot No.";
                    //             OldItem := "Item No.";

                    //         end;
                    //     end;
                    // end;
                    //<<Cmt WDC01
                end;

                trigger OnPreDataItem()
                var
                    myInt: Integer;
                begin
                    SetFilter("Posting Date", '<=%1', DateStock);
                    //SAT
                    Clear(DateExp);
                    Clear(OldLocation);
                    clear(OldLot);
                end;
            }

            trigger OnAfterGetRecord()
            begin

                Item.SETRANGE(Item."Date Filter", 0D, DateStock);
                Item.CALCFIELDS(Item.Inventory);
                IF StockNul AND (Item.Inventory = 0) THEN
                    CurrReport.SKIP;

                //<<MIG001
                IF InvPostGroup.GET("Inventory Posting Group") THEN;
                CU := 0;
                NewTotStockVal := 0;
                ValStock := 0;
                QteStock := 0;
                EcrValeur.RESET;
                EcrValeur.SETCURRENTKEY(EcrValeur."Item No.", EcrValeur."Posting Date", EcrValeur."Item Ledger Entry Type", EcrValeur."Entry Type",
                EcrValeur."Variance Type", EcrValeur."Item Charge No.", EcrValeur."Location Code", EcrValeur."Variant Code");
                EcrValeur.SETRANGE(EcrValeur."Item No.", Item."No.");
                EcrValeur.SETRANGE(EcrValeur."Posting Date", 0D, DateStock);

                IF "Magasin No." <> '' THEN
                    EcrValeur.SETRANGE(EcrValeur."Location Code", "Magasin No.");
                IF EcrValeur.FINDFIRST THEN BEGIN
                    EcrValeur.CALCSUMS(EcrValeur."Cost Amount (Actual)", EcrValeur."Cost Amount (Expected)", EcrValeur."Item Ledger Entry Quantity");
                    QteStock := EcrValeur."Item Ledger Entry Quantity";
                    IF Item."Costing Method" = Item."Costing Method"::Standard THEN
                        CU := Item."Standard Cost"
                    ELSE BEGIN
                        IF QteStock <> 0 THEN BEGIN
                            ValStock := EcrValeur."Cost Amount (Actual)" + EcrValeur."Cost Amount (Expected)";
                            CU := ValStock / QteStock;
                        END ELSE
                            CU := Item."Unit Cost";
                    END;
                END;
                IF StockNul THEN BEGIN
                    IF (QteStock = 0) THEN //1708
                        CurrReport.SKIP;
                END;
                //>>MIG001
                Counter += 1; //HD
                NewTotStockVal := CU * QteStock;

                //<<001
                CUTotal := 0;
                ValStockTotal := 0;
                QteStockTotal := 0;

                EcrValeur.RESET;
                EcrValeur.SETCURRENTKEY(EcrValeur."Item No.", EcrValeur."Posting Date", EcrValeur."Item Ledger Entry Type", EcrValeur."Entry Type",
                EcrValeur."Variance Type", EcrValeur."Item Charge No.", EcrValeur."Location Code", EcrValeur."Variant Code");
                EcrValeur.SETRANGE(EcrValeur."Item No.", Item."No.");
                EcrValeur.SETRANGE(EcrValeur."Posting Date", 0D, DateStock);

                IF "Magasin No." <> '' THEN
                    EcrValeur.SETRANGE(EcrValeur."Location Code", "Magasin No.");
                IF EcrValeur.FINDFIRST THEN BEGIN
                    EcrValeur.CALCSUMS(EcrValeur."Cost Amount (Actual)", EcrValeur."Cost Amount (Expected)", EcrValeur."Item Ledger Entry Quantity");
                    QteStockTotal := EcrValeur."Item Ledger Entry Quantity";
                    IF Item."Costing Method" = Item."Costing Method"::Standard THEN
                        CUTotal := Item."Standard Cost"
                    ELSE BEGIN
                        IF QteStockTotal <> 0 THEN BEGIN
                            ValStockTotal := EcrValeur."Cost Amount (Actual)" + EcrValeur."Cost Amount (Expected)";
                            CUTotal := ValStockTotal / QteStockTotal;
                        END ELSE
                            CUTotal := Item."Unit Cost";
                    END;
                END;
                //>>001

            end;

            trigger OnPreDataItem()
            begin
                FiltersText := Item.GetFilters;
                // CurrReport.CREATETOTALS(NewTotStockVal);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Filters)
                {
                    field(DateStock; DateStock)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Date fin';
                    }
                    field(StockNul; StockNul)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Ignorer stock 0';
                    }
                    // field(Owner; Owner)
                    // {
                    //     ApplicationArea = Basic, Suite;
                    //     CaptionML = ENU = 'Owner', FRA = 'Propriétaire';
                    // }
                }
            }
        }


    }

    labels
    {
        Article = 'Item';
        Qte_stock = 'Qte stock';
        PMP = 'PMP (Euro)';
        StockValue = 'Stock Value (Euro)';
        Compta_Stock = 'Compta. Stock';
        Reapro = 'Réapro';
        Bloc_ked = 'Blocked';
        Total = 'Total';
        InvFamilyLbl = 'Inventory Family';
        RepSystemLbl = 'Replenishment System';
    }
    trigger OnInitReport()
    begin
        DateStock := WorkDate();
        StockNul := false;
        Owner := 'Serelys';
    end;

    trigger OnPreReport()
    begin

        IF DateStock = 0D THEN ERROR('La date fin de calcul de stock est obligatoire');

        TotalValStock := 0;
        Counter := 0;//HD
        CompanyInfo.GET;
        //CompanyInfo.CalcFields(Picture);
    end;


    var
        sumCUTotal: Decimal;
        Location: Record Location;
        DateStock: Date;
        "Magasin No.": Code[10];
        ValStock: Decimal;
        CompanyInfo: Record 79;
        EcrValeur: Record 5802;
        StockNul: Boolean;
        Owner: text;
        QteStock: Decimal;
        EcrArticle: Record 32;
        CU: Decimal;
        ExcelBuf: Record 370 temporary;
        PrintToExcel: Boolean;
        Rec330: Record 330;
        CurrFactor: Decimal;
        TotalValStock: Decimal;
        PurchInvLine: Record 123;
        ValueEntry: Record 5802;
        InvPostGroup: Record 94;
        LocalEUR: Decimal;
        PerQty: Decimal;
        LocalQty: Decimal;
        ILE: Record 32;
        NewTotStockVal: Decimal;
        StockVal: Decimal;
        Text001: Label 'Trial Balance';
        Text002: Label 'Company Name';
        Text003: Label 'Report No.';
        Text004: Label 'Report Name';
        Text005: Label 'User ID';
        Text006: Label 'Date';
        Text007: Label 'G/L Filter';
        Text0001: Label 'Stock jusqu''à ';
        QteStockTotal: Decimal;
        ValStockTotal: Decimal;
        CUTotal: Decimal;
        Counter: Integer;
        FiltersText: Text;
        DateExp: Date;
        DateReControl: Date;
        OldLocation: Code[20];
        OldLot: Code[30];
        OldItem: Code[30];
        ItemLedgerEntry4: Record "Item Ledger Entry";
    //ExternalRef: code[20];
}

