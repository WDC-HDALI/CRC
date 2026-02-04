report 54016 "WDC-ST Customer Draft"
{
    // Version    Requirement  UserID   Date         Where       Description
    // -----------------------------------------------------------------------------------------------------------------
    DefaultLayout = RDLC;
    RDLCLayout = '.\.vscode\src_ST\report\RDLC\CustomerDraft.rdlc';
    dataset
    {
        dataitem("Customer ledger Entry"; "Cust. Ledger Entry")
        {
            DataItemTableView = where("Document Type" = const(Payment));
            column(date_comtabilisation; "Posting Date")
            {
            }
            column(MntTTLettre; montant_en_lettre)
            {
            }
            column(nom_banque; "Bank Name")
            {
            }
            column(Picture; RecCompany.Picture)
            {
            }
            column(InfSoc_city; RecCompany.City)
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
            column(amount; Amount)
            {
            }
            column(dateEcheance; "Due Date")
            {
            }
            column(NomAuxiliaire_PaymentLine; CopyStr("Customer Name", 1, 50))
            {
            }
            column(No_document; "Document No.")
            {
            }
            trigger OnAfterGetRecord()
            var
                lCustBankaccount: Record "Customer Bank Account";
            begin
                montant_en_lettre := '';
                Convert_cdu."Montant en texte"(montant_en_lettre, ABS(Amount));
                IF RecCompany.GET() THEN
                    RecCompany.CALCFIELDS(RecCompany.Picture);
                lCustBankaccount.Reset();
                lCustBankaccount.SETRANGE("Customer No.", "Customer No.");
                if lCustBankaccount.FindFirst() then begin
                    CustBankAccounCode := lCustBankaccount.Code;
                    EVALUATE(Rkey, FORMAT(lCustBankaccount."RIB Key"));
                    RIB := lCustBankaccount."Bank Branch No." + lCustBankaccount."Agency Code" + lCustBankaccount."Bank Account No." + Rkey;
                    ch1 := COPYSTR(lCustBankaccount."Bank Account No.", 1, 2);
                    ch2 := COPYSTR(lCustBankaccount."Bank Account No.", 3, 3);
                    ch3 := COPYSTR(lCustBankaccount."Bank Account No.", 6, 13);
                    ch4 := COPYSTR(lCustBankaccount."Bank Account No.", 19, 2);
                end;
            end;

            trigger OnPreDataItem()
            begin
                montant_en_lettre := '';
            end;

        }

    }
    // requestpage
    // {

    //     layout
    //     {
    //         area(content)
    //         {
    //             group(Group)
    //             {
    //                 CaptionML = ENU = 'Filters', FRA = 'Filtres';

    //                 field(CustBankAccounCode; CustBankAccounCode)
    //                 {
    //                     CaptionML = ENU = 'Customer Bank Account', FRA = 'Banque Client';
    //                     ApplicationArea = All;
    //                 }

    //             }
    //         }
    //     }
    // }
    var
        montant_en_lettre: Text;
        RecCompany: Record "Company Information";
        Convert_cdu: codeunit "WDC-ED Conv Amount to Letter";
        RIB: Code[30];
        RecBankAccount: Record "Bank Account";
        Rkey: Text[2];
        ch1: Code[10];
        ch2: Code[3];
        ch3: Code[13];
        ch4: Code[2];
        CustBankAccounCode: Code[20];

}
