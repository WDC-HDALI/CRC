report 54001 "WDC-ST Retenu a la source"
{
    DefaultLayout = RDLC;
    RDLCLayout = '.\.vscode\src_ST\report\RDLC\Retenualasource.rdlc';

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
            column(Typepaiement_PaymentHeader; "Payment Amount Type")
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
                column(MontantRetenue_PaymentLine; "Payment Line"."RS Amount")
                {
                }
                column(JobNo_PaymentLine; "Payment Line"."Job No.")
                {
                }
                column(AssietteRS_PaymentLine; "Payment Line"."Assiette RS")
                {
                }
                column(AdresseClient; RecVendor.Address + ' ' + RecVendor.City + ' ' + RecVendor."Post Code")
                {
                }
                column(MatriculeClient; RecVendor."VAT Registration No.")
                {
                }
                column(ImpDate; ImpDate)
                {
                }
                column(MatEntrep; MatEntrep)
                {
                }
                column(CdeTva; CdeTva)
                {
                }
                column(Categorie; Categorie)
                {
                }
                column(Etab; Etab)
                {
                }
                column(MatEntrepEntrep; MatEntrepEntrep)
                {
                }
                column(CdeTvaEntrep; CdeTvaEntrep)
                {
                }
                column(CategorieEntrep; CategorieEntrep)
                {
                }
                column(EtabEntrep; EtabEntrep)
                {
                }
                column(DescRentenu; RecGroupeRetenue.Description)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    ImpDate := WORKDATE;
                    CumulMntLCY += ABS("Amount (LCY)");
                    Increment += 1;
                    IF RecGBanque.GET("Account No.") THEN;
                    IF "Payment Header".GET("No.") THEN;
                    TexteLettre := '';
                    CU_MntLettre."Montant en texte"(TexteLettre, ABS(CumulMntLCY));
                    /// Get User Id
                    CLEAR(RecUser);
                    RecUser.SETRANGE(RecUser."User Name", USERID);
                    IF RecUser.FINDFIRST THEN;

                    // Get Bank
                    CLEAR(RecBankAccount);
                    RecBankAccount.SETFILTER(RecBankAccount.Code, '%1', "Bank Account Code");
                    RecBankAccount.SETRANGE("Customer No.", "Payment Line"."Account No.");
                    IF RecBankAccount.FINDFIRST THEN;
                    BEGIN
                    END;


                    // GET CUSTOMER
                    CLEAR(RecVendor);
                    IF RecVendor.GET("Payment Line"."Account No.") THEN

                        // Code TVA Client
                        NewMat := '';
                    MatEntrep := '';
                    CdeTva := '';
                    Categorie := '';
                    Etab := '';


                    NewMat := DELCHR(RecVendor."VAT Registration No.", '=', '/|\| ');
                    MatEntrep := COPYSTR(NewMat, 1, 8);
                    CdeTva := COPYSTR(NewMat, 9, 1);
                    Categorie := COPYSTR(NewMat, 10, 1);
                    Etab := COPYSTR(NewMat, 11, 3);


                    // Get Description de retenu
                    CLEAR(RecGroupeRetenue);
                    RecGroupeRetenue.SETRANGE(RecGroupeRetenue.Code, "Payment Line"."RS Code");
                    IF RecGroupeRetenue.FINDFIRST THEN;
                end;

                trigger OnPreDataItem()
                begin
                    Increment := 1;
                    IF Rec_Company.GET() THEN;
                    Rec_Company.CALCFIELDS(Picture);
                    TxtCompanyname := Rec_Company.Name;
                    TXTADRESSE := Rec_Company.Address + ' ' + Rec_Company.City + ' ' + Rec_Company."Post Code";
                    CumulMntLCY := 0;


                    NewMatEntrep := DELCHR(Rec_Company."VAT Registration No.", '=', '/|\| ');
                    MatEntrepEntrep := COPYSTR(NewMatEntrep, 1, 8);
                    CdeTvaEntrep := COPYSTR(NewMatEntrep, 9, 1);
                    CategorieEntrep := COPYSTR(NewMatEntrep, 10, 1);
                    EtabEntrep := COPYSTR(NewMatEntrep, 11, 3);

                    SETFILTER("Payment Line"."RS Amount", '<>%1', 0);
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

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
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
        RecVendor: Record 23;
        ImpDate: Date;
        MatEntrep: Text;
        CdeTva: Text;
        Categorie: Text;
        Etab: Text;
        NewMat: Text;
        MatEntrepEntrep: Text;
        CdeTvaEntrep: Text;
        CategorieEntrep: Text;
        EtabEntrep: Text;
        NewMatEntrep: Text;
        RecGroupeRetenue: Record "WDC-ST Retained Group";
}

