report 54012 "WDC-ST Draft"
{
    // Version    Requirement  UserID   Date         Where       Description
    // -----------------------------------------------------------------------------------------------------------------
    DefaultLayout = RDLC;
    RDLCLayout = '.\.vscode\src_ST\report\RDLC\Draft.rdlc';


    dataset
    {
        dataitem("Payment Header"; "WDC-ED Payment Header")
        {
            column(CodeBeneficaire; "Payment Header"."Account No.")
            {
            }
            column(NomBeneficaire; "Payment Header"."Payment Slip Type")
            {
            }
            column(date_comtabilisation; "Payment Header"."Posting Date")
            {
            }
            column(MntTTLettre; montant_en_lettre)
            {
            }
            column(nom_banque; "Payment Header"."Bank Name")
            {
            }

            column(N_borderau; "Payment Header"."No.")
            {
            }
            column(Picture; RecCompany.Picture)
            {
            }
            column(typepaiment; "Payment Header"."Payment Slip Type")
            {
            }
            column(N_bord; "Payment Header"."No.")
            {
            }
            column(Adressefou; Adressefou)
            {
            }
            column(InfSoc_city; RecCompany.City)
            {
            }
            column(RIB; RecBankAccount."Bank Account No.")
            {
            }
            column(name; RecCompany.Name)
            {
            }
            column(adresse; RecCompany.Address)
            {
            }
            column(adresse2; RecCompany."Address 2")
            {
            }
            column(postcode; RecCompany."Post Code")
            {
            }
            column(county; RecCompany.County)
            {
            }
            column(ch2; ch2)
            {
            }
            column(ch3; ch3)
            {
            }
            column(ch4; ch4)
            {
            }
            column(ch1; ch1)
            {
            }
            column(TotalMontant; TotalMontant)
            {
            }
            dataitem("Payment Line"; "WDC-ED Payment Line")
            {
                DataItemLink = "No." = FIELD("No.");
                column(PaymentLineMontantinitial; "Payment Line"."Initial Amount")
                {
                }
                column("PaymentLineMontantRetenueValidé"; "Payment Line"."RS Amount")
                {
                }
                // column(PaymentLineNcommande; "Payment Line"."N° commande")
                // {
                // }
                column(dateEcheance; "Payment Line"."Due Date")
                {
                }
                // column(N_cheque; "Payment Line"."Contrepartie Ligne de paiement")
                // {
                // }

                column(NomAuxiliaire_PaymentLine; CopyStr(Rec_fournisseur.Name, 1, 18))
                {
                }
                column(libelle; "Payment Line"."Payment Label")
                {
                }
                column(No_document; "Payment Line"."Document No.")
                {
                }
                column(dateDoc; dateDoc)
                {
                }
                column(amount; "Payment Line".Amount)
                {
                }
                column(LineNo; "Line No.")
                {
                }
                column(ribtest; "RIB")
                {

                }

                trigger OnAfterGetRecord()
                begin
                    TotalMontant := 0;
                    montant_en_lettre := '';
                    TotalMontant := ABS("Payment Line".Amount);
                    Convert_cdu."Montant en texte"(montant_en_lettre, TotalMontant);
                    IF "Payment Line"."Account Type" = "Payment Line"."Account Type"::Vendor THEN begin
                        Rec_fournisseur.RESET;
                        if Rec_fournisseur.get("Payment Line"."Account No.") then;
                        // Adressefou := Rec_fournisseur.Address + Rec_fournisseur."Address 2" + Rec_fournisseur.City + Rec_fournisseur."Post Code";
                    end;


                    //date document
                    // Rec_salesinvoice.RESET;
                    // Rec_salesinvoice.SETRANGE(Rec_salesinvoice."No.", "Payment Line"."No.");
                    // IF Rec_salesinvoice.FINDFIRST THEN
                    //     dateDoc := Rec_salesinvoice."Document Date";
                end;
            }

            trigger OnAfterGetRecord()
            begin
                // RecPaymentLine.RESET;
                // RecPaymentLine.SETRANGE(RecPaymentLine."No.", "Payment Header"."No.");
                //IF RecPaymentLine.FINDFIRST THEN;
                //     REPEAT
                //         TotalMontantIN := TotalMontantIN + RecPaymentLine."Initial Amount";
                //         TotalRetenue := TotalRetenue + RecPaymentLine."RS Amount";

                //     UNTIL RecPaymentLine.NEXT = 0;
                //CALCFIELDS("Payment Header".Amount);
                //TotalMontant := ABS("Payment Header".Amount);
                //Convert_cdu."Montant en texte"(ABS(TotalMontant));
                IF RecCompany.GET() THEN;
                RecCompany.CALCFIELDS(RecCompany.Picture);
                IF RecBankAccount.GET("Payment Header"."Account No.") THEN;
                EVALUATE(Rkey, FORMAT(RecBankAccount."RIB Key"));
                RIB := RecBankAccount."Bank Branch No." + RecBankAccount."Agency Code" +
                RecBankAccount."Bank Account No." + Rkey;
                // ch1 := COPYSTR(RecPaymentLine."Header RIB", 1, 2);
                // ch2 := COPYSTR(RecPaymentLine."Header RIB", 3, 3);
                // ch3 := COPYSTR(RecPaymentLine."Header RIB", 6, 13);
                // ch4 := COPYSTR(RecPaymentLine."Header RIB", 19, 2);
                ch1 := COPYSTR("Payment Header"."Bank Account No.", 1, 2);
                ch2 := COPYSTR("Payment Header"."Bank Account No.", 3, 3);
                ch3 := COPYSTR("Payment Header"."Bank Account No.", 6, 13);
                ch4 := COPYSTR("Payment Header"."Bank Account No.", 19, 2);
            end;

            trigger OnPreDataItem()
            begin
                TotalMontant := 0;
                montant_en_lettre := '';
            end;
        }
    }
    var
        montant_en_lettre: Text;
        Rec_salesInvoices: Record "Sales Invoice Header";
        TotalMontant: Decimal;
        RecPaymentLine: Record "WDC-ED Payment Line";
        RecCompany: Record "Company Information";
        Adresse: Text[100];
        Siege: Text[100];
        CP: Text[50];
        Rec_fournisseur: Record Vendor;
        //Convert_cdu: Codeunit "50001";
        Convert_cdu: codeunit "WDC-ED Conv Amount to Letter";
        Adressefou: Text;
        Rec_salesinvoice: Record "Sales Invoice Header";
        dateDoc: Date;
        RIB: Code[30];
        RecBankAccount: Record "Bank Account";
        Rkey: Text[2];
        TotalMontantIN: Decimal;
        TotalRetenue: Decimal;
        ch1: Code[10];
        ch2: Code[3];
        ch3: Code[13];
        ch4: Code[2];
}

