//****************Documentation*************
//WDC01  WDC.HG  22/09/2025 Correct the Credit Memo Entry 
codeunit 54002 "WDC-ST Sales&PurchaseHook"
{

    procedure SalesPostTimbre(VAR SalesHeader: Record "Sales Header"; GenJnlPostLine: Codeunit 12; GenJOurnalLine: Record "Gen. Journal Line")

    var
        GenJnlLine: Record "Gen. Journal Line";
        SourceCodeSetup: Record "Source Code Setup";
        CustomerPostingGroup: Record "Customer Posting Group";
        SrcCode: code[10];
        CompteTimbre: Code[20];
        MntTimbre: Decimal;
    begin
        SourceCodeSetup.GET;
        SrcCode := SourceCodeSetup.Sales;
        CustomerPostingGroup.GET(SalesHeader."Customer Posting Group");
        IF SalesHeader."Apply Fiscal Stamp" THEN BEGIN
            CustomerPostingGroup.TestField("Apply Fiscal Stamp");
            CustomerPostingGroup.TESTFIELD("Fiscal Stamp Account No.");
            CustomerPostingGroup.TESTFIELD("Stamp Amount");
            MntTimbre := 0;
            MntTimbre := CustomerPostingGroup."Stamp Amount";
            CompteTimbre := CustomerPostingGroup."Fiscal Stamp Account No.";
            GenJnlLine.INIT;
            GenJnlLine."Posting Date" := SalesHeader."Posting Date";
            GenJnlLine."Document Date" := SalesHeader."Document Date";
            GenJnlLine.Description := SalesHeader."Posting Description";
            GenJnlLine."Shortcut Dimension 1 Code" := SalesHeader."Shortcut Dimension 1 Code";
            GenJnlLine."Shortcut Dimension 2 Code" := SalesHeader."Shortcut Dimension 2 Code";
            GenJnlLine."Reason Code" := SalesHeader."Reason Code";
            GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
            GenJnlLine."Account No." := CompteTimbre;
            GenJnlLine."Document Type" := GenJOurnalLine."Document Type";
            GenJnlLine."Document No." := GenJOurnalLine."Document No.";
            GenJnlLine."External Document No." := SalesHeader."External Document No.";
            GenJnlLine."Currency Code" := SalesHeader."Currency Code";
            IF GenJnlLine."Document Type" = GenJnlLine."Document Type"::"Credit Memo" THEN BEGIN
                GenJnlLine.Amount := MntTimbre;
                GenJnlLine."Source Currency Code" := GenJnlLine."Currency Code";
                GenJnlLine."Source Currency Amount" := MntTimbre;
                GenJnlLine."Amount (LCY)" := MntTimbre;
            END
            ELSE BEGIN
                GenJnlLine.Amount := -MntTimbre;
                GenJnlLine."Source Currency Code" := GenJnlLine."Currency Code";
                GenJnlLine."Source Currency Amount" := -MntTimbre;
                GenJnlLine."Amount (LCY)" := -MntTimbre;
            END;
            IF GenJnlLine."Currency Code" = '' THEN
                GenJnlLine."Currency Factor" := 1
            ELSE
                GenJnlLine."Currency Factor" := GenJnlLine."Currency Factor";
            GenJnlLine.Correction := GenJnlLine.Correction;
            GenJnlLine."Sales/Purch. (LCY)" := 0;
            GenJnlLine."Profit (LCY)" := 0;
            GenJnlLine."Inv. Discount (LCY)" := 0;
            GenJnlLine."Sell-to/Buy-from No." := SalesHeader."Sell-to Customer No.";
            GenJnlLine."Bill-to/Pay-to No." := SalesHeader."Bill-to Customer No.";
            GenJnlLine."Salespers./Purch. Code" := SalesHeader."Salesperson Code";
            GenJnlLine."System-Created Entry" := TRUE;
            GenJnlLine."On Hold" := GenJnlLine."On Hold";
            GenJnlLine."Allow Application" := GenJnlLine."Bal. Account No." = '';
            GenJnlLine."Due Date" := SalesHeader."Due Date";
            GenJnlLine."Payment Terms Code" := SalesHeader."Payment Terms Code";
            GenJnlLine."Source Type" := GenJnlLine."Source Type"::Customer;
            GenJnlLine."Source No." := SalesHeader."Bill-to Customer No.";
            GenJnlLine."Source Code" := SrcCode;
            GenJnlLine."Posting No. Series" := SalesHeader."Posting No. Series";
            GenJnlPostLine.RunWithCheck(GenJnlLine);
        END;
    end;

    procedure PurchPostTimbre(VAR PurchaseHeader: Record "Purchase Header"; GenJnlPostLine: Codeunit 12; GenJournalLine: Record "Gen. Journal Line")
    var
        GenJnlLine: Record 81;
        SourceCodeSetup: Record "Source Code Setup";
        VendorPostingGroup: Record "Vendor Posting Group";
        SrcCode: code[10];
        CompteTimbre: Code[20];
        MntTimbre: Decimal;
    begin
        SourceCodeSetup.GET;
        SrcCode := SourceCodeSetup.Sales;
        VendorPostingGroup.GET(PurchaseHeader."Vendor Posting Group");
        IF PurchaseHeader."Apply Fiscal Stamp" THEN BEGIN
            VendorPostingGroup.TestField("Apply Fiscal Stamp");
            VendorPostingGroup.TESTFIELD("Fiscal Stamp Account No.");
            VendorPostingGroup.TESTFIELD("Stamp Amount");
            MntTimbre := 0;
            //<<WDC01
            if PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::"Credit Memo" then
                MntTimbre := -VendorPostingGroup."Stamp Amount"
            else
                MntTimbre := VendorPostingGroup."Stamp Amount";
            //>>WDC01
            CompteTimbre := VendorPostingGroup."Fiscal Stamp Account No.";
            GenJnlLine.INIT;
            GenJnlLine."Posting Date" := PurchaseHeader."Posting Date";
            GenJnlLine."Document Date" := PurchaseHeader."Document Date";
            GenJnlLine.Description := PurchaseHeader."Posting Description";
            GenJnlLine."Shortcut Dimension 1 Code" := GenJnlLine."Shortcut Dimension 1 Code";
            GenJnlLine."Shortcut Dimension 2 Code" := GenJnlLine."Shortcut Dimension 2 Code";
            GenJnlLine."Reason Code" := GenJnlLine."Reason Code";
            GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
            GenJnlLine."Account No." := CompteTimbre;
            GenJnlLine."Document Type" := GenJournalLine."Document Type";
            GenJnlLine."Document No." := GenJournalLine."Document No.";
            GenJnlLine."External Document No." := GenJournalLine."External Document No.";
            GenJnlLine."Currency Code" := GenJnlLine."Currency Code";
            GenJnlLine.Amount := MntTimbre;
            GenJnlLine."Source Currency Code" := GenJnlLine."Currency Code";
            GenJnlLine."Source Currency Amount" := MntTimbre;
            GenJnlLine."Amount (LCY)" := MntTimbre;
            IF PurchaseHeader."Currency Code" = '' THEN
                GenJnlLine."Currency Factor" := 1
            ELSE
                GenJnlLine."Currency Factor" := PurchaseHeader."Currency Factor";
            GenJnlLine.Correction := GenJnlLine.Correction;
            GenJnlLine."Sales/Purch. (LCY)" := 0;
            GenJnlLine."Profit (LCY)" := 0;
            GenJnlLine."Inv. Discount (LCY)" := 0;
            GenJnlLine."Sell-to/Buy-from No." := PurchaseHeader."Buy-from Vendor No.";
            GenJnlLine."Bill-to/Pay-to No." := PurchaseHeader."Pay-to Vendor No.";
            GenJnlLine."Salespers./Purch. Code" := PurchaseHeader."Purchaser Code";
            GenJnlLine."System-Created Entry" := TRUE;
            GenJnlLine."On Hold" := GenJnlLine."On Hold";
            GenJnlLine."Applies-to Doc. Type" := GenJnlLine."Applies-to Doc. Type";
            GenJnlLine."Applies-to Doc. No." := GenJnlLine."Applies-to Doc. No.";
            GenJnlLine."Applies-to ID" := GenJnlLine."Applies-to ID";
            GenJnlLine."Allow Application" := GenJnlLine."Bal. Account No." = '';
            GenJnlLine."Due Date" := GenJnlLine."Due Date";
            GenJnlLine."Payment Terms Code" := GenJnlLine."Payment Terms Code";
            GenJnlLine."Source Type" := GenJnlLine."Source Type"::Vendor;
            GenJnlLine."Source No." := PurchaseHeader."Pay-to Vendor No.";
            GenJnlLine."Source Code" := SrcCode;
            GenJnlLine."Posting No. Series" := GenJnlLine."Posting No. Series";

            GenJnlPostLine.RunWithCheck(GenJnlLine);

        END;
    END;

}