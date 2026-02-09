report 54014 "WDC-ST Cheques"
{
    DefaultLayout = RDLC;
    RDLCLayout = './.vscode/src_ST/Report/RDLC/Chèques.rdlc';

    dataset
    {
        dataitem(WDCED_Payment_Header; "WDC-ED Payment Header")
        {
            dataitem(WDCED_Payment_Line; "WDC-ED Payment Line")
            {
                DataItemLink = "No." = FIELD("No.");
                DataItemTableView = SORTING("No.", "Line No.");
                RequestFilterFields = "No.";
                column(PaymentLineMontantinitial; WDCED_Payment_Line."Initial Amount")
                {
                }
                column(PaymentLineNcommande; WDCED_Payment_Line."Posting Group")
                {
                }


                column(dateEcheance; WDCED_Payment_Line."Due Date")
                {
                }
                column(libelle; WDCED_Payment_Line."Payment Label")
                {
                }
                column(No_document; WDCED_Payment_Line."Document No.")
                {
                }
                column(dateDoc; dateDoc)
                {
                }
                column(amount; WDCED_Payment_Line.Amount)
                {
                }
                column(CodeBeneficaire; RecGPaymentHeader."Account No.")
                {
                }
                column(NomBeneficaire; RecGPaymentHeader."Payment Slip Type")
                {
                }
                column(date_comtabilisation; RecGPaymentHeader."Posting Date")
                {
                }
                column(MntTTLettre; montant_en_lettre)
                {
                }
                column(nom_banque; RecGPaymentHeader."Bank Name")
                {
                }
                column(N_borderau; RecGPaymentHeader."No.")
                {
                }
                column(N_bord; RecGPaymentHeader."No.")
                {
                }
                column(Adressefou; Adressefou)
                {
                }
                column(InfSoc_city; RecCompany.City)
                {
                }
                column(RIB; RIB)
                {
                }
                column(TypeBank; RecBankAccount."Modèle chèques")
                {
                }
                column(MontantD; MontantD)
                {
                }
                column(Nom_Fournisseur; Rec_fournisseur.Name)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    RecGPaymentHeader.GET(WDCED_Payment_Line."No.");

                    RecGPaymentHeader.CALCFIELDS("Amount (LCY)");
                    TotalMontant := ABS((RecGPaymentHeader."Amount (LCY)"));
                    Convert_cdu."Montant en texte"(montant_en_lettre, TotalMontant);
                    CLEAR(RecBankAccount);
                    IF RecBankAccount.GET(RecGPaymentHeader."Account No.") THEN;


                    MntTTlettre := '';
                    Convert_cdu."Montant en texte"(MntTTlettre, ABS(Amount));
                end;

                trigger OnPreDataItem()
                begin
                    TotalMontant := 0;
                    montant_en_lettre := '';
                end;
            }
        }
    }
    var
        montant_en_lettre: Text;
        TotalMontant: Decimal;
        RecCompany: Record 79;
        Rec_fournisseur: Record 23;
        Convert_cdu: Codeunit "WDC-ED Conv Amount to Letter";
        Adressefou: Text;
        dateDoc: Date;
        RIB: Code[30];
        RecBankAccount: Record 270;
        RecGPaymentHeader: Record 50865;
        MntTTlettre: Text;
        MontantD: Text;
}

