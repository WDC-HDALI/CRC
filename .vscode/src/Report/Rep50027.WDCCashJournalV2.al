namespace CRC.CRC;

using Microsoft.Sales.History;
using Microsoft.Sales.Receivables;
using Microsoft.Sales.Document;
using Microsoft.Foundation.Company;
using Microsoft.Sales.Customer;
using System.Utilities;
using Microsoft.Finance.GeneralLedger.Journal;
using System.Security.AccessControl;

report 50027 "WDC Cash Journal V2"
{
    DefaultLayout = RDLC;
    RDLCLayout = './.vscode/src/Report/RDLC/CashJournal_V2.rdl';
    ApplicationArea = All;
    CaptionML = ENU = 'Cash Journal V2', FRA = 'Journal de caisse V2';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {

        dataitem(Factures; "Cust. Ledger Entry")
        {
            DataItemTableView = SORTING("Document Type", "Customer No.", "Posting Date", "Currency Code")
                                    ORDER(Ascending)
                                    where("Document Type" = filter(Invoice), "Customer Posting Group" = filter('C-PASSAGER'));

            column(COMPANYNAME; COMPANYNAME)
            {

            }
            column(CompInfo_Picture; CompInfo.Picture)
            {

            }
            column(StartingDate; StartingDate)
            {

            }
            column(EndingDate; EndingDate)
            {

            }
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
            column(Avoir; Avoir)
            {

            }
            column(Type_Doc2; Type_Doc)
            {

            }
            column(PaymentReferenceDetailedtext; InvoicePaymentDetailedText)
            {

            }

            trigger OnPreDataItem()
            begin
                if (StartingDate = 0D) or (EndingDate = 0D) then
                    Error('Les dates début et fin ne doivent pas être vide!');
                if EndingDate < StartingDate then
                    Error('Date fin ne doit pas être antérieur à la date début !');
                Factures.SetFilter("Posting Date", '%1..%2', StartingDate, EndingDate);
                CompInfo.get;
                CompInfo.CalcFields(Picture);
                Type_Doc := 'FACTURES';
                ToDisplay := 0;
                //TotalBL := 0;
            end;

            trigger OnAfterGetRecord()
            var
                lSalesInvHeader: Record "Sales Invoice Header";
                lDetailedCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
                lCustomerLedgerEntry: record "Cust. Ledger Entry";
            begin
                InvoicePaymentDetailedText := '';
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
                        //HG
                        lCustomerLedgerEntry.reset();
                        if lCustomerLedgerEntry.get(lDetailedCustLedgEntry."Applied Cust. Ledger Entry No.") then begin
                            if InvoicePaymentDetailedText <> '' then
                                InvoicePaymentDetailedText += '/';
                            InvoicePaymentDetailedText += CopyStr(format(lCustomerLedgerEntry."Payment Method Code"), 1, 3) + ':' + format(lCustomerLedgerEntry."Payment Reference");
                        end
                    //HG

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
                        lCustomerLedgerEntry.reset();
                        if lCustomerLedgerEntry.get(lDetailedCustLedgEntry."Applied Cust. Ledger Entry No.") then begin
                            if InvoicePaymentDetailedText <> '' then
                                InvoicePaymentDetailedText += '/';
                            InvoicePaymentDetailedText += CopyStr(format(lCustomerLedgerEntry."Payment Method Code"), 1, 3) + ':' + format(lCustomerLedgerEntry."Payment Reference");
                        end
                    until lDetailedCustLedgEntry.Next() = 0;
                Avoir := 0;
                Clear(lDetailedCustLedgEntry);
                lDetailedCustLedgEntry.SetCurrentKey("Cust. Ledger Entry No.", "Entry Type", "Posting Date");
                lDetailedCustLedgEntry.SetRange("Applied Cust. Ledger Entry No.", Factures."Entry No.");
                lDetailedCustLedgEntry.SetRange("Entry Type", lDetailedCustLedgEntry."Entry Type"::Application);
                lDetailedCustLedgEntry.SetFilter("Posting Date", '%1..%2', StartingDate, EndingDate);
                lDetailedCustLedgEntry.SetRange("Payment Slip Type", "Payment Slip Type"::" ");
                if lDetailedCustLedgEntry.FindSet() then
                    repeat
                        if lDetailedCustLedgEntry."Initial Document Type" = lDetailedCustLedgEntry."Initial Document Type"::"Credit Memo" then
                            Avoir += lDetailedCustLedgEntry."Amount (LCY)";

                        // if lDetailedCustLedgEntry."Amount (LCY)" < 0 then
                        //     Avoir += lDetailedCustLedgEntry."Amount (LCY)" * (-1);
                        InsertTempCustLedgerEntries(lDetailedCustLedgEntry."Applied Cust. Ledger Entry No.");
                        if (lDetailedCustLedgEntry."Initial Document Type" = lDetailedCustLedgEntry."Initial Document Type"::"Credit Memo") and (lDetailedCustLedgEntry.Unapplied = false) then begin
                            if lCustomerLedgerEntry.get(lDetailedCustLedgEntry."Cust. Ledger Entry No.") then begin
                                if InvoicePaymentDetailedText <> '' then
                                    InvoicePaymentDetailedText += '/';
                                InvoicePaymentDetailedText += format(lCustomerLedgerEntry."Document No.");
                            end;
                        end;
                    until lDetailedCustLedgEntry.Next() = 0;

                totalTTC += Factures."Amount (LCY)";

            end;
        }



        dataitem(Paiement;
        "Cust. Ledger Entry")
        {
            DataItemTableView = SORTING("Document Type", "Customer No.", "Posting Date", "Currency Code")
                                    ORDER(Ascending)
                                    where("Document Type" = filter(payment), "Customer Posting Group" = filter('C-PASSAGER'));
            //, "Payment Method Code"=filter(<>'RS'));

            column(Paiement_PostingDate;
            Paiement."Posting Date")
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
            column(InvoiceDate; InvoiceDate)
            {

            }
            column(InvoiceAmountLCY; InvoiceAmountLCY)
            {

            }
            column(External_Document_No_; "External Document No.")
            {

            }
            column(Type_Doc4; Type_Doc)
            {

            }
            column(PaymentDetailText; PaymentDetailText)
            {

            }

            trigger OnPreDataItem()
            begin
                Paiement.SetFilter("Posting Date", '%1..%2', StartingDate, EndingDate);

                Type_Doc := 'Retard Paiement';
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
                PaymentDetailText := '';

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
                            if lCustLedgerEntry."Posting Date" < StartingDate then begin
                                if StrPos(NRecu, lCustLedgerEntry."Document No.") = 0 then begin
                                    if NRecu <> '' then
                                        NRecu += '|';
                                    NRecu += lCustLedgerEntry."Document No.";
                                end;
                            end;
                        end;
                    until lDetailedCustLedgEntry.Next() = 0;


                if NRecu = '' then
                    CurrReport.Skip();

            end;
        }
        dataitem(AvancePaiementComptant; "Cust. Ledger Entry")
        {
            DataItemTableView = SORTING("Document Type", "Customer No.", "Posting Date", "Currency Code")
                                    ORDER(Ascending)
                                    where("Document Type" = filter(payment), "Customer Posting Group" = filter('C-PASSAGER'), Open = filter(true));

            column(AvancePaiementComptant_PostingDate; AvancePaiementComptant."Posting Date")
            {

            }
            column(AvancePaiementComptant_DocumentType; AvancePaiementComptant."Document Type")
            {

            }
            column(AvancePaiementComptant_DocumentNo; AvancePaiementComptant."Document No.")
            {

            }
            column(AvancePaiementComptant_CustomerNo; AvancePaiementComptant."Sell-to Customer No.")
            {

            }
            column(AvancePaiementComptant_CustomerName; AvancePaiementComptant."Customer Name")
            {

            }
            column(OrderNo; AvancePaiementComptant."External Document No.")
            {

            }
            column(AvancePaiementComptant_AmountLCY; AvancePaiementComptant."Amount (LCY)")
            {

            }
            column(AvancePaiementComptant_Espece; AvancePaiementComptant_Espece)
            {

            }
            column(AvancePaiementComptant_Cheque; AvancePaiementComptant_Cheque)
            {

            }
            column(AvancePaiementComptant_RS; AvancePaiementComptant_RS)
            {

            }
            Column(AvancePaiementComptant_Traite; AvancePaiementComptant_Traite)
            {

            }
            column(AvancePaiementComptant_Virement; AvancePaiementComptant_virement)
            {

            }
            column(Type_Doc3; Type_Doc)
            {

            }

            trigger OnPreDataItem()
            begin
                AvancePaiementComptant.SetFilter("Posting Date", '%1..%2', StartingDate, EndingDate);
                ToDisplay := 0;
            end;

            trigger OnAfterGetRecord()
            var
                lCustLedgerEntry: Record "Cust. Ledger Entry";
                lDetailedCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
            begin

                Type_Doc := 'Avance comptant';
                AvancePaiementComptant_Espece := 0;
                AvancePaiementComptant_Cheque := 0;
                AvancePaiementComptant_Traite := 0;
                AvancePaiementComptant_RS := 0;
                AvancePaiementComptant_Virement := 0;
                AvancePaiementComptant.CalcFields("Amount (LCY)");
                case AvancePaiementComptant."Payment Slip Type" of
                    "Payment Slip Type"::Cash:
                        begin
                            AvancePaiementComptant_Espece += (AvancePaiementComptant."Amount (LCY)") * (-1);
                            Total_Espece += AvancePaiementComptant_Espece;
                        end;
                    "Payment Slip Type"::Cheque:
                        begin
                            AvancePaiementComptant_Cheque += (AvancePaiementComptant."Amount (LCY)") * (-1);
                            Total_Cheque += AvancePaiementComptant_Cheque;
                        end;
                    "Payment Slip Type"::Draft:
                        begin
                            AvancePaiementComptant_Traite += (AvancePaiementComptant."Amount (LCY)") * (-1);
                            Total_Traite += AvancePaiementComptant_Traite;
                        end;
                    "Payment Slip Type"::RS:
                        begin
                            AvancePaiementComptant_RS += (AvancePaiementComptant."Amount (LCY)") * (-1);
                            Total_RS += AvancePaiementComptant_RS;
                        end;

                    "Payment Slip Type"::Transfer:
                        begin
                            AvancePaiementComptant_Virement += (AvancePaiementComptant."Amount (LCY)") * (-1);
                            Total_Virement += AvancePaiementComptant_Virement;
                        end;
                end;

            end;
        }

        dataitem(Paiementterme; "Cust. Ledger Entry")
        {
            DataItemTableView = SORTING("Document Type", "Customer No.", "Posting Date", "Currency Code")
                                    ORDER(Ascending)
                                    where("Document Type" = filter(payment), "Customer Posting Group" = filter('C-GROUPE'));

            column(Paiementterme_PostingDate; Paiementterme."Posting Date")
            {

            }
            column(Paiementterme_DocumentType; Paiementterme."Document Type")
            {

            }
            column(Paiementterme_DocumentNo; Paiementterme."Document No.")
            {

            }
            column(Paiementterme_CustomerNo; Paiementterme."Sell-to Customer No.")
            {

            }
            column(Paiementterme_CustomerName; Paiementterme."Customer Name")
            {

            }
            column(Paiementterme_AmountLCY; Paiementterme."Amount (LCY)")
            {

            }
            column(Paiementterme_bankaccount; Paiementterme."Bank Name")
            {

            }

            column(Paiementterme_Espece; Paiementterme_Espece)
            {

            }
            column(Paiementterme_Cheque; Paiementterme_Cheque)
            {

            }
            column(Paiementterme_RS; Paiementterme_RS)
            {

            }
            Column(Paiementterme_Traite; Paiementterme_Traite)
            {

            }
            column(Paiementterme_Virement; Paiementterme_virement)
            {

            }

            column(Type_Doc6; Type_Doc)
            {

            }
            column(PaiementtermeText; PaiementtermeText)
            {

            }

            trigger OnPreDataItem()
            begin
                Paiementterme.SetFilter("Posting Date", '%1..%2', StartingDate, EndingDate);

                ToDisplay := 0;
                //TotalBL := 0;
            end;

            trigger OnAfterGetRecord()
            var
                lCustLedgerEntry: Record "Cust. Ledger Entry";
                lDetailedCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
            begin
                PaiementtermeText := '';
                Type_Doc := 'Reçu a terme';
                Paiementterme_Espece := 0;
                Paiementterme_Cheque := 0;
                Paiementterme_Traite := 0;
                Paiementterme_RS := 0;
                Paiementterme_Virement := 0;
                Paiementterme.CalcFields("Amount (LCY)");
                case Paiementterme."Payment Slip Type" of
                    "Payment Slip Type"::Cash:
                        begin
                            Paiementterme_Espece += (Paiementterme."Amount (LCY)") * (-1);
                            Total_Espece += Paiementterme_Espece;
                            totalTTC += Paiementterme_Espece;
                        end;
                    "Payment Slip Type"::Cheque:
                        begin
                            Paiementterme_Cheque += (Paiementterme."Amount (LCY)") * (-1);
                            if Paiementterme."Payment Reference" <> '' then
                                PaiementtermeText := CopyStr(format(Paiementterme."Payment Method Code"), 1, 3) + ':' + format(Paiementterme."Payment Reference");
                            Total_Cheque += Paiementterme_Cheque;
                            totalTTC += Paiementterme_Cheque;
                        end;
                    "Payment Slip Type"::Draft:
                        begin
                            Paiementterme_Traite += (Paiementterme."Amount (LCY)") * (-1);
                            if Paiementterme."Payment Reference" <> '' then
                                PaiementtermeText := CopyStr(format(Paiementterme."Payment Method Code"), 1, 3) + ':' + format(Paiementterme."Payment Reference");
                            Total_Traite += Paiementterme_Traite;
                            totalTTC += Paiementterme_Traite;
                        end;
                    "Payment Slip Type"::RS:
                        begin
                            Paiementterme_RS += (Paiementterme."Amount (LCY)") * (-1);
                            Total_RS += Paiementterme_RS;
                            totalTTC += Paiementterme_RS;
                        end;

                    "Payment Slip Type"::Transfer:
                        begin
                            Paiementterme_Virement += (Paiementterme."Amount (LCY)") * (-1);
                            if Paiementterme."Payment Reference" <> '' then
                                PaiementtermeText := CopyStr(format(Paiementterme."Payment Method Code"), 1, 3) + ':' + format(Paiementterme."Payment Reference");
                            Total_Virement += Paiementterme_Virement;
                            totalTTC += Paiementterme_Virement;
                        end;
                end;

            end;
        }

        dataitem(CanceledPayment; "Cust. Ledger Entry")
        {
            DataItemTableView = SORTING("Document Type", "Customer No.", "Posting Date", "Currency Code")
                                    ORDER(Ascending)
                                    where("Document Type" = filter(payment), Reversed = filter(true), "Reversed by Entry No." = filter(0), "Reversed Entry No." = filter(<> 0));

            column(CanceledPayment_PostingDate; CanceledPayment."Posting Date")
            {

            }
            column(CanceledPayment_DocumentType; CanceledPayment."Document Type")
            {

            }
            column(CanceledPayment_DocumentNo; CanceledPayment."Document No.")
            {

            }
            column(CanceledPayment_CustomerNo; CanceledPayment."Sell-to Customer No.")
            {

            }
            column(CanceledPayment_CustomerName; CanceledPayment."Customer Name")
            {

            }
            column(CanceledPayment_AmountLCY; CanceledPayment."Amount (LCY)")
            {

            }
            column(CanceledPayment_PaymentMethodCode; CanceledPayment."Payment Method Code")
            {

            }
            column(CanceledPayment_PaymentReference; CanceledPayment."Payment Reference")
            {

            }
            column(CanceledPayment_BankAccount; CanceledPayment."Bank Name")
            {

            }
            column(CanceledPayment_DueDate; CanceledPayment."Due Date")
            {

            }
            column(UserName; UserName)
            {

            }
            column(SystemCreatedAt; SystemCreatedAt)
            {

            }
            column(Type_Doc7; "Type_Doc")
            {

            }



            trigger OnPreDataItem()
            begin
                Evaluate(StartingDateTime, format(StartingDate));
                Evaluate(EndingDateTime, format(EndingDate));
                CanceledPayment.SetFilter("SystemCreatedAt", '%1..%2', StartingDateTime, EndingDateTime);
            end;

            trigger OnAfterGetRecord()
            var
                user: record User;

            begin
                Type_Doc := 'Canceled Payment';
                UserName := '';
                user.Reset();
                if user.Get(CanceledPayment.SystemCreatedBy) then
                    UserName := user."User Name";
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

                //Total_recette := Total_Espece + Total_Cheque + Total_RS + Total_Traite + Total_Virement;

                Total_recette := totalTTC;
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
        Doc = 'N° doc';
        Montant = 'Montant';
    }

    // trigger OnInitReport()
    // begin
    //     StartingDate := WorkDate();
    //     EndingDate := WorkDate();
    // end;

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

    procedure SetFilterDate(DateDebut: Date; DateFin: date)
    begin
        if (DateDebut <> 0D) and (DateFin <> 0D) then begin
            StartingDate := DateDebut;
            EndingDate := DateFin;
        end;
    end;


    var
        TempCustLedgerEntries: Record "Cust. Ledger Entry" temporary;
        StartingDate: Date;
        StartingDateTime: DateTime;
        EndingDate: Date;
        EndingDateTime: DateTime;

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
        Avoir: decimal;
        Paiement_Espece: Decimal;
        Paiement_Cheque: Decimal;
        Paiement_RS: Decimal;
        Paiement_Traite: decimal;
        Paiement_Virement: Decimal;
        Paiementterme_Espece: Decimal;
        Paiementterme_Cheque: Decimal;
        Paiementterme_RS: Decimal;
        Paiementterme_Traite: decimal;
        Paiementterme_Virement: Decimal;
        AvancePaiementComptant_Espece: Decimal;
        AvancePaiementComptant_Cheque: Decimal;
        AvancePaiementComptant_Traite: Decimal;
        AvancePaiementComptant_RS: Decimal;
        AvancePaiementComptant_Virement: Decimal;
        NRecu: Text[150];
        InvoiceDate: Date;
        InvoiceAmountLCY: Decimal;
        Total_recette: Decimal;
        Total_Espece: Decimal;
        Total_Cheque: Decimal;
        Total_RS: Decimal;
        Total_Traite: Decimal;
        Total_Virement: Decimal;
        InvoicePaymentDetailedText: text[250];
        PaymentDetailText: text[250];
        PaiementtermeText: text[250];
        UserName: code[50];
        totalTTC: Decimal;
        CompInfo: Record "Company Information";
}
