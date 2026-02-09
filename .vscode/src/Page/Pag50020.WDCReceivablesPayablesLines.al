

page 50020 "WDC Receivables-Payables Lines"
{
    ApplicationArea = all;
    CaptionML = ENU = 'Lines', FRA = 'Lignes';
    LinksAllowed = false;
    PageType = ListPart;
    SourceTable = "Receivables-Payables Buffer";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                Editable = false;
                ShowCaption = false;
                field("Period Start"; Rec."Period Start")
                {
                    ApplicationArea = Suite;
                    CaptionML = ENU = 'Period Start', FRA = 'Début de la période';
                    ToolTip = 'Specifies the beginning of the period covered by the summary report of receivables for customers and payables for vendors.';
                }
                field("Period Name"; Rec."Period Name")
                {
                    ApplicationArea = Suite;
                    CaptionML = ENU = 'Period Name', FRA = 'Nom de la période';
                    ToolTip = 'Specifies the name of the period covered by the summary report of receivables for customers and payables for vendors.';
                }
                field(CustBalancesDue; Rec."Cust. Balances Due")
                {
                    ApplicationArea = Suite;
                    AutoFormatType = 1;
                    CaptionML = ENU = 'Cust. Balances Due', FRA = 'Encaissement prévu';
                    DrillDown = true;
                    ToolTip = 'Specifies the total amount your company is owed by customers. The program automatically calculates and updates the contents of the field, using entries in the Remaining Amt. (LCY) field in the Cust. Ledger Entry table.';

                    trigger OnDrillDown()
                    begin
                        ShowCustEntriesDue();
                    end;
                }
                field(VendorBalancesDue; Rec."Vendor Balances Due")
                {
                    ApplicationArea = Suite;
                    AutoFormatType = 1;
                    CaptionML = ENU = 'Vendor Balances Due', FRA = 'Engagement fournisseur';
                    DrillDown = true;
                    ToolTip = 'Specifies the total amount your company owes its vendors. The program automatically calculates and updates the contents of the field, using entries in the Remaining Amt. (LCY) field in the Vendor Ledger Entry table.';

                    trigger OnDrillDown()
                    begin
                        ShowVendEntriesDue();
                    end;
                }
                field(Confirmed; BalanceConfirmed)
                {
                    ApplicationArea = Suite;
                    AutoFormatType = 1;
                    CaptionML = ENU = 'Confirmed Draft', FRA = 'Traite confirmée';
                    ToolTip = 'Specific draft confirmed not posted in GL';
                    trigger OnDrillDown()
                    begin
                        ShowConfirmed();
                    end;
                }
                field(CumulEngage; TotalEngagement)
                {
                    ApplicationArea = Suite;
                    AutoFormatType = 1;
                    CaptionML = ENU = 'Total Engagement', FRA = 'Total engagement';
                    ToolTip = 'Total des engagments';
                }

                field(ReceivablesPayables; Rec."Receivables-Payables")
                {
                    ApplicationArea = Suite;
                    AutoFormatType = 1;
                    CaptionML = ENU = 'Receivables-Payables', FRA = 'Encaissement-Décaissement';
                    ToolTip = 'Specifies expected payments from customers and to vendors. It does not include other transactions that affect liquidity or the liquid balance at the beginning of the period. Therefore, the amounts in the column do not represent the liquid balance at the close of the period.';
                }

            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Imprimer)
            {
                ApplicationArea = Suite;
                CaptionML = ENU = 'Print', FRA = 'Imprimer';
                Image = Print;
                trigger OnAction()
                var
                begin
                    REPORT.RUNMODAL(50034);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        if DateRec.Get(Rec."Period Type", Rec."Period Start") then;
        CalcLine();
    end;

    trigger OnFindRecord(Which: Text) FoundDate: Boolean
    var
        VariantRec: Variant;
    begin
        VariantRec := Rec;
        FoundDate := PeriodFormLinesMgt.FindDate(VariantRec, DateRec, Which, PeriodType.AsInteger());
        Rec := VariantRec;
    end;

    trigger OnNextRecord(Steps: Integer) ResultSteps: Integer
    var
        VariantRec: Variant;
    begin
        VariantRec := Rec;
        ResultSteps := PeriodFormLinesMgt.NextDate(VariantRec, DateRec, Steps, PeriodType.AsInteger());
        Rec := VariantRec;
    end;

    trigger OnOpenPage()
    begin
        Rec.Reset();
        Rec.SetFilter("Period Start", '>=%1', 20250701D);
    end;

    var
        CustLedgEntry: Record "Cust. Ledger Entry";
        VendLedgEntry: Record "Vendor Ledger Entry";
        DateRec: Record Date;
        PeriodFormLinesMgt: Codeunit "Period Form Lines Mgt.";
        PeriodType: Enum "Analysis Period Type";
        AmountType: Enum "Analysis Amount Type";
        VendorNo: Code[20];

    protected var
        GLSetup: Record "General Ledger Setup";

    procedure SetLines(var NewGLSetup: Record "General Ledger Setup"; NewPeriodType: Enum "Analysis Period Type"; NewAmountType: Enum "Analysis Amount Type"; pVendorNo: Code[20])
    begin
        GLSetup.Copy(NewGLSetup);
        Rec.DeleteAll();
        PeriodType := NewPeriodType;
        AmountType := NewAmountType;
        VendorNo := pVendorNo;
        CurrPage.Update(false);
    end;

    local procedure ShowCustEntriesDue()
    begin
        SetDateFilter();
        CustLedgEntry.Reset();
        CustLedgEntry.SetFilter("Remaining Amt. (LCY)", '<%1', 0);
        CustLedgEntry.SetFilter("Document type", '<>%1', CustLedgEntry."Document type"::"Credit Memo");
        CustLedgEntry.SetFilter("Due Date", '>=%1', WorkDate());
        CustLedgEntry.SetFilter("Due Date", GLSetup.GetFilter("Date Filter"));
        CustLedgEntry.SetFilter("Global Dimension 1 Code", GLSetup.GetFilter("Global Dimension 1 Filter"));
        CustLedgEntry.SetFilter("Global Dimension 2 Code", GLSetup.GetFilter("Global Dimension 2 Filter"));
        PAGE.Run(0, CustLedgEntry)
    end;

    local procedure ShowConfirmed()
    begin
        SetDateFilter();
        clear(PaymentLine);
        PaymentLine.SetCurrentKey("No.", "Account No.", "Bank Branch No.", "Agency Code", "Bank Account No.", "Payment Address Code");
        PaymentLine.SetRange("Status Name", 'CONFIRMEE');
        PaymentLine.setrange("Payment Class", 'DECAISSEMENT EFFET');
        PaymentLine.setrange("Account Type", PaymentLine."Account Type"::Vendor);
        if VendorNo <> '' then //HD14122025 
            PaymentLine.SetFilter("Account No.", '%1', VendorNo);
        PaymentLine.SetFilter("Due Date", '>=%1', WorkDate());
        PaymentLine.SetFilter("Due Date", GLSetup.GetFilter("Date Filter"));
        PAGE.Run(0, PaymentLine);
    end;

    local procedure ShowVendEntriesDue()
    begin
        SetDateFilter();
        VendLedgEntry.Reset();
        VendLedgEntry.SetCurrentKey("Vendor No.", "Posting Date", "Currency Code");
        if VendorNo <> '' then //HD14122025 
            VendLedgEntry.SetFilter("Vendor No.", '%1', VendorNo);
        VendLedgEntry.SetFilter("Amount (LCY)", '>%1', 0);
        VendLedgEntry.SetRange("Payment Slip Type", VendLedgEntry."Payment Slip Type"::Draft);////HD210725 With HJ
        VendLedgEntry.SetFilter("Due Date", '>=%1', WorkDate());
        VendLedgEntry.SetFilter("Due Date", GLSetup.GetFilter("Date Filter"));
        VendLedgEntry.SetFilter("Global Dimension 1 Code", GLSetup.GetFilter("Global Dimension 1 Filter"));
        VendLedgEntry.SetFilter("Global Dimension 2 Code", GLSetup.GetFilter("Global Dimension 2 Filter"));
        PAGE.Run(0, VendLedgEntry);
    end;

    local procedure SetDateFilter()
    begin
        if AmountType = AmountType::"Net Change" then
            GLSetup.SetRange("Date Filter", Rec."Period Start", Rec."Period End") //
        else
            GLSetup.SetRange("Date Filter", 0D, Rec."Period End");
    end;

    local procedure CalcLine()
    begin
        SetDateFilter();
        //New filter to vendor ledger entries       
        Balance := 0;
        VendLedgEntry.Reset();
        VendLedgEntry.SetCurrentKey("Vendor No.", "Posting Date", "Currency Code");
        if VendorNo <> '' then //HD14122025 
            VendLedgEntry.SetFilter("Vendor No.", '%1', VendorNo);
        VendLedgEntry.SetFilter("Amount (LCY)", '>%1', 0);
        VendLedgEntry.SetRange("Payment Slip Type", VendLedgEntry."Payment Slip Type"::Draft);////HD210725 With HJ
        VendLedgEntry.SetFilter("Due Date", '>=%1', WorkDate());
        VendLedgEntry.SetFilter("Due Date", GLSetup.GetFilter("Date Filter"));
        VendLedgEntry.SetFilter("Global Dimension 1 Code", GLSetup.GetFilter("Global Dimension 1 Filter"));
        VendLedgEntry.SetFilter("Global Dimension 2 Code", GLSetup.GetFilter("Global Dimension 2 Filter"));
        if VendLedgEntry.FindSet() then
            repeat
                VendLedgEntry.CalcFields("Amount (LCY)");
                Balance := Balance + VendLedgEntry."Amount (LCY)"
            until VendLedgEntry.next = 0;
        //New filter to vendor ledger entries 
        //New Customer
        Balancecli := 0;
        CustLedgEntry.Reset();
        CustLedgEntry.SetFilter("Remaining Amt. (LCY)", '<%1', 0);
        CustLedgEntry.SetFilter("Due Date", '>=%1', WorkDate());
        CustLedgEntry.SetFilter("Document type", '<>%1', CustLedgEntry."Document type"::"Credit Memo");
        CustLedgEntry.SetFilter("Due Date", GLSetup.GetFilter("Date Filter"));
        CustLedgEntry.SetFilter("Global Dimension 1 Code", GLSetup.GetFilter("Global Dimension 1 Filter"));
        CustLedgEntry.SetFilter("Global Dimension 2 Code", GLSetup.GetFilter("Global Dimension 2 Filter"));
        if CustLedgEntry.FindSet() then
            repeat
                CustLedgEntry.CalcFields("Remaining Amt. (LCY)");
                Balancecli := Balancecli + CustLedgEntry."Remaining Amt. (LCY)";
            until CustLedgEntry.next = 0;
        GLSetup.CalcFields("Cust. Balances Due", "Vendor Balances Due");
        //>>Begin Draft confirmed
        clear(BalanceConfirmed);
        clear(PaymentLine);
        PaymentLine.SetCurrentKey("No.", "Account No.", "Bank Branch No.", "Agency Code", "Bank Account No.", "Payment Address Code");
        PaymentLine.SetRange("Status Name", 'CONFIRMEE');
        PaymentLine.setrange("Payment Class", 'DECAISSEMENT EFFET');
        PaymentLine.setrange("Account Type", PaymentLine."Account Type"::Vendor);
        if VendorNo <> '' then //HD14122025 
            PaymentLine.SetFilter("Account No.", '%1', VendorNo);
        PaymentLine.SetFilter("Due Date", '>=%1', WorkDate());
        PaymentLine.SetFilter("Due Date", GLSetup.GetFilter("Date Filter"));
        IF PaymentLine.FINDSET THEN
            repeat
                BalanceConfirmed += PaymentLine."Amount (LCY)";
            UNTIL PaymentLine.NEXT = 0;
        //>>End Draft confirmed
        TotalEngagement := 0;
        BalanceConfirmed := Abs(BalanceConfirmed);
        TotalEngagement := BalanceConfirmed + Balance;
        Rec."Cust. Balances Due" := abs(Balancecli);
        Rec."Vendor Balances Due" := Balance;//GLSetup."Vendor Balances Due";
        Rec."Receivables-Payables" := abs(Balancecli) - TotalEngagement;
        OnAfterCalcLine(GLSetup, Rec);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCalcLine(var GLSetup: Record "General Ledger Setup"; var ReceivablesPayablesBuffer: Record "Receivables-Payables Buffer")
    begin
    end;

    var
        Balance: Decimal;
        Balancecli: Decimal;
        TraiteConfirme: Code[20];
        PaymentLine: Record "WDC-ED Payment Line";
        BalanceConfirmed: Decimal;
        CumulEngage: Decimal;
        TotalEngagement: Decimal;
}

