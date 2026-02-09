//**************Documentation**************
// WDC.FS 12/06/2025: Create report for WDC Ordre de virement
report 54013 "WDC-ST Ordre de virement"
{
    CaptionML = ENU = 'Transfer order', FRA = 'Ordre de virement';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = './.vscode/src_ST/Report/RDLC/WDC_Ordre_de_virement.rdl';

    dataset
    {
        dataitem(CompanyInformation; "Company Information")
        {
            DataItemTableView = sorting("Primary Key");
            column(CompanyPicture; Picture)
            {

            }
            column(CompanyName; Name)
            {

            }

            dataitem("Payment Header"; "WDC-ED Payment Header")
            {

                dataitem("Payment Line"; "WDC-ED Payment Line")
                {
                    DataItemTableView = sorting("No.", "Line No.");
                    DataItemLink = "No." = FIELD("No.");
                    column(Amount__LCY_; "Amount (LCY)")
                    {
                    }
                    column(Vendor_No_; "Account No.")
                    {
                    }
                    column(PaymentLineNo; "Line No.")
                    {
                    }

                    column(Vendor_Name; "Payment Label")
                    {
                    }
                    column(Posting_Date; "Posting Date")
                    {
                    }
                    column(AmountInWords; "AmountInWords")
                    {
                    }
                    column(CodeBankDigit1; CodeBankDigits[1]) { }
                    column(CodeBankDigit2; CodeBankDigits[2]) { }

                    // CodeAgence digits
                    column(CodeAgenceDigit1; CodeAgenceDigits[1]) { }
                    column(CodeAgenceDigit2; CodeAgenceDigits[2]) { }
                    column(CodeAgenceDigit3; CodeAgenceDigits[3]) { }


                    // NumCompte digits
                    column(NumCompteDigit1; NumCompteDigits[1]) { }
                    column(NumCompteDigit2; NumCompteDigits[2]) { }
                    column(NumCompteDigit3; NumCompteDigits[3]) { }
                    column(NumCompteDigit4; NumCompteDigits[4]) { }
                    column(NumCompteDigit5; NumCompteDigits[5]) { }
                    column(NumCompteDigit6; NumCompteDigits[6]) { }
                    column(NumCompteDigit7; NumCompteDigits[7]) { }
                    column(NumCompteDigit8; NumCompteDigits[8]) { }
                    column(NumCompteDigit9; NumCompteDigits[9]) { }
                    column(NumCompteDigit10; NumCompteDigits[10]) { }
                    column(NumCompteDigit11; NumCompteDigits[11]) { }
                    column(NumCompteDigit12; NumCompteDigits[12]) { }
                    column(NumCompteDigit13; NumCompteDigits[13]) { }

                    // LastTwo digits
                    column(LastTwoDigit1; LastTwoDigits[1]) { }
                    column(LastTwoDigit2; LastTwoDigits[2]) { }
                    column(NumCompteDigit1_1; NumBankDigits1[1]) { }
                    column(NumCompteDigit1_2; NumBankDigits1[2]) { }
                    column(NumCompteDigit1_3; NumBankDigits1[3]) { }
                    column(NumCompteDigit1_4; NumBankDigits1[4]) { }
                    column(NumCompteDigit1_5; NumBankDigits1[5]) { }
                    column(NumCompteDigit1_6; NumBankDigits1[6]) { }
                    column(NumCompteDigit1_7; NumBankDigits1[7]) { }
                    column(NumCompteDigit1_8; NumBankDigits1[8]) { }
                    column(NumCompteDigit1_9; NumBankDigits1[9]) { }
                    column(NumCompteDigit1_10; NumBankDigits1[10]) { }
                    column(NumCompteDigit1_11; NumBankDigits1[11]) { }
                    column(NumCompteDigit1_12; NumBankDigits1[12]) { }
                    column(NumCompteDigit1_13; NumBankDigits1[13]) { }


                    trigger OnAfterGetRecord()
                    var
                        tmpText: Text;
                        CurrencyCode: Code[10];
                        SubTotal: Decimal;
                    begin
                        SubTotal := "Payment Line"."Amount (LCY)";
                        MontantTouteLettre."Montant en texte"(tmpText, SubTotal);
                        AmountInWords := tmpText;
                        CompanyInfo.CALCFIELDS(Picture);
                        N_Compte_bancaire := "Payment Line"."Bank Account No.";//'12345678901234567890';
                        SplitAccountNumber(N_Compte_bancaire,
                    CodeBank, CodeAgence, NumCompte, LastTwo,
                    CodeBankDigits, CodeAgenceDigits, NumCompteDigits, LastTwoDigits);
                        N_Compte_bancaire1 := "Payment Line"."Header RIB"; //"Payment Header"."Bank Account No.";//'1234567890123';
                        SplitAccountNumber1(N_Compte_bancaire1, NumCompte, NumBankDigits1);
                    end;
                }
            }
        }
    }

    var
        AmountInWords: Text[100];
        MontantTouteLettre: Codeunit "WDC-ST MontantTouteLettre";
        CompanyInfo: Record "Company Information";
        N_Compte_bancaire: Text[20];
        CodeBankDigits: array[2] of Text[1];
        CodeAgenceDigits: array[3] of Text[1];
        NumCompteDigits: array[13] of Text[1];
        LastTwoDigits: array[2] of Text[1];
        CodeBank: Text[2];
        CodeAgence: Text[3];
        NumCompte: Text[13];
        LastTwo: Text[2];
        NumBankDigits1: array[13] of Text[1];
        N_Compte_bancaire1: Text[20];


    procedure SplitAccountNumber(InputNum: Text[20]; var CodeBank: Text[2]; var CodeAgence: Text[3]; var NumCompte: Text[13]; var LastTwo: Text[2]; var CodeBankDigits: array[2] of Text[1];
    var CodeAgenceDigits: array[3] of Text[1];
    var NumCompteDigits: array[13] of Text[1];
    var LastTwoDigits: array[2] of Text[1])
    var
        InputText: Text[20];
        i: Integer;

    begin
        InputText := InputNum;
        CodeBank := CopyStr(InputText, 1, 2);
        CodeAgence := CopyStr(InputText, 3, 3);
        NumCompte := CopyStr(InputText, 6, 13);
        LastTwo := CopyStr(InputText, 19, 2);
        for i := 1 to 2 do
            CodeBankDigits[i] := CopyStr(CodeBank, i, 1);

        for i := 1 to 3 do
            CodeAgenceDigits[i] := CopyStr(CodeAgence, i, 1);

        for i := 1 to 13 do
            NumCompteDigits[i] := CopyStr(NumCompte, i, 1);

        for i := 1 to 2 do
            LastTwoDigits[i] := CopyStr(LastTwo, i, 1);

    end;

    procedure SplitAccountNumber1(InputNum: Text[20]; var NumCompte: Text[13]; var NumBankDigits1: array[2] of Text[1])
    var
        InputText: Text[20];
        i: Integer;
    begin
        InputText := InputNum;
        NumCompte := CopyStr(InputText, 6, 13);
        for i := 1 to 13 do
            NumBankDigits1[i] := CopyStr(NumCompte, i, 1);

    end;

    trigger OnPreReport()
    begin
        CompanyInfo.Get();
    end;

}
