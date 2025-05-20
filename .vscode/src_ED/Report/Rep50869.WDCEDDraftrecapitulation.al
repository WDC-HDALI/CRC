report 50869 "WDC-ED Draft recapitulation"
{
    DefaultLayout = RDLC;
    RDLCLayout = './.vscode/src_ED/report/RDLC/Draftrecapitulation.rdlc';
    captionML = ENU = 'Draft recapitulation', FRA = 'Récapitulatif provisoire';

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
                    column(STRSUBSTNO_Text001_CopyText_; StrSubstNo(Text001, CopyText))
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
                        column(Vendor_Name; Vendor.Name)
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
                        column(DraftAmount; DraftAmount)
                        {
                            AutoFormatExpression = "Currency Code";
                            AutoFormatType = 1;
                        }
                        column(PrintDraftCounting; PrintDraftCounting)
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
                        column(Text004; Text004Lbl)
                        {
                        }
                        column(Text005; Text005Lbl)
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
                        column(Vendor_NameCaption; Vendor_NameCaptionLbl)
                        {
                        }
                        column(Payment_Lines__Bank_Account_Name_Caption; Payment_Lines__Bank_Account_Name_CaptionLbl)
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
                            Vendor.SetRange("No.", "Account No.");
                            if not Vendor.FindFirst then
                                Error(Text002, "Account No.");

                            DraftAmount := Abs(Amount);
                            DraftCounting := 1;
                        end;

                        trigger OnPreDataItem()
                        begin
                            SetRange("Account Type", "Account Type"::Vendor);
                            Clear(DraftAmount);
                            Clear(DraftCounting);
                        end;
                    }
                }

                trigger OnAfterGetRecord()
                begin
                    if Number > 1 then begin
                        CopyText := Text006;
                        OutputNo := OutputNo + 1;
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
                SetRange("No.", TransfertNo);
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
                    captionML = ENU = 'Options', FRA = 'Options';
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
        TransfertNo := "Payment Lines1".GetFilter("No.");
        if TransfertNo = '' then
            Error(Text000);

        CompanyInformation.Get();
        FormatAddress.Company(CompanyAddr, CompanyInformation);
    end;

    procedure PrintDraftCounting(): Text[30]
    begin
        if DraftCounting > 1 then
            exit(Format(DraftCounting) + Text005Lbl);

        exit(Format(DraftCounting) + Text004Lbl);
    end;

    procedure InitRequest(InitDraftNo: Code[20]; InitCopies: Integer)
    begin
        TransfertNo := InitDraftNo;
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
        Vendor: Record Vendor;
        GLSetup: Record "General Ledger Setup";
        PaymtHeader: Record "WDC-ED Payment Header";
        PaymtManagt: Codeunit "WDC-ED Payment Management";
        FormatAddress: Codeunit "Format Address";
        BankAccountAddr: array[8] of Text[100];
        CompanyAddr: array[8] of Text[100];
        LoopsNumber: Integer;
        CopiesNumber: Integer;
        CopyText: Text;
        DraftAmount: Decimal;
        DraftCounting: Decimal;
        TransfertNo: Code[20];
        PostingDate: Date;
        OutputNo: Integer;
        Text000: TextConst ENU = 'You must specify a transfer number.',
                           FRA = 'Vous devez spécifier un numéro de virement.';
        Text002: TextConst ENU = 'Vendor %1 does not exist.',
                           FRA = 'Le fournisseur %1 n''existe pas.';
        Text006: TextConst ENU = 'COPY',
                           FRA = 'COPIE';
        Text001: TextConst ENU = 'Draft Recapitulation %1',
                           FRA = 'Récapitulatif provisoire %1';
        Text007: TextConst ENU = 'Page %1',
                           FRA = 'Page %1';
        PaymtHeader__No__CaptionLbl: TextConst ENU = 'Draft No.',
                                               FRA = 'N° brouillon';
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
        PaymtHeader__Bank_Account_No__CaptionLbl: TextConst ENU = 'Bank Account No.',
                                                            FRA = 'N° compte bancaire';
        PaymtHeader__RIB_Key_CaptionLbl: TextConst ENU = 'RIB Key',
                                                   FRA = 'Clé RIB';
        PaymtHeader__National_Issuer_No__CaptionLbl: TextConst ENU = 'National Issuer No.',
                                                               FRA = 'N° émetteur national';
        PaymtHeader_IBANCaptionLbl: TextConst ENU = 'IBAN',
                                              FRA = 'IBAN';
        PaymtHeader__SWIFT_Code_CaptionLbl: TextConst ENU = 'SWIFT Code',
                                                      FRA = 'SWIFT Code';
        Text004Lbl: TextConst ENU = ' DRAFT',
                              FRA = 'BROUILLON';
        Text005Lbl: TextConst ENU = ' DRAFTS',
                              FRA = 'BROUILLONS';
        Vendor_NameCaptionLbl: TextConst ENU = 'Name',
                                         FRA = 'Nom';
        Payment_Lines__Bank_Account_Name_CaptionLbl: TextConst ENU = 'Bank Account Name',
                                                               FRA = 'Nom compte bancaire';
        ABS_Amount__Control1120031CaptionLbl: TextConst ENU = 'Amount',
                                                        FRA = 'Montant';
        Bank_AccountCaptionLbl: TextConst ENU = 'Bank Account',
                                          FRA = 'Compte bancaire';
        Payment_Lines__SWIFT_Code_CaptionLbl: TextConst ENU = 'Swift Code',
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

