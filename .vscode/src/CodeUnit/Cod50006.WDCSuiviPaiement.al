codeunit 50011 "Suivi paiement"
{
    trigger OnRun()
    Var
    begin
        GeneralLedgSetup.Get();
        StartDateFilter := GeneralLedgSetup."Go Live Date";
        EndDateFilter := WorkDate();
        BuildMatrix('', StartDateFilter, EndDateFilter);
    end;

    var
        GeneralLedgSetup: Record "General Ledger Setup";
        StartDateFilter: Date;
        EndDateFilter: Date;
        CustLedgEntry: Record "Cust. Ledger Entry";
        SalesInvLine: Record "Sales Invoice Line";
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
        SalesInvHeader: Record "Sales Invoice Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        DetCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        MatrixBuf: Record "Payment Tracking Buffer";
        SalesLine: record "Sales Line";
        SalesHeader: record "Sales Header";
        GLSetup: Record "General Ledger Setup";
        RoundingPrecision: Decimal;
        Currency: record Currency;
    // ----------------------------------------------
    // BUILD MATRIX PRINCIPALE
    // ----------------------------------------------
    procedure BuildMatrix(SalespersonFilter: Code[20]; FromDate: Date; ToDate: Date)
    var
        Sign: Integer;
    begin
        MatrixBuf.DeleteAll();
        CustLedgEntry.Reset();
        CustLedgEntry.SetFilter("Document Type", '%1|%2', CustLedgEntry."Document Type"::Invoice, CustLedgEntry."Document Type"::"Credit Memo");

        CustLedgEntry.SetRange("Posting Date", FromDate, ToDate);

        if SalespersonFilter <> '' then
            CustLedgEntry.SetRange("Salesperson Code", SalespersonFilter);

        if CustLedgEntry.FindSet() then
            repeat
                case CustLedgEntry."Document Type" of
                    CustLedgEntry."Document Type"::Invoice:
                        HandleInvoice(CustLedgEntry);

                    CustLedgEntry."Document Type"::"Credit Memo":
                        HandleCreditMemo(CustLedgEntry);
                end;
            until CustLedgEntry.Next() = 0;
        // ----------------------------------------------
        // TRAITEMENT BL Livrée non facturé
        // ----------------------------------------------            
        Clear(SalesLine);
        SalesLine.setrange("Document Type", SalesLine."Document Type"::Order);
        SalesLine.setfilter("Qty. Shipped Not Invoiced", '<>%1', 0);
        if SalesLine.findset then
            repeat
            begin
                if SalesLine."Currency Code" <> '' then begin
                    Currency.Get(SalesLine."Currency Code");
                    RoundingPrecision := Currency."Amount Rounding Precision";
                end else begin
                    GLSetup.Get();
                    RoundingPrecision := GLSetup."Amount Rounding Precision";
                end;
                MatrixBuf.Init();
                if MatrixBuf.FindLast() then
                    MatrixBuf."Entry No." := MatrixBuf."Entry No." + 1
                else
                    MatrixBuf."Entry No." := 1;
                SalesHeader.get(SalesHeader."Document Type"::Order, SalesLine."Document No.");
                MatrixBuf."Item Type" := Format(SalesLine.type);
                MatrixBuf."Document No." := SalesLine."Document No.";
                MatrixBuf."Customer No." := SalesLine."Sell-to Customer No.";
                MatrixBuf."Customer Name" := SalesHeader."Sell-to Customer Name";
                MatrixBuf."Salesperson Code" := SalesHeader."Salesperson Code";
                MatrixBuf."Posting Date" := SalesHeader."Posting Date";
                MatrixBuf.Validate("Item No.", SalesLine."No.");
                MatrixBuf."Item Description" := SalesLine.Description;
                MatrixBuf.Quantity := SalesLine."Qty. Shipped Not Invoiced";
                MatrixBuf."Amount Excl. VAT" := SalesLine."Qty. Shipped Not Invoiced" * SalesLine."Unit Price";
                MatrixBuf."Amount Incl. VAT" := Round(SalesLine."Qty. Shipped Not Invoiced" * SalesLine."Unit Price" * (1 + (SalesLine."VAT %" / 100)), RoundingPrecision);
                MatrixBuf."Due Date" := SalesHeader."Due Date";
                MatrixBuf."Payment Amount" := 0;
                MatrixBuf."Payment Date" := 0D;
                MatrixBuf."Payment Type" := '';
                MatrixBuf."Customer Amount" := Round(SalesLine."Qty. Shipped Not Invoiced" * SalesLine."Unit Price" * (1 + (SalesLine."VAT %" / 100)), RoundingPrecision);
                MatrixBuf."Document Type" := 'BLNONFACT';
                MatrixBuf.Insert();
            end;
            until SalesLine.next = 0;
        // ----------------------------------------------
        // TRAITEMENT Réception retour
        // ----------------------------------------------            
        Clear(SalesLine);
        Sign := -1;
        SalesLine.setrange("Document Type", SalesLine."Document Type"::"Return Order");
        SalesLine.setfilter("Return Qty. Rcd. Not Invd.", '<>%1', 0);
        if SalesLine.findset then
            repeat
            begin
                if SalesLine."Currency Code" <> '' then begin
                    Currency.Get(SalesLine."Currency Code");
                    RoundingPrecision := Currency."Amount Rounding Precision";
                end else begin
                    GLSetup.Get();
                    RoundingPrecision := GLSetup."Amount Rounding Precision";
                end;
                MatrixBuf.Init();
                if MatrixBuf.FindLast() then
                    MatrixBuf."Entry No." := MatrixBuf."Entry No." + 1
                else
                    MatrixBuf."Entry No." := 1;
                SalesHeader.get(SalesHeader."Document Type"::Order, SalesLine."Document No.");
                MatrixBuf."Item Type" := Format(SalesLine.type);
                MatrixBuf."Document No." := SalesLine."Document No.";
                MatrixBuf."Customer No." := SalesLine."Sell-to Customer No.";
                MatrixBuf."Customer Name" := SalesHeader."Sell-to Customer Name";
                MatrixBuf."Salesperson Code" := SalesHeader."Salesperson Code";
                MatrixBuf."Posting Date" := SalesHeader."Posting Date";
                MatrixBuf.Validate("Item No.", SalesLine."No.");
                MatrixBuf."Item Description" := SalesLine.Description;
                MatrixBuf.Quantity := SalesLine."Return Qty. Rcd. Not Invd." * sign;
                MatrixBuf."Amount Excl. VAT" := SalesLine."Return Qty. Rcd. Not Invd." * sign;
                MatrixBuf."Amount Incl. VAT" := Round(SalesLine."Return Qty. Rcd. Not Invd." * SalesLine."Unit Price" * (1 + (SalesLine."VAT %" / 100) * sign), RoundingPrecision);
                MatrixBuf."Due Date" := SalesHeader."Due Date";
                MatrixBuf."Payment Amount" := 0;
                MatrixBuf."Payment Date" := 0D;
                MatrixBuf."Payment Type" := '';
                MatrixBuf."Customer Amount" := Round(SalesLine."Return Qty. Rcd. Not Invd." * SalesLine."Unit Price" * (1 + (SalesLine."VAT %" / 100) * sign), RoundingPrecision);
                MatrixBuf."Document Type" := 'RETNONFACT';
                MatrixBuf.Insert();
            end;
            until SalesLine.next = 0;
    end;
    // ----------------------------------------------
    // TRAITEMENT FACTURE
    // ----------------------------------------------
    local procedure HandleInvoice(var CLE: Record "Cust. Ledger Entry")
    var
        Salesperson: Code[20];
        PaymentAmount: Decimal;
        PaymentDate: Date;
        PaymentType: Code[30];
    begin
        Salesperson := '';

        if SalesInvHeader.Get(CLE."Document No.") then
            Salesperson := SalesInvHeader."Salesperson Code";

        CalcPaymentInfo(CLE, PaymentAmount, PaymentDate, PaymentType);

        SalesInvLine.Reset();
        SalesInvLine.SetRange("Document No.", CLE."Document No.");

        if SalesInvLine.FindSet() then
            repeat
                InsertMatrixLine(
                    CLE,
                    SalesInvLine."No.",
                    SalesInvLine.Quantity,
                    SalesInvLine."Amount",
                    SalesInvLine."Amount Including VAT",
                    PaymentAmount,
                    PaymentDate,
                    Salesperson,
                    PaymentType, SalesInvHeader."Sell-to Customer Name", SalesInvLine.Description, format(SalesInvLine.Type), cle."Amount (LCY)", 'FACTURE');
            until SalesInvLine.Next() = 0;
    end;

    // ----------------------------------------------
    // TRAITEMENT AVOIR
    // ----------------------------------------------
    local procedure HandleCreditMemo(var CLE: Record "Cust. Ledger Entry")
    var
        Salesperson: Code[20];
        PaymentAmount: Decimal;
        PaymentDate: Date;
        PaymentType: Code[30];
        Sign: Integer;
    begin
        Salesperson := '';

        if SalesCrMemoHeader.Get(CLE."Document No.") then
            Salesperson := SalesCrMemoHeader."Salesperson Code";

        CalcPaymentInfo(CLE, PaymentAmount, PaymentDate, PaymentType);

        Sign := -1;

        SalesCrMemoLine.Reset();
        SalesCrMemoLine.SetRange("Document No.", CLE."Document No.");

        if SalesCrMemoLine.FindSet() then
            repeat
                InsertMatrixLine(
                    CLE,
                    SalesCrMemoLine."No.",
                    SalesCrMemoLine.Quantity * Sign,
                    SalesCrMemoLine."Amount" * Sign,
                    SalesCrMemoLine."Amount Including VAT" * Sign,
                    PaymentAmount,
                    PaymentDate,
                    Salesperson,
                    PaymentType, SalesCrMemoHeader."Sell-to Customer Name", SalesCrMemoLine.Description, format(SalesCrMemoLine.Type), cle."Amount (LCY)", 'AVOIR');
            until SalesCrMemoLine.Next() = 0;
    end;

    local procedure CalcPaymentInfo(var CLE: Record "Cust. Ledger Entry"; var PaymentAmount: Decimal; var PaymentDate: Date; var PaymentType: Code[30])
    begin
        PaymentAmount := 0;
        PaymentDate := 0D;
        PaymentType := '';

        DetCustLedgEntry.Reset();
        DetCustLedgEntry.SetRange("Cust. Ledger Entry No.", CLE."Entry No.");
        DetCustLedgEntry.SetRange("Entry Type", DetCustLedgEntry."Entry Type"::Application);

        if DetCustLedgEntry.FindSet() then
            repeat
                PaymentAmount += DetCustLedgEntry."Amount (LCY)";

                if (PaymentDate = 0D) or (DetCustLedgEntry."Posting Date" > PaymentDate) then begin
                    PaymentDate := DetCustLedgEntry."Posting Date";
                    PaymentType := Format(DetCustLedgEntry."Payment Slip Type");  // <-- TYPE DE PAIEMENT
                end;

            until DetCustLedgEntry.Next() = 0;
    end;

    // ----------------------------------------------
    // INSERTION BUFFER
    // ----------------------------------------------
    local procedure InsertMatrixLine(
        var CLE: Record "Cust. Ledger Entry";
        ItemNo: Code[20];
        Qty: Decimal;
        AmountHT: Decimal;
        AmountTTC: Decimal;
        PaymentAmount: Decimal;
        PaymentDate: Date;
        SalespersonCode: Code[20];
        PaymentType: Code[30];
        CustomerName: Code[70];
        ItemDescription: code[70];
        ItemTyp: Code[15];
        CustomerMnt: decimal;
        DocumentT: Code[15]
        )

    var
        lItem: Record Item;
    begin
        MatrixBuf.Init();
        if MatrixBuf.FindLast() then
            MatrixBuf."Entry No." := MatrixBuf."Entry No." + 1
        else
            MatrixBuf."Entry No." := 1;

        if lItem.Get(ItemNo) then;
        MatrixBuf."Item Type" := Format(Itemtyp);
        MatrixBuf."Document No." := CLE."Document No.";
        MatrixBuf."Customer No." := CLE."Customer No.";
        MatrixBuf."Customer Name" := CustomerName;
        MatrixBuf."Salesperson Code" := SalespersonCode;
        MatrixBuf."Posting Date" := CLE."Posting Date";
        MatrixBuf.Validate("Item No.", ItemNo);
        MatrixBuf."Item Description" := ItemDescription;
        MatrixBuf."Sub Category" := lItem.SubCategorie;
        MatrixBuf.Quantity := Qty;
        MatrixBuf."Amount Excl. VAT" := AmountHT;
        MatrixBuf."Amount Incl. VAT" := AmountTTC;
        MatrixBuf."Due Date" := CLE."Due Date";
        MatrixBuf."Payment Amount" := PaymentAmount;
        MatrixBuf."Payment Date" := PaymentDate;
        MatrixBuf."Payment Type" := PaymentType;
        MatrixBuf."Customer Amount" := CustomerMnt;
        MatrixBuf."Document Type" := DocumentT;
        MatrixBuf.Insert();
    end;
}
