//**************Documentation****************
//WDC01  WDC.HG 25/09/2025 Add Fields "Customer No." and "Customer Name"
codeunit 50005 "WDC Tax Ledger Update"
{
    trigger OnRun()
    begin
    end;

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
        incr: Integer;
        Item: Record "Item";
    begin
        // Supprimer l'existant
        TaxEntry.DeleteAll();
        incr := 0;
        if pSales then begin
            // 1 - Sales Invoice Line
            Clear(SalesInvLine);
            SalesInvLine.SetRange("Posting Date", pDateFrom, pDateTo);
            if SalesInvLine.FindSet() then
                repeat
                    incr := incr + 1;
                    TaxEntry.Init();
                    TaxEntry."Entry No." := incr;
                    TaxEntry."Type Taxe" := TaxEntry."Type Taxe"::Vente;
                    TaxEntry."Type Document" := TaxEntry."Type Document"::"Facture Vente";
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
                    TaxEntry."Montant TTC" := TaxEntry."Montant HT" + TaxEntry."Montant TVA";
                    TaxEntry."Posting group" := SalesInvLine."Posting group";
                    TaxEntry."TVA group" := SalesInvLine."VAT Bus. Posting Group";
                    TaxEntry.Insert();
                until SalesInvLine.Next() = 0;

            // 2 - Sales Credit Memo Line
            Clear(SalesCrMemoLine);
            SalesCrMemoLine.SetRange("Posting Date", pDateFrom, pDateTo);
            IF SalesCrMemoLine.FindSet() then
                repeat
                    incr := incr + 1;
                    TaxEntry.Init();
                    TaxEntry."Entry No." := incr;
                    TaxEntry."Type Taxe" := TaxEntry."Type Taxe"::Vente;
                    TaxEntry."Type Document" := TaxEntry."Type Document"::"Avoir Vente";
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
                    TaxEntry."Montant TTC" := TaxEntry."Montant HT" + TaxEntry."Montant TVA";
                    TaxEntry."Posting group" := SalesCrMemoLine."Posting group";
                    TaxEntry."TVA group" := SalesCrMemoLine."VAT Bus. Posting Group";
                    TaxEntry.Insert();
                until SalesCrMemoLine.Next() = 0;
        end;
        if pPurchas then begin


            // 3 - Purchase Invoice Line
            Clear(PurchInvLine);
            PurchInvLine.SetRange("Posting Date", pDateFrom, pDateTo);
            if PurchInvLine.FindSet() then
                repeat
                    incr := incr + 1;
                    TaxEntry.Init();
                    TaxEntry."Entry No." := incr;
                    TaxEntry."Type Taxe" := TaxEntry."Type Taxe"::Achat;
                    TaxEntry."Type Document" := TaxEntry."Type Document"::"Facture Achat";
                    TaxEntry."Document No." := PurchInvLine."Document No.";

                    if PurchInvHdr.Get(PurchInvLine."Document No.") then begin
                        TaxEntry."External Document No." := PurchInvHdr."Vendor Invoice No.";
                        //<<WDC01
                        TaxEntry."orderer No." := PurchInvHdr."Buy-from Vendor No.";
                        TaxEntry."Orderer Name" := PurchInvHdr."Buy-from Vendor Name";
                        //>>WDC01
                    end;
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
                    TaxEntry."Montant TTC" := TaxEntry."Montant HT" + TaxEntry."Montant TVA";
                    TaxEntry."Posting group" := PurchInvLine."Posting group";
                    TaxEntry."TVA group" := PurchInvLine."VAT Bus. Posting Group";
                    TaxEntry.Insert();
                until PurchInvLine.Next() = 0;

            // 4 - Purchase Credit Memo Line
            Clear(PurchCrMemoLine);
            PurchCrMemoLine.SetRange("Posting Date", pDateFrom, pDateTo);
            if PurchCrMemoLine.FindSet() then
                repeat
                    incr := incr + 1;
                    TaxEntry.Init();
                    TaxEntry."Entry No." := incr;
                    TaxEntry."Type Taxe" := TaxEntry."Type Taxe"::Achat;
                    TaxEntry."Type Document" := TaxEntry."Type Document"::"Avoir Achat";
                    TaxEntry."Document No." := PurchCrMemoLine."Document No.";

                    if PurchCrMemoHdr.Get(PurchCrMemoLine."Document No.") then begin
                        TaxEntry."External Document No." := PurchCrMemoHdr."Vendor Cr. Memo No.";
                        //<<WDC01
                        TaxEntry."orderer No." := PurchCrMemoHdr."Buy-from Vendor No.";
                        TaxEntry."Orderer Name" := PurchCrMemoHdr."Buy-from Vendor Name";
                        //>>WDC01
                    end;
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
                    TaxEntry."Montant TTC" := TaxEntry."Montant HT" + TaxEntry."Montant TVA";
                    TaxEntry."Posting group" := PurchCrMemoLine."Posting group";
                    TaxEntry."TVA group" := PurchCrMemoLine."VAT Bus. Posting Group";
                    TaxEntry.Insert();
                until PurchCrMemoLine.Next() = 0;
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
}
