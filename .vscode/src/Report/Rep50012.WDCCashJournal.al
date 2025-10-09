namespace CRC.CRC;

using Microsoft.Sales.History;
using Microsoft.Sales.Receivables;
using Microsoft.Sales.Document;
using Microsoft.Sales.Customer;
using System.Utilities;

report 50012 "WDC Cash Journal"
{
    DefaultLayout = RDLC;
    RDLCLayout = './.vscode/src/Report/RDLC/CashJournal.rdl';
    ApplicationArea = All;
    CaptionML = ENU = 'Cash Journal', FRA = 'Journal de caisse';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Sales Shipment Line"; "Sales Shipment Line")
        {
            DataItemTableView = SORTING("Document No.", "Line No.")
                                    ORDER(Ascending)
                                    where("Qty. Shipped Not Invoiced" = filter(<> 0));

            column(COMPANYNAME; COMPANYNAME)
            {

            }
            column(StartingDate; StartingDate)
            {

            }
            column(EndingDate; EndingDate)
            {

            }
            column(DocumentNo_SalesShipmentLine; "Sales Shipment Line"."Document No.")
            {

            }
            column(CustomerNo_SalesShipmentLine; "Sell-to Customer No.")
            {

            }
            column(PostingDate_SalesShipmentLine; "Posting Date")
            {

            }
            column(ShipCustName; ShipCustName)
            {

            }
            column(ShipAmount; ShipAmount)
            {

            }
            column(Type_Doc; Type_Doc)
            {

            }
            column(ToDisplay; ToDisplay)
            {

            }

            trigger OnPreDataItem()
            begin
                if (StartingDate = 0D) or (EndingDate = 0D) then
                    Error('Les dates début et fin ne doivent pas être vide!');
                if EndingDate < StartingDate then
                    Error('Date fin ne doit pas être antérieur à la date début !');

                "Sales Shipment Line".SetFilter("Posting Date", '%1..%2', StartingDate, EndingDate);

                Type_Doc := 'BL NON FACTURE';
                ToDisplay := 0;
                TotalBL := 0;
            end;

            trigger OnAfterGetRecord()
            var
                lCustomer: Record Customer;
                lSalesLine: Record "Sales Line";
            begin
                Clear(lCustomer);
                ShipAmount := 0;

                lCustomer.get("Sales Shipment Line"."Sell-to Customer No.");
                ShipCustName := lCustomer.Name;

                If "Item Charge Base Amount" <> 0 then
                    ShipAmount := "Item Charge Base Amount" * (1 + ("Sales Shipment Line"."VAT %" / 100))
                else If lSalesLine.GET(lSalesLine."Document Type"::Order, "Sales Shipment Line"."Order No.", "Sales Shipment Line"."Order Line No.") then
                    ShipAmount := ("Sales Shipment Line".Quantity * lSalesLine."Unit Price") * (1 - "Line Discount %" / 100)
                    * (1 + ("Sales Shipment Line"."VAT %" / 100));
                //ShipAmount := ("Qty. Shipped Not Invoiced" * lSalesLine."Unit Price") * (100 - "Line Discount %");
                if ShipAmount <> 0 then
                    ToDisplay += 1;

                TotalBL += ShipAmount;
            end;
        }

        dataitem("Return Receipt Line"; "Return Receipt Line")
        {
            DataItemTableView = SORTING("Document No.", "Line No.")
                                    ORDER(Ascending)
                                    where("Return Qty. Rcd. Not Invd." = filter(<> 0));

            column(DocumentNo_ReturnReceiptLine; "Return Receipt Line"."Document No.")
            {

            }
            column(CustomerNo_ReturnReceiptLine; "Sell-to Customer No.")
            {

            }
            column(PostingDate_ReturnReceiptLine; "Posting Date")
            {

            }
            column(ShipCustName2; ShipCustName)
            {

            }
            column(ShipAmount2; ShipAmount)
            {

            }
            column(Type_Doc6; Type_Doc)
            {

            }

            trigger OnPreDataItem()
            begin

                "Return Receipt Line".SetFilter("Posting Date", '%1..%2', StartingDate, EndingDate);

                Type_Doc := 'RETOUR NON FACTURE';
                ToDisplay := 0;
                TotalBL := 0;
            end;

            trigger OnAfterGetRecord()
            var
                lCustomer: Record Customer;
                lSalesLine: Record "Sales Line";
            begin
                Clear(lCustomer);
                ShipAmount := 0;

                lCustomer.get("Return Receipt Line"."Sell-to Customer No.");
                ShipCustName := lCustomer.Name;

                If "Item Charge Base Amount" <> 0 then
                    ShipAmount := "Item Charge Base Amount"
                else
                    ShipAmount := ("Return Qty. Rcd. Not Invd." * "Return Receipt Line"."Unit Price") * (100 - "Return Receipt Line"."Line Discount %");

                if ShipAmount <> 0 then
                    ToDisplay += 1;

                TotalBL -= ShipAmount;
            end;
        }
        dataitem(Factures; "Cust. Ledger Entry")
        {
            DataItemTableView = SORTING("Document Type", "Customer No.", "Posting Date", "Currency Code")
                                    ORDER(Ascending)
                                    where("Document Type" = filter(Invoice));

            column(Factures_PostingDate; Factures."Posting Date")
            {

            }
            column(Factures_DocumentType; Factures."Document Type")
            {

            }
            column(Factures_DocumentNo; Factures."Document No.")
            {

            }
            column(Factures_CustomerNo; Factures."Sell-to Customer No.")
            {

            }
            column(Factures_CustomerName; ShipCustName)
            {

            }
            column(Factures_AmountLCY; Factures."Amount (LCY)")
            {

            }
            column(Espece; Espece)
            {

            }
            column(Cheque; Cheque)
            {

            }
            column(RS; RS)
            {

            }
            Column(Traite; Traite)
            {

            }
            column(Virement; virement)
            {

            }
            column(Type_Doc2; Type_Doc)
            {

            }

            trigger OnPreDataItem()
            begin
                Factures.SetFilter("Posting Date", '%1..%2', StartingDate, EndingDate);

                Type_Doc := 'FACTURES';
                ToDisplay := 0;
                //TotalBL := 0;
            end;

            trigger OnAfterGetRecord()
            var
                lSalesInvHeader: Record "Sales Invoice Header";
                lDetailedCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
            begin

                clear(ShipCustName);
                if lSalesInvHeader.get(Factures."Document No.") then
                    ShipCustName := lSalesInvHeader."Sell-to Customer Name"
                else
                    ShipCustName := Factures."Customer Name";

                Espece := 0;
                Clear(lDetailedCustLedgEntry);
                lDetailedCustLedgEntry.SetCurrentKey("Cust. Ledger Entry No.", "Entry Type", "Posting Date");
                lDetailedCustLedgEntry.SetRange("Cust. Ledger Entry No.", Factures."Entry No.");
                lDetailedCustLedgEntry.SetRange("Entry Type", lDetailedCustLedgEntry."Entry Type"::Application);
                lDetailedCustLedgEntry.SetFilter("Posting Date", '%1..%2', StartingDate, EndingDate);
                lDetailedCustLedgEntry.SetRange("Payment Slip Type", "Payment Slip Type"::Cash);
                if lDetailedCustLedgEntry.FindSet() then
                    repeat
                        Espece += lDetailedCustLedgEntry."Amount (LCY)" * (-1);
                        Total_Espece += lDetailedCustLedgEntry."Amount (LCY)" * (-1);
                        InsertTempCustLedgerEntries(lDetailedCustLedgEntry."Applied Cust. Ledger Entry No.");
                    until lDetailedCustLedgEntry.Next() = 0;

                Cheque := 0;
                Clear(lDetailedCustLedgEntry);
                lDetailedCustLedgEntry.SetCurrentKey("Cust. Ledger Entry No.", "Entry Type", "Posting Date");
                lDetailedCustLedgEntry.SetRange("Cust. Ledger Entry No.", Factures."Entry No.");
                lDetailedCustLedgEntry.SetRange("Entry Type", lDetailedCustLedgEntry."Entry Type"::Application);
                lDetailedCustLedgEntry.SetFilter("Posting Date", '%1..%2', StartingDate, EndingDate);
                lDetailedCustLedgEntry.SetRange("Payment Slip Type", "Payment Slip Type"::Cheque);
                if lDetailedCustLedgEntry.FindSet() then
                    repeat
                        Cheque += lDetailedCustLedgEntry."Amount (LCY)" * (-1);
                        Total_Cheque += lDetailedCustLedgEntry."Amount (LCY)" * (-1);
                        InsertTempCustLedgerEntries(lDetailedCustLedgEntry."Applied Cust. Ledger Entry No.");
                    until lDetailedCustLedgEntry.Next() = 0;

                Traite := 0;
                Clear(lDetailedCustLedgEntry);
                lDetailedCustLedgEntry.SetCurrentKey("Cust. Ledger Entry No.", "Entry Type", "Posting Date");
                lDetailedCustLedgEntry.SetRange("Cust. Ledger Entry No.", Factures."Entry No.");
                lDetailedCustLedgEntry.SetRange("Entry Type", lDetailedCustLedgEntry."Entry Type"::Application);
                lDetailedCustLedgEntry.SetFilter("Posting Date", '%1..%2', StartingDate, EndingDate);
                lDetailedCustLedgEntry.SetRange("Payment Slip Type", "Payment Slip Type"::Draft);
                if lDetailedCustLedgEntry.FindSet() then
                    repeat
                        Traite += lDetailedCustLedgEntry."Amount (LCY)" * (-1);
                        Total_Traite += lDetailedCustLedgEntry."Amount (LCY)" * (-1);
                        InsertTempCustLedgerEntries(lDetailedCustLedgEntry."Applied Cust. Ledger Entry No.");
                    until lDetailedCustLedgEntry.Next() = 0;

                RS := 0;
                Clear(lDetailedCustLedgEntry);
                lDetailedCustLedgEntry.SetCurrentKey("Cust. Ledger Entry No.", "Entry Type", "Posting Date");
                lDetailedCustLedgEntry.SetRange("Cust. Ledger Entry No.", Factures."Entry No.");
                lDetailedCustLedgEntry.SetRange("Entry Type", lDetailedCustLedgEntry."Entry Type"::Application);
                lDetailedCustLedgEntry.SetFilter("Posting Date", '%1..%2', StartingDate, EndingDate);
                lDetailedCustLedgEntry.SetRange("Payment Slip Type", "Payment Slip Type"::RS);
                if lDetailedCustLedgEntry.FindSet() then
                    repeat
                        RS += lDetailedCustLedgEntry."Amount (LCY)" * (-1);
                        Total_RS += lDetailedCustLedgEntry."Amount (LCY)" * (-1);
                        InsertTempCustLedgerEntries(lDetailedCustLedgEntry."Applied Cust. Ledger Entry No.");
                    until lDetailedCustLedgEntry.Next() = 0;

                Virement := 0;
                Clear(lDetailedCustLedgEntry);
                lDetailedCustLedgEntry.SetCurrentKey("Cust. Ledger Entry No.", "Entry Type", "Posting Date");
                lDetailedCustLedgEntry.SetRange("Cust. Ledger Entry No.", Factures."Entry No.");
                lDetailedCustLedgEntry.SetRange("Entry Type", lDetailedCustLedgEntry."Entry Type"::Application);
                lDetailedCustLedgEntry.SetFilter("Posting Date", '%1..%2', StartingDate, EndingDate);
                lDetailedCustLedgEntry.SetRange("Payment Slip Type", "Payment Slip Type"::Transfer);
                if lDetailedCustLedgEntry.FindSet() then
                    repeat
                        Virement += lDetailedCustLedgEntry."Amount (LCY)" * (-1);
                        Total_Virement += lDetailedCustLedgEntry."Amount (LCY)" * (-1);
                        InsertTempCustLedgerEntries(lDetailedCustLedgEntry."Applied Cust. Ledger Entry No.");
                    until lDetailedCustLedgEntry.Next() = 0;
            end;
        }

        dataitem(Avoir; "Cust. Ledger Entry")
        {
            DataItemTableView = SORTING("Document Type", "Customer No.", "Posting Date", "Currency Code")
                                    ORDER(Ascending)
                                    where("Document Type" = filter("credit memo"));

            column(Avoir_PostingDate; Avoir."Posting Date")
            {

            }
            column(Avoir_DocumentType; Avoir."Document Type")
            {

            }
            column(Avoir_DocumentNo; Avoir."Document No.")
            {

            }
            column(Avoir_CustomerNo; Avoir."Sell-to Customer No.")
            {

            }
            column(Avoir_CustomerName; ShipCustName)
            {

            }
            column(Avoir_AmountLCY; Avoir_Montant)
            {

            }

            column(Type_Doc3; Type_Doc)
            {

            }

            trigger OnPreDataItem()
            begin
                Avoir.SetFilter("Posting Date", '%1..%2', StartingDate, EndingDate);

                Type_Doc := 'AVOIR';
                ToDisplay := 0;
                //TotalBL := 0;
            end;

            trigger OnAfterGetRecord()
            var
                lSalesCrHeader: Record "Sales Cr.Memo Header";
            begin
                Avoir_Montant := 0;
                Avoir.CalcFields("Amount (LCY)");
                Avoir_Montant := Avoir."Amount (LCY)" * (-1);

                clear(ShipCustName);
                if lSalesCrHeader.get(Avoir."Document No.") then
                    ShipCustName := lSalesCrHeader."Sell-to Customer Name"
                else
                    ShipCustName := Avoir."Customer Name";
            end;

        }

        dataitem(Paiement; "Cust. Ledger Entry")
        {
            DataItemTableView = SORTING("Document Type", "Customer No.", "Posting Date", "Currency Code")
                                    ORDER(Ascending)
                                    where("Document Type" = filter(payment | ''));
            //, "Payment Method Code"=filter(<>'RS'));

            column(Paiement_PostingDate; Paiement."Posting Date")
            {

            }
            column(Paiement_DocumentType; Paiement."Document Type")
            {

            }
            column(Paiement_DocumentNo; Paiement."Document No.")
            {

            }
            column(Paiement_CustomerNo; Paiement."Sell-to Customer No.")
            {

            }
            column(Paiement_CustomerName; Paiement."Customer Name")
            {

            }
            column(Paiement_AmountLCY; Paiement."Amount (LCY)")
            {

            }
            column(Paiement_Espece; Paiement_Espece)
            {

            }
            column(Paiement_Cheque; Paiement_Cheque)
            {

            }
            column(Paiement_RS; Paiement_RS)
            {

            }
            Column(Paiement_Traite; Paiement_Traite)
            {

            }
            column(Paiement_Virement; Paiement_virement)
            {

            }
            column(NRecu; NRecu)
            {

            }
            column(Document_No_; "Document No.")
            {

            }
            column(Type_Doc4; Type_Doc)
            {

            }

            trigger OnPreDataItem()
            begin
                Paiement.SetFilter("Posting Date", '%1..%2', StartingDate, EndingDate);

                Type_Doc := 'PAIEMENT';
                ToDisplay := 0;
                //TotalBL := 0;
            end;

            trigger OnAfterGetRecord()
            var
                lCustLedgerEntry: Record "Cust. Ledger Entry";
                lDetailedCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
            begin
                if TempCustLedgerEntries.get(Paiement."Entry No.") then
                    CurrReport.Skip();

                if IsCanceled(Paiement."Entry No.", Paiement."Document No.") then
                    CurrReport.Skip();

                clear(NRecu);
                Paiement_Espece := 0;
                Paiement_Cheque := 0;
                Paiement_Traite := 0;
                Paiement_RS := 0;
                Paiement_Virement := 0;

                //récupération du N° facture
                Clear(lDetailedCustLedgEntry);
                lDetailedCustLedgEntry.SetCurrentKey("Applied Cust. Ledger Entry No.", "Entry Type");
                lDetailedCustLedgEntry.SetRange("Applied Cust. Ledger Entry No.", Paiement."Entry No.");
                lDetailedCustLedgEntry.SetRange("Entry Type", lDetailedCustLedgEntry."Entry Type"::Application);
                lDetailedCustLedgEntry.SetRange("Initial Document Type", lDetailedCustLedgEntry."Initial Document Type"::invoice);
                if lDetailedCustLedgEntry.FindFirst() then
                    repeat
                        Clear(lCustLedgerEntry);
                        if lCustLedgerEntry.get(lDetailedCustLedgEntry."Cust. Ledger Entry No.") then begin
                            if StrPos(NRecu, lCustLedgerEntry."Document No.") = 0 then begin
                                if NRecu <> '' then
                                    NRecu += '|';
                                NRecu += lCustLedgerEntry."Document No.";
                            end;
                        end;
                    until lDetailedCustLedgEntry.Next() = 0;

                //Réglement sans facture
                if NRecu = '' then begin

                    Clear(lDetailedCustLedgEntry);
                    lDetailedCustLedgEntry.SetCurrentKey("Applied Cust. Ledger Entry No.", "Entry Type");
                    lDetailedCustLedgEntry.SetRange("Applied Cust. Ledger Entry No.", Paiement."Entry No.");
                    lDetailedCustLedgEntry.SetRange("Entry Type", lDetailedCustLedgEntry."Entry Type"::Application);
                    lDetailedCustLedgEntry.SetFilter("Initial Document Type", '<>%1', lDetailedCustLedgEntry."Initial Document Type"::invoice);
                    if lDetailedCustLedgEntry.FindFirst() then
                        repeat
                            Clear(lCustLedgerEntry);
                            if lCustLedgerEntry.get(lDetailedCustLedgEntry."Cust. Ledger Entry No.") then begin
                                // if lCustLedgerEntry."Document Type" <> lCustLedgerEntry."Document Type"::Invoice then
                                //    CurrReport.Skip();
                                if StrPos(NRecu, lCustLedgerEntry."Document No.") = 0 then begin
                                    if NRecu <> '' then
                                        NRecu += '|';
                                    NRecu += lCustLedgerEntry."Document No.";
                                end;
                            end;
                        until lDetailedCustLedgEntry.Next() = 0;
                end;
                //if NRecu = '' then
                //    CurrReport.Skip();

                case Paiement."Payment Slip Type" of
                    "Payment Slip Type"::Cash:
                        begin
                            Paiement_Espece += Paiement."Amount (LCY)" * (-1);
                            Total_Espece += Paiement_Espece;
                        end;
                    "Payment Slip Type"::Cheque:
                        begin
                            Paiement_Cheque += Paiement."Amount (LCY)" * (-1);
                            Total_Cheque += Paiement_Cheque;
                        end;
                    "Payment Slip Type"::Draft:
                        begin
                            Paiement_Traite += Paiement."Amount (LCY)" * (-1);
                            Total_Traite += Paiement_Traite;
                        end;
                    "Payment Slip Type"::RS:
                        begin
                            Paiement_RS += Paiement."Amount (LCY)" * (-1);
                            Total_RS += Paiement_RS;
                        end;

                    "Payment Slip Type"::Transfer:
                        begin
                            Paiement_Virement += Paiement."Amount (LCY)" * (-1);
                            Total_Virement += Paiement_Virement;
                        end;
                end;

            end;
        }

        dataitem(Integer; Integer)
        {
            DataItemTableView = SORTING(Number) ORDER(Ascending)
                                    where(Number = filter(1));

            column(Total_recette; Total_recette)
            {

            }
            column(Total_Espece; Total_espece)
            {

            }
            column(Total_Cheque; Total_Cheque)
            {

            }
            column(Total_RS; Total_RS)
            {

            }
            column(Total_Traite; Total_Traite)
            {

            }
            column(Total_Virement; Total_Virement)
            {

            }
            column(Number; Number)
            {

            }
            column(Type_Doc5; Type_Doc)
            {

            }
            trigger OnAfterGetRecord()
            var
            begin
                Total_recette := Total_Espece + Total_Cheque + Total_RS + Total_Traite + Total_Virement;
                Type_Doc := 'TOTAL';

            end;

        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Filters)
                {
                    field(StartingDate; StartingDate)
                    {
                        ApplicationArea = all;
                        CaptionML = ENU = 'Starting Date', FRA = 'Date début';
                    }
                    field(EndingDate; EndingDate)
                    {
                        ApplicationArea = all;
                        Captionml = ENU = 'Ending Date', FRA = 'Date fin';
                    }

                }
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }
    }

    labels
    {
        title = 'JOURNAL DE CAISSE';
        Page = 'Page';
        Date = 'Date';
        Client = 'N° client';
        Nom_Client = 'Nom client';
        Doc = 'N° document';
        Montant = 'Montant';
    }

    trigger OnInitReport()
    begin
        StartingDate := WorkDate();
        EndingDate := WorkDate();
    end;

    procedure InsertTempCustLedgerEntries(pEntryNo: Integer)
    var
    begin
        TempCustLedgerEntries.Reset();
        if TempCustLedgerEntries.get(pEntryNo) then
            exit;

        TempCustLedgerEntries.Init();
        TempCustLedgerEntries."Entry No." := pEntryNo;
        TempCustLedgerEntries.Insert();
    end;


    Procedure IsCanceled(pCustomerLedEntryNo: Integer; pDocumentNo: Code[20]): Boolean
    var
        lDetCustomerLedgent: Record "Detailed Cust. Ledg. Entry";
    begin
        lDetCustomerLedgent.Reset();
        lDetCustomerLedgent.SetCurrentKey("Cust. Ledger Entry No.", "Posting Date", "Ledger Entry Amount");
        lDetCustomerLedgent.SetRange("Document Type", lDetCustomerLedgent."Document Type"::Payment);
        lDetCustomerLedgent.SetRange("Cust. Ledger Entry No.", pCustomerLedEntryNo);
        lDetCustomerLedgent.SetRange("Document No.", pDocumentNo);
        lDetCustomerLedgent.CalcSums("Credit Amount (LCY)");
        exit(lDetCustomerLedgent."Credit Amount (LCY)" = 0)
    end;

    var
        TempCustLedgerEntries: Record "Cust. Ledger Entry" temporary;
        StartingDate: Date;
        EndingDate: Date;
        ShipCustName: Text[100];
        ShipAmount: Decimal;
        Type_Doc: Text[20];
        ToDisplay: Integer;
        TotalBL: Decimal;
        Espece: Decimal;
        Cheque: Decimal;
        RS: Decimal;
        Traite: decimal;
        Virement: Decimal;
        Paiement_Espece: Decimal;
        Paiement_Cheque: Decimal;
        Paiement_RS: Decimal;
        Paiement_Traite: decimal;
        Paiement_Virement: Decimal;
        NRecu: Text[150];
        Total_recette: Decimal;
        Total_Espece: Decimal;
        Total_Cheque: Decimal;
        Total_RS: Decimal;
        Total_Traite: Decimal;
        Total_Virement: Decimal;
        Avoir_Montant: Decimal;
}
