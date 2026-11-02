//****************Documentation**********************
//wdc01  WDC.FS  20/06/2025 Add action
//WDC02  WDC.HG  27/08/2025 Update the value of UnpaidInProgress field 
pageextension 50026 "WDC Customer Card" extends "Customer Card"
{
    layout
    {
        modify("No.")
        {
            Editable = CustomerNoIsEditable;
        }
        modify("Shipping Agent Code")
        {
            Visible = false;
        }

        modify("Shipping Agent Service Code")
        {
            Visible = false;
        }
        modify("Balance Due (LCY)")
        {
            Visible = false;
        }

        // modify("Balance (LCY)")
        // {
        //     Visible = false;
        // }
        modify("Balance Due")
        {
            Visible = false;
        }
        modify("CustSalesLCY - CustProfit - AdjmtCostLCY")
        {
            Visible = false;
        }
        modify("Responsibility Center")
        {
            Visible = false;
        }
        modify(Reserve)
        {
            Visible = false;
        }
        modify("Document Sending Profile")
        {
            Visible = false;
        }
        modify(TotalSales2)
        {
            Visible = false;
        }
        modify(AdjCustProfit)
        {
            Visible = false;
        }
        modify("EORI Number")
        {
            Visible = false;
        }
        modify(GLN)
        {
            Visible = false;
        }
        modify("Currency Code")
        {
            Visible = false;
        }
        modify("Prices Including VAT")
        {
            Visible = false;
        }
        modify("Prepayment %")
        {
            Visible = false;
        }

        modify("Application Method")
        {
            Visible = false;
        }
        modify("Partner Type")
        {
            Visible = false;
        }
        modify("Intrastat Partner Type")
        {
            Visible = false;
        }


        modify("Reminder Terms Code")
        {
            Visible = false;
        }
        modify("Fin. Charge Terms Code")
        {
            Visible = false;
        }
        modify("Cash Flow Payment Terms Code")
        {
            Visible = false;
        }
        modify("Print Statements")
        {
            Visible = false;
        }
        modify("Last Statement No.")
        {
            Visible = false;

        }
        modify("Block Payment Tolerance")
        {
            Visible = false;

        }
        modify("Preferred Bank Account Code")
        {
            Visible = false;

        }
        modify("Exclude from Pmt. Practices")
        {
            Visible = false;

        }
        modify("Use GLN in Electronic Document")
        {
            Visible = false;
        }
        modify("Registration Number")
        {
            Visible = false;
        }
        modify("Language Code")
        {
            Visible = false;
        }
        modify("Format Region")
        {
            Visible = false;
        }
        modify("IC Partner Code")
        {
            Visible = false;
        }
        modify(AdjProfitPct)
        {
            Visible = false;
        }
        modify(BalanceAsVendor)
        {
            Visible = false;
        }
        modify("Base Calendar Code")
        {
            Visible = false;
        }
        modify("Customized Calendar")
        {
            Visible = false;
        }
        modify("Privacy Blocked")
        {
            Visible = false;
        }
        modify(Blocked)
        {
            Editable = EditFields;
        }
        modify("Customer Disc. Group")
        {
            Editable = EditFields;
        }
        modify("Customer Price Group")
        {
            Editable = EditFields;
        }
        //<<CHG01
        modify("Payment Method Code")
        {
            Visible = false;
        }
        // modify("Balance (LCY)")
        // {
        //     Visible = false;
        // }
        // addafter("Balance (LCY)")
        // {
        //     field("WDC Balance (LCY)"; Rec."WDC Balance (LCY)")
        //     {
        //         ApplicationArea = all;
        //     }
        // }
        //>>CHG01
        addafter("Shipment Method Code")
        {
            field(ShippingAgentCode; Rec."Shipping Agent Code")
            {
                CaptionML = FRA = 'N° camion';
                ApplicationArea = All;
            }
            field(ShippingAgentServiceCode; Rec."Shipping Agent Service Code")
            {
                CaptionML = FRA = 'Code chauffeur';
                ApplicationArea = All;
            }
        }
        addbefore("Credit Limit (LCY)")
        {
            field(BalanceNotEncashed; BalanceNotEncashed)
            {
                CaptionML = ENU = 'Balance Not Encased', FRA = 'Solde non encaissé';
                ApplicationArea = All;
                Editable = false;
                Style = Strong;
                StyleExpr = StyleTxtBalanceNotEncashed;
            }
        }
        addafter(General)
        {
            group(Detail)
            {
                group(GR01)
                {
                    ShowCaption = false;
                    field(Report; Rec.Report)
                    {
                        ApplicationArea = all;
                        Style = Strong;
                    }
                    field(Debit; Rec.Debit)
                    {
                        CaptionML = ENU = 'Invoiced Shipments', FRA = 'BL Facturés';
                        ApplicationArea = all;
                        Style = Strong;
                    }
                    field("Total Shipment"; Rec."Total Shipment")
                    {
                        CaptionML = ENU = 'Shipments not invoiced', FRA = 'BL non facturés';
                        ApplicationArea = all;
                        Style = Strong;
                    }
                    field(Credit; Rec.Credit)
                    {
                        CaptionML = ENU = 'Payments', FRA = 'Paiements';
                        ApplicationArea = all;
                        Style = StrongAccent;
                    }


                    field(TotalCustomerAmount; TotalCustomerAmount)
                    {
                        CaptionML = ENU = 'Total Customer Amount', FRA = 'Solde client';
                        ApplicationArea = all;
                        Style = Strong;
                        StyleExpr = StyleTxt;
                        Editable = false;
                    }
                }

                group(Gr02)
                {
                    ShowCaption = false;
                    field("Draft Not Due"; Rec."Draft Not Due")
                    {
                        ApplicationArea = all;
                        Style = Attention;
                    }

                    //<<hg
                    // field(UnpaidInProgress; UnpaidInProgress)
                    // {
                    //     CaptionML = ENU = 'Unpaid in progress', FRA = 'Impayés en cours';
                    //     Editable = false;
                    //     ApplicationArea = all;
                    //     Style = StrongAccent;
                    //     //<<WDC02
                    //     trigger OnDrillDown()
                    //     var
                    //         FilteredDetailedCusotmerLedgEntry: record "Detailed Cust. Ledg. Entry";
                    //     begin
                    //         FilteredDetailedCusotmerLedgEntry.reset();
                    //         FilteredDetailedCusotmerLedgEntry.SetFilter("Cust. Ledger Entry No.", LinkedCustomerLedgerEntryNo);
                    //         FilteredDetailedCusotmerLedgEntry.SetRange("Entry Type", FilteredDetailedCusotmerLedgEntry."Entry Type"::"Initial Entry");
                    //         Page.Run(Page::"Detailed Cust. Ledg. Entries", FilteredDetailedCusotmerLedgEntry);
                    //     end;
                    //     //>>WDC02
                    // }
                    field("Unpaid Before GoLive"; Rec."Unpaid Before GoLive")
                    {
                        ApplicationArea = all;
                    }
                    field("Unpaid in progress"; Rec."Unpaid in progress")
                    {
                        ApplicationArea = all;
                    }
                    field("Historics Unpaid"; Rec."Historics Unpaid")
                    {
                        ApplicationArea = all;
                        Style = StrongAccent;
                    }
                    field("Payment In Coffre"; Rec."Payment In Coffre")
                    {
                        ApplicationArea = all;
                    }
                }

            }
            group(Historics)
            {
                CaptionML = ENU = 'Customer Historics', FRA = 'Extrait client';
                part("WDC Cust. Ledger Entry"; "WDC Cust. Ledger Entry")
                {

                    ApplicationArea = Basic, Suite;
                    SubPageLink = "Customer No." = field("No.");
                    UpdatePropagation = Both;
                }
                fixed(FTotal)
                {
                    ShowCaption = false;
                    label(DebitL)
                    {
                        CaptionML = ENU = 'Total Debit ', FRA = 'Total Débit';
                        ApplicationArea = all;
                        Style = StrongAccent;
                    }
                    field("Open Debit"; Rec."Open Debit")
                    {
                        ShowCaption = true;
                        CaptionML = ENU = 'Total Debit ', FRA = 'Total Débit';
                        ApplicationArea = all;
                        Style = StrongAccent;
                    }

                    label(CreditL)
                    {
                        CaptionML = ENU = 'Total Credit', FRA = 'Total Crédit';
                        ApplicationArea = all;
                        Style = StrongAccent;
                    }
                    field("Open Credit"; Rec."Open Credit")
                    {
                        CaptionML = ENU = 'Total Credit', FRA = 'Total Crédit';
                        ApplicationArea = all;
                        Style = StrongAccent;
                    }
                }

            }
            group(ShippedNotInvoiced)
            {
                CaptionML = ENU = 'WDC Sales Shipment Not Inv.', FRA = 'BL non facturées';
                part("WDC Sales Shipment Not Inv."; "WDC Sales Shipment Not Inv.")
                {
                    ApplicationArea = Basic, Suite;
                    SubPageLink = "Sell-to Customer No." = field("No.");
                    UpdatePropagation = Both;
                }
                fixed(TotalShp)
                {
                    label(TotalShipment)
                    {
                        CaptionML = ENU = 'Total Shipment', FRA = 'Total BL';
                        ApplicationArea = all;
                        Style = StrongAccent;
                    }
                    field("Total Shipment_"; Rec."Total Shipment")
                    {
                        CaptionML = ENU = 'Total BL', FRA = 'Total BL';
                        ApplicationArea = all;
                        Style = StrongAccent;
                    }
                }

            }
        }
    }
    //<<wdc01
    actions
    {
        modify("Ledger E&ntries")
        {
            ApplicationArea = All;
            Promoted = true;
            PromotedCategory = Process;
            PromotedIsBig = true;
            PromotedOnly = true;
        }
        addafter(Contact)
        {
            action("Customer Extract")
            {
                CaptionML = ENU = 'Customer Extract', FRA = 'Extrait client';
                ApplicationArea = All;
                Image = Invoice;
                PromotedOnly = true;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    lCustomer: Record Customer;
                begin
                    lCustomer.Reset;
                    lCustomer.SetRange("No.", Rec."No.");
                    Report.RunModal(50013, true, false, lCustomer);
                end;

            }

            action("Customer Posted Shipments")
            {
                CaptionML = ENU = 'Customer Posted Shipments', FRA = 'Expéditions clients enregistrées';
                ApplicationArea = All;
                Image = SalesShipment;
                PromotedOnly = true;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = page "Posted Sales Shipments";
                RunPageLink = "Sell-to Customer No." = field("No.");
                RunPageView = sorting("Posting Date") order(descending);
            }
            action("Customer Posted Invoices")
            {
                CaptionML = ENU = 'Customer Posted Invoices', FRA = 'Factures clients enregistrées';
                ApplicationArea = All;
                Image = Documents;
                PromotedOnly = true;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = page "Posted Sales Invoices";
                RunPageLink = "Sell-to Customer No." = field("No.");
                RunPageView = sorting("Posting Date") order(descending);
            }
            action("Customer Posted Payments")
            {
                CaptionML = ENU = 'Customer Posted Payments', FRA = 'Paiements clients enregistrés';
                ApplicationArea = All;
                Image = Payment;
                PromotedOnly = true;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = page "WDC Customers Payments";
                RunPageLink = "Customer No." = field("No.");
                RunPageView = sorting("Posting Date") order(descending);

            }
        }

    }
    trigger OnOpenPage()
    var
        UserSetup: Record "User Setup";
        GLSetup: record "General Ledger Setup";
    begin
        GLSetup.get;
        UserSetup.Get(UserId);
        CustomerNoIsEditable := true;
        If Rec."No." <> '' then
            CustomerNoIsEditable := UserSetup."Allow Rename Customer";
        EditFields := UserSetup."Allow Modify Customer";
        Rec.SetFilter("Start Year Filter", '..%1', GLSetup."Go Live Date");
        rec.SetFilter("Start Date Filter", '%1..', GLSetup."Go Live Date" + 1);//WDC.CHG
        rec.SetFilter("Due Date Filter", '%1..', WorkDate);
    end;

    trigger OnAfterGetRecord()
    var
        UserSetup: Record "User Setup";
        lCustLedgEntr: Record "Cust. Ledger Entry";
        lDetailedCustLedgEntry: record "Detailed Cust. Ledg. Entry";
        GLSetup: record "General Ledger Setup";
    begin
        UnpaidInProgress := 0;
        LinkedCustomerLedgerEntryNo := '';
        // //<<WDC02
        // lDetailedCustLedgEntry.Reset();
        // lDetailedCustLedgEntry.SetCurrentKey("Document Type", "Customer No.", "Posting Date", "Currency Code");
        // lDetailedCustLedgEntry.SetRange("Customer No.", Rec."No.");
        // lDetailedCustLedgEntry.SetRange("Document Type", lDetailedCustLedgEntry."Document Type"::" ");
        // lDetailedCustLedgEntry.SetFilter("Payment Slip Type", '%1|%2', lDetailedCustLedgEntry."Payment Slip Type"::Draft, lDetailedCustLedgEntry."Payment Slip Type"::Cheque);
        // lDetailedCustLedgEntry.SetRange("Entry Type", lDetailedCustLedgEntry."Entry Type"::"Initial Entry");
        // lDetailedCustLedgEntry.SetFilter("Applied Cust. Ledger Entry No.", '%1', 0);
        // if lDetailedCustLedgEntry.FindSet() then
        //     repeat
        //         if lCustLedgEntr.get(lDetailedCustLedgEntry."Cust. Ledger Entry No.") then begin
        //             lCustLedgEntr.CalcFields("Remaining Amt. (LCY)");
        //             if lCustLedgEntr."Remaining Amt. (LCY)" <> 0 then begin
        //                 if LinkedCustomerLedgerEntryNo = '' then
        //                     LinkedCustomerLedgerEntryNo := Format(lCustLedgEntr."Entry No.")
        //                 else
        //                     LinkedCustomerLedgerEntryNo := LinkedCustomerLedgerEntryNo + '|' + Format(lCustLedgEntr."Entry No.");
        //                 UnpaidInProgress += lCustLedgEntr."Remaining Amt. (LCY)";
        //             end;

        //         end
        //     until lDetailedCustLedgEntry.Next() = 0;
        // //>>WDC02

        // CalcAndGetUnpaidEntries();
        UserSetup.Get(UserId);
        if not UserSetup."Allow Modify Customer" then
            CurrPage.Editable(false);
        // Rec.CalcFields("Balance (LCY) Amount", "Total Shipment");//Remplacer Balance (LCY)par Balance (LCY)amount wdc.CHG 26/02/2026 demande de filtrer solde client a parir de 01/07/2025
        //TotalCustomerAmount := Rec."Balance (LCY) Amount" + (Rec."Total Shipment");
        Rec.CalcFields("Balance (LCY)", "Total Shipment");
        TotalCustomerAmount := Rec."Balance (LCY)" + (Rec."Total Shipment");

        Rec.CalcFields("Draft Not Due");
        BalanceNotEncashed := TotalCustomerAmount + Rec."Draft Not Due";
        StyleTxt := Color(); //WDC01
        StyleTxtBalanceNotEncashed := ColorBalanceNotEncashed();
    end;

    procedure Color(): text[50]
    begin
        if TotalCustomerAmount > 0 then
            exit('unfavorable')
        else
            exit('favorable');

    end;

    procedure ColorBalanceNotEncashed(): text[50]
    begin
        if BalanceNotEncashed > 0 then
            exit('unfavorable')
        else
            exit('favorable');

    end;

    procedure CalcAndGetUnpaidEntries()
    var
        UserSetup: Record "User Setup";
        lCustLedgEntr: Record "Cust. Ledger Entry";
        lDetailedCustLedgEntry: record "Detailed Cust. Ledg. Entry";
        GLSetup: record "General Ledger Setup";
    begin
        UnpaidInProgress := 0;
        LinkedCustomerLedgerEntryNo := '';
        //<<WDC02
        lDetailedCustLedgEntry.Reset();
        lDetailedCustLedgEntry.SetCurrentKey("Document Type", "Customer No.", "Posting Date", "Currency Code");
        lDetailedCustLedgEntry.SetRange("Customer No.", Rec."No.");
        lDetailedCustLedgEntry.SetRange("Document Type", lDetailedCustLedgEntry."Document Type"::" ");
        lDetailedCustLedgEntry.SetFilter("Payment Slip Type", '%1|%2', lDetailedCustLedgEntry."Payment Slip Type"::Draft, lDetailedCustLedgEntry."Payment Slip Type"::Cheque);
        lDetailedCustLedgEntry.SetRange("Entry Type", lDetailedCustLedgEntry."Entry Type"::"Initial Entry");
        lDetailedCustLedgEntry.setrange(Unpaid, true);
        lDetailedCustLedgEntry.Setrange("Unpaid is Encaissed", false);
        if lDetailedCustLedgEntry.FindSet() then
            repeat
                if lCustLedgEntr.get(lDetailedCustLedgEntry."Cust. Ledger Entry No.") then begin
                    lCustLedgEntr.CalcFields("Amount (LCY)");
                    if LinkedCustomerLedgerEntryNo = '' then
                        LinkedCustomerLedgerEntryNo := Format(lCustLedgEntr."Entry No.")
                    else
                        LinkedCustomerLedgerEntryNo := LinkedCustomerLedgerEntryNo + '|' + Format(lCustLedgEntr."Entry No.");
                    UnpaidInProgress += Abs(lCustLedgEntr."Amount (LCY)");
                end;
            until lDetailedCustLedgEntry.Next() = 0;
    end;

    var
        TotalCustomerAmount: Decimal;
        StyleTxtBalanceNotEncashed: Text[50];
        BalanceNotEncashed: Decimal;
        StyleTxt: Text[50];
        EditFields: Boolean;
        UnpaidInProgress: Decimal;
        LinkedCustomerLedgerEntryNo: Text;
        CustomerNoIsEditable: Boolean;
}