report 54000 "WDC-ST Ordres de virement"
{
    DefaultLayout = RDLC;
    RDLCLayout = '.\.vscode\src_ST\report\RDLC\Ordresdevirement.rdlc';

    dataset

    {
        dataitem("Payment Header"; "WDC-ED Payment Header")
        {
            column(BankBranchNo; "Payment Header"."Bank Branch No.")
            {
            }
            column(AgencyCode; "Payment Header"."Agency Code")
            {
            }
            column(BankAccountNo; "Payment Header"."Bank Account No.")
            {
            }
            column(RibKey; "Payment Header"."Bank Branch No." + "Payment Header"."Agency Code" + "Payment Header"."Bank Account No." + FORMAT("Payment Header"."RIB Key"))
            {
            }
            column(BankName; "Payment Header"."Bank Name")
            {
            }
            column(PostingDate; "Payment Header"."Posting Date")
            {
            }
            column("TypeRèglement_PaymentHeader"; "Payment Header"."Payment Methode Code")
            {
            }
            column(Typepaiement_PaymentHeader; "Payment Header"."Payment Amount Type")
            {
            }
            column(Type_Reglement; "Payment Header"."Payment Methode Code")
            {
            }

            dataitem("Payment Line"; "WDC-ED Payment Line")
            {
                column("Numéro"; "Payment Line"."No.")
                {
                }
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
                column(TxtAdresse; TXTADRESSE)
                {
                }
                column(MatriculeFiscal; Rec_Company."VAT Registration No.")
                {
                }
                column(NameBanque; FORMAT("Payment Line"."Account No.") + ' : ' + FORMAT("Payment Line"."Payment Label"))
                {
                }
                column(NomUtilisateur; RecUser."Full Name")
                {
                }
                column(CityBanque; RecGBanque.City)
                {
                }
                column(NomDeLaBanque; RecBankAccount.Name)
                {
                }
                column(TxtReportTitle; TxtReportTitle)
                {
                }
                column(TxtCompanyName; TxtCompanyname)
                {
                }
                column(Picture; Rec_Company.Picture)
                {
                }
                column(Montant; "Payment Line".Amount)
                {
                }
                column(BankAccountNo_PaymentLine; "Payment Line"."Bank Account No.")
                {
                }

                column(BankAccountCode_PaymentLine; "Payment Line"."Bank Account Code")
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
                column(NomeBank; RecBankAccount.Name)
                {
                }
                column(MntLettre; TexteLettre)
                {
                }
                column(Commentaires_PaymentLine; "Payment Line".Comments)
                {
                }
                column(AccountNo_PaymentLine; "Payment Line"."Account No.")
                {
                }
                column("Libellé_PaymentLine"; "Payment Line"."Payment Label")
                {
                }
                column(DocLettrer; DocLettrer)
                {
                }
                column(CompteBK; CompteBK)
                {
                }
                column(Bank; Bank)
                {
                }
                column("RibEntête_PaymentLine"; "Payment Line"."Header RIB")
                {
                }
                column(RIBBK; RIBBK)
                {
                }
                column(NomBk; NomBk)
                {
                }
                column(AddressBk; AddressBk)
                {
                }
                column(ListFactLettr; ListFactLettr)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    CumulMntLCY += ABS("Amount (LCY)");
                    Increment += 1;
                    RIBBK := '';
                    IF RecGBanque.GET("Account No.") THEN;
                    IF "Payment Header".GET("No.") THEN;

                    IF "Payment Header"."Account Type" = "Payment Header"."Account Type"::"Bank Account" THEN BEGIN
                        RecBankAccountEntete.SETFILTER(RecBankAccountEntete."No.", '%1', "Payment Header"."Account No.");
                        IF RecBankAccountEntete.FINDFIRST THEN;
                        BEGIN
                            RIBBK := RecBankAccountEntete."Bank Account No.";
                            NomBk := RecBankAccountEntete.Name;
                            AddressBk := RecBankAccountEntete.Address;

                        END;
                    END;

                    TexteLettre := '';
                    CU_MntLettre."Montant en texte"(TexteLettre, ABS(CumulMntLCY));
                    /// Get User Id
                    CLEAR(RecUser);
                    RecUser.SETRANGE(RecUser."User Name", USERID);
                    IF RecUser.FINDFIRST THEN;

                    // Get Bank
                    CompteBK := '';
                    Bank := '';
                    CLEAR(RecBankAccount);
                    RecBankAccount.SETFILTER(RecBankAccount.Code, '%1', "Bank Account Code");
                    RecBankAccount.SETRANGE("Customer No.", "Payment Line"."Account No.");
                    IF RecBankAccount.FINDFIRST THEN;
                    BEGIN
                    END;

                    IF "Payment Line"."Account Type" = "Payment Line"."Account Type"::"Bank Account" THEN BEGIN
                        CLEAR(RecBankAccount1);
                        RecBankAccount1.SETRANGE(RecBankAccount1."No.", "Account No.");
                        IF RecBankAccount1.FINDFIRST THEN
                            CompteBK := RecBankAccount1."Bank Account No.";
                        Bank := RecBankAccount1.Name;

                    END;

                    IF "Payment Line"."Account Type" = "Payment Line"."Account Type"::Vendor THEN BEGIN
                        CLEAR(VendorBankAccount);
                        VendorBankAccount.SETRANGE(VendorBankAccount."Vendor No.", "Account No.");
                        VendorBankAccount.SETRANGE(Code, "Payment Line"."Bank Account Code");
                        IF VendorBankAccount.FINDFIRST THEN
                            CompteBK := VendorBankAccount."Agency Code" + VendorBankAccount."Bank Account No." + FORMAT(VendorBankAccount."RIB Key");
                        Bank := VendorBankAccount.Name;


                    END;

                    IF PaymentHeader.GET("Payment Line"."No.") THEN;
                    ListFactLettr := '';
                    IDLettrage_ := '';
                    IDLettrage_ := "Payment Line"."No." + '/' + FORMAT("Payment Line"."Line No.");
                    VendLedgerEntry.SETRANGE("Applies-to ID", IDLettrage_);
                    IF VendLedgerEntry.FINDSET THEN
                        REPEAT
                            ListFactLettr += VendLedgerEntry."Document No." + ',';
                        UNTIL VendLedgerEntry.NEXT = 0;
                end;

                trigger OnPreDataItem()
                begin
                    Increment := 1;
                    IF Rec_Company.GET() THEN;
                    Rec_Company.CALCFIELDS(Picture);
                    TxtCompanyname := Rec_Company.Name;
                    TXTADRESSE := Rec_Company.Address + ' ' + Rec_Company.City + ' ' + Rec_Company."Post Code";
                    CumulMntLCY := 0;
                end;
            }
        }

        dataitem(DataItem1000000037; 2000000026)
        {
            DataItemTableView = SORTING(Number)
                                ORDER(Ascending)
                                WHERE(Number = CONST(1));
            column(CumulMntLCY; CumulMntLCY)
            {
            }
            column(MontantLettrer; MontantLettrer)
            {
            }
        }
    }

    var
        TxtCompanyname: Code[50];
        Increment: Integer;
        Rec_Company: Record 79;
        CU_MntLettre: Codeunit "WDC-ST MontantTouteLettre";
        TexteLettre: Text[1024];
        CumulMntLCY: Decimal;
        Partition2: Decimal;
        TxtReportTitle: Text[250];
        RecGBanque: Record 23;
        MontantLettrer: Decimal;
        TXTADRESSE: Text;
        RecUser: Record 2000000120;
        RecBankAccount: Record 287;
        DocLettrer: Text;
        RecBankAccount1: Record 270;
        CompteBK: Text;
        VendorBankAccount: Record 288;
        Bank: Text;
        RecBankAccountEntete: Record 270;
        RIBBK: Text;
        NomBk: Text;
        AddressBk: Text;
        ListFactLettr: Text[1024];
        VendLedgerEntry: Record 25;
        IDLettrage_: Code[50];
        PaymentHeader: Record 50865;
}

