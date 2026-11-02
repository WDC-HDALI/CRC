report 50915 "WDC Cancel Pstd Purch Invoice"
{
    ProcessingOnly = true;
    ApplicationArea = All;
    CaptionML = ENU = 'WDC Delete Posted Purchase Invoice', FRA = 'WDC Supprimer facture Achats enreg.';
    Permissions =
   TableData "G/L Entry" = rimd,
   TableData "VAT Entry" = rimd,
   TableData "Value Entry" = rimd,
   TableData "Vendor Ledger Entry" = rimd,
   TableData "Detailed Vendor Ledg. Entry" = rimd,
   TableData "Purch. Inv. Header" = rimd,
   TableData "Purch. Inv. Line" = rimd,
   TableData "Purch. Rcpt. Header" = rimd,
   TableData "Purch. Rcpt. Line" = rimd,
   TableData "Item Ledger Entry" = rimd;
    dataset
    {
        dataitem("Purch. Inv. Header"; "Purch. Inv. Header")
        {
            DataItemTableView = sorting("No.");
            trigger OnAfterGetRecord()
            var
                lGLEntries: Record 17;
                lvendorLedger: Record 25;
                lDetVendorLeg: Record 380;
                lVatEntry: Record 254;
                lValueEntrie: Record 5802;
                lItemLedgerEntr: Record 32;
                lPurchInvLines: Record "Purch. Inv. Line";
                lPurchRcptHeader: Record "Purch. Rcpt. Header";
                lPurchRcptLines: Record "Purch. Rcpt. Line";
                lText001: Textconst ENU = 'Invoice is already deleted',
                                     FRA = 'Cette facture est déjà annulé';
                lText002: Textconst ENU = 'Do you want to cancel this invoice?',
                                     FRA = 'Voulez-vous vraiment annuler la facture %1?';

            begin

                if confirm(StrSubstNo(lText002, "Purch. Inv. Header"."No.")) then begin
                    if "Purch. Inv. Header".Cancelled = true then
                        Error(lText001);
                    lGLEntries.Reset();
                    lGLEntries.SetRange("Document No.", "Purch. Inv. Header"."No.");
                    if lGLEntries.FindSet() then
                        repeat
                            lGLEntries.Delete();
                        until lGLEntries.Next() = 0;

                    lVatEntry.Reset();
                    lVatEntry.SetRange("Document No.", "Purch. Inv. Header"."No.");
                    if lVatEntry.FindSet() then
                        repeat
                            lVatEntry.Delete();
                        until lVatEntry.Next() = 0;

                    lValueEntrie.Reset();
                    lValueEntrie.SetRange("Document No.", "Purch. Inv. Header"."No.");
                    if lValueEntrie.FindSet() then
                        repeat
                            lValueEntrie.Delete();
                        until lValueEntrie.Next() = 0;

                    lDetVendorLeg.Reset();
                    lDetVendorLeg.SetRange("Document No.", "Purch. Inv. Header"."No.");
                    if lDetVendorLeg.FindSet() then
                        repeat
                            lDetVendorLeg.Delete();
                        until lDetVendorLeg.Next() = 0;

                    lvendorLedger.Reset();
                    lvendorLedger.SetRange("Document No.", "Purch. Inv. Header"."No.");
                    if lvendorLedger.FindSet() then
                        repeat
                            lvendorLedger.Delete()
                        until lvendorLedger.Next() = 0;

                    lItemLedgerEntr.Reset();
                    lItemLedgerEntr.SetRange("Document No.", "Purch. Inv. Header"."No.");
                    if lItemLedgerEntr.FindSet() then
                        repeat
                            lItemLedgerEntr.Delete();
                        until lItemLedgerEntr.Next() = 0;

                    lPurchRcptHeader.Reset();
                    lPurchRcptHeader.SetRange("Posting Description", "Purch. Inv. Header"."Posting Description");
                    if lPurchRcptHeader.FindFirst() then
                        repeat
                            lPurchRcptLines.Reset();
                            lPurchRcptLines.SetRange("Document No.", lPurchRcptHeader."No.");
                            if lPurchRcptLines.FindFirst() then
                                repeat
                                    lPurchRcptLines.Delete();
                                until lPurchRcptLines.Next() = 0;
                            lPurchRcptHeader.Delete();
                        until lPurchRcptHeader.next = 0;

                    lPurchInvLines.Reset();
                    lPurchInvLines.SetRange("Document No.", "Purch. Inv. Header"."No.");
                    if lPurchInvLines.FindFirst() then
                        repeat
                            lPurchInvLines.Delete();
                        until lPurchInvLines.Next() = 0;
                    InsertCommentAndMotifLines;
                    "Purch. Inv. Header"."Stamp Amount" := 0;
                    "Purch. Inv. Header".Cancelled := true;
                    "Purch. Inv. Header"."Replacment Invoice No." := RepInvoiceNo;
                    "Purch. Inv. Header".Modify();

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
                        TableRelation = "Purch. Inv. Header";
                        ApplicationArea = all;
                    }
                }
            }
        }

    }
    procedure DeleteAssociedPayments(pDocumentNo: Code[20])
    var
        lGLEntries: Record 17;
        lvendorLedger: Record 25;
        lDetVendorLeg: Record 380;
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

        lDetVendorLeg.Reset();
        lDetVendorLeg.SetRange("Document No.", pDocumentNo);
        if lDetVendorLeg.FindSet() then
            repeat
                lDetVendorLeg.Delete();
            until lDetVendorLeg.Next() = 0;

        lvendorLedger.Reset();
        lvendorLedger.SetRange("Document No.", pDocumentNo);
        if lvendorLedger.FindSet() then
            repeat
                lvendorLedger.Delete()
            until lvendorLedger.Next() = 0;
    end;

    procedure InsertCommentAndMotifLines()
    var
        lPurchInvLines: Record "Purch. Inv. Line";
    begin
        lPurchInvLines.Init();
        lPurchInvLines."Document No." := "Purch. Inv. Header"."No.";
        lPurchInvLines."Line No." := 10000;
        lPurchInvLines.Type := lPurchInvLines.Type::" ";
        lPurchInvLines.Description := 'Cette facture a été annulée par :' + UserID +
                                          ' \ Le: ' + Format(WorkDate()) + ' ' + Format(Time);
        lPurchInvLines.Insert();

        lPurchInvLines.Init();
        lPurchInvLines."Document No." := "Purch. Inv. Header"."No.";
        lPurchInvLines."Line No." := 20000;
        lPurchInvLines.Type := lPurchInvLines.Type::" ";
        if RepInvoiceNo = '' then
            lPurchInvLines.Description := 'Raison :' + Format(Raison)
        else
            lPurchInvLines.Description := 'Raison :' + Format(Raison) + ': Facture remplaçante: ' + RepInvoiceNo;
        lPurchInvLines.Insert();

        If Description <> '' then begin
            lPurchInvLines.Init();
            lPurchInvLines."Document No." := "Purch. Inv. Header"."No.";
            lPurchInvLines."Line No." := 30000;
            lPurchInvLines.Type := lPurchInvLines.Type::" ";
            lPurchInvLines.Description := Description;
            lPurchInvLines.Insert();
        end;
    end;

    var
        RepInvoiceNo: Code[20];
        Raison: Option "Erreur d''information","Modification ou annulation de la commande"
                        ,"La facture a été émise en double";
        Description: text[250];
        AssociedPaymentNo: Code[20];
}
