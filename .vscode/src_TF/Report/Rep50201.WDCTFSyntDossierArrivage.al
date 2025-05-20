report 50201 "WDC-TF Synt. Dossier Arrivage"
{
    DefaultLayout = RDLC;
    RDLCLayout = './.vscode/src_TF/Report/RDLC/SynthèseDossierArrivage.rdlc';
    CaptionML = ENU = 'Arrival File Summary', FRA = 'Synthèse Dossier Arrivage';
    EnableHyperlinks = true;
    PreviewMode = PrintLayout;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;
    dataset
    {
        dataitem("WDC-TF Transit Folder"; "WDC-TF Transit Folder")
        {
            RequestFilterFields = "No.";
            column(Picture; CompanyInformation.Picture)
            {
            }
            column(CompanyName; CompanyInformation.Name)
            {
            }
            column(NumDossier; "WDC-TF Transit Folder"."No.")
            {
            }
            column(NumTransitExterne; "WDC-TF Transit Folder"."External Document No.")
            {
            }
            column(Datedouverture; "WDC-TF Transit Folder"."Opening Date")
            {
            }
            column("Datedeclôture"; "WDC-TF Transit Folder"."Closing Date")
            {
            }
            column(CodeFournisseur; "WDC-TF Transit Folder"."Vendor No.")
            {
            }
            column(Nomfournisseur; "WDC-TF Transit Folder"."Vendor Name")
            {
            }
            column(Statut; "WDC-TF Transit Folder".Statut)
            {
            }
            column(URLDossier; URLDossier)
            {
            }
            column(URLFrs; URLFrs)
            {
            }
            dataitem("Value Entry"; "Value Entry")
            {
                DataItemLink = "Transit Folder No." = FIELD("No.");
                DataItemTableView = SORTING("Item Ledger Entry No.", "Entry Type")
                                    ORDER(Ascending)
                                    WHERE("Document Type" = FILTER("Purchase Receipt" | "Purchase Invoice" | "Purchase Return Shipment" | "Purchase Credit Memo"));
                column(ItemNo; "Value Entry"."Item No.")
                {
                }
                column(PostingDate; "Value Entry"."Posting Date")
                {
                }
                column(ItemLedgerEntryType; "Value Entry"."Item Ledger Entry Type")
                {
                }
                column(SourceNo; "Value Entry"."Source No.")
                {
                }
                column(DocumentNo; "Value Entry"."Document No.")
                {
                }
                column(Description; "Value Entry".Description)
                {
                }
                column(DocumentType; "Value Entry"."Document Type")
                {
                }
                column(ExternalDocumentNo; "Value Entry"."External Document No.")
                {
                }
                column(DocumentDate; "Value Entry"."Document Date")
                {
                }
                column(CostAmountActual; "Value Entry"."Cost Amount (Actual)")
                {
                }
                column(ValuedQuantity; "Value Entry"."Valued Quantity")
                {
                }
                column(CostAmountExpected; "Value Entry"."Cost Amount (Expected)")
                {
                }
                column(OrderNo; "Value Entry"."Order No.")
                {
                }
                column(CodeDevise; CodeDevise)
                {
                }
                column(TxChange; TxChange)
                {
                }
                column(MontantDevise; MontantDevise)
                {
                }
                column(ItemChargeNo; "Value Entry"."Item Charge No.")
                {
                }
                column(TotalMarchandise; TotalMarchandise)
                {
                }
                column(TotalFrais; TotalFrais)
                {
                }
                column(ItemLedgerEntryQuantity; "Value Entry"."Item Ledger Entry Quantity")
                {
                }
                column(ItemLedgerEntryNo; "Value Entry"."Item Ledger Entry No.")
                {
                }
                column(PrixAchatDS; PrixAchatDS)
                {
                }
                column(MntAchatDS; MntAchatDS)
                {
                }
                column(MntFrais; MntFrais)
                {
                }
                column(PrixAchatDevise; PrixAchatDevise)
                {
                }
                column(MontantAchatDevise; MontantAchatDevise)
                {
                }
                column(TxChangeRec; TxChangeRec)
                {
                }
                column(CodeDeviseRec; CodeDeviseRec)
                {
                }
                column(CoutUnitaire; Item."Unit Cost")
                {
                }
                column(PrixUnitaire; Item."Unit Price")
                {
                }
                column(ItemDesc; Item.Description)
                {
                }
                column(ItemChargeDescription; ItemCharge.Description)
                {
                }
                column(URLItem; URLItem)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    CodeDevise := '';
                    TxChange := 0;
                    MontantDevise := 0;
                    MntAchatDS := 0;
                    PrixAchatDS := 0;
                    MntFrais := 0;
                    PrixAchatDevise := 0;
                    MontantAchatDevise := 0;
                    TxChangeRec := 0;
                    CodeDeviseRec := '';
                    InvoiceHeader.RESET;
                    ReceptHeader.RESET;
                    ReceptLine.RESET;
                    //Purchase Receipt|Purchase Invoice|Purchase Return Shipment|Purchase Credit Memo
                    // Calc devise+Taux Change+Montant Devise : Purch Inv Header
                    IF ("Document Type" = "Document Type"::"Purchase Invoice") AND ("Item Charge No." = '') THEN
                        IF InvoiceHeader.GET("Value Entry"."Document No.") THEN BEGIN
                            CodeDevise := InvoiceHeader."Currency Code";
                            IF InvoiceHeader."Currency Factor" <> 0 THEN
                                TxChange := 1 / InvoiceHeader."Currency Factor"
                            ELSE
                                TxChange := 1;
                            InvoiceHeader.CALCFIELDS(Amount);
                            MontantDevise := InvoiceHeader.Amount;
                            TotalMarchandise += "Value Entry"."Cost Amount (Actual)";
                        END;
                    IF PurchInvLine.GET("Document No.", "Document Line No.") THEN BEGIN
                        PrixAchatDevise := PurchInvLine."Direct Unit Cost";
                        MontantAchatDevise := PurchInvLine.Amount;
                    END;
                    // Calc devise+Taux Change+Montant Devise : Purchase Credit Memo PurchCrMemoHdr PurchCrMemoLine
                    IF ("Document Type" = "Document Type"::"Purchase Credit Memo") AND ("Item Charge No." = '') THEN
                        IF PurchCrMemoHdr.GET("Value Entry"."Document No.") THEN BEGIN
                            CodeDevise := PurchCrMemoHdr."Currency Code";
                            IF PurchCrMemoHdr."Currency Factor" <> 0 THEN
                                TxChange := 1 / PurchCrMemoHdr."Currency Factor"
                            ELSE
                                TxChange := 1;
                            PurchCrMemoHdr.CALCFIELDS(Amount);
                            MontantDevise := -PurchCrMemoHdr.Amount;
                            TotalMarchandise += "Value Entry"."Cost Amount (Actual)";
                        END;
                    IF PurchCrMemoLine.GET("Document No.", "Document Line No.") THEN BEGIN
                        PrixAchatDevise := PurchCrMemoLine."Direct Unit Cost";
                        MontantAchatDevise := -PurchCrMemoLine.Amount;
                    END;
                    // Calc Pris Achat Devise + Montant Achat Devise
                    IF ("Document Type" = "Document Type"::"Purchase Receipt") AND ("Item Charge No." = '') THEN
                        IF ReceptLine.GET("Document No.", "Document Line No.") THEN BEGIN
                            IF ReceptHeader.GET("Document No.") THEN BEGIN
                                IF ReceptHeader."Currency Factor" <> 0 THEN
                                    TxChangeRec := 1 / ReceptHeader."Currency Factor"
                                ELSE
                                    TxChangeRec := 1;
                                CodeDeviseRec := ReceptHeader."Currency Code";
                            END;
                            PrixAchatDevise := ReceptLine."Unit Cost";
                            MontantAchatDevise := ReceptLine."Item Charge Base Amount";

                        END;

                    // Calc Pris Achat Devise + Montant Achat Devise ReturnShipHeader  ReturnShipLine
                    IF ("Document Type" = "Document Type"::"Purchase Return Shipment") AND ("Item Charge No." = '') THEN
                        IF ReturnShipLine.GET("Document No.", "Document Line No.") THEN BEGIN
                            IF ReturnShipHeader.GET("Document No.") THEN BEGIN
                                IF ReturnShipHeader."Currency Factor" <> 0 THEN
                                    TxChangeRec := 1 / ReturnShipHeader."Currency Factor"
                                ELSE
                                    TxChangeRec := 1;

                                CodeDeviseRec := ReturnShipHeader."Currency Code";
                            END;
                            PrixAchatDevise := ReturnShipLine."Unit Cost";
                            MontantAchatDevise := -ReturnShipLine."Item Charge Base Amount";

                        END;
                    // Calc Montant Frais Annex
                    IF (("Document Type" = "Document Type"::"Purchase Invoice") OR ("Document Type" = "Document Type"::"Purchase Credit Memo")) AND ("Item Charge No." <> '') THEN
                        TotalFrais += "Value Entry"."Cost Amount (Actual)";

                    // Calc Prix Achat DS + Montant DS article
                    IF "Item Charge No." = '' THEN BEGIN
                        MntAchatDS := "Cost Amount (Actual)" + "Cost Amount (Expected)";
                        PrixAchatDS := 0;
                        MntFrais := 0;
                    END ELSE BEGIN
                        PrixAchatDS := 0;
                        MntAchatDS := 0;
                        MntFrais := "Cost Amount (Actual)" + "Cost Amount (Expected)";
                    END;
                    IF Item.GET("Value Entry"."Item No.") THEN BEGIN
                        URLItem := '';
                        URLItem := GETURL(CLIENTTYPE::Current, COMPANYNAME, OBJECTTYPE::Page, 30, Item);
                    END;

                    IF ItemCharge.GET("Value Entry"."Item Charge No.") THEN;
                end;

                trigger OnPreDataItem()
                begin
                    TotalMarchandise := 0;
                    TotalFrais := 0;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                URLDossier := '';
                URLFrs := '';
                URLDossier := GETURL(CLIENTTYPE::Current, COMPANYNAME, OBJECTTYPE::Page, 50104, "WDC-TF Transit Folder");
                IF Vendor.GET("WDC-TF Transit Folder"."Vendor No.") THEN
                    URLFrs := GETURL(CLIENTTYPE::Current, COMPANYNAME, OBJECTTYPE::Page, 26, Vendor);
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        CompanyInformation.GET;
        CompanyInformation.CALCFIELDS(Picture);
    end;

    var
        InvoiceHeader: Record "Purch. Inv. Header";
        CodeDevise: Code[20];
        TxChange: Decimal;
        MontantDevise: Decimal;
        TotalMarchandise: Decimal;
        TotalFrais: Decimal;
        PrixAchatDS: Decimal;
        MntAchatDS: Decimal;
        MntFrais: Decimal;
        PrixAchatDevise: Decimal;
        MontantAchatDevise: Decimal;
        PurchInvLine: Record "Purch. Inv. Line";
        ReceptLine: Record "Purch. Rcpt. Line";
        ReceptHeader: Record "Purch. Rcpt. Header";
        TxChangeRec: Decimal;
        CodeDeviseRec: Code[20];
        CompanyInformation: Record "Company Information";
        RetReceiptHeader: Record "Return Receipt Header";
        RetReceiptLine: Record "Return Receipt Line";
        PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.";
        PurchCrMemoLine: Record "Purch. Cr. Memo Line";
        ReturnShipHeader: Record "Return Shipment Header";
        ReturnShipLine: Record "Return Shipment Line";
        Item: Record Item;
        ItemCharge: Record "Item Charge";
        URLDossier: Text[1024];
        URLFrs: Text[1024];
        URLItem: Text[1024];
        Vendor: Record Vendor;
}

