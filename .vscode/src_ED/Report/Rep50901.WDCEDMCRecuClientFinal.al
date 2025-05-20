report 50901 "WDC-ED MC-Recu Client Final"
{
    DefaultLayout = RDLC;
    RDLCLayout = './.vscode/src_ED/report/RDLC/MCRecuClientFinal.rdlc';

    dataset
    {
        dataitem("Payment Header"; "WDC-ED Payment Header")
        {
            RequestFilterFields = "No.";
            column(TxtReportTitle; TxtReportTitle)
            {
            }
            column("Numéro"; "Payment Header"."No.")
            {
            }
            column(TxtCompanyName; TxtCompanyname)
            {
            }
            column(Picture; Rec_Company.Picture)
            {
            }
            column(BankBranchNo; "Payment Header"."Bank Branch No.")
            {
            }
            column(AgencyCode; "Payment Header"."Agency Code")
            {
            }
            column(BankAccountNo; "Payment Header"."Bank Account No.")
            {
            }
            column(RibKey; "Payment Header"."RIB Key")
            {
            }
            column(BankName; "Payment Header"."Bank Name")
            {
            }
            column(PostingDate; "Payment Header"."Posting Date")
            {
            }
            column("TypeRèglement_PaymentHeader"; "Payment Header"."Payment Class")
            {
            }
            column(Logo; Rec_Company.Picture)
            {
            }
            column(CompanyName; Rec_Company.Name)
            {
            }
            column(CompanyAddress; Rec_Company.Address)
            {
            }
            column(Typepaiement_PaymentHeader; "Payment Header"."Payment Class")
            {
            }
            column(NombredeLigne_PaymentHeader; "Payment Header"."No. of Lines")
            {
            }
            column(PaymentClassName_PaymentHeader; "Payment Header"."Payment Class Name")
            {
            }
            dataitem("Payment Line"; "WDC-ED Payment Line")
            {
                DataItemLink = "No." = FIELD("No."),
                               "Payment Class" = FIELD("Payment Class");
                RequestFilterFields = "No.";
                column(Increment; Increment)
                {
                }
                column(ExternelDoc; "Payment Line"."External Document No.")
                {
                }
                column(DraweeRef; "Payment Line"."Drawee Reference")
                {
                }
                column(BankAccountName; "Payment Line"."Bank Account Name")
                {
                }
                column(BankCity; "Payment Line"."Bank City")
                {
                }
                column(AmountLCY; ABS("Payment Line"."Amount (LCY)"))
                {
                }
                column(P2; Partition2)
                {
                }
                column(DueDate_PaymentLine; "Payment Line"."Due Date")
                {
                }
                column(NomAuxiliaire_PaymentLine; "Payment Line"."Status Name")
                {
                }
                column(CustName; TxtCustName)
                {
                }
                column(BanqueLigne; "Payment Line"."Drawee Reference")
                {
                }
                column(AppliestoDocType_PaymentLine; "Payment Line"."Applies-to Doc. Type")
                {
                }
                column(MontantRetenue_PaymentLine; "Payment Line".Amount)
                {
                }
                column(AppliestoDocNo_PaymentLine; "Payment Line"."Applies-to Doc. No.")
                {
                }
                column(Amount_PaymentLine; "Payment Line".Amount)
                {
                }
                column("Libellé_PaymentLine"; "Payment Line"."Account No.")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    Increment += 1;
                    CumulMntLCY += ABS("Amount (LCY)");
                    //NombreLigne:=2;
                    IF RecGCustomer.GET("Account No.") THEN BEGIN
                        TxtCustName := RecGCustomer."No." + ' - ' + RecGCustomer.Name;
                    END;
                end;

                trigger OnPreDataItem()
                begin
                    nbrl := 1
                end;
            }
            dataitem("Payment Line1"; "WDC-ED Payment Line")
            {
                DataItemLink = "No." = FIELD("No."),
                               "Payment Class" = FIELD("Payment Class");
                column(nbrl; nbrl)
                {
                }
                dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
                {
                    DataItemLink = "Applies-to ID" = FIELD("Applies-to ID");
                    DataItemTableView = WHERE("Applies-to ID" = FILTER(<> ''));
                    column(DocumentNo_CustLedgerEntry; "Cust. Ledger Entry"."Document No.")
                    {
                    }
                    column(Amount_CustLedgerEntry; "Cust. Ledger Entry".Amount)
                    {
                    }
                    column(AppliestoID_CustLedgerEntry; "Cust. Ledger Entry"."Applies-to ID")
                    {
                    }
                    column(SalespersonCode_CustLedgerEntry; "Cust. Ledger Entry"."Salesperson Code")
                    {
                    }
                    column(DocumentDate_CustLedgerEntry; "Cust. Ledger Entry"."Document Date")
                    {
                    }
                }
            }
            dataitem(Integer; Integer)
            {
                DataItemTableView = SORTING(Number)
                                    ORDER(Ascending)
                                    WHERE(Number = CONST(1));
                column(MntLettre; TexteLettre)
                {
                }
                column(CumulMntLCY; test)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    test += CumulMntLCY;
                    CU_MntLettre."Montant en texteDevise"(TexteLettre, (ABS(test)), PrintCurrencyCode());

                    //TexteLettre := CU_MntLettre."Montant en texte"((ABS(test)));
                end;

                trigger OnPreDataItem()
                begin
                    test := 0;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                Increment := 0;
                Rec_Company.GET;
                Rec_Company.CALCFIELDS(Picture);
                TxtCompanyname := Rec_Company.Name;
                CumulMntLCY := 0;
            end;
        }
    }

    procedure PrintCurrencyCode(): Code[10]
    begin
        if "Payment Line1"."Currency Code" = '' then begin
            GLSetup.Get();
            exit(GLSetup."LCY Code");
        end;
        exit("Payment Line1"."Currency Code");
    end;

    var
        TxtCompanyname: Code[50];
        Increment: Integer;
        GLSetup: Record "General Ledger Setup";
        Rec_Company: Record "Company Information";
        CU_MntLettre: Codeunit "WDC-ED Conv Amount to Letter";
        TexteLettre: Text[1024];
        CumulMntLCY: Decimal;
        test: Decimal;
        Partition: array[20] of Decimal;
        Partition2: Decimal;
        NombreLigne: Decimal;
        Pagination: array[100] of Decimal;
        TxtTitre: TextConst ENU = 'BORDEREAU DE REMISE  %1  A L''ENCAISSEMENT',
                            FRA = 'BORDEREAU DE REMISE  %1  A L''ENCAISSEMENT';
        TxtReportTitle: Text[250];
        RecGCustomer: Record Customer;
        TxtCustName: Text[200];
        "NbChèque": Integer;
        nbrl: Integer;
        PaymentHeader: Record "WDC-ED Payment Header";

}

