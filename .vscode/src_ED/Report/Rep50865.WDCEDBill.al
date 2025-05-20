report 50865 "WDC-ED Bill"
{
    DefaultLayout = RDLC;
    RDLCLayout = './.vscode/src_ED/report/RDLC/Bill.rdlc';
    captionML = ENU = 'Bill', FRA = 'Lettre de change';

    dataset
    {
        dataitem("Payment Line"; "WDC-ED Payment Line")
        {
            DataItemTableView = WHERE("Account Type" = FILTER(Customer), Marked = CONST(true));
            RequestFilterHeading = 'Payment lines';
            column(CustAdr_6_; CustAdr[6])
            {
            }
            column(CustAdr_7_; CustAdr[7])
            {
            }
            column(CustAdr_5_; CustAdr[5])
            {
            }
            column(CustAdr_4_; CustAdr[4])
            {
            }
            column(CustAdr_2_; CustAdr[2])
            {
            }
            column(CustAdr_3_; CustAdr[3])
            {
            }
            column(CustAdr_1_; CustAdr[1])
            {
            }
            column(Payment_Line__Agency_Code_; "Agency Code")
            {
            }
            column(Payment_Line__Bank_Branch_No__; "Bank Branch No.")
            {
            }
            column(Payment_Line__Bank_Account_No__; "Bank Account No.")
            {
            }
            column(CONVERTSTR_FORMAT__RIB_Key__2_______0__; ConvertStr(Format("RIB Key", 2), ' ', '0'))
            {
            }
            column(Payment_Line__Bank_Account_Name_; "Bank Account Name")
            {
            }
            column(FORMAT_Amount_0___Precision_2___Standard_Format_0___; '****' + Format(Amount, 0, '<Precision,2:><Standard Format,0>'))
            {
            }
            column(FORMAT_Amount_0___Precision_2___Standard_Format_0____Control1120051; '****' + Format(Amount, 0, '<Precision,2:><Standard Format,0>'))
            {
            }
            column(Payment_Line__Drawee_Reference_; "Drawee Reference")
            {
            }
            column(IssueCity; IssueCity)
            {
            }
            column(IssueDate; Format(IssueDate))
            {
            }
            column(Payment_Line__Due_Date_; Format("Due Date"))
            {
            }
            column(Payment_Line__Bank_City_; "Bank City")
            {
            }
            column(PostingDate; Format(PostingDate))
            {
            }
            column(AmountText; AmountText)
            {
            }
            column(FORMAT_AmountText_; Format(AmountText))
            {
            }
            column(Payment_Line_No_; "No.")
            {
            }
            column(Payment_Line_Line_No_; "Line No.")
            {
            }
            column(ACCEPTANCE_or_ENDORSMENTCaption; ACCEPTANCE_or_ENDORSMENTCaptionLbl)
            {
            }
            column(of_DRAWEECaption; of_DRAWEECaptionLbl)
            {
            }
            column(Stamp_Allow_and_SignatureCaption; Stamp_Allow_and_SignatureCaptionLbl)
            {
            }
            column(ADDRESSCaption; ADDRESSCaptionLbl)
            {
            }
            column(NAME_andCaption; NAME_andCaptionLbl)
            {
            }
            column(Value_in__Caption; Value_in__CaptionLbl)
            {
            }
            column(DRAWEE_R_I_B_Caption; DRAWEE_R_I_B_CaptionLbl)
            {
            }
            column(DOMICILIATIONCaption; DOMICILIATIONCaptionLbl)
            {
            }
            column(TOCaption; TOCaptionLbl)
            {
            }
            column(ONCaption; ONCaptionLbl)
            {
            }
            column(AMOUNT_FOR_CONTROLCaption; AMOUNT_FOR_CONTROLCaptionLbl)
            {
            }
            column(CREATION_DATECaption; CREATION_DATECaptionLbl)
            {
            }
            column(DUE_DATECaption; DUE_DATECaptionLbl)
            {
            }
            column(DRAWEE_REF_Caption; DRAWEE_REF_CaptionLbl)
            {
            }
            column(BILLCaption; BILLCaptionLbl)
            {
            }

            trigger OnAfterGetRecord()
            var
                CustPaymentAddr: Record "WDC-ED Payment Address";
                Cust: Record Customer;
                FormatAddress: Codeunit "Format Address";
            begin
                CustPaymentAddr.Init();

                PaymtHeader.Get("No.");
                PostingDate := PaymtHeader."Posting Date";

                Amount := -Amount;

                GLSetup.Get();
                if IssueDate = 0D then
                    IssueDate := WorkDate;

                if CustPaymentAddr.Get("Account Type", "Account No.", "Payment Address Code") then
                    PaymtManagt.PaymentAddr(CustAdr, CustPaymentAddr)
                else begin
                    Cust.Get("Account No.");
                    FormatAddress.Customer(CustAdr, Cust);
                end;

                if "Currency Code" = '' then
                    AmountText := Text001 + ' €'
                else
                    AmountText := Text001 + ' ' + "Currency Code";
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
                    captionML = ENU = 'Options';
                    field(IssueDate; IssueDate)
                    {
                        ApplicationArea = All;
                        captionML = ENU = 'Issue date', FRA = 'Date d''émission';
                    }
                    field(IssueCity; IssueCity)
                    {
                        ApplicationArea = All;
                        captionML = ENU = 'Issue city', FRA = 'Ville d''émission';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            CompanyInfo.Get();
            IssueCity := CompanyInfo.City;
            IssueDate := WorkDate;
        end;
    }

    labels
    {
        Against_this_BILL_noted_as_NO_CHARGES_please_pay_the_indicated_sum_below_for_order_ofCaption = 'Against this BILL noted as NO CHARGES Please pay the indicated sum below for order of :';
    }

    var
        CompanyInfo: Record "Company Information";
        GLSetup: Record "General Ledger Setup";
        PaymtHeader: Record "WDC-ED Payment Header";
        PaymtManagt: Codeunit "WDC-ED Payment Management";
        CustAdr: array[8] of Text[100];
        IssueCity: Text[30];
        IssueDate: Date;
        PostingDate: Date;
        AmountText: Text[30];
        Text001: TextConst ENU = 'Amount',
                           FRA = 'Montant';
        ACCEPTANCE_or_ENDORSMENTCaptionLbl: TextConst ENU = 'ACCEPTANCE or ENDORSMENT',
                                                      FRA = 'ACCEPTATION ou AVAL';
        of_DRAWEECaptionLbl: TextConst ENU = 'of DRAWEE', Comment = 'NAME and ADDRESS of DRAWEE',
                                       FRA = 'du TIRÉ';
        Stamp_Allow_and_SignatureCaptionLbl: TextConst ENU = 'Stamp Allow and Signature',
                                                       FRA = 'Droit de timbre et signature';
        ADDRESSCaptionLbl: TextConst ENU = 'ADDRESS', Comment = 'Translate address and uppecase the result',
                                     FRA = 'ADRESSE';
        NAME_andCaptionLbl: TextConst ENU = 'NAME and',
                                      FRA = 'NOM et';
        Value_in__CaptionLbl: TextConst ENU = 'Value in :',
                                        FRA = 'Valeur entrée :';
        DRAWEE_R_I_B_CaptionLbl: TextConst ENU = 'DRAWEE R.I.B.',
                                           FRA = 'R.I.B. DU TIRÉ';
        DOMICILIATIONCaptionLbl: TextConst ENU = 'DOMICILIATION',
                                           FRA = 'DOMICILIATION',
                                           Comment = 'Translate domiciliation and uppecase the result';
        TOCaptionLbl: TextConst ENU = 'TO',
                                FRA = 'A';
        ONCaptionLbl: TextConst ENU = 'ON',
                                FRA = 'Dans';
        AMOUNT_FOR_CONTROLCaptionLbl: TextConst ENU = 'AMOUNT FOR CONTROL',
                                                FRA = 'MONTANT POUR CONTRÔLE';
        CREATION_DATECaptionLbl: TextConst ENU = 'CREATION DATE',
                                           FRA = 'DATE CRÉATION';
        DUE_DATECaptionLbl: TextConst ENU = 'DUE DATE',
                                      FRA = 'DATE D''ÉCHÉANCE';
        DRAWEE_REF_CaptionLbl: TextConst ENU = 'DRAWEE REF.',
                                         FRA = 'RÉF. TIRÉ';
        BILLCaptionLbl: TextConst ENU = 'BILL',
                                  FRA = 'EFFET';
}

