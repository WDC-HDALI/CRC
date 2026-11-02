//**************Documentation****************
//WDC01  WDC.HG 25/09/2025 Add Fields "Customer No." and "Customer Name"
codeunit 50005 "WDC Tax Ledger Update"
{
    procedure UpdateTaxLedger(pDateFrom: Date; pDateTo: Date; pPurchas: Boolean; pSales: Boolean)
    var
        SalesInvLine: Record "Sales Invoice Line";
        SalesInvHdr: Record "Sales Invoice Header";
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
        SalesCrMemoHdr: Record "Sales Cr.Memo Header";
        PurchInvLine: Record "Purch. Inv. Line";
        PurchInvHdr: Record "Purch. Inv. Header";
        PurchCrMemoLine: Record "Purch. Cr. Memo Line";
        PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.";
        TaxEntry: Record "WDC Tax Ledger Entry";
        Item: Record "Item";

    begin
        // Supprimer l'existant
        TaxEntry.DeleteAll();
        //   if pSales then begin
        // 1 - Sales 
        InsertSalesInvoiceLines(pDateFrom, pDateTo);
        InsertSalesCreditMemoLines(pDateFrom, pDateTo);
        //    end;
        // if pPurchas then begin
        //     // 2 - Purchase
        //     InsertPurchaseInvoicesLines(pDateFrom, pDateTo);
        //     InsertPurchaseCreditMemoLines(pDateFrom, pDateTo);
        // end;
    end;

    procedure InsertSalesInvoiceLines(pDateFrom: Date; pDateTo: Date)
    var
        SalesInvLine: Record "Sales Invoice Line";
        SalesInvHdr: Record "Sales Invoice Header";
        TaxEntry: Record "WDC Tax Ledger Entry";
        Item: Record "Item";
        lCustLedgEntry: record "Cust. Ledger Entry";
        TotalVAT7: Decimal;
        TotalVAT13: Decimal;
        TotalVAT19: Decimal;
    begin
        SalesInvHdr.Reset();
        SalesInvHdr.SetCurrentKey("Posting Date");
        SalesInvHdr.SetRange("Posting Date", pDateFrom, pDateTo);
        if SalesInvHdr.FindFirst() then
            repeat
                TotalVAT7 := 0;
                TotalVAT13 := 0;
                TotalVAT19 := 0;
                if lCustLedgEntry.Get(SalesInvHdr."Cust. Ledger Entry No.") then
                    lCustLedgEntry.CalcFields("Amount (LCY)");
                SalesInvLine.Reset();
                SalesInvLine.SetCurrentKey("Document No.", "Line No.");
                SalesInvLine.SetRange("Document No.", SalesInvHdr."No.");
                if SalesInvLine.FindSet() then
                    repeat
                        TaxEntry.Init();
                        TaxEntry."Entry No." := GetEntryNo;
                        TaxEntry."Type Taxe" := TaxEntry."Type Taxe"::Sales;
                        TaxEntry."Type Document" := TaxEntry."Type Document"::"Sales Invoice";
                        TaxEntry."Document No." := SalesInvLine."Document No.";
                        if SalesInvHdr.Get(SalesInvLine."Document No.") then begin
                            TaxEntry."External Document No." := SalesInvHdr."External Document No.";
                            //<<WDC01
                            TaxEntry."orderer No." := SalesInvHdr."Sell-to Customer No.";
                            TaxEntry."Orderer Name" := SalesInvHdr."Sell-to Customer Name";
                        end;
                        //>>WDC01
                        if SalesInvLine.Type = SalesInvLine.Type::Item then Begin
                            item.get(SalesInvLine."No.");
                            TaxEntry."Catégorie Article" := item."Item Category Code";
                        End;
                        TaxEntry."Posting Date" := SalesInvLine."Posting Date";
                        TaxEntry."Type Mouvement" := GetLineTypeSales(SalesInvLine.Type);
                        TaxEntry."Line No." := SalesInvLine."Line No.";
                        TaxEntry."No." := SalesInvLine."No.";
                        TaxEntry."Description" := SalesInvLine.Description;
                        TaxEntry."Quantité" := SalesInvLine.Quantity;
                        TaxEntry."Prix unitaire" := SalesInvLine."Unit Price";
                        TaxEntry."Montant HT" := SalesInvLine.Amount;
                        TaxEntry."TVA %" := SalesInvLine."VAT %";
                        TaxEntry."Montant TVA" := Round(SalesInvLine.Amount * SalesInvLine."VAT %" / 100, 0.001);
                        if SalesInvLine."VAT %" = 7 then
                            TotalVAT7 += TaxEntry."Montant TVA"
                        else if SalesInvLine."VAT %" = 13 then
                            TotalVAT13 += TaxEntry."Montant TVA"
                        else if SalesInvLine."VAT %" = 19 then
                            TotalVAT19 += TaxEntry."Montant TVA";

                        //TaxEntry."Montant TTC" := TaxEntry."Montant HT" + TaxEntry."Montant TVA";
                        TaxEntry."Montant TTC" := lCustLedgEntry."Amount (LCY)";
                        TaxEntry."Posting group" := SalesInvLine."Posting group";
                        TaxEntry."TVA group" := SalesInvLine."VAT Bus. Posting Group";
                        TaxEntry.Insert();
                    until SalesInvLine.Next() = 0;
                if TotalVAT7 <> 0 then
                    InsertVATLine(TaxEntry."Type Taxe"::Sales, TaxEntry."Type Document"::"Sales Invoice", SalesInvHdr."No.", TotalVAT7, 7);
                if TotalVAT13 <> 0 then
                    InsertVATLine(TaxEntry."Type Taxe"::Sales, TaxEntry."Type Document"::"Sales Invoice", SalesInvHdr."No.", TotalVAT13, 13);
                if TotalVAT19 <> 0 then
                    InsertVATLine(TaxEntry."Type Taxe"::Sales, TaxEntry."Type Document"::"Sales Invoice", SalesInvHdr."No.", TotalVAT19, 19);

                InsertStampAmount(TaxEntry."Type Taxe"::Sales, TaxEntry."Type Document"::"Sales Invoice", SalesInvHdr."No.", SalesInvHdr."Stamp Amount");
            until SalesInvHdr.Next = 0;
    end;

    procedure InsertSalesCreditMemoLines(pDateFrom: Date; pDateTo: Date)
    var
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
        SalesCrMemoHdr: Record "Sales Cr.Memo Header";
        TaxEntry: Record "WDC Tax Ledger Entry";
        Item: Record "Item";
        lCustLedgEntry: record "Cust. Ledger Entry";
        TotalVAT7: Decimal;
        TotalVAT13: Decimal;
        TotalVAT19: Decimal;
    begin
        SalesCrMemoHdr.Reset();
        SalesCrMemoHdr.SetCurrentKey("Posting Date");
        SalesCrMemoHdr.SetRange("Posting Date", pDateFrom, pDateTo);
        if SalesCrMemoHdr.FindFirst() then
            repeat
                TotalVAT7 := 0;
                TotalVAT13 := 0;
                TotalVAT19 := 0;
                if lCustLedgEntry.Get(SalesCrMemoHdr."Cust. Ledger Entry No.") then
                    lCustLedgEntry.CalcFields("Amount (LCY)");
                SalesCrMemoLine.Reset();
                SalesCrMemoLine.SetCurrentKey("Document No.", "Line No.");
                SalesCrMemoLine.SetRange("Document No.", SalesCrMemoHdr."No.");
                IF SalesCrMemoLine.FindSet() then
                    repeat
                        TaxEntry.Init();
                        TaxEntry."Entry No." := GetEntryNo();
                        TaxEntry."Type Taxe" := TaxEntry."Type Taxe"::Sales;
                        TaxEntry."Type Document" := TaxEntry."Type Document"::"Sales Credit Memo";
                        TaxEntry."Document No." := SalesCrMemoLine."Document No.";
                        if SalesCrMemoHdr.Get(SalesCrMemoLine."Document No.") then begin
                            TaxEntry."External Document No." := SalesCrMemoHdr."External Document No.";
                            //<<WDC01
                            TaxEntry."orderer No." := SalesCrMemoHdr."Sell-to Customer No.";
                            TaxEntry."Orderer Name" := SalesCrMemoHdr."Sell-to Customer Name";
                            //>>WDC01
                        end;
                        if SalesCrMemoLine.Type = SalesCrMemoLine.Type::Item then Begin
                            item.get(SalesCrMemoLine."No.");
                            TaxEntry."Catégorie Article" := item."Item Category Code";
                        End;
                        TaxEntry."Posting Date" := SalesCrMemoLine."Posting Date";
                        TaxEntry."Type Mouvement" := GetLineTypeSales(SalesCrMemoLine.Type);
                        TaxEntry."Line No." := SalesCrMemoLine."Line No.";
                        TaxEntry."No." := SalesCrMemoLine."No.";
                        TaxEntry."Description" := SalesCrMemoLine.Description;
                        TaxEntry."Quantité" := -SalesCrMemoLine.Quantity;
                        TaxEntry."Prix unitaire" := SalesCrMemoLine."Unit Price";
                        TaxEntry."Montant HT" := -SalesCrMemoLine.Amount;
                        TaxEntry."TVA %" := SalesCrMemoLine."VAT %";
                        TaxEntry."Montant TVA" := Round(TaxEntry."Montant HT" * SalesCrMemoLine."VAT %" / 100, 0.001);
                        if SalesCrMemoLine."VAT %" = 7 then
                            TotalVAT7 += TaxEntry."Montant TVA"
                        else if SalesCrMemoLine."VAT %" = 13 then
                            TotalVAT13 += TaxEntry."Montant TVA"
                        else if SalesCrMemoLine."VAT %" = 19 then
                            TotalVAT19 += TaxEntry."Montant TVA";
                        //TaxEntry."Montant TTC" := TaxEntry."Montant HT" + TaxEntry."Montant TVA";
                        TaxEntry."Montant TTC" := lCustLedgEntry."Amount (LCY)";
                        TaxEntry."Posting group" := SalesCrMemoLine."Posting group";
                        TaxEntry."TVA group" := SalesCrMemoLine."VAT Bus. Posting Group";
                        TaxEntry.Insert();
                    until SalesCrMemoLine.Next() = 0;
                if TotalVAT7 <> 0 then
                    InsertVATLine(TaxEntry."Type Taxe"::Sales, TaxEntry."Type Document"::"Sales Credit Memo", SalesCrMemoHdr."No.", TotalVAT7, 7);
                if TotalVAT13 <> 0 then
                    InsertVATLine(TaxEntry."Type Taxe"::Sales, TaxEntry."Type Document"::"Sales Credit Memo", SalesCrMemoHdr."No.", TotalVAT13, 13);
                if TotalVAT19 <> 0 then
                    InsertVATLine(TaxEntry."Type Taxe"::Sales, TaxEntry."Type Document"::"Sales Credit Memo", SalesCrMemoHdr."No.", TotalVAT19, 19);
            until SalesCrMemoHdr.Next = 0;

    end;

    procedure InsertPurchaseInvoicesLines(pDateFrom: Date; pDateTo: Date)
    var
        PurchInvLine: Record "Purch. Inv. Line";
        PurchInvHdr: Record "Purch. Inv. Header";
        PurchCrMemoLine: Record "Purch. Cr. Memo Line";
        PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.";
        TaxEntry: Record "WDC Tax Ledger Entry";
        Item: Record "Item";
        TotalVAT7: Decimal;
        TotalVAT13: Decimal;
        TotalVAT19: Decimal;
    begin
        PurchInvHdr.Reset();
        PurchInvHdr.SetCurrentKey("Posting Date");
        PurchInvHdr.SetRange("Posting Date", pDateFrom, pDateTo);
        if PurchInvHdr.FindFirst() then
            repeat
                TotalVAT7 := 0;
                TotalVAT13 := 0;
                TotalVAT19 := 0;
                PurchInvLine.Reset();
                PurchInvLine.SetCurrentKey("Document No.", "Line No.");
                PurchInvLine.SetRange("Document No.", PurchInvHdr."No.");
                if PurchInvLine.FindSet() then
                    repeat
                        TaxEntry.Init();
                        TaxEntry."Entry No." := GetEntryNo;
                        TaxEntry."Type Taxe" := TaxEntry."Type Taxe"::Purchase;
                        TaxEntry."Type Document" := TaxEntry."Type Document"::"Purchase Invoice";
                        TaxEntry."Document No." := PurchInvLine."Document No.";
                        TaxEntry."External Document No." := PurchInvHdr."Vendor Invoice No.";
                        TaxEntry."orderer No." := PurchInvHdr."Buy-from Vendor No.";
                        TaxEntry."Orderer Name" := PurchInvHdr."Buy-from Vendor Name";
                        if PurchInvLine.Type = PurchInvLine.Type::Item then Begin
                            item.get(PurchInvLine."No.");
                            TaxEntry."Catégorie Article" := item."Item Category Code";
                        End;
                        TaxEntry."Posting Date" := PurchInvLine."Posting Date";
                        TaxEntry."Type Mouvement" := GetLineTypePurch(PurchInvLine.Type);
                        TaxEntry."Line No." := PurchInvLine."Line No.";
                        TaxEntry."No." := PurchInvLine."No.";
                        TaxEntry."Description" := PurchInvLine.Description;
                        TaxEntry."Quantité" := PurchInvLine.Quantity;
                        TaxEntry."Prix unitaire" := PurchInvLine."Direct Unit Cost";
                        TaxEntry."Montant HT" := PurchInvLine.Amount;
                        TaxEntry."TVA %" := PurchInvLine."VAT %";
                        TaxEntry."Montant TVA" := Round(PurchInvLine.Amount * PurchInvLine."VAT %" / 100, 0.001);
                        if PurchInvLine."VAT %" = 7 then
                            TotalVAT7 += TaxEntry."Montant TVA"
                        else if PurchInvLine."VAT %" = 13 then
                            TotalVAT13 += TaxEntry."Montant TVA"
                        else if PurchInvLine."VAT %" = 19 then
                            TotalVAT19 += TaxEntry."Montant TVA";
                        TaxEntry."Montant TTC" := TaxEntry."Montant HT" + TaxEntry."Montant TVA";
                        TaxEntry."Posting group" := PurchInvLine."Posting group";
                        TaxEntry."TVA group" := PurchInvLine."VAT Bus. Posting Group";
                        TaxEntry.Insert();
                    until PurchInvLine.Next() = 0;
                if TotalVAT7 <> 0 then
                    InsertVATLine(TaxEntry."Type Taxe"::Purchase, TaxEntry."Type Document"::"Purchase Invoice", PurchInvHdr."No.", TotalVAT7, 7);
                if TotalVAT13 <> 0 then
                    InsertVATLine(TaxEntry."Type Taxe"::Purchase, TaxEntry."Type Document"::"Purchase Invoice", PurchInvHdr."No.", TotalVAT13, 13);
                if TotalVAT19 <> 0 then
                    InsertVATLine(TaxEntry."Type Taxe"::Purchase, TaxEntry."Type Document"::"Purchase Invoice", PurchInvHdr."No.", TotalVAT19, 19);

                InsertStampAmount(TaxEntry."Type Taxe"::Purchase, TaxEntry."Type Document"::"Purchase Invoice", PurchInvHdr."No.", PurchInvHdr."Stamp Amount");

            until PurchInvHdr.Next = 0;

    end;

    procedure InsertPurchaseCreditMemoLines(pDateFrom: Date; pDateTo: Date)
    var
        PurchCrMemoLine: Record "Purch. Cr. Memo Line";
        PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.";
        TaxEntry: Record "WDC Tax Ledger Entry";
        Item: Record "Item";
        TotalVAT7: Decimal;
        TotalVAT13: Decimal;
        TotalVAT19: Decimal;
        y2: record 254;
    begin
        PurchCrMemoHdr.Reset();
        PurchCrMemoHdr.SetCurrentKey("Posting Date");
        PurchCrMemoHdr.SetRange("Posting Date", pDateFrom, pDateTo);
        if PurchCrMemoHdr.FindFirst() then
            repeat
                TotalVAT7 := 0;
                TotalVAT13 := 0;
                TotalVAT19 := 0;
                PurchCrMemoLine.Reset();
                PurchCrMemoLine.SetCurrentKey("Document No.", "Line No.");
                PurchCrMemoLine.SetRange("Document No.", PurchCrMemoHdr."No.");
                if PurchCrMemoLine.FindSet() then
                    repeat
                        TaxEntry.Init();
                        TaxEntry."Entry No." := GetEntryNo;
                        TaxEntry."Type Taxe" := TaxEntry."Type Taxe"::Purchase;
                        TaxEntry."Type Document" := TaxEntry."Type Document"::"Purchase Credit Memo";
                        TaxEntry."Document No." := PurchCrMemoLine."Document No.";
                        TaxEntry."External Document No." := PurchCrMemoHdr."Vendor Cr. Memo No.";
                        TaxEntry."orderer No." := PurchCrMemoHdr."Buy-from Vendor No.";
                        TaxEntry."Orderer Name" := PurchCrMemoHdr."Buy-from Vendor Name";
                        if PurchCrMemoLine.Type = PurchCrMemoLine.Type::Item then Begin
                            item.get(PurchCrMemoLine."No.");
                            TaxEntry."Catégorie Article" := item."Item Category Code";
                        End;
                        TaxEntry."Posting Date" := PurchCrMemoLine."Posting Date";
                        TaxEntry."Type Mouvement" := GetLineTypePurch(PurchCrMemoLine.Type);
                        TaxEntry."Line No." := PurchCrMemoLine."Line No.";
                        TaxEntry."No." := PurchCrMemoLine."No.";
                        TaxEntry."Description" := PurchCrMemoLine.Description;
                        TaxEntry.Quantité := -PurchCrMemoLine.Quantity;
                        TaxEntry."Prix unitaire" := PurchCrMemoLine."Direct Unit Cost";
                        TaxEntry."Montant HT" := -PurchCrMemoLine.Amount;
                        TaxEntry."TVA %" := PurchCrMemoLine."VAT %";
                        TaxEntry."Montant TVA" := Round(TaxEntry."Montant HT" * PurchCrMemoLine."VAT %" / 100, 0.001);
                        if PurchCrMemoLine."VAT %" = 7 then
                            TotalVAT7 += TaxEntry."Montant TVA"
                        else if PurchCrMemoLine."VAT %" = 13 then
                            TotalVAT13 += TaxEntry."Montant TVA"
                        else if PurchCrMemoLine."VAT %" = 19 then
                            TotalVAT19 += TaxEntry."Montant TVA";
                        TaxEntry."Montant TTC" := TaxEntry."Montant HT" + TaxEntry."Montant TVA";
                        TaxEntry."Posting group" := PurchCrMemoLine."Posting group";
                        TaxEntry."TVA group" := PurchCrMemoLine."VAT Bus. Posting Group";
                        TaxEntry.Insert();
                    until PurchCrMemoLine.Next() = 0;
                if TotalVAT7 <> 0 then
                    InsertVATLine(TaxEntry."Type Taxe"::Purchase, TaxEntry."Type Document"::"Purchase Credit Memo", PurchCrMemoHdr."No.", TotalVAT7, 7);
                if TotalVAT13 <> 0 then
                    InsertVATLine(TaxEntry."Type Taxe"::Purchase, TaxEntry."Type Document"::"Purchase Credit Memo", PurchCrMemoHdr."No.", TotalVAT13, 13);
                if TotalVAT19 <> 0 then
                    InsertVATLine(TaxEntry."Type Taxe"::Purchase, TaxEntry."Type Document"::"Purchase Credit Memo", PurchCrMemoHdr."No.", TotalVAT19, 19);
            until PurchCrMemoHdr.Next = 0;
    end;



    procedure InsertVATLine(pEntyType: enum "WDC Tax Entry Type"; pDocType: Enum "WDC Tax Document Type"; pDocNo: Code[20]; pTotalVat: Decimal; pPercentVat: Decimal)
    var
        SalesInvHdr: Record "Sales Invoice Header";
        TaxEntry: Record "WDC Tax Ledger Entry";
    begin
        if SalesInvHdr.Get(pDocNo) then begin
            TaxEntry.Init();
            TaxEntry."Entry No." := GetEntryNo;
            TaxEntry."Type Taxe" := pEntyType;
            TaxEntry."Type Document" := pDocType;
            TaxEntry."Document No." := SalesInvHdr."No.";
            TaxEntry."External Document No." := SalesInvHdr."External Document No.";
            TaxEntry."orderer No." := SalesInvHdr."Sell-to Customer No.";
            TaxEntry."Orderer Name" := SalesInvHdr."Sell-to Customer Name";
            TaxEntry."Posting Date" := SalesInvHdr."Posting Date";
            TaxEntry."No." := 'TVA ' + FORMAT(pPercentVat) + '%';
            TaxEntry."Description" := 'TVA COLLECTEE ' + FORMAT(pPercentVat) + '%';
            TaxEntry."Montant HT" := pTotalVat;
            TaxEntry.Insert();

        end;
    end;

    procedure InsertStampAmount(pEntyType: enum "WDC Tax Entry Type"; pDocType: Enum "WDC Tax Document Type"; pDocNo: Code[20]; pStampAmount: Decimal)
    var
        SalesInvHdr: Record "Sales Invoice Header";
        TaxEntry: Record "WDC Tax Ledger Entry";
    begin
        if SalesInvHdr.Get(pDocNo) then begin
            TaxEntry.Init();
            TaxEntry."Entry No." := GetEntryNo;
            TaxEntry."Type Taxe" := pEntyType;
            TaxEntry."Type Document" := pDocType;
            TaxEntry."Document No." := SalesInvHdr."No.";
            TaxEntry."External Document No." := SalesInvHdr."External Document No.";
            TaxEntry."orderer No." := SalesInvHdr."Sell-to Customer No.";
            TaxEntry."Orderer Name" := SalesInvHdr."Sell-to Customer Name";
            TaxEntry."Posting Date" := SalesInvHdr."Posting Date";
            TaxEntry."No." := 'TIMBRE';
            TaxEntry."Description" := 'TIMBRE';
            TaxEntry."Montant HT" := pStampAmount;
            TaxEntry.Insert();
        end;
    end;

    local procedure GetLineTypeSales(LineType: Enum "Sales Line Type"): Option "","Compte","Article","Immobilisation","Frais Annexe"
    begin
        case LineType of
            LineType::" ":
                exit(0); // Vide
            LineType::"G/L Account":
                exit(1); // Compte
            LineType::Item:
                exit(2); // Article
            LineType::"Fixed Asset":
                exit(3); // Immobilisation
            LineType::"Charge (Item)":
                exit(4); // Frais Annexe
        end;
    end;

    local procedure GetLineTypePurch(LineType: Enum "Purchase Line Type"): Option "","Compte","Article","Immobilisation","Frais Annexe"
    begin
        case LineType of
            LineType::" ":
                exit(0);
            LineType::"G/L Account":
                exit(1);
            LineType::Item:
                exit(2);
            LineType::"Fixed Asset":
                exit(3);
            LineType::"Charge (Item)":
                exit(4);
        end;
    end;

    procedure GetEntryNo(): Integer
    var
        TaxEntry: Record "WDC Tax Ledger Entry";
    begin
        TaxEntry.Reset();
        TaxEntry.SetCurrentKey("Entry No.");
        if TaxEntry.FindLast() then;
        exit(TaxEntry."Entry No." + 1)
    end;

}
