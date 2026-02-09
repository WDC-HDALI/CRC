//*****************Documentation********************
//WDC01  WDC.HG  13/08/2025  Create Current Object
//WDC02  WDC.HG  18/11/2025  Add vendor report 
//WDC03  WDC.FS  26.12.2025  Edit report
namespace CRC.CRC;

using Microsoft.Sales.History;
using Microsoft.Finance.GeneralLedger.Setup;
using Microsoft.Purchases.Document;
using Microsoft.Purchases.Payables;
using Microsoft.Purchases.History;
using Microsoft.Purchases.Vendor;
using Microsoft.Sales.Receivables;
using Microsoft.Inventory.Item;
using Microsoft.Finance.VAT.Setup;
using Microsoft.Sales.Document;
using Microsoft.Sales.Customer;
using System.Utilities;

report 50028 "WDC Global Vendor Balance"
{
    DefaultLayout = RDLC;
    RDLCLayout = './.vscode/src/Report/RDLC/GlobalvendorBalance.rdl';
    ApplicationArea = All;
    CaptionML = ENU = 'Global Vendor Balance', FRA = 'Extrait fournisseur';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(Vendor; Vendor)
        {
            DataItemTableView = SORTING("No.");
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.";

            column(COMPANYNAME; COMPANYNAME)
            {

            }
            column(Picture_Company; CompanyInfo.Picture)
            {

            }
            column(Address_Company; CompanyInfo.Address)
            {

            }
            column(City_Company; CompanyInfo.City)
            {
            }
            column(PostCode_Company; CompanyInfo."Post Code")
            {
            }
            column(Phone_Company; CompanyInfo."Phone No.")
            {

            }
            column(VendorNo; "No.")
            {

            }
            column(VendorName; Name)
            {

            }

            column(Payment_Terms_Code; "Payment Terms Code")
            {

            }
            //<<WDC02
            column(VendorReport; FilteredVendor.Report)
            {

            }
            //>>WDC02
            //<<wdc03
            column(TotalVendorAmount; TotalVendorAmount)

            {
            }
            column(TotalReceiptNotInvoiced; TotalReceiptNotInvoiced)
            {
            }
            //><wdc03

            column(Date_Filter; DateFilterTxt)
            {
            }


            dataitem(Paiement; "Vendor Ledger Entry")
            {
                DataItemLink = "vendor No." = field("No.");
                DataItemTableView = SORTING("Entry No.") ORDER(Ascending) where(Reversed = filter(false));

                column(Paiement_PostingDate; Paiement."Posting Date")
                {

                }
                column(Paiement_DocumentType; Paiement."Document Type")
                {

                }
                column(Paiement_DocumentNo; Paiement."Document No.")
                {

                }
                //<<WDC02
                column(External_Document_No_; "External Document No.")
                {

                }
                //>>WDC02
                column(Paiement_AmountLCY; PaiementAmount)
                {

                }

                column(Credit_Amount__LCY_; "Credit Amount (LCY)")
                {

                }
                column(Debit_Amount__LCY_; "Debit Amount (LCY)")
                {

                }
                column(Payment_Slip_Type; "Payment Slip Type")
                {

                }
                column(Due_Date; DueDate)
                {

                }
                column(BankName; BankName)
                {

                }
                column(N_cheque; "Payment Reference")
                {

                }
                column(TotalPaiement; TotalPaiement)
                {

                }

                trigger OnPreDataItem()
                begin

                    Paiement.SetFilter("Posting Date", '%1..%2', StartingDate, EndingDate);

                end;

                trigger OnAfterGetRecord()
                var
                    lPaymentHeader: record "WDC-ED Payment Header";

                begin
                    BankName := '';
                    DueDate := 0D;
                    if Paiement."Payment Slip Type" = Paiement."Payment Slip Type"::Draft then
                        DueDate := Paiement."Due Date";
                    Type_Doc := Format("Document Type");
                    PaiementAmount := 0;
                    Paiement.CalcFields("Amount (LCY)", "Debit Amount (LCY)", "Credit Amount (LCY)");
                    PaiementAmount := Paiement."Amount (LCY)"; //* (-1);
                    TotalPaiement += PaiementAmount;
                    if Paiement."Document Type" = Paiement."Document Type"::Payment then
                        if lPaymentHeader.Get(Paiement."Document No.") then
                            BankName := lPaymentHeader."Bank Name";

                end;
            }

            dataitem(Integer; Integer)
            {
                DataItemTableView = SORTING(Number) ORDER(Ascending)
                                        where(Number = filter(1));

                column(Number; Number)
                {

                }
                column(Type_Doc5; Type_Doc)
                {

                }
                column(Total_recette; Total_recette)
                {

                }
                trigger OnAfterGetRecord()
                var
                begin
                    Total_recette := TotalPaiement;
                    Type_Doc := 'TOTAL';
                end;

            }

            trigger OnPreDataItem()
            var
                GLSetup: Record "General Ledger Setup";
            begin
                if (StartingDate = 0D) or (EndingDate = 0D) then
                    Error('Les dates début et fin ne doivent pas être vide!');
                if EndingDate < StartingDate then
                    Error('Date fin ne doit pas être antérieur à la date début !');
                //<<wdc03
                DateFilterTxt := StrSubstNo('%1 .. %2', StartingDate, EndingDate);
                //>>wdc03
            end;



            trigger OnAfterGetRecord()
            var
                GLSetup: record "General Ledger Setup";

            begin
                CompanyInfo.Get;
                CompanyInfo.CalcFields(Picture);
                //<<wdc03
                GLSetup.get();
                if FilteredVendor.get(Vendor."No.") then begin
                    FilteredVendor.SetFilter("Start Year Filter", '..%1', StartingDate);
                    FilteredVendor.CalcFields(Report);
                    FilteredVendor.CalcFields("Balance (LCY)");
                    FilteredVendor.CalcFields("Total Receipt");
                    TotalVendorAmount := FilteredVendor."Balance (LCY)" - FilteredVendor."Total Receipt";
                    TotalReceiptNotInvoiced := FilteredVendor."Total Receipt";

                end;
                //>>WDC03
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Filtres)
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



    }

    labels
    {
        title = 'EXTRAIT FOURNISSEUR';
        Page = 'Page';
        Date = 'Date';
        Client = 'N° Fournisseur';
        Nom_Client = 'Nom Fournisseur';
        Doc = 'N° document';
        Montant = 'Montant';
    }


    trigger OnInitReport()
    begin
        //StartingDate := DMY2Date(1, 1, Date2DMY(WorkDate, 3));
        StartingDate := DMY2Date(1, Date2DMY(WorkDate, 2), Date2DMY(WorkDate, 3));
        EndingDate := CALCDATE('<CM>', StartingDate);
    end;

    var
        StartingDate: Date;
        EndingDate: Date;
        PaiementAmount: decimal;
        Type_Doc: Text[20];
        TotalPaiement: Decimal;
        Total_recette: Decimal;
        CompanyInfo: Record 79;
        DueDate: Date;
        BankName: Text[100];
        FilteredVendor: record vendor;
        TotalVendorAmount: Decimal;
        TotalReceiptNotInvoiced: Decimal;
        DateFilterTxt: Text[100];
}
