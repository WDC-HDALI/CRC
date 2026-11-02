report 50914 "WDC Cancel Purch Credit Memo"
{
    ProcessingOnly = true;
    ApplicationArea = All;
    CaptionML = ENU = 'WDC Delete  Purchase Credit Memo', FRA = 'WDC Supprimer avoir achat';
    Permissions =
   TableData "G/L Entry" = rimd,
   TableData "VAT Entry" = rimd,
   TableData "Value Entry" = rimd,
   TableData "Vendor Ledger Entry" = rimd,
   TableData "Detailed Vendor Ledg. Entry" = rimd,
   TableData "Purch. Cr. Memo Hdr." = rimd,
   TableData "Purch. Cr. Memo Line" = rimd,
   TableData "Item Ledger Entry" = rimd;
    dataset
    {
        dataitem("Purch. Cr. Memo Hdr."; "Purch. Cr. Memo Hdr.")
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
                lPurchCrMemoHeader: Record "Purch. Cr. Memo Hdr.";
                lPurchCrMemoLine: Record "Purch. Cr. Memo Line";
                lText001: Textconst ENU = 'Credit is already deleted',
                                     FRA = 'Cet avoir est déjà annulé';
                lText002: Textconst ENU = 'Do you want to cancel this Credit Memo?',
                                     FRA = 'Voulez-vous vraiment annuler l avoir %1?';

            begin

                if confirm(StrSubstNo(lText002, "Purch. Cr. Memo Hdr."."No.")) then begin
                    if "Purch. Cr. Memo Hdr.".Cancelled = true then
                        Error(lText001);
                    lGLEntries.Reset();
                    lGLEntries.SetRange("Document No.", "Purch. Cr. Memo Hdr."."No.");
                    if lGLEntries.FindSet() then
                        repeat
                            lGLEntries.Delete();
                        until lGLEntries.Next() = 0;

                    lVatEntry.Reset();
                    lVatEntry.SetRange("Document No.", "Purch. Cr. Memo Hdr."."No.");
                    if lVatEntry.FindSet() then
                        repeat
                            lVatEntry.Delete();
                        until lVatEntry.Next() = 0;

                    lValueEntrie.Reset();
                    lValueEntrie.SetRange("Document No.", "Purch. Cr. Memo Hdr."."No.");
                    if lValueEntrie.FindSet() then
                        repeat
                            lValueEntrie.Delete();
                        until lValueEntrie.Next() = 0;

                    lDetVendorLeg.Reset();
                    lDetVendorLeg.SetRange("Document No.", "Purch. Cr. Memo Hdr."."No.");
                    if lDetVendorLeg.FindSet() then
                        repeat
                            lDetVendorLeg.Delete();
                        until lDetVendorLeg.Next() = 0;

                    lvendorLedger.Reset();
                    lvendorLedger.SetRange("Document No.", "Purch. Cr. Memo Hdr."."No.");
                    if lvendorLedger.FindSet() then
                        repeat
                            lvendorLedger.Delete()
                        until lvendorLedger.Next() = 0;

                    lItemLedgerEntr.Reset();
                    lItemLedgerEntr.SetRange("Document No.", "Purch. Cr. Memo Hdr."."No.");
                    if lItemLedgerEntr.FindSet() then
                        repeat
                            lItemLedgerEntr.Delete();
                        until lItemLedgerEntr.Next() = 0;

                    lPurchCrMemoHeader.Reset();
                    lPurchCrMemoHeader.SetRange("Posting Description", "Purch. Cr. Memo Hdr."."Posting Description");
                    if lPurchCrMemoHeader.FindFirst() then
                        repeat
                            lPurchCrMemoLine.Reset();
                            lPurchCrMemoLine.SetRange("Document No.", lPurchCrMemoHeader."No.");
                            if lPurchCrMemoLine.FindFirst() then
                                repeat
                                    lPurchCrMemoLine.Delete();
                                until lPurchCrMemoLine.Next() = 0;
                            lPurchCrMemoHeader.Delete();
                        until lPurchCrMemoHeader.next = 0;
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
                    field(RepCrMemoNo; RepCrmemoNo)
                    {
                        CaptionML = ENU = 'Replacement credit memo No.', FRA = 'N° avoir remplaçante';
                        TableRelation = "Purch. Cr. Memo Hdr.";
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
        lPurchCrMemoLines: Record "Purch. Cr. Memo Line";
    begin
        lPurchCrMemoLines.Init();
        lPurchCrMemoLines."Document No." := "Purch. Cr. Memo Hdr."."No.";
        lPurchCrMemoLines."Line No." := 10000;
        lPurchCrMemoLines.Type := lPurchCrMemoLines.Type::" ";
        lPurchCrMemoLines.Description := 'Cet avoir a été annulée par :' + UserID +
                                          ' \ Le: ' + Format(WorkDate()) + ' ' + Format(Time);
        lPurchCrMemoLines.Insert();

        lPurchCrMemoLines.Init();
        lPurchCrMemoLines."Document No." := "Purch. Cr. Memo Hdr."."No.";
        lPurchCrMemoLines."Line No." := 20000;
        lPurchCrMemoLines.Type := lPurchCrMemoLines.Type::" ";
        if RepCrMemoNo = '' then
            lPurchCrMemoLines.Description := 'Raison :' + Format(Raison)
        else
            lPurchCrMemoLines.Description := 'Raison :' + Format(Raison) + ': Avoir remplaçante: ' + RepCrMemoNo;
        lPurchCrMemoLines.Insert();

        If Description <> '' then begin
            lPurchCrMemoLines.Init();
            lPurchCrMemoLines."Document No." := "Purch. Cr. Memo Hdr."."No.";
            lPurchCrMemoLines."Line No." := 30000;
            lPurchCrMemoLines.Type := lPurchCrMemoLines.Type::" ";
            lPurchCrMemoLines.Description := Description;
            lPurchCrMemoLines.Insert();
        end;
    end;

    var
        RepCrMemoNo: Code[20];
        Raison: Option "Erreur d''information","Modification ou annulation de la commande"
                        ,"L'avoir a été émis en double";
        Description: text[250];
        AssociedPaymentNo: Code[20];
}
