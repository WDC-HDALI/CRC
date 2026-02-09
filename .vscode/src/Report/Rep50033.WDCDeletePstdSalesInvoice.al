report 50033 "WDC Cancel Pstd Sales Invoice"
{
    ProcessingOnly = true;
    ApplicationArea = All;
    CaptionML = ENU = 'Delete Posted Sales Invoice', FRA = 'Supprimer facture Vente enreg.';
    //UsageCategory = Administration;
    Permissions =
   TableData "G/L Entry" = rimd,
   TableData "VAT Entry" = rimd,
   TableData "Value Entry" = rimd,
   TableData "Cust. Ledger Entry" = rimd,
   TableData "Detailed Cust. Ledg. Entry" = rimd,
   TableData "Sales Invoice Header" = rimd,
   TableData "Sales Invoice Line" = rimd,
   TableData "Sales Shipment Header" = rimd,
   TableData "Sales Shipment Line" = rimd,
   TableData "Item Ledger Entry" = rimd;
    dataset
    {
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            DataItemTableView = sorting("No.");
            trigger OnAfterGetRecord()
            var
                lGLEntries: Record 17;
                lcustomerLedger: Record 21;
                lDetCustomerLeg: Record 379;
                lVatEntry: Record 254;
                lValueEntrie: Record 5802;
                lItemLedgerEntr: Record 32;
                lSalesInvoiceLines: Record "Sales Invoice Line";
                lSalesShipmentHeader: Record "Sales Shipment Header";
                lSalesShipmentLines: Record "Sales Shipment Line";
                lText001: Textconst ENU = 'Invoice is already deleted',
                                     FRA = 'Cette facture est déjà annulé';
                lText002: Textconst ENU = 'Do you want to cancel this invoice?',
                                     FRA = 'Voulez-vous vraiment annuler la facture %1?';

            begin

                if confirm(StrSubstNo(lText002, "Sales Invoice Header"."No.")) then begin
                    if "Sales Invoice Header".Canceled = true then
                        Error(lText001);
                    lGLEntries.Reset();
                    lGLEntries.SetRange("Document No.", "Sales Invoice Header"."No.");
                    if lGLEntries.FindSet() then
                        repeat
                            lGLEntries.Delete();
                        until lGLEntries.Next() = 0;

                    lVatEntry.Reset();
                    lVatEntry.SetRange("Document No.", "Sales Invoice Header"."No.");
                    if lVatEntry.FindSet() then
                        repeat
                            lVatEntry.Delete();
                        until lVatEntry.Next() = 0;

                    lValueEntrie.Reset();
                    lValueEntrie.SetRange("Document No.", "Sales Invoice Header"."No.");
                    if lValueEntrie.FindSet() then
                        repeat
                            lValueEntrie.Delete();
                        until lValueEntrie.Next() = 0;

                    lDetCustomerLeg.Reset();
                    lDetCustomerLeg.SetRange("Document No.", "Sales Invoice Header"."No.");
                    if lDetCustomerLeg.FindSet() then
                        repeat
                            if "Sales Invoice Header"."Customer Posting Group" = 'C-PASSAGER' then
                                if (lDetCustomerLeg."Entry Type" = lDetCustomerLeg."Entry Type"::Application) and
                                   (lDetCustomerLeg."Document Type" = lDetCustomerLeg."Document Type"::Payment) then
                                    DeleteAssociedPayments(lDetCustomerLeg."Document No.");
                            lDetCustomerLeg.Delete();
                        until lDetCustomerLeg.Next() = 0;

                    lcustomerLedger.Reset();
                    lcustomerLedger.SetRange("Document No.", "Sales Invoice Header"."No.");
                    if lcustomerLedger.FindSet() then
                        repeat
                            lcustomerLedger.Delete()
                        until lcustomerLedger.Next() = 0;

                    lItemLedgerEntr.Reset();
                    lItemLedgerEntr.SetRange("Document No.", "Sales Invoice Header"."No.");
                    if lItemLedgerEntr.FindSet() then
                        repeat
                            lItemLedgerEntr.Delete();
                        until lItemLedgerEntr.Next() = 0;

                    lSalesShipmentHeader.Reset();
                    lSalesShipmentHeader.SetRange("Posting Description", "Sales Invoice Header"."Posting Description");
                    if lSalesShipmentHeader.FindFirst() then
                        repeat
                            lSalesShipmentLines.Reset();
                            lSalesShipmentLines.SetRange("Document No.", lSalesShipmentHeader."No.");
                            if lSalesShipmentLines.FindFirst() then
                                repeat
                                    lSalesShipmentLines.Delete();
                                until lSalesShipmentLines.Next() = 0;
                            lSalesShipmentHeader.Delete();
                        until lSalesShipmentHeader.next = 0;

                    lSalesInvoiceLines.Reset();
                    lSalesInvoiceLines.SetRange("Document No.", "Sales Invoice Header"."No.");
                    if lSalesInvoiceLines.FindFirst() then
                        repeat
                            lSalesInvoiceLines.Delete();
                        until lSalesInvoiceLines.Next() = 0;
                    InsertCommentAndMotifLines;
                    "Sales Invoice Header"."Stamp Amount" := 0;
                    "Sales Invoice Header".Canceled := true;
                    "Sales Invoice Header"."Replacment Invoice No." := RepInvoiceNo;
                    "Sales Invoice Header".Modify();

                end;
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Filter)
                {
                    field(Raison; Raison)
                    {
                        CaptionML = ENU = 'Raison', FRA = 'Motif';
                        ApplicationArea = all;
                    }
                    field(Description; Description)
                    {
                        CaptionML = ENU = 'Description', FRA = 'Description';
                        ApplicationArea = all;
                        MultiLine = true;
                    }
                    field(RepInvoiceNo; RepInvoiceNo)
                    {
                        CaptionML = ENU = 'Replacement invoice No.', FRA = 'N° facture remplaçante';
                        TableRelation = "Sales Invoice Header";
                        ApplicationArea = all;
                    }
                }
            }
        }

    }
    procedure DeleteAssociedPayments(pDocumentNo: Code[20])
    var
        lGLEntries: Record 17;
        lcustomerLedger: Record 21;
        lDetCustomerLeg: Record 379;
        lBankEntries: Record "Bank Account Ledger Entry";
    begin
        lBankEntries.Reset();
        lBankEntries.SetRange("Document No.", pDocumentNo);
        if lBankEntries.FindSet() then
            repeat
                lBankEntries.Delete();
            until lBankEntries.Next() = 0;

        lGLEntries.Reset();
        lGLEntries.SetRange("Document No.", pDocumentNo);
        if lGLEntries.FindSet() then
            repeat
                lGLEntries.Delete();
            until lGLEntries.Next() = 0;

        lDetCustomerLeg.Reset();
        lDetCustomerLeg.SetRange("Document No.", pDocumentNo);
        if lDetCustomerLeg.FindSet() then
            repeat
                lDetCustomerLeg.Delete();
            until lDetCustomerLeg.Next() = 0;

        lcustomerLedger.Reset();
        lcustomerLedger.SetRange("Document No.", pDocumentNo);
        if lcustomerLedger.FindSet() then
            repeat
                lcustomerLedger.Delete()
            until lcustomerLedger.Next() = 0;
    end;

    procedure InsertCommentAndMotifLines()
    var
        lSalesInvoiceLines: Record "Sales Invoice Line";
    begin
        lSalesInvoiceLines.Init();
        lSalesInvoiceLines."Document No." := "Sales Invoice Header"."No.";
        lSalesInvoiceLines."Line No." := 10000;
        lSalesInvoiceLines.Type := lSalesInvoiceLines.Type::" ";
        lSalesInvoiceLines.Description := 'Cette facture a été annulée par :' + UserID +
                                          ' \ Le: ' + Format(WorkDate()) + ' ' + Format(Time);
        lSalesInvoiceLines.Insert();

        lSalesInvoiceLines.Init();
        lSalesInvoiceLines."Document No." := "Sales Invoice Header"."No.";
        lSalesInvoiceLines."Line No." := 20000;
        lSalesInvoiceLines.Type := lSalesInvoiceLines.Type::" ";
        if RepInvoiceNo = '' then
            lSalesInvoiceLines.Description := 'Raison :' + Format(Raison)
        else
            lSalesInvoiceLines.Description := 'Raison :' + Format(Raison) + ': Facture remplaçante: ' + RepInvoiceNo;
        lSalesInvoiceLines.Insert();

        If Description <> '' then begin
            lSalesInvoiceLines.Init();
            lSalesInvoiceLines."Document No." := "Sales Invoice Header"."No.";
            lSalesInvoiceLines."Line No." := 30000;
            lSalesInvoiceLines.Type := lSalesInvoiceLines.Type::" ";
            lSalesInvoiceLines.Description := Description;
            lSalesInvoiceLines.Insert();
        end;
    end;

    var
        RepInvoiceNo: Code[20];
        Raison: Option "Erreur d''information","Modification ou annulation de la commande"
                        ,"La facture a été émise en double";
        Description: text[250];
        AssociedPaymentNo: Code[20];
}
