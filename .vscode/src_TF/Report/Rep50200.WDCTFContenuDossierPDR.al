report 50200 "WDC-TF Contenu Dossier PDR"
{
    DefaultLayout = RDLC;
    RDLCLayout = './.vscode/src_TF/Report/RDLC/ContenuDossierPDR.rdlc';
    CaptionML = ENU = 'PDR File Content', FRA = 'Contenu Dossier PDR';
    EnableHyperlinks = true;
    PreviewMode = PrintLayout;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;
    dataset
    {
        dataitem("WDC-TF Transit Folder"; "WDC-TF Transit Folder")
        {
            RequestFilterFields = "No.";
            column(NDossier_DossiersTransit; "WDC-TF Transit Folder"."No.")
            {
            }
            column(NFournisseur_DossiersTransit; "WDC-TF Transit Folder"."Vendor No.")
            {
            }
            column(Nomfournisseur_DossiersTransit; "WDC-TF Transit Folder"."Vendor Name")
            {
            }
            column(NTransitExterne_DossiersTransit; "WDC-TF Transit Folder"."External Document No.")
            {
            }
            column(Datedouverture_DossiersTransit; "WDC-TF Transit Folder"."Opening Date")
            {
            }
            column("Datedeclôture_DossiersTransit"; "WDC-TF Transit Folder"."Closing Date")
            {
            }
            column(statut_DossiersTransit; "WDC-TF Transit Folder".Statut)
            {
            }
            column(Mnt_Marchandise; MontantMarchandise)
            {
            }
            column(Picture_CompanyInformation; CompanyInformation.Picture)
            {
            }
            column(Name_CompanyInformation; CompanyInformation.Name)
            {
            }
            column(Address_CompanyInformation; CompanyInformation.Address)
            {
            }
            column(TotFrais; TotFrais)
            {
            }
            dataitem("Item Charge"; "Item Charge")
            {
                DataItemTableView = SORTING("No.")
                                    ORDER(Ascending);
                column(No_ItemCharge; "Item Charge"."No.")
                {
                }
                column(Description_ItemCharge; "Item Charge".Description)
                {
                }
                column("FraisFacturés_ItemCharge"; "Item Charge"."Invoiced Charge")
                {
                }
                column(Percent; Percent)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    Percent := 0;
                    SETFILTER("Folder Filter", "WDC-TF Transit Folder"."No.");
                    CALCFIELDS("Invoiced Charge");
                    IF "Invoiced Charge" = 0 THEN
                        CurrReport.SKIP;
                    Percent := ("Invoiced Charge" / (MontantMarchandise + TotFrais)) * 100;
                    DecGC_TotDS_FA := 0;
                    DecGC_UnitDS := 0;
                    DecGC_Unit := 0;
                end;
            }
            dataitem("Purch. Rcpt. Line"; "Purch. Rcpt. Line")
            {
                DataItemLink = "Transit Folder No." = FIELD("No.");
                DataItemTableView = SORTING("Document No.", "Line No.")
                                    WHERE(Type = CONST(Item),
                                          Quantity = FILTER(<> 0));
                RequestFilterFields = Width;
                CalcFields = "Transit Folder No.";
                column(DocumentNo_PurchRcptLine; "Purch. Rcpt. Line"."Document No.")
                {
                }
                column(No_PurchRcptLine; "Purch. Rcpt. Line"."No.")
                {
                }
                column(Description_PurchRcptLine; "Purch. Rcpt. Line".Description)
                {
                }
                column(Quantity_PurchRcptLine; "Purch. Rcpt. Line".Quantity)
                {
                }
                column(LineNo_PurchRcptLine; "Purch. Rcpt. Line"."Line No.")
                {
                }
                column(DirectUnitCost_PurchRcptLine; "Purch. Rcpt. Line"."Direct Unit Cost")
                {
                }
                column(UnitCostLCY_PurchRcptLine; "Purch. Rcpt. Line"."Unit Cost (LCY)")
                {
                }
                column(DecDevise; DecDevise)
                {
                }
                column(totalquantity; totalquantity)
                {
                }
                column(Totaldev; Totaldev)
                {
                }
                column(TotalDs; TotalDs)
                {
                }
                dataitem("Value Entry"; "Value Entry")
                {
                    DataItemLink = "Transit Folder No." = FIELD("Transit Folder No."),
                                   "Item No." = FIELD("No.");
                    DataItemTableView = SORTING("Item Charge No.", "Inventory Posting Group", "Item No.")
                                        WHERE("Expected Cost" = CONST(false));

                    column(EntryNo_ValueEntry; "Value Entry"."Entry No.")
                    {
                    }
                    column(DocumentNo_ValueEntry; "Value Entry"."Document No.")
                    {
                    }
                    column(DocumentType_ValueEntry; "Value Entry"."Document Type")
                    {
                    }
                    column(Ndossier_ValueEntry; "Value Entry"."Transit Folder No.")
                    {
                    }
                    column(ItemNo_ValueEntry; "Value Entry"."Item No.")
                    {
                    }
                    column(ItemchargeNo_ValueEntry; "Value Entry"."Item Charge No.")
                    {
                    }
                    column(DecGC_UnitDS_FA; DecGC_UnitDS_FA)
                    {
                    }
                    column(DecGC_UnitD_FA; DecGC_UnitD_FA)
                    {
                    }
                    column(DecGC_TotDS_FA; DecGC_TotDS_FA)
                    {
                    }
                    column(DecGC_TotD_FA; DecGC_TotD_FA)
                    {
                    }
                    column(DecGC_TotDS_Rcp; DecGC_TotDS_Rcp)
                    {
                    }
                    column(DecGC_TotD_Rcp; DecGC_TotD_Rcp)
                    {
                    }
                    column(DecGC_UnitDS_Rcp; DecGC_UnitDS_Rcp)
                    {
                    }
                    column(DecGC_UnitD_Rcp; DecGC_UnitD_Rcp)
                    {
                    }
                    column(DecGC_TotD; DecGC_TotD)
                    {
                    }
                    column(DecGC_UnitD; DecGC_UnitD)
                    {
                    }
                    column(Percent1; Percent1)
                    {
                    }
                    column(DecGC_DS_FA; DecGC_DS_FA)
                    {
                    }
                    column(details; details)
                    {
                    }
                    column(DescItemCharge; DescItemCharge)
                    {
                    }
                    column(DecGC_TotDS; DecGC_TotDS)
                    {
                    }
                    column(DecGC_UnitDS; DecGC_UnitDS)
                    {
                    }
                    column(DecGC_Tot; DecGC_Tot)
                    {
                    }
                    column(DecGC_Unit; DecGC_Unit)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        IF "Value Entry"."Item Charge No." <> '' THEN
                            DecGC_TotDS_FA := "Cost Amount (Actual)"
                        ELSE
                            DecGC_TotDS_FA := 0;
                        DecGC_DS_FA := "Cost per Unit";
                        PurchInvLine.SETRANGE("Transit Folder No.", "Transit Folder No.");
                        PurchInvLine.SETRANGE("No.", "Item Charge No.");
                        IF PurchInvLine.FINDFIRST THEN BEGIN
                            DecGC_UnitD := PurchInvLine."Direct Unit Cost";
                            DecGC_TotD := PurchInvLine."Direct Unit Cost" * PurchInvLine.Quantity;
                        END;
                        if (MontantMarchandise + TotFrais) <> 0 then
                            Percent1 := DecGC_TotDS_FA / (MontantMarchandise + TotFrais) * 100;
                        IF ItemCharge.GET("Item Charge No.") THEN;
                        DescItemCharge := ItemCharge.Description;
                    end;

                    trigger OnPreDataItem()
                    begin
                        "Value Entry".SETFILTER("Item Ledger Entry No.", GetItemRcptEntryNoFILTER("Purch. Rcpt. Line"));
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    DecGC_TotDS_Rcp := MontantTotAcquisition("Purch. Rcpt. Line");
                    DecGC_TotDS := CostAmountDS("Purch. Rcpt. Line");
                    IF Quantity <> 0 THEN
                        DecGC_UnitDS := DecGC_TotDS / Quantity
                    ELSE
                        DecGC_UnitDS := 0;
                    DecGC_Tot := CostAmount("Purch. Rcpt. Line");
                    IF Quantity <> 0 THEN
                        DecGC_Unit := DecGC_Tot / Quantity
                    ELSE
                        DecGC_Unit := 0;
                    VendLedgEntry.RESET;
                    VendLedgEntry.SETRANGE("Document Type", VendLedgEntry."Document Type"::Invoice);
                    VendLedgEntry.SETRANGE("Vendor No.", "WDC-TF Transit Folder"."Vendor No.");
                    VendLedgEntry.SETRANGE("Transit Folder No.", "WDC-TF Transit Folder"."No.");
                    IF VendLedgEntry.FINDFIRST THEN BEGIN
                        IF VendLedgEntry."Original Currency Factor" <> 0 THEN
                            DecDevise := (1 / VendLedgEntry."Original Currency Factor");
                    END
                    ELSE BEGIN
                        PurchRcptHeader.RESET;
                        PurchRcptHeader.SETRANGE("No.", "Document No.");
                        IF PurchRcptHeader.FINDFIRST THEN BEGIN
                            IF PurchRcptHeader."Currency Factor" <> 0 THEN
                                DecDevise := (1 / PurchRcptHeader."Currency Factor");
                        END;
                    END;
                    totalquantity := 0;
                    Totaldev := 0;
                    TotalDs := 0;
                    purchreceptline.SETRANGE(Width, Width);
                    purchreceptline.SETRANGE("No.", "No.");
                    IF purchreceptline.FINDFIRST THEN
                        REPEAT
                            totalquantity += purchreceptline.Quantity;
                            Totaldev += purchreceptline."Direct Unit Cost" * purchreceptline.Quantity;
                            TotalDs += purchreceptline."Unit Cost (LCY)" * purchreceptline.Quantity;
                        UNTIL purchreceptline.NEXT = 0;
                end;
            }

            trigger OnAfterGetRecord()
            var
                LRcpLine: Record "Purch. Rcpt. Line";
            begin
                MontantMarchandise := 0;
                ValueEntry.SETCURRENTKEY("Item Charge No.", "Inventory Posting Group", "Item No.", "Transit Folder No.");
                ValueEntry.SETRANGE("Item Charge No.", '');
                ValueEntry.SETRANGE("Transit Folder No.", "No.");
                IF ValueEntry.FINDFIRST THEN BEGIN
                    ValueEntry.CALCSUMS("Cost Amount (Actual)", "Cost Amount (Expected)");
                    MontantMarchandise := ValueEntry."Cost Amount (Expected)" + ValueEntry."Cost Amount (Actual)";
                END;
                ItemCharge.SETFILTER("Folder Filter", "No.");
                IF ItemCharge.FINDFIRST THEN
                    REPEAT
                        ItemCharge.CALCFIELDS("Invoiced Charge");
                        TotFrais += ItemCharge."Invoiced Charge";
                    UNTIL ItemCharge.NEXT = 0;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field("Détail"; details)
                    {
                        Caption = 'Afficher détail';
                        ApplicationArea = all;
                    }
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

    trigger OnInitReport()
    begin
        CompanyInformation.GET();
        CompanyInformation.CALCFIELDS(Picture);
    end;

    var
        MontantMarchandise: Decimal;
        DecGC_TotDS_Rcp: Decimal;
        DecGC_UnitDS_Rcp: Decimal;
        DecGC_UnitDS_FA: Decimal;
        DecGC_TotDS_FA: Decimal;
        DecGC_TotDS: Decimal;
        DecGC_UnitDS: Decimal;
        CompanyInformation: Record "Company Information";
        ValueEntry: Record "Value Entry";
        Percent: Decimal;
        DecGC_TotD_Rcp: Decimal;
        DecGC_UnitD_Rcp: Decimal;
        DecGC_UnitD_FA: Decimal;
        DecGC_TotD_FA: Decimal;
        DecGC_TotD: Decimal;
        DecGC_UnitD: Decimal;
        TotFrais: Decimal;
        ItemCharge: Record "Item Charge";
        PurchInvLine: Record "Purch. Inv. Line";
        Percent1: Decimal;
        DecDevise: Decimal;
        PurchInvHeader: Record "Purch. Inv. Header";
        PurchRcptHeader: Record "Purch. Rcpt. Header";
        DecGC_DS_FA: Decimal;
        details: Boolean;
        DescItemCharge: Text[50];
        DecDevisePurchase: Decimal;
        DecGC_Tot: Decimal;
        DecGC_Unit: Decimal;
        VendLedgEntry: Record "Vendor Ledger Entry";
        totalquantity: Decimal;
        purchreceptline: Record "Purch. Rcpt. Line";
        Totaldev: Decimal;
        TotalDs: Decimal;
        TOTPERC2: Decimal;

    procedure MontantTotAcquisition(RecLRcpLine: Record "Purch. Rcpt. Line") DecLC_TotDS_Rcp: Decimal
    var
        LItemLedgEntry: Record "Item Ledger Entry";
    begin
        LItemLedgEntry.RESET;
        LItemLedgEntry.SETCURRENTKEY("Document No.", "Document Type", "Document Line No.", "Entry Type");
        LItemLedgEntry.SETRANGE(LItemLedgEntry."Document No.", RecLRcpLine."Document No.");
        LItemLedgEntry.SETRANGE("Document Type", LItemLedgEntry."Document Type"::"Purchase Receipt");
        LItemLedgEntry.SETRANGE("Document Line No.", RecLRcpLine."Line No.");
        LItemLedgEntry.SETRANGE("Entry Type", LItemLedgEntry."Entry Type"::Purchase);
        LItemLedgEntry.SETRANGE("Item Charge Filter", '');
        IF LItemLedgEntry.FINDFIRST THEN BEGIN
            REPEAT
                LItemLedgEntry.CALCFIELDS("Cost Amount (Expected)", "Cost Amount (Actual)");
                DecLC_TotDS_Rcp := DecLC_TotDS_Rcp + LItemLedgEntry."Cost Amount (Expected)" + LItemLedgEntry."Cost Amount (Actual)";
            UNTIL LItemLedgEntry.NEXT = 0;
        END;
    end;

    procedure GetItemChargeDescription(CodeLChergeItemNo: Code[20]) ItemChargeDescription: Text[50]
    var
        RecLItemCharge: Record "Item Charge";
    begin
    end;

    procedure GetItemRcptEntryNoFILTER(LPurchRcptLine: Record "Purch. Rcpt. Line") TxTReturnFILTER: Text[1000]
    var
        LItemEntryRelation: Record "Item Entry Relation";
    begin
        IF LPurchRcptLine."Item Rcpt. Entry No." = 0 THEN BEGIN
            LItemEntryRelation.RESET;
            LItemEntryRelation.SETRANGE("Source Type", 121);
            LItemEntryRelation.SETRANGE("Source Subtype", 0);
            LItemEntryRelation.SETRANGE("Source ID", LPurchRcptLine."Document No.");
            LItemEntryRelation.SETRANGE("Source Ref. No.", LPurchRcptLine."Line No.");
            LItemEntryRelation.FINDFIRST;
            REPEAT
                IF STRLEN(TxTReturnFILTER) = 0 THEN
                    TxTReturnFILTER := FORMAT(LItemEntryRelation."Item Entry No.")
                ELSE
                    TxTReturnFILTER := TxTReturnFILTER + '|' + FORMAT(LItemEntryRelation."Item Entry No.");
            UNTIL LItemEntryRelation.NEXT = 0;
        END
        ELSE
            TxTReturnFILTER := FORMAT(LPurchRcptLine."Item Rcpt. Entry No.");
    end;

    procedure CostAmountDS(pPurchRcptLine: Record "Purch. Rcpt. Line") CostAmountDS: Decimal
    var
        lValueEntry: Record "Value Entry";
    begin
        CostAmountDS := 0;
        lValueEntry.SETCURRENTKEY("Item Charge No.", "Inventory Posting Group", "Item No.", "Transit Folder No.");
        lValueEntry.SETRANGE("Item Charge No.", '');
        lValueEntry.SETRANGE("Transit Folder No.", pPurchRcptLine."Transit Folder No.");
        lValueEntry.SETRANGE("Item No.", pPurchRcptLine."No.");
        lValueEntry.SETRANGE("Document Type", lValueEntry."Document Type"::"Purchase Invoice");
        IF lValueEntry.FINDFIRST THEN BEGIN
            lValueEntry.CALCSUMS("Cost Amount (Actual)", "Cost Amount (Expected)");
            CostAmountDS := lValueEntry."Cost Amount (Actual)";
        END
        ELSE BEGIN
            CostAmountDS := lValueEntry."Cost Amount (Expected)";
        END;
    end;

    procedure CostAmount(pPurchRcptLine: Record "Purch. Rcpt. Line") CostAmount: Decimal
    var
        lValueEntry: Record "Value Entry";
    begin
        CostAmount := 0;
        lValueEntry.SETCURRENTKEY("Item Charge No.", "Inventory Posting Group", "Item No.", "Transit Folder No.");
        lValueEntry.SETRANGE("Item Charge No.", '');
        lValueEntry.SETRANGE("Transit Folder No.", pPurchRcptLine."Transit Folder No.");
        lValueEntry.SETRANGE("Item No.", pPurchRcptLine."No.");
        lValueEntry.SETRANGE("Document Type", lValueEntry."Document Type"::"Purchase Invoice");
        IF lValueEntry.FINDFIRST THEN BEGIN
            lValueEntry.CALCSUMS("Cost Amount (Actual)", "Cost Amount (Expected)");
            IF GetDeviseInv(lValueEntry) <> 0 THEN
                CostAmount := lValueEntry."Cost Amount (Actual)" / GetDeviseInv(lValueEntry);
        END
        ELSE BEGIN
            IF GetDeviseRcp(lValueEntry) <> 0 THEN
                CostAmount := lValueEntry."Cost Amount (Expected)" / GetDeviseRcp(lValueEntry);
        END;
    end;

    procedure GetDeviseRcp(pValueEntry: Record "Value Entry") DeviseRcp: Decimal
    var
        lPurchRcptHeader: Record "Purch. Rcpt. Header";
    begin
        DeviseRcp := 0;
        lPurchRcptHeader.RESET;
        lPurchRcptHeader.SETRANGE("No.", pValueEntry."Document No.");
        IF lPurchRcptHeader.FINDFIRST THEN BEGIN
            IF lPurchRcptHeader."Currency Factor" <> 0 THEN
                DeviseRcp := (1 / lPurchRcptHeader."Currency Factor");
        END;
    end;

    procedure GetDeviseInv(pValueEntry: Record "Value Entry") DeviseInv: Decimal
    var
        lPurchInvHeader: Record "Purch. Inv. Header";
    begin
        DeviseInv := 0;
        lPurchInvHeader.RESET;
        lPurchInvHeader.SETRANGE("No.", pValueEntry."Document No.");
        IF lPurchInvHeader.FINDFIRST THEN BEGIN
            IF lPurchInvHeader."Currency Factor" <> 0 THEN
                DeviseInv := (1 / lPurchInvHeader."Currency Factor");
        END;
    end;
}

