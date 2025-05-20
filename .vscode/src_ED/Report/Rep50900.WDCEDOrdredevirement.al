report 50900 "WDC-ED Ordre de virement"
//report 10869 "Draft recapitulation"
{
    DefaultLayout = RDLC;
    RDLCLayout = './.vscode/src_ED/report/RDLC/Draftrecapitulation.rdl';
    Description = 'WDC01';
    CaptionML = ENU = 'Draft recapitulation', FRA = 'Projet de récapitulation';

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
            column(CompanyPicture; CompanyInformation.Picture)
            {
            }
            dataitem(CopyLoop; "Integer")
            {
                DataItemTableView = SORTING(Number);
                dataitem(PageLoop; "Integer")
                {
                    DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));

                    column(BodyText; BodyText)
                    {
                    }
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
                    column(CompanyInformation__Name; CompanyInformation.Name)
                    {
                    }
                    column(CompanyInformation__Address; CompanyInformation.Address)
                    {
                    }
                    column(CompanyInformation__Address2; CompanyInformation."Address 2")
                    {
                    }
                    column(CompanyInformation__City; CompanyInformation.City)
                    {
                    }
                    column(CompanyInformation__PostCode; CompanyInformation."Post Code")
                    {
                    }
                    column(CompanyInformation__Country; CompanyInfoCountry.Name)
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
                    column(PaymtHeader__BankName; PaymtHeader."Bank Name")
                    {
                    }
                    column(PaymtHeader__BankName2; PaymtHeader."Bank Name 2")
                    {
                    }
                    column(PaymtHeader__BankAddress; PaymtHeader."Bank Address")
                    {
                    }
                    column(PaymtHeader__BankAddress2; PaymtHeader."Bank Address 2")
                    {
                    }
                    column(PaymtHeader__BankPostCode; PaymtHeader."Bank Post Code")
                    {
                    }
                    column(PaymtHeader__BankCounty; BankCountry.Name)
                    {
                    }
                    column(BankAddText; BankAddText)
                    {
                    }

                    column(FORMAT_PostingDate_0_4_; PostingDate)//Format(PostingDate, 0, 4))
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
                    column(PrintCurrencyCode; PrintCurrencyCode())
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
                        column(PrintCurrencyCode_Control1120060; PrintCurrencyCode())
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
                        column(PrintCurrencyCode_Control1120061; PrintCurrencyCode())
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
                        column(PrintCurrencyCode_Control1120063; PrintCurrencyCode())
                        {
                        }
                        column(DraftAmount; DraftAmount)
                        {
                            AutoFormatExpression = "Currency Code";
                            AutoFormatType = 1;
                        }
                        column(DraftAmountSum; DraftAmountSum)
                        {
                            AutoFormatExpression = "Currency Code";
                            AutoFormatType = 1;
                        }
                        column(MontantTouteLettreTEXT; MontantTouteLettreTEXT)
                        {

                        }
                        column(PrintDraftCounting; PrintDraftCounting())
                        {
                        }
                        column(PrintCurrencyCode_Control1120064; PrintCurrencyCode())
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
                        var
                            MontantTouteLettre: Codeunit "WDC-ST MontantTouteLettre";
                            PaymentLine: Record "WDC-ED Payment Line";

                        begin
                            Vendor.SetRange("No.", "Account No.");
                            if not Vendor.FindFirst() then
                                Error(Text002, "Account No.");

                            Clear(DraftAmountSum);
                            PaymentLine.Reset();
                            PaymentLine.SetRange("No.", "No.");
                            PaymentLine.SetRange("Account No.", "Account No.");
                            if PaymentLine.FindSet() then
                                repeat
                                    DraftAmountSum += Abs(PaymentLine.Amount);
                                until PaymentLine.next = 0;

                            DraftAmount := Abs(Amount);
                            Clear(MontantTouteLettreTEXT);
                            MontantTouteLettre."Montant en texteDevise"(MontantTouteLettreTEXT, DraftAmountSum, PrintCurrencyCode());
                            MontantTouteLettreTEXT := lowercase(MontantTouteLettreTEXT);
                            DraftCounting := 1;
                        end;

                        trigger OnPreDataItem()
                        begin
                            SetRange("Account Type", "Account Type"::Vendor);
                            Clear(DraftAmount);
                            Clear(DraftCounting);
                            Clear(DraftAmountSum);
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
            var

            begin
                PaymtHeader.Get("No.");
                if BankCountry.get(PaymtHeader."Bank Country/Region Code") then;

                Clear(BankAddText);
                if PaymtHeader."Bank Name" <> '' then
                    BankAddText += '<b>' + PaymtHeader."Bank Name" + '</b>';
                if PaymtHeader."Bank Address" <> '' then
                    BankAddText += '<br>' + PaymtHeader."Bank Address";
                if PaymtHeader."Bank Address 2" <> '' then
                    BankAddText += '<br>' + PaymtHeader."Bank Address 2";
                if PaymtHeader."Bank Post Code" <> '' then
                    BankAddText += '<br>' + PaymtHeader."Bank Post Code";
                if PaymtHeader."Bank City" <> '' then
                    if PaymtHeader."Bank Post Code" <> '' then
                        BankAddText += ' ' + PaymtHeader."Bank City"
                    else
                        BankAddText += '<br>' + PaymtHeader."Bank City";
                if BankCountry.Name <> '' then
                    if (PaymtHeader."Bank Post Code" <> '') or (PaymtHeader."Bank City" <> '') then
                        BankAddText += ' ' + BankCountry.Name
                    else
                        BankAddText += '<br>' + BankCountry.Name;

                PostingDate := PaymtHeader."Posting Date";
                PaymentBankAcc(BankAccountAddr, PaymtHeader);

                Clear(BodyText);
                BodyText := 'Madame, Monsieur,<br><br>Nous vous serions reconnaissants de bien vouloir effectuer, par le débit de notre compte Messem <br>'
                            + PaymtHeader."Account No." + ' - ' + PaymtHeader.IBAN + ',';

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
                    CaptionML = ENU = 'Options', FRA = 'Options';
                    field(CopiesNumber; CopiesNumber)
                    {
                        ApplicationArea = Basic, Suite;
                        CaptionML = ENU = 'Number of copies', FRA = 'N° copie';
                    }
                }
            }
        }

        actions
        {
        }
    }

    trigger OnPreReport()
    begin
        TransfertNo := "Payment Lines1".GetFilter("No.");
        if TransfertNo = '' then
            Error(Text000);

        CompanyInformation.Get();
        CompanyInformation.CalcFields(Picture);
        if CompanyInfoCountry.get(CompanyInformation."Country/Region Code") then;
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

    procedure PaymentBankAcc(var AddrArray: array[8] of Text[100]; BankAcc: Record "WDC-ED Payment Header")
    var
        FormatAddress: Codeunit "Format Address";
    begin

        FormatAddress.FormatAddr(
          AddrArray, BankAcc."Bank Name", BankAcc."Bank Name 2", BankAcc."Bank Contact", BankAcc."Bank Address", BankAcc."Bank Address 2",
          BankAcc."Bank City", BankAcc."Bank Post Code", BankAcc."Bank County", BankAcc."Bank Country/Region Code");
    end;

    var
        MontantTouteLettreTEXT: TEXT;
        BankAddText: text;
        BodyText: text;
        CompanyInformation: Record "Company Information";
        CompanyInfoCountry: Record "Country/Region";
        BankCountry: Record "Country/Region";
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
        DraftAmountSum: Decimal;
        DraftCounting: Decimal;
        TransfertNo: Code[20];
        PostingDate: Date;
        Text000: textconst ENU = 'You must specify a transfer number.', FRA = 'Vous devez préciser un numéro de transfert.';
        Text002: textconst ENU = 'Vendor %1 does not exist.', FRA = 'Le fournisseur %1 n''existe pas.';
        Text006: textconst ENU = 'COPY', FRA = 'COPIE';
        Text001: textconst ENU = 'Draft Recapitulation %1', FRA = 'Brouillon de récapitulation %1';
        OutputNo: Integer;
        Text007: textconst ENU = 'Page %1', FRA = 'Page %1';
        PaymtHeader__No__CaptionLbl: textconst ENU = 'Draft No.', FRA = 'Projet n°';
        CompanyInformation__Phone_No__CaptionLbl: textconst ENU = 'Phone No.', FRA = 'N° téléphone';
        CompanyInformation__Fax_No__CaptionLbl: textconst ENU = 'Fax No.', FRA = 'N° télécopie';
        CompanyInformation__VAT_Registration_No__CaptionLbl: textconst ENU = 'VAT Registration No.', FRA = 'Numéro d''immatriculation à la TVA';
        PrintCurrencyCodeCaptionLbl: textconst ENU = 'Currency Code', FRA = 'Code devise';
        PaymtHeader__Bank_Branch_No__CaptionLbl: textconst ENU = 'Bank Branch No.', FRA = 'N° succursale bancaire';
        PaymtHeader__Agency_Code_CaptionLbl: textconst ENU = 'Agency Code', FRA = 'Code agence';
        PaymtHeader__Bank_Account_No__CaptionLbl: textconst ENU = 'Bank Account No.', FRA = 'N° compte banque';
        PaymtHeader__RIB_Key_CaptionLbl: textconst ENU = 'RIB Key', FRA = 'Clé RIB';
        PaymtHeader__National_Issuer_No__CaptionLbl: textconst ENU = 'National Issuer No.', FRA = 'Numéro d''émetteur national';
        PaymtHeader_IBANCaptionLbl: textconst ENU = 'IBAN', FRA = 'IBAN';
        PaymtHeader__SWIFT_Code_CaptionLbl: textconst ENU = 'SWIFT Code', FRA = 'SWIFT Code';
        Text004Lbl: textconst ENU = ' DRAFT', FRA = ' BROUILLON';
        Text005Lbl: textconst ENU = ' DRAFTS', FRA = ' BROUILLON';
        Vendor_NameCaptionLbl: textconst ENU = 'Name', FRA = 'Nom';
        Payment_Lines__Bank_Account_Name_CaptionLbl: textconst ENU = 'Bank Account Name', FRA = 'Nom compt bancaire';
        ABS_Amount__Control1120031CaptionLbl: textconst ENU = 'Amount', FRA = 'Montant';
        Bank_AccountCaptionLbl: textconst ENU = 'Bank Account', FRA = 'Compte bancaire';
        Payment_Lines__SWIFT_Code_CaptionLbl: textconst ENU = 'Swift Code', FRA = 'Swift Code';
        Payment_Lines_IBANCaptionLbl: textconst ENU = 'IBAN', FRA = 'IBAN';
        ReportCaptionLbl: textconst ENU = 'Report', FRA = 'Rapport';
        ReportCaption_Control1120015Lbl: textconst ENU = 'Report', FRA = 'Rapport';
        TotalCaptionLbl: textconst ENU = 'Total', FRA = 'Totale';
        Done_at__CaptionLbl: textconst ENU = 'Done at :', FRA = 'Fait à:';
        On__CaptionLbl: textconst ENU = 'On :', FRA = 'Sur :';
        Signature__CaptionLbl: textconst ENU = 'Signature :', FRA = 'Signature';
}

