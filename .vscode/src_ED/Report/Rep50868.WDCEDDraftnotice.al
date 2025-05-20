report 50868 "WDC-ED Draft notice"
{
    DefaultLayout = RDLC;
    RDLCLayout = './.vscode/src_ED/report/RDLC/Draftnotice.rdlc';
    captionML = ENU = 'Draft notice', FRA = 'Avis provisoire';

    dataset
    {
        dataitem("Payment Lines1"; "WDC-ED Payment Line")
        {
            DataItemTableView = SORTING("No.", "Line No.") WHERE(Marked = CONST(true));
            column(Payment_Lines1_No_; "No.")
            {
            }
            column(Payment_Lines1_Line_No_; "Line No.")
            {
            }

            trigger OnAfterGetRecord()
            begin
                PaymtHeader.Get("No.");
                PaymtHeader.CalcFields("Payment Class Name");
                PostingDate := PaymtHeader."Posting Date";

                BankAccountBuffer."Customer No." := "Account No.";
                BankAccountBuffer."Bank Branch No." := "Bank Branch No.";
                BankAccountBuffer."Agency Code" := "Agency Code";
                BankAccountBuffer."Bank Account No." := "Bank Account No.";
                if not BankAccountBuffer.Insert() then;
            end;

            trigger OnPreDataItem()
            begin
                SetRange("No.", TransfertNo);
            end;
        }
        dataitem(Vendor; Vendor)
        {
            // DataItemLinkReference = "Payment Lines1";
            DataItemTableView = SORTING("No.");
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.";
            column(Vendor_No_; "No.")
            {
            }
            dataitem(CopyLoop; "Integer")
            {
                DataItemTableView = SORTING(Number);
                dataitem("Bank Account Buffer"; "WDC-ED Bank Account Buffer")
                {
                    DataItemTableView = SORTING("Customer No.", "Bank Branch No.", "Agency Code", "Bank Account No.");
                    column(Bank_Account_Buffer_Customer_No_; "Bank Account Buffer"."Customer No.")
                    {
                    }
                    column(Bank_Account_Buffer_Bank_Branch_No_; "Bank Account Buffer"."Bank Branch No.")
                    {
                    }
                    column(Bank_Account_Buffer_Agency_Code; "Bank Account Buffer"."Agency Code")
                    {
                    }
                    column(Bank_Account_Buffer_Bank_Account_No_; "Bank Account Buffer"."Bank Account No.")
                    {
                    }
                    dataitem("Payment Line"; "WDC-ED Payment Line")
                    {
                        DataItemLink = "Account No." = FIELD("Customer No."), "Bank Branch No." = FIELD("Bank Branch No."), "Agency Code" = FIELD("Agency Code"), "Bank Account No." = FIELD("Bank Account No.");
                        DataItemLinkReference = "Bank Account Buffer";
                        DataItemTableView = SORTING("No.", "Account No.", "Bank Branch No.", "Agency Code", "Bank Account No.", "Payment Address Code") WHERE(Marked = CONST(true));
                        column(FORMAT_PostingDate_0_4_; Format(PostingDate, 0, 4))
                        {
                        }
                        column(Payment_Lines1___No__; "Payment Lines1"."No.")
                        {
                        }
                        column(PaymtHeader_IBAN; PaymtHeader.IBAN)
                        {
                        }
                        column(VendAddr_7_; VendAddr[7])
                        {
                        }
                        column(PaymtHeader_SWIFT_Code; PaymtHeader."SWIFT Code")
                        {
                        }
                        column(VendAddr_6_; VendAddr[6])
                        {
                        }
                        column(CompanyInformation__VAT_Registration_No__; CompanyInformation."VAT Registration No.")
                        {
                        }
                        column(VendAddr_5_; VendAddr[5])
                        {
                        }
                        column(CompanyInformation__Fax_No__; CompanyInformation."Fax No.")
                        {
                        }
                        column(VendAddr_4_; VendAddr[4])
                        {
                        }
                        column(CompanyInformation__Phone_No__; CompanyInformation."Phone No.")
                        {
                        }
                        column(VendAddr_3_; VendAddr[3])
                        {
                        }
                        column(CompanyAddr_6_; CompanyAddr[6])
                        {
                        }
                        column(VendAddr_2_; VendAddr[2])
                        {
                        }
                        column(CompanyAddr_5_; CompanyAddr[5])
                        {
                        }
                        column(VendAddr_1_; VendAddr[1])
                        {
                        }
                        column(CompanyAddr_4_; CompanyAddr[4])
                        {
                        }
                        column(CompanyAddr_3_; CompanyAddr[3])
                        {
                        }
                        column(CompanyAddr_2_; CompanyAddr[2])
                        {
                        }
                        column(CompanyAddr_1_; CompanyAddr[1])
                        {
                        }
                        column(STRSUBSTNO_Text002_CopyText_; StrSubstNo(Text002, CopyText))
                        {
                        }
                        column(PrintCurrencyCode; PrintCurrencyCode)
                        {
                        }
                        column(OutputNo; OutputNo)
                        {
                        }
                        column(Vendor__No__; Vendor."No.")
                        {
                        }
                        column(CopyLoop_Number; CopyLoop.Number)
                        {
                        }
                        column(Bank_Account_Buffer___Agency_Code_; "Bank Account Buffer"."Agency Code")
                        {
                        }
                        column(Bank_Account_Buffer___Customer_No__; "Bank Account Buffer"."Customer No.")
                        {
                        }
                        column(Bank_Account_Buffer___Bank_Branch_No__; "Bank Account Buffer"."Bank Branch No.")
                        {
                        }
                        column(Bank_Account_Buffer___Bank_Account_No__; "Bank Account Buffer"."Bank Account No.")
                        {
                        }
                        column(HeaderText1; HeaderText1)
                        {
                        }
                        column(PrintCurrencyCode_Control1120069; PrintCurrencyCode)
                        {
                        }
                        column(ABS_Amount_; Abs(Amount))
                        {
                            AutoFormatExpression = "Currency Code";
                            AutoFormatType = 1;
                        }
                        column(Payment_Line__Due_Date_; Format("Due Date"))
                        {
                        }
                        column(PostingDate; Format(PostingDate))
                        {
                        }
                        column(Payment_Line__External_Document_No__; "External Document No.")
                        {
                        }
                        column(PaymtHeader__Payment_Class_Name_; PaymtHeader."Payment Class Name")
                        {
                        }
                        column(Payment_Line__Document_No__; "Document No.")
                        {
                        }
                        column(PrintCurrencyCode_Control1120064; PrintCurrencyCode)
                        {
                        }
                        column(DraftAmount; DraftAmount)
                        {
                            AutoFormatExpression = "Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalDraftAmount; TotalDraftAmount)
                        {
                        }
                        column(Payment_Line_No_; "No.")
                        {
                        }
                        column(Payment_Line_Line_No_; "Line No.")
                        {
                        }
                        column(Payment_Line_Payment_Address_Code; "Payment Address Code")
                        {
                        }
                        column(Payment_Line_Account_No_; "Account No.")
                        {
                        }
                        column(Payment_Line_Bank_Branch_No_; "Bank Branch No.")
                        {
                        }
                        column(Payment_Line_Agency_Code; "Agency Code")
                        {
                        }
                        column(Payment_Line_Bank_Account_No_; "Bank Account No.")
                        {
                        }
                        column(Payment_Line_Applies_to_ID; "Applies-to ID")
                        {
                        }
                        column(Payment_Lines1___No__Caption; Payment_Lines1___No__CaptionLbl)
                        {
                        }
                        column(PaymtHeader__IBAN__Caption; PaymtHeader__IBAN__CaptionLbl)
                        {
                        }
                        column(PaymtHeader__SWIFT_Code__Caption; PaymtHeader__SWIFT_Code__CaptionLbl)
                        {
                        }
                        column(CompanyInformation__VAT_Registration_No__Caption; CompanyInformation__VAT_Registration_No__CaptionLbl)
                        {
                        }
                        column(CompanyInformation__Fax_No__Caption; CompanyInformation__Fax_No__CaptionLbl)
                        {
                        }
                        column(CompanyInformation__Phone_No__Caption; CompanyInformation__Phone_No__CaptionLbl)
                        {
                        }
                        column(PrintCurrencyCodeCaption; PrintCurrencyCodeCaptionLbl)
                        {
                        }
                        column(Draft_Notice_AmountCaption; Draft_Notice_AmountCaptionLbl)
                        {
                        }
                        dataitem("Vendor Ledger Entry"; "Vendor Ledger Entry")
                        {
                            CalcFields = "Remaining Amount";
                            DataItemLink = "Vendor No." = FIELD("Account No."), "Applies-to ID" = FIELD("Applies-to ID");
                            DataItemLinkReference = "Payment Line";
                            DataItemTableView = SORTING("Document No.");
                            column(HeaderText2; HeaderText2)
                            {
                            }
                            column(ABS__Remaining_Amount__; Abs("Remaining Amount"))
                            {
                                AutoFormatExpression = "Currency Code";
                                AutoFormatType = 1;
                            }
                            column(PrintCurrencyCode_Control1120060; PrintCurrencyCode)
                            {
                            }
                            column(Vendor_Ledger_Entry__Currency_Code_; "Currency Code")
                            {
                            }
                            column(ABS__Remaining_Amount___Control1120059; Abs("Remaining Amount"))
                            {
                                AutoFormatExpression = "Currency Code";
                                AutoFormatType = 1;
                            }
                            column(Vendor_Ledger_Entry__Document_No__; "Document No.")
                            {
                            }
                            column(Vendor_Ledger_Entry_Description; Description)
                            {
                            }
                            column(Vendor_Ledger_Entry__External_Document_No__; "External Document No.")
                            {
                            }
                            column(Vendor_Ledger_Entry__Posting_Date_; Format("Posting Date"))
                            {
                            }
                            column(Vendor_Ledger_Entry__Due_Date_; Format("Due Date"))
                            {
                            }
                            column(ABS__Remaining_Amount___Control1120036; Abs("Remaining Amount"))
                            {
                                AutoFormatExpression = "Currency Code";
                                AutoFormatType = 1;
                            }
                            column(PrintCurrencyCode_Control1120063; PrintCurrencyCode)
                            {
                            }
                            column(Vendor_Ledger_Entry_Entry_No_; "Entry No.")
                            {
                            }
                            column(Vendor_Ledger_Entry_Vendor_No_; "Vendor No.")
                            {
                            }
                            column(Vendor_Ledger_Entry_Applies_to_ID; "Applies-to ID")
                            {
                            }
                            column(Vendor_Ledger_Entry__Document_No__Caption; FieldCaption("Document No."))
                            {
                            }
                            column(Vendor_Ledger_Entry_DescriptionCaption; FieldCaption(Description))
                            {
                            }
                            column(Vendor_Ledger_Entry__External_Document_No__Caption; FieldCaption("External Document No."))
                            {
                            }
                            column(Vendor_Ledger_Entry__Posting_Date_Caption; Vendor_Ledger_Entry__Posting_Date_CaptionLbl)
                            {
                            }
                            column(Vendor_Ledger_Entry__Due_Date_Caption; Vendor_Ledger_Entry__Due_Date_CaptionLbl)
                            {
                            }
                            column(ABS__Remaining_Amount___Control1120059Caption; ABS__Remaining_Amount___Control1120059CaptionLbl)
                            {
                            }
                            column(ReportCaption; ReportCaptionLbl)
                            {
                            }
                            column(ReportCaption_Control1120015; ReportCaption_Control1120015Lbl)
                            {
                            }

                            trigger OnAfterGetRecord()
                            begin
                                if "Payment Line"."Applies-to ID" = '' then
                                    CurrReport.Skip
                                    ;
                                if "Currency Code" = '' then
                                    "Currency Code" := GLSetup."LCY Code";

                                DraftCounting := DraftCounting + 1;
                            end;
                        }

                        trigger OnAfterGetRecord()
                        var
                            PaymtAddr: Record "WDC-ED Payment Address";
                            PaymtManagt: Codeunit "WDC-ED Payment Management";
                        begin
                            HeaderText1 := StrSubstNo(Text004, "Bank Account Name", "SWIFT Code",
                                "Agency Code", IBAN, PostingDate);
                            DraftCounting := 0;

                            TotalDraftAmount := TotalDraftAmount + Abs(Amount);

                            if "Payment Address Code" = '' then
                                FormatAddress.Vendor(VendAddr, Vendor)
                            else
                                if PaymtAddr.Get("Account Type"::Vendor, "Account No.", "Payment Address Code") then
                                    PaymtManagt.PaymentAddr(VendAddr, PaymtAddr);

                            DraftAmount := Abs(Amount);
                        end;

                        trigger OnPreDataItem()
                        begin
                            SetRange("No.", TransfertNo);
                            SetRange("Account No.", Vendor."No.");

                            TotalDraftAmount := 0;
                            Clear(DraftAmount);
                        end;
                    }
                }

                trigger OnAfterGetRecord()
                begin
                    if Number > 1 then begin
                        CopyText := Text001;
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
                PaymtLine.Reset();
                PaymtLine.SetRange("No.", TransfertNo);
                PaymtLine.SetRange("Account No.", "No.");
                if not PaymtLine.FindFirst then
                    CurrReport.Skip();
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
                    field(NumberOfCopies; CopiesNumber)
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

    trigger OnPostReport()
    begin
        BankAccountBuffer.DeleteAll();
    end;

    trigger OnPreReport()
    begin
        TransfertNo := CopyStr("Payment Lines1".GetFilter("No."), 1, MaxStrLen(TransfertNo));
        if TransfertNo = '' then
            Error(Text000);

        CompanyInformation.Get();
        FormatAddress.Company(CompanyAddr, CompanyInformation);
        GLSetup.Get();
    end;

    procedure PrintCurrencyCode(): Code[10]
    begin
        if "Payment Lines1"."Currency Code" = '' then
            exit(GLSetup."LCY Code");

        exit("Payment Lines1"."Currency Code");
    end;

    var
        CompanyInformation: Record "Company Information";
        GLSetup: Record "General Ledger Setup";
        PaymtHeader: Record "WDC-ED Payment Header";
        PaymtLine: Record "WDC-ED Payment Line";
        BankAccountBuffer: Record "WDC-ED Bank Account Buffer";
        FormatAddress: Codeunit "Format Address";
        VendAddr: array[8] of Text[100];
        CompanyAddr: array[8] of Text[100];
        LoopsNumber: Integer;
        CopiesNumber: Integer;
        CopyText: Text;
        DraftAmount: Decimal;
        TotalDraftAmount: Decimal;
        DraftCounting: Decimal;
        TransfertNo: Code[20];
        HeaderText1: Text;
        PostingDate: Date;
        OutputNo: Integer;
        Text000: TextConst ENU = 'You must specify a transfer number.',
                           FRA = 'Vous devez spécifier un numéro de virement.';
        Text001: TextConst ENU = 'COPY',
                           FRA = 'COPIE';
        Text002: TextConst ENU = 'Draft notice %1',
                           FRA = 'Avis provisoire %1';
        Text004: TextConst ENU = 'A transfer to your bank account %1 (RIB : %2 %3 %4) has been done on %5.',
                           FRA = 'Un virement sur votre compte bancaire %1 (RIB : %2 %3 %4) a été effectué le %5.';
        HeaderText2: TextConst ENU = 'This transfer is related to these invoices :',
                               FRA = 'Ce virement est lié aux factures suivantes :';
        Text005: TextConst ENU = 'Page %1',
                           FRA = 'Page %1';
        Payment_Lines1___No__CaptionLbl: TextConst ENU = 'Draft No.',
                                                   FRA = 'N° brouillon';
        PaymtHeader__IBAN__CaptionLbl: TextConst ENU = 'IBAN',
                                                 FRA = 'IBAN';
        PaymtHeader__SWIFT_Code__CaptionLbl: TextConst ENU = 'SWIFT Code',
                                                       FRA = 'SWIFT Code';
        CompanyInformation__VAT_Registration_No__CaptionLbl: TextConst ENU = 'VAT Registration No.',
                                                                       FRA = 'N° identif. intracomm.';
        CompanyInformation__Fax_No__CaptionLbl: TextConst ENU = 'FAX No.',
                                                          FRA = 'N° TÉLÉCOPIE';
        CompanyInformation__Phone_No__CaptionLbl: TextConst ENU = 'Phone No.',
                                                            FRA = 'N° téléphone';
        PrintCurrencyCodeCaptionLbl: TextConst ENU = 'Currency Code',
                                               FRA = 'Code devise';
        Draft_Notice_AmountCaptionLbl: TextConst ENU = 'Draft Notice Amount',
                                                 FRA = 'Montant avis provisoire';
        Vendor_Ledger_Entry__Posting_Date_CaptionLbl: TextConst ENU = 'Posting Date',
                                                                FRA = 'Date comptabilisation';
        Vendor_Ledger_Entry__Due_Date_CaptionLbl: TextConst ENU = 'Due Date',
                                                            FRA = 'Date d''échéance';
        ABS__Remaining_Amount___Control1120059CaptionLbl: TextConst ENU = 'Amount',
                                                                    FRA = 'Montant';
        ReportCaptionLbl: TextConst ENU = 'Report',
                                    FRA = 'État';
        ReportCaption_Control1120015Lbl: TextConst ENU = 'Report',
                                                   FRA = 'État';
}

