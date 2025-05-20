report 50871 "WDC-ED Withdraw recapitulation"
{
    DefaultLayout = RDLC;
    RDLCLayout = './.vscode/src_ED/report/RDLC/Withdrawrecapitulation.rdlc';
    captionML = ENU = 'Withdraw recapitulation', FRA = 'Récapitulatif de prélèvement';

    dataset
    {
        dataitem("Payment Lines1"; "WDC-ED Payment Line")
        {
            DataItemTableView = SORTING("No.", "Line No.");
            MaxIteration = 1;
            PrintOnlyIfDetail = true;
            column(Payment_Lines1_No_; "No.")
            {
            }
            column(Payment_Lines1_Line_No_; "Line No.")
            {
            }
            dataitem(CopyLoop; "Integer")
            {
                DataItemTableView = SORTING(Number);
                dataitem(PageLoop; "Integer")
                {
                    DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                    column(PaymtHeader__No__; PaymtHeader."No.")
                    {
                    }
                    column(STRSUBSTNO_Text005_CopyText_; StrSubstNo(Text005, CopyText))
                    {
                    }
                    column(CompanyAddr_1_; CompanyAddr[1])
                    {
                    }
                    column(CompanyAddr_2_; CompanyAddr[2])
                    {
                    }
                    column(CompanyAddr_3_; CompanyAddr[3])
                    {
                    }
                    column(CompanyAddr_4_; CompanyAddr[4])
                    {
                    }
                    column(CompanyAddr_5_; CompanyAddr[5])
                    {
                    }
                    column(CompanyAddr_6_; CompanyAddr[6])
                    {
                    }
                    column(CompanyInformation__Phone_No__; CompanyInformation."Phone No.")
                    {
                    }
                    column(CompanyInformation__Fax_No__; CompanyInformation."Fax No.")
                    {
                    }
                    column(CompanyInformation__VAT_Registration_No__; CompanyInformation."VAT Registration No.")
                    {
                    }
                    column(FORMAT_PostingDate_0_4_; Format(PostingDate, 0, 4))
                    {
                    }
                    column(BankAccountAddr_4_; BankAccountAddr[4])
                    {
                    }
                    column(BankAccountAddr_5_; BankAccountAddr[5])
                    {
                    }
                    column(BankAccountAddr_6_; BankAccountAddr[6])
                    {
                    }
                    column(BankAccountAddr_7_; BankAccountAddr[7])
                    {
                    }
                    column(BankAccountAddr_3_; BankAccountAddr[3])
                    {
                    }
                    column(BankAccountAddr_2_; BankAccountAddr[2])
                    {
                    }
                    column(BankAccountAddr_1_; BankAccountAddr[1])
                    {
                    }
                    column(PrintCurrencyCode; PrintCurrencyCode)
                    {
                    }
                    column(PaymtHeader__Bank_Branch_No__; PaymtHeader."Bank Branch No.")
                    {
                    }
                    column(PaymtHeader__Agency_Code_; PaymtHeader."Agency Code")
                    {
                    }
                    column(PaymtHeader__Bank_Account_No__; PaymtHeader."Bank Account No.")
                    {
                    }
                    column(PaymtHeader__RIB_Key_; PaymtHeader."RIB Key")
                    {
                    }
                    column(PaymtHeader__National_Issuer_No__; PaymtHeader."National Issuer No.")
                    {
                    }
                    column(OutputNo; OutputNo)
                    {
                    }
                    column(PaymtHeader_IBAN; PaymtHeader.IBAN)
                    {
                    }
                    column(PaymtHeader__SWIFT_Code_; PaymtHeader."SWIFT Code")
                    {
                    }
                    column(PageLoop_Number; Number)
                    {
                    }
                    column(PaymtHeader__No__Caption; PaymtHeader__No__CaptionLbl)
                    {
                    }
                    column(CompanyInformation__Phone_No__Caption; CompanyInformation__Phone_No__CaptionLbl)
                    {
                    }
                    column(CompanyInformation__Fax_No__Caption; CompanyInformation__Fax_No__CaptionLbl)
                    {
                    }
                    column(CompanyInformation__VAT_Registration_No__Caption; CompanyInformation__VAT_Registration_No__CaptionLbl)
                    {
                    }
                    column(PrintCurrencyCodeCaption; PrintCurrencyCodeCaptionLbl)
                    {
                    }
                    column(PaymtHeader__Bank_Branch_No__Caption; PaymtHeader__Bank_Branch_No__CaptionLbl)
                    {
                    }
                    column(PaymtHeader__Agency_Code_Caption; PaymtHeader__Agency_Code_CaptionLbl)
                    {
                    }
                    column(PaymtHeader__Bank_Account_No__Caption; PaymtHeader__Bank_Account_No__CaptionLbl)
                    {
                    }
                    column(PaymtHeader__RIB_Key_Caption; PaymtHeader__RIB_Key_CaptionLbl)
                    {
                    }
                    column(PaymtHeader__National_Issuer_No__Caption; PaymtHeader__National_Issuer_No__CaptionLbl)
                    {
                    }
                    column(PageCaption; PageCaptionLbl)
                    {
                    }
                    column(PaymtHeader_IBANCaption; PaymtHeader_IBANCaptionLbl)
                    {
                    }
                    column(PaymtHeader__SWIFT_Code_Caption; PaymtHeader__SWIFT_Code_CaptionLbl)
                    {
                    }
                    dataitem("Payment Lines"; "WDC-ED Payment Line")
                    {
                        DataItemLink = "No." = FIELD("No.");
                        DataItemLinkReference = "Payment Lines1";
                        DataItemTableView = SORTING("No.", "Line No.");
                        column(ABS_Amount_; Abs(Amount))
                        {
                            AutoFormatExpression = "Currency Code";
                            AutoFormatType = 1;
                        }
                        column(PrintCurrencyCode_Control1120060; PrintCurrencyCode)
                        {
                        }
                        column(Customer_Name; Customer.Name)
                        {
                        }
                        column(Payment_Lines__Bank_Branch_No__; "Bank Branch No.")
                        {
                        }
                        column(ABS_Amount__Control1120031; Abs(Amount))
                        {
                            AutoFormatExpression = "Currency Code";
                            AutoFormatType = 1;
                        }
                        column(Payment_Lines__Bank_Account_Name_; "Bank Account Name")
                        {
                        }
                        column(Payment_Lines__Account_No__; "Account No.")
                        {
                        }
                        column(PrintCurrencyCode_Control1120061; PrintCurrencyCode)
                        {
                        }
                        column(Payment_Lines__Agency_Code_; "Agency Code")
                        {
                        }
                        column(Payment_Lines__Bank_Account_No__; "Bank Account No.")
                        {
                        }
                        column(Payment_Lines__SWIFT_Code_; "SWIFT Code")
                        {
                        }
                        column(Payment_Lines_IBAN; IBAN)
                        {
                        }
                        column(ABS_Amount__Control1120036; Abs(Amount))
                        {
                            AutoFormatExpression = "Currency Code";
                            AutoFormatType = 1;
                        }
                        column(PrintCurrencyCode_Control1120063; PrintCurrencyCode)
                        {
                        }
                        column(WithdrawAmount; WithdrawAmount)
                        {
                            AutoFormatExpression = "Currency Code";
                            AutoFormatType = 1;
                        }
                        column(PrintWithdrawCounting; PrintWithdrawCounting)
                        {
                        }
                        column(PrintCurrencyCode_Control1120064; PrintCurrencyCode)
                        {
                        }
                        column(FORMAT_PostingDate_0_4__Control1120034; Format(PostingDate, 0, 4))
                        {
                        }
                        column(CompanyInformation_City; CompanyInformation.City)
                        {
                        }
                        column(WithdrawCounting; WithdrawCounting)
                        {
                        }
                        column(Text001; Text001Lbl)
                        {
                        }
                        column(Text002; Text002Lbl)
                        {
                        }
                        column(Payment_Lines_No_; "No.")
                        {
                        }
                        column(Payment_Lines_Line_No_; "Line No.")
                        {
                        }
                        column(Payment_Lines__Account_No__Caption; FieldCaption("Account No."))
                        {
                        }
                        column(Customer_NameCaption; Customer_NameCaptionLbl)
                        {
                        }
                        column(Payment_Lines__Bank_Account_Name_Caption; FieldCaption("Bank Account Name"))
                        {
                        }
                        column(ABS_Amount__Control1120031Caption; ABS_Amount__Control1120031CaptionLbl)
                        {
                        }
                        column(Bank_AccountCaption; Bank_AccountCaptionLbl)
                        {
                        }
                        column(Payment_Lines__SWIFT_Code_Caption; Payment_Lines__SWIFT_Code_CaptionLbl)
                        {
                        }
                        column(Payment_Lines_IBANCaption; Payment_Lines_IBANCaptionLbl)
                        {
                        }
                        column(ReportCaption; ReportCaptionLbl)
                        {
                        }
                        column(ReportCaption_Control1120015; ReportCaption_Control1120015Lbl)
                        {
                        }
                        column(TotalCaption; TotalCaptionLbl)
                        {
                        }
                        column(Done_at__Caption; Done_at__CaptionLbl)
                        {
                        }
                        column(On__Caption; On__CaptionLbl)
                        {
                        }
                        column(Signature__Caption; Signature__CaptionLbl)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            Customer.SetRange("No.", "Account No.");
                            if not Customer.FindFirst then
                                Error(Text004, "Account No.");

                            WithdrawAmount := Abs(Amount);
                            WithdrawCounting := 1;
                        end;

                        trigger OnPreDataItem()
                        begin
                            Clear(WithdrawAmount);
                            Clear(WithdrawCounting);
                            SetRange("Account Type", "Account Type"::Customer);
                        end;
                    }
                }

                trigger OnAfterGetRecord()
                begin
                    if Number > 1 then begin
                        CopyText := Text003;
                        OutputNo += 1;
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    OutputNo := 1;
                    LoopsNumber := Abs(CopiesNumber) + 1;
                    CopyText := '';
                    SetRange(Number, 1, LoopsNumber);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                PaymtHeader.Get("No.");
                PostingDate := PaymtHeader."Posting Date";

                PaymtManagt.PaymentBankAcc(BankAccountAddr, PaymtHeader);
            end;

            trigger OnPreDataItem()
            begin
                SetRange("No.", WithDrawNo);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    captionML = ENU = 'Options';
                    field(CopiesNumber; CopiesNumber)
                    {
                        ApplicationArea = All;
                        captionML = ENU = 'Number of copies', FRA = 'Nombre de copies';
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        WithDrawNo := CopyStr("Payment Lines1".GetFilter("No."), 1, MaxStrLen(WithDrawNo));
        if WithDrawNo = '' then
            Error(Text006);

        CompanyInformation.Get();
        FormatAddress.Company(CompanyAddr, CompanyInformation);
    end;

    procedure PrintWithdrawCounting(): Text[30]
    begin
        if WithdrawCounting > 1 then
            exit(Format(WithdrawCounting) + Text001Lbl);

        exit(Format(WithdrawCounting) + Text002Lbl);
    end;

    procedure InitRequest(InitWithdrawNo: Code[20]; InitCopies: Integer)
    begin
        WithDrawNo := InitWithdrawNo;
        CopiesNumber := InitCopies;
    end;

    procedure PrintCurrencyCode(): Code[10]
    begin
        if "Payment Lines1"."Currency Code" = '' then begin
            GLSetup.Get();
            exit(GLSetup."LCY Code");
        end;
        exit("Payment Lines1"."Currency Code");
    end;

    var
        CompanyInformation: Record "Company Information";
        Customer: Record Customer;
        GLSetup: Record "General Ledger Setup";
        PaymtHeader: Record "WDC-ED Payment Header";
        PaymtManagt: Codeunit "WDC-ED Payment Management";
        FormatAddress: Codeunit "Format Address";
        BankAccountAddr: array[8] of Text[100];
        CompanyAddr: array[8] of Text[100];
        LoopsNumber: Integer;
        CopiesNumber: Integer;
        CopyText: Text;
        WithdrawAmount: Decimal;
        WithdrawCounting: Decimal;
        WithDrawNo: Code[20];
        PostingDate: Date;
        OutputNo: Integer;
        Text003: TextConst ENU = 'COPY',
                           FRA = 'COPIE';
        Text004: TextConst ENU = 'Customer %1 does not exist.',
                           FRA = 'Le client %1 n''existe pas.';
        Text005: TextConst ENU = 'Withdraw Recapitulation %1',
                           FRA = 'Récapitulatif de prélèvement %1';
        Text006: TextConst ENU = 'You must specify a withdraw number.',
                           FRA = 'Vous devez spécifier un numéro de prélèvement.';
        Text007: TextConst ENU = 'Page %1',
                           FRA = 'Page %1';
        PaymtHeader__No__CaptionLbl: TextConst ENU = 'Withdraw No.',
                                               FRA = 'N° prélèvement';
        CompanyInformation__Phone_No__CaptionLbl: TextConst ENU = 'Phone No.',
                                                            FRA = 'N° téléphone';
        CompanyInformation__Fax_No__CaptionLbl: TextConst ENU = 'FAX No.',
                                                          FRA = 'N° TÉLÉCOPIE';
        CompanyInformation__VAT_Registration_No__CaptionLbl: TextConst ENU = 'VAT Registration No.',
                                                                       FRA = 'N° identif. intracomm.';
        PrintCurrencyCodeCaptionLbl: TextConst ENU = 'Currency Code',
                                               FRA = 'Code devise';
        PaymtHeader__Bank_Branch_No__CaptionLbl: TextConst ENU = 'Bank Branch No.',
                                                           FRA = 'Code établissement';
        PaymtHeader__Agency_Code_CaptionLbl: TextConst ENU = 'Agency Code',
                                                       FRA = 'Code agence';
        PaymtHeader__Bank_Account_No__CaptionLbl: TextConst ENU = 'Bank Branch No.',
                                                           FRA = 'Code établissement';
        PaymtHeader__RIB_Key_CaptionLbl: TextConst ENU = 'RIB Key',
                                                   FRA = 'Clé RIB';
        PaymtHeader__National_Issuer_No__CaptionLbl: TextConst ENU = 'National Issuer No.',
                                                               FRA = 'N° émetteur national';
        PageCaptionLbl: TextConst ENU = 'Page',
                                  FRA = 'Page';
        PaymtHeader_IBANCaptionLbl: TextConst ENU = 'IBAN',
                                              FRA = 'IBAN';
        PaymtHeader__SWIFT_Code_CaptionLbl: TextConst ENU = 'SWIFT Code',
                                                      FRA = 'Code SWIFT';
        Text001Lbl: TextConst ENU = ' WITHDRAWS',
                              FRA = ' PRÉLÈVEMENTS';
        Text002Lbl: TextConst ENU = ' WITHDRAW',
                              FRA = ' PRÉLÈVEMENTS';
        Customer_NameCaptionLbl: TextConst ENU = 'Name',
                                           FRA = 'Nom';
        ABS_Amount__Control1120031CaptionLbl: TextConst ENU = 'Amount',
                                                        FRA = 'Montant';
        Bank_AccountCaptionLbl: TextConst ENU = 'Bank Account',
                                          FRA = 'Compte bancaire';
        Payment_Lines__SWIFT_Code_CaptionLbl: TextConst ENU = 'SWIFT Code',
                                                        FRA = 'Code SWIFT';
        Payment_Lines_IBANCaptionLbl: TextConst ENU = 'IBAN',
                                                FRA = 'IBAN';
        ReportCaptionLbl: TextConst ENU = 'Report',
                                    FRA = 'État';
        ReportCaption_Control1120015Lbl: TextConst ENU = 'Report',
                                                   FRA = 'État';
        TotalCaptionLbl: TextConst ENU = 'Total',
                                   FRA = 'Total';
        Done_at__CaptionLbl: TextConst ENU = 'Done at :',
                                       FRA = 'Fait à :';
        On__CaptionLbl: TextConst ENU = 'On :',
                                  FRA = 'Le :';
        Signature__CaptionLbl: TextConst ENU = 'Signature :',
                                         FRA = 'Signature :';
}

