report 50867 "WDC-ED Remittance"
{
    DefaultLayout = RDLC;
    RDLCLayout = './.vscode/src_ED/report/RDLC/Remittance.rdlc';
    captionML = ENU = 'Remittance', FRA = 'Remise';

    dataset
    {
        dataitem("Payment Lines1"; "WDC-ED Payment Line")
        {
            DataItemTableView = SORTING("No.", "Line No.") WHERE("Account Type" = CONST(Customer));
            MaxIteration = 1;
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.";
            RequestFilterHeading = 'Payment lines';
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
                    column(Operation; Operation)
                    {
                    }
                    column(PaymtHeader__No__; PaymtHeader."No.")
                    {
                    }
                    column(STRSUBSTNO_Text003____1__CopyText_; StrSubstNo(Text003Lbl + ' %1', CopyText))
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
                    column(CompanyInfo__Phone_No__; CompanyInfo."Phone No.")
                    {
                    }
                    column(CompanyInfo__Fax_No__; CompanyInfo."Fax No.")
                    {
                    }
                    column(CompanyInfo__VAT_Registration_No__; CompanyInfo."VAT Registration No.")
                    {
                    }
                    column(FORMAT_PostingDate_0_4_; Format(PostingDate, 0, 4))
                    {
                    }
                    column(BankAccAddr_4_; BankAccAddr[4])
                    {
                    }
                    column(BankAccAddr_5_; BankAccAddr[5])
                    {
                    }
                    column(BankAccAddr_6_; BankAccAddr[6])
                    {
                    }
                    column(BankAccAddr_7_; BankAccAddr[7])
                    {
                    }
                    column(BankAccAddr_3_; BankAccAddr[3])
                    {
                    }
                    column(BankAccAddr_2_; BankAccAddr[2])
                    {
                    }
                    column(BankAccAddr_1_; BankAccAddr[1])
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
                    column(OutputNo; OutputNo)
                    {
                    }
                    column(Text003; Text003Lbl)
                    {
                    }
                    column(Text000; Text000Lbl)
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
                    column(CompanyInfo__Phone_No__Caption; CompanyInfo__Phone_No__CaptionLbl)
                    {
                    }
                    column(CompanyInfo__Fax_No__Caption; CompanyInfo__Fax_No__CaptionLbl)
                    {
                    }
                    column(CompanyInfo__VAT_Registration_No__Caption; CompanyInfo__VAT_Registration_No__CaptionLbl)
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
                    column(PaymtHeader_IBANCaption; PaymtHeader_IBANCaptionLbl)
                    {
                    }
                    column(PaymtHeader__SWIFT_Code_Caption; PaymtHeader__SWIFT_Code_CaptionLbl)
                    {
                    }
                    dataitem("Payment Line"; "WDC-ED Payment Line")
                    {
                        DataItemLink = "No." = FIELD("No.");
                        DataItemLinkReference = "Payment Lines1";
                        DataItemTableView = SORTING("No.", "Line No.");
                        column(PrintAmountInLCYCode; PrintAmountInLCYCode)
                        {
                        }
                        column(StatementAmount; StatementAmount)
                        {
                            AutoFormatExpression = ExtrCurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(PrintCurrencyCode_Control1120060; PrintCurrencyCode)
                        {
                        }
                        column(Cust_Name; Cust.Name)
                        {
                        }
                        column(StatementAmount_Control1120031; StatementAmount)
                        {
                            AutoFormatExpression = ExtrCurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(PrintCurrencyCode_Control1120061; PrintCurrencyCode)
                        {
                        }
                        column(Payment_Line__Due_Date_; Format("Due Date"))
                        {
                        }
                        column(Payment_Line__No__; "No.")
                        {
                        }
                        column(Payment_Line__Account_No__; "Account No.")
                        {
                        }
                        column(Payment_Line__Drawee_Reference_; "Drawee Reference")
                        {
                        }
                        column(Payment_Line__Bank_Branch_No__; "Bank Branch No.")
                        {
                        }
                        column(Payment_Line__Agency_Code_; "Agency Code")
                        {
                        }
                        column(Payment_Line__Bank_Account_No__; "Bank Account No.")
                        {
                        }
                        column(Payment_Line__SWIFT_Code_; "SWIFT Code")
                        {
                        }
                        column(Payment_Line_IBAN; IBAN)
                        {
                        }
                        column(StatementAmount_Control1120036; StatementAmount)
                        {
                            AutoFormatExpression = ExtrCurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(PrintCurrencyCode_Control1120063; PrintCurrencyCode)
                        {
                        }
                        column(StatementAmount_Control1120039; StatementAmount)
                        {
                            AutoFormatExpression = ExtrCurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(PrintCountingDelivery; PrintCountingDelivery)
                        {
                        }
                        column(PrintCurrencyCode_Control1120064; PrintCurrencyCode)
                        {
                        }
                        column(Payment_Line_Line_No_; "Line No.")
                        {
                        }
                        column(All_amounts_are_in_company_currencyCaption; All_amounts_are_in_company_currencyCaptionLbl)
                        {
                        }
                        column(Cust_NameCaption; Cust_NameCaptionLbl)
                        {
                        }
                        column(StatementAmount_Control1120031Caption; StatementAmount_Control1120031CaptionLbl)
                        {
                        }
                        column(Payment_Line__Drawee_Reference_Caption; FieldCaption("Drawee Reference"))
                        {
                        }
                        column(Payment_Line__No__Caption; Payment_Line__No__CaptionLbl)
                        {
                        }
                        column(Payment_Line__Due_Date_Caption; Payment_Line__Due_Date_CaptionLbl)
                        {
                        }
                        column(Payment_Line__Account_No__Caption; FieldCaption("Account No."))
                        {
                        }
                        column(Payment_Line__Bank_Branch_No__Caption; FieldCaption("Bank Branch No."))
                        {
                        }
                        column(Payment_Line__Agency_Code_Caption; FieldCaption("Agency Code"))
                        {
                        }
                        column(Payment_Line__Bank_Account_No__Caption; FieldCaption("Bank Account No."))
                        {
                        }
                        column(Payment_Line__SWIFT_Code_Caption; FieldCaption("SWIFT Code"))
                        {
                        }
                        column(Payment_Line_IBANCaption; Payment_Line_IBANCaptionLbl)
                        {
                        }
                        column(ReportCaption; ReportCaptionLbl)
                        {
                        }
                        column(EmptyStringCaption; EmptyStringCaptionLbl)
                        {
                        }
                        column(ReportCaption_Control1120015; ReportCaption_Control1120015Lbl)
                        {
                        }
                        column(TotalCaption; TotalCaptionLbl)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            Cust.Get("Account No.");

                            if PrintAmountInLCYCode then
                                StatementAmount := Amount
                            else
                                StatementAmount := Amount;
                            StatementAmount := Abs(Amount);
                        end;

                        trigger OnPreDataItem()
                        begin
                            Clear(StatementAmount);
                        end;
                    }
                }

                trigger OnAfterGetRecord()
                begin
                    if Number > 1 then begin
                        OutputNo := OutputNo + 1;
                        CopyText := Text000Lbl;
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    LoopsNumber := Abs(CopiesNumber) + 1;
                    CopyText := '';
                    SetRange(Number, 1, LoopsNumber);

                    OutputNo := 1;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                PaymtHeader.Get("No.");
                PostingDate := PaymtHeader."Posting Date";

                PaymtHeader.CalcFields("No. of Lines");
                CountStatement := PaymtHeader."No. of Lines";

                PaymtHeader.TestField("Account Type", PaymtHeader."Account Type"::"Bank Account");

                FormatAddress.FormatAddr(
                  BankAccAddr, PaymtHeader."Bank Name", PaymtHeader."Bank Name 2", '', PaymtHeader."Bank Address", PaymtHeader."Bank Address 2",
                  PaymtHeader."Bank City", PaymtHeader."Bank Post Code", '', '');
            end;

            trigger OnPreDataItem()
            begin
                CompanyInfo.Get();
                FormatAddress.Company(CompanyAddr, CompanyInfo);
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    captionML = ENU = 'Options', FRA = 'Options';
                    field(CopiesNumber; CopiesNumber)
                    {
                        ApplicationArea = All;
                        captionML = ENU = 'Number of Copies', FRA = 'Nombre de copies';
                    }
                    field(PrintAmountInLCYCode; PrintAmountInLCYCode)
                    {
                        ApplicationArea = All;
                        captionML = ENU = 'Print Amounts in LCY', FRA = 'Imprimer montants DS';
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

    procedure ExtrCurrencyCode(): Code[10]
    begin
        if PrintAmountInLCYCode then
            exit('');

        exit("Payment Lines1"."Currency Code");
    end;

    procedure PrintCurrencyCode(): Code[10]
    begin
        if ("Payment Lines1"."Currency Code" = '') or PrintAmountInLCYCode then begin
            GLSetup.Get();
            exit(GLSetup."LCY Code");
        end;
        exit("Payment Lines1"."Currency Code");
    end;

    procedure PrintCountingDelivery(): Text[30]
    begin
        if CountStatement > 1 then
            exit(Format(CountStatement) + Text002);

        exit(Format(CountStatement) + Text001);
    end;

    procedure InitRequest(InitCopies: Integer; InitAmountInLCYCode: Boolean)
    begin
        CopiesNumber := InitCopies;
        PrintAmountInLCYCode := InitAmountInLCYCode;
    end;

    var
        CompanyInfo: Record "Company Information";
        Cust: Record Customer;
        GLSetup: Record "General Ledger Setup";
        PaymtHeader: Record "WDC-ED Payment Header";
        FormatAddress: Codeunit "Format Address";
        BankAccAddr: array[8] of Text[100];
        CompanyAddr: array[8] of Text[100];
        Operation: Text[80];
        LoopsNumber: Integer;
        CopiesNumber: Integer;
        CopyText: Text[30];
        PrintAmountInLCYCode: Boolean;
        StatementAmount: Decimal;
        CountStatement: Integer;
        PostingDate: Date;
        OutputNo: Integer;
        Text001: TextConst ENU = ' BILL',
                           FRA = 'EFFET';
        Text002: TextConst ENU = ' BILLS',
                           FRA = 'EFFETS';
        Text004: TextConst ENU = 'Page %1',
                           FRA = 'Page %1';
        Text003Lbl: TextConst ENU = 'Remittance',
                              FRA = 'Remise';
        Text000Lbl: TextConst ENU = 'COPY',
                              FRA = 'COPIE';
        PaymtHeader__No__CaptionLbl: TextConst ENU = 'Remittance No.',
                                               FRA = 'N° remise';
        CompanyInfo__Phone_No__CaptionLbl: TextConst ENU = 'Phone No.',
                                                     FRA = 'N° téléphone';
        CompanyInfo__Fax_No__CaptionLbl: TextConst ENU = 'FAX No.',
                                                   FRA = 'N° TÉLÉCOPIE';
        CompanyInfo__VAT_Registration_No__CaptionLbl: TextConst ENU = 'VAT Registration No.',
                                                                FRA = 'N° identif. intracomm.';
        PrintCurrencyCodeCaptionLbl: TextConst ENU = 'Currency Code',
                                               FRA = 'Code devise';
        PaymtHeader__Bank_Branch_No__CaptionLbl: TextConst ENU = 'Bank Branch No.',
                                                           FRA = 'Code établissement';
        PaymtHeader__Agency_Code_CaptionLbl: TextConst ENU = 'Agency Code',
                                                       FRA = 'Code agence';
        PaymtHeader__Bank_Account_No__CaptionLbl: TextConst ENU = 'Bank Account No.',
                                                            FRA = 'N° compte bancaire';
        PaymtHeader_IBANCaptionLbl: TextConst ENU = 'IBAN',
                                              FRA = 'IBAN';
        PaymtHeader__SWIFT_Code_CaptionLbl: TextConst ENU = 'SWIFT Code',
                                                      FRA = 'SWIFT Code';
        All_amounts_are_in_company_currencyCaptionLbl: TextConst ENU = 'All amounts are in company currency',
                                                                 FRA = 'Tous les montants sont en devise société';
        Cust_NameCaptionLbl: TextConst ENU = 'Name',
                                       FRA = 'Nom';
        StatementAmount_Control1120031CaptionLbl: TextConst ENU = 'Remaining Amount',
                                                            FRA = 'Montant ouvert';
        Payment_Line__No__CaptionLbl: TextConst ENU = 'Document No.',
                                                FRA = 'N° du document';
        Payment_Line__Due_Date_CaptionLbl: TextConst ENU = 'Due Date',
                                                     FRA = 'Date d''échéance';
        Payment_Line_IBANCaptionLbl: TextConst ENU = 'IBAN',
                                               FRA = 'IBAN';
        ReportCaptionLbl: TextConst ENU = 'Report',
                                    FRA = 'État';
        EmptyStringCaptionLbl: TextConst ENU = '/',
                                         FRA = '/';
        ReportCaption_Control1120015Lbl: TextConst ENU = 'Report',
                                                   FRA = 'État';
        TotalCaptionLbl: TextConst ENU = 'Total',
                                   FRA = 'Total';
}

