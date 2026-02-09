namespace CRC.CRC;

using Microsoft.Sales.History;
using Microsoft.Sales.Receivables;
using Microsoft.Sales.Document;
using Microsoft.Sales.Customer;
using System.Utilities;
using Microsoft.Finance.GeneralLedger.Journal;

report 50017 "WDC Cash Journal1"
{
    DefaultLayout = RDLC;
    RDLCLayout = './.vscode/src/Report/RDLC/CashJournal1.rdl';
    ApplicationArea = All;
    CaptionML = ENU = 'Cash Journal v2', FRA = 'Journal de caisse v2';
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
                    ShipAmount := "Item Charge Base Amount"
                else If lSalesLine.GET(lSalesLine."Document Type"::Order, "Sales Shipment Line"."Order No.", "Sales Shipment Line"."Order Line No.") then
                    ShipAmount := ("Qty. Shipped Not Invoiced" * lSalesLine."Unit Price") * (100 - "Line Discount %");

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
            column(Remaining_AmountLCY; Factures."Remaining Amt. (LCY)")
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
            column(Avoir1; Avoir1)
            {

            }

            column(Virement; virement)
            {

            }
            column(Type_Doc2; Type_Doc)
            {

            }
            column(TotalComptants; TotalComptants)
            {

            }
            column(TotalTermes; TotalTermes)
            {

            }
            column(TotalAmountComptants; TotalAmountComptants)
            {

            }
            column(TotalAmountTermes; TotalAmountTermes)
            {

            }
            column(TotalEspeceCmp; TotalEspeceCmp)
            {

            }
            column(TotalChequeCmp; TotalChequeCmp)
            {

            }
            column(TotalTraiteCmp; TotalTraiteCmp)
            {

            }
            column(TotalRSCmp; TotalRSCmp)
            {

            }
            column(TotalVirementCmp; TotalVirementCmp)
            {

            }
            column(TotalAvoirCmp; TotalAvoirCmp)
            {

            }
            column(TotalAvoirT; TotalAvoirT)
            {

            }
            column(TotalEspeceT; TotalEspeceT)
            {

            }
            column(TotalChequeT; TotalChequeT)
            {

            }
            column(TotalTraiteT; TotalTraiteT)
            {

            }
            column(TotalRST; TotalRST)
            {

            }
            column(TotalVirementT; TotalVirementT)
            {

            }

            column(AvoirTotalT; AvoirTotalT)
            {

            }
            column(AvoirTotalCmp; AvoirTotalCmp)
            {

            }

            trigger OnPreDataItem()
            begin
                Factures.SetFilter("Posting Date", '%1..%2', StartingDate, EndingDate);

                Type_Doc := 'FACTURES';
                ToDisplay := 0;
                //TotalBL := 0;
                TotalComptants := 0;
                TotalTermes := 0;
                TotalAmountComptants := 0;
                TotalAmountTermes := 0;
                Total_Espece := 0;
                Total_Cheque := 0;
                Total_Traite := 0;
                Total_RS := 0;
                Total_Virement := 0;
                Total_Avoir := 0;
                Total_AvoirCmp := 0;
                Total_AvoirT := 0;
            end;

            trigger OnAfterGetRecord()
            var
                lSalesInvHeader: Record "Sales Invoice Header";
                lDetailedCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
            begin
                factures.CalcFields("Remaining Amt. (LCY)");
                factures.CalcFields("Amount (LCY)");
                clear(ShipCustName);
                if lSalesInvHeader.get(Factures."Document No.") then
                    ShipCustName := lSalesInvHeader."Sell-to Customer Name"
                else
                    ShipCustName := Factures."Customer Name";

                Espece := 0;
                Clear(lDetailedCustLedgEntry);
                //lDetailedCustLedgEntry.SetCurrentKey("Cust. Ledger Entry No.", "Entry Type", "Posting Date");
                lDetailedCustLedgEntry.SetRange("Cust. Ledger Entry No.", Factures."Entry No.");
                lDetailedCustLedgEntry.SetRange("Entry Type", lDetailedCustLedgEntry."Entry Type"::Application);
                //lDetailedCustLedgEntry.SetFilter("Posting Date", '%1..%2', StartingDate, EndingDate);
                lDetailedCustLedgEntry.SetRange("Payment Slip Type", "Payment Slip Type"::Cash);
                if lDetailedCustLedgEntry.FindSet() then
                    repeat
                        Espece += lDetailedCustLedgEntry."Amount (LCY)" * (-1);
                        Total_Espece += lDetailedCustLedgEntry."Amount (LCY)" * (-1);
                        InsertTempCustLedgerEntries(lDetailedCustLedgEntry."Applied Cust. Ledger Entry No.");
                    until lDetailedCustLedgEntry.Next() = 0;

                Cheque := 0;
                Clear(lDetailedCustLedgEntry);
                //lDetailedCustLedgEntry.SetCurrentKey("Cust. Ledger Entry No.", "Entry Type", "Posting Date");
                lDetailedCustLedgEntry.SetRange("Cust. Ledger Entry No.", Factures."Entry No.");
                lDetailedCustLedgEntry.SetRange("Entry Type", lDetailedCustLedgEntry."Entry Type"::Application);
                //lDetailedCustLedgEntry.SetFilter("Posting Date", '%1..%2', StartingDate, EndingDate);
                lDetailedCustLedgEntry.SetRange("Payment Slip Type", "Payment Slip Type"::Cheque);
                if lDetailedCustLedgEntry.FindSet() then
                    repeat
                        Cheque += lDetailedCustLedgEntry."Amount (LCY)" * (-1);
                        Total_Cheque += lDetailedCustLedgEntry."Amount (LCY)" * (-1);
                        InsertTempCustLedgerEntries(lDetailedCustLedgEntry."Applied Cust. Ledger Entry No.");
                    until lDetailedCustLedgEntry.Next() = 0;

                Traite := 0;
                Clear(lDetailedCustLedgEntry);
                //lDetailedCustLedgEntry.SetCurrentKey("Cust. Ledger Entry No.", "Entry Type", "Posting Date");
                lDetailedCustLedgEntry.SetRange("Cust. Ledger Entry No.", Factures."Entry No.");
                lDetailedCustLedgEntry.SetRange("Entry Type", lDetailedCustLedgEntry."Entry Type"::Application);
                //lDetailedCustLedgEntry.SetFilter("Posting Date", '%1..%2', StartingDate, EndingDate);
                lDetailedCustLedgEntry.SetRange("Payment Slip Type", "Payment Slip Type"::Draft);
                if lDetailedCustLedgEntry.FindSet() then
                    repeat
                        Traite += lDetailedCustLedgEntry."Amount (LCY)" * (-1);
                        Total_Traite += lDetailedCustLedgEntry."Amount (LCY)" * (-1);
                        InsertTempCustLedgerEntries(lDetailedCustLedgEntry."Applied Cust. Ledger Entry No.");
                    until lDetailedCustLedgEntry.Next() = 0;

                RS := 0;
                Clear(lDetailedCustLedgEntry);
                //lDetailedCustLedgEntry.SetCurrentKey("Cust. Ledger Entry No.", "Entry Type", "Posting Date");
                lDetailedCustLedgEntry.SetRange("Cust. Ledger Entry No.", Factures."Entry No.");
                lDetailedCustLedgEntry.SetRange("Entry Type", lDetailedCustLedgEntry."Entry Type"::Application);
                //lDetailedCustLedgEntry.SetFilter("Posting Date", '%1..%2', StartingDate, EndingDate);
                lDetailedCustLedgEntry.SetRange("Payment Slip Type", "Payment Slip Type"::RS);
                if lDetailedCustLedgEntry.FindSet() then
                    repeat
                        RS += lDetailedCustLedgEntry."Amount (LCY)" * (-1);
                        Total_RS += lDetailedCustLedgEntry."Amount (LCY)" * (-1);
                        InsertTempCustLedgerEntries(lDetailedCustLedgEntry."Applied Cust. Ledger Entry No.");
                    until lDetailedCustLedgEntry.Next() = 0;

                Virement := 0;
                Clear(lDetailedCustLedgEntry);
                //lDetailedCustLedgEntry.SetCurrentKey("Cust. Ledger Entry No.", "Entry Type", "Posting Date");
                lDetailedCustLedgEntry.SetRange("Cust. Ledger Entry No.", Factures."Entry No.");
                lDetailedCustLedgEntry.SetRange("Entry Type", lDetailedCustLedgEntry."Entry Type"::Application);
                //lDetailedCustLedgEntry.SetFilter("Posting Date", '%1..%2', StartingDate, EndingDate);
                lDetailedCustLedgEntry.SetRange("Payment Slip Type", "Payment Slip Type"::Transfer);
                if lDetailedCustLedgEntry.FindSet() then
                    repeat
                        Virement += lDetailedCustLedgEntry."Amount (LCY)" * (-1);
                        Total_Virement += lDetailedCustLedgEntry."Amount (LCY)" * (-1);
                        InsertTempCustLedgerEntries(lDetailedCustLedgEntry."Applied Cust. Ledger Entry No.");
                    until lDetailedCustLedgEntry.Next() = 0;

                Avoir1 := 0;
                Clear(lDetailedCustLedgEntry);
                //lDetailedCustLedgEntry.SetCurrentKey("Cust. Ledger Entry No.", "Entry Type", "Posting Date");
                lDetailedCustLedgEntry.SetRange("Cust. Ledger Entry No.", Factures."Entry No.");
                lDetailedCustLedgEntry.SetRange("Entry Type", lDetailedCustLedgEntry."Entry Type"::Application);
                //lDetailedCustLedgEntry.SetFilter("Posting Date", '%1..%2', StartingDate, EndingDate);
                lDetailedCustLedgEntry.SetFilter("Document Type", '%1|%2', lDetailedCustLedgEntry."Document Type"::"Credit Memo", lDetailedCustLedgEntry."Document Type"::Invoice);
                if lDetailedCustLedgEntry.FindSet() then
                    repeat
                        Avoir1 += lDetailedCustLedgEntry."Amount (LCY)" * (-1);
                        Total_Avoir += lDetailedCustLedgEntry."Amount (LCY)" * (-1);
                        IF (Factures."Sell-to Customer No." = '9999') THEN BEGIN
                            Total_AvoirCmp += lDetailedCustLedgEntry."Amount (LCY)" * (-1);
                        END;
                        //END;
                        IF (Factures."Sell-to Customer No." <> '9999') THEN BEGIN
                            Total_AvoirT += lDetailedCustLedgEntry."Amount (LCY)" * (-1);
                        END;
                        InsertTempCustLedgerEntries(lDetailedCustLedgEntry."Applied Cust. Ledger Entry No.");
                    until lDetailedCustLedgEntry.Next() = 0;
                IF (Factures."Sell-to Customer No." = '9999') AND (Factures."Remaining Amt. (LCY)" <> Factures."Amount (LCY)") THEN BEGIN
                    TotalComptants += Espece + Cheque + Traite + RS + Virement + Avoir1;
                    TotalAmountComptants += Factures."Amount (LCY)";
                    TotalEspeceCmp += Espece;
                    TotalChequeCmp += Cheque;
                    TotalTraiteCmp += Traite;
                    TotalRSCmp += RS;
                    TotalVirementCmp += Virement;
                    TotalAvoirCmp += Avoir1;
                END;
                IF (Factures."Sell-to Customer No." <> '9999') AND (Factures."Remaining Amt. (LCY)" <> Factures."Amount (LCY)") THEN BEGIN
                    TotalTermes += Espece + Cheque + Traite + RS + Virement + Avoir1;
                    TotalAmountTermes += Factures."Amount (LCY)";
                    TotalEspeceT += Espece;
                    TotalChequeT += Cheque;
                    TotalTraiteT += Traite;
                    TotalRST += RS;
                    TotalVirementT += Virement;
                    TotalAvoirT += Avoir1;
                END;

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
            column(Paiement_Avoir; Paiement_Avoir)
            {

            }
            column(Paiement_Virement; Paiement_virement)
            {

            }
            column(NRecu; NRecu)
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


                clear(NRecu);
                Paiement_Espece := 0;
                Paiement_Cheque := 0;
                Paiement_Traite := 0;
                Paiement_RS := 0;
                Paiement_Virement := 0;
                Paiement_Avoir := 0;
                Total_AvoirCmp := 0;
                Total_AvoirT := 0;

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
                            if NRecu <> '' then
                                NRecu += '|';
                            NRecu += lCustLedgerEntry."Document No.";
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
                                if lCustLedgerEntry."Document Type" <> lCustLedgerEntry."Document Type"::Invoice then
                                    CurrReport.Skip();

                                if NRecu <> '' then
                                    NRecu += '|';
                                NRecu += lCustLedgerEntry."Document No.";
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

            //end;
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
            column(Total_Avoir; Total_Avoir)
            {

            }
            column(Total_AvoirCmp; Total_AvoirCmp)
            {

            }
            column(Total_AvoirT; Total_AvoirT)
            {

            }
            column(TotalAvoirT1; TotalAvoirT)
            {

            }
            column(TotalAvoirCmp1; TotalAvoirCmp)
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
                Total_recette := Total_Espece + Total_Cheque - Total_RS + Total_Traite + Total_Virement;
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
        Avoir1: Decimal;
        Traite: decimal;
        Virement: Decimal;
        Paiement_Espece: Decimal;
        Paiement_Cheque: Decimal;
        Paiement_RS: Decimal;
        Paiement_Traite: decimal;
        Paiement_Virement: Decimal;
        Paiement_Avoir: Decimal;
        NRecu: Text[150];
        Total_recette: Decimal;
        Total_Espece: Decimal;
        Total_Cheque: Decimal;
        Total_RS: Decimal;
        Total_Traite: Decimal;
        Total_Avoir: Decimal;
        Total_Virement: Decimal;
        Avoir_Montant: Decimal;
        TotalComptants: Decimal;
        TotalTermes: Decimal;
        TotalAmountComptants: Decimal;
        TotalAmountTermes: Decimal;
        TotalChequeCmp: Decimal;
        TotalTraiteCmp: Decimal;
        TotalEspeceCmp: Decimal;
        TotalRSCmp: Decimal;
        TotalVirementCmp: Decimal;
        TotalAvoirCmp: Decimal;
        TotalChequeT: Decimal;
        TotalTraiteT: Decimal;
        TotalEspeceT: Decimal;
        TotalRST: Decimal;
        TotalVirementT: Decimal;
        TotalAvoirT: Decimal;
        Total_AvoirCmp: Decimal;
        Total_AvoirT: Decimal;
        AvoirTotalT: Text[20];
        AvoirTotalCmp: Text[20];
}
