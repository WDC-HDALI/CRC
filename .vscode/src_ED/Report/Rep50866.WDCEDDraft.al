report 50866 "WDC-ED Draft"
{
    DefaultLayout = RDLC;
    RDLCLayout = './.vscode/src_ED/report/RDLC/Draft.rdlc';
    captionML = ENU = 'Draft', FRA = 'Brouillon';

    dataset
    {
        dataitem("Payment Line"; "WDC-ED Payment Line")
        {
            DataItemTableView = WHERE("Account Type" = FILTER(Vendor), Marked = CONST(true));
            RequestFilterHeading = 'Payment lines';
            column(CompanyAddr_6_; CompanyAddr[6])
            {
            }
            column(CompanyAddr_7_; CompanyAddr[7])
            {
            }
            column(CompanyAddr_5_; CompanyAddr[5])
            {
            }
            column(CompanyAddr_4_; CompanyAddr[4])
            {
            }
            column(CompanyAddr_2_; CompanyAddr[2])
            {
            }
            column(CompanyAddr_3_; CompanyAddr[3])
            {
            }
            column(CompanyAddr_1_; CompanyAddr[1])
            {
            }
            column(PaymtHeader__Bank_Post_Code_; PaymtHeader."Bank Post Code")
            {
            }
            column(CONVERTSTR_FORMAT_PaymtHeader__RIB_Key__2_______0__; ConvertStr(Format(PaymtHeader."RIB Key", 2), ' ', '0'))
            {
            }
            column(PostingDate; Format(PostingDate))
            {
            }
            column(FORMAT_Amount_0___Precision_2___Standard_Format_0___; '****' + Format(Amount, 0, '<Precision,2:><Standard Format,0>'))
            {
            }
            column(FORMAT_Amount_0___Precision_2___Standard_Format_0____Control1120051; '****' + Format(Amount, 0, '<Precision,2:><Standard Format,0>'))
            {
            }
            column(BillReference; BillReference)
            {
            }
            column(IssueCity; IssueCity)
            {
            }
            column(AmountText; AmountText)
            {
            }
            column(IssueDate; Format(IssueDate))
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
            column(PaymtHeader__Bank_Name_; PaymtHeader."Bank Name")
            {
            }
            column(Payment_Line__Due_Date_; Format("Due Date"))
            {
            }
            column(Payment_Line_No_; "No.")
            {
            }
            column(Payment_Line_Line_No_; "Line No.")
            {
            }
            column(OK_FOR_ENDORSMENTCaption; OK_FOR_ENDORSMENTCaptionLbl)
            {
            }
            column(of_SUBSCRIBERCaption; of_SUBSCRIBERCaptionLbl)
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
            column(SUBSCRIBER_S_R_I_B_Caption; SUBSCRIBER_S_R_I_B_CaptionLbl)
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
            column(DRAFTCaption; DRAFTCaptionLbl)
            {
            }
            column(SUBSCRIBER_REF_Caption; SUBSCRIBER_REF_CaptionLbl)
            {
            }
            column(DRAFTCaption_Control1120002; DRAFTCaption_Control1120002Lbl)
            {
            }

            trigger OnAfterGetRecord()
            begin
                GLSetup.Get();

                PaymtHeader.Get("No.");

                PostingDate := PaymtHeader."Posting Date";

                GLSetup.Get();
                if IssueDate = 0D then
                    IssueDate := WorkDate;

                FormatAddress.Company(CompanyAddr, CompanyInfo);

                if "Currency Code" = '' then
                    AmountText := Text001 + ' €'
                else
                    AmountText := Text001 + ' ' + "Currency Code";
            end;

            trigger OnPreDataItem()
            begin
                CompanyInfo.Get();
                CompanyInfo.TestField("Default Bank Account No.");
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
        Against_the_present_DRAFT_noted_as_NO_CHARGES__we_will_pay_the_indicated_sum_below_toCaption = 'Against the present DRAFT noted as NO CHARGES, we will pay the indicated sum below to :';
    }

    var
        CompanyInfo: Record "Company Information";
        GLSetup: Record "General Ledger Setup";
        PaymtHeader: Record "WDC-ED Payment Header";
        FormatAddress: Codeunit "Format Address";
        CompanyAddr: array[8] of Text[100];
        IssueCity: Text[30];
        IssueDate: Date;
        BillReference: Code[10];
        PostingDate: Date;
        AmountText: Text[30];
        Text001: TextConst ENU = 'Amount',
                           FRA = 'Montant';
        OK_FOR_ENDORSMENTCaptionLbl: TextConst ENU = 'OK FOR ENDORSMENT',
                                               FRA = 'BON POUR AVAL';
        of_SUBSCRIBERCaptionLbl: TextConst ENU = 'of SUBSCRIBER', Comment = 'NAME and ADDRESS of SUBSCRIBER',
                                           FRA = 'du SOUSCRIPTEUR';
        Stamp_Allow_and_SignatureCaptionLbl: TextConst ENU = 'Stamp Allow and Signature',
                                                       FRA = 'Droit de timbre et signature';
        ADDRESSCaptionLbl: TextConst ENU = 'ADDRESS',
                                     FRA = 'ADRESSE';
        NAME_andCaptionLbl: TextConst ENU = 'NAME and',
                                      FRA = 'NOM et';
        Value_in__CaptionLbl: TextConst ENU = 'Value in :',
                                        FRA = 'Valeur entrée :';
        SUBSCRIBER_S_R_I_B_CaptionLbl: TextConst ENU = 'SUBSCRIBER''S R.I.B.',
                                               FRA = '';
        DOMICILIATIONCaptionLbl: TextConst ENU = 'DOMICILIATION',
                                           FRA = 'R.I.B. du SOUSCRIPTEUR',
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
        DRAFTCaptionLbl: TextConst ENU = 'DRAFT',
                                   FRA = 'BROUILLON';
        SUBSCRIBER_REF_CaptionLbl: TextConst ENU = 'SUBSCRIBER REF.',
                                             FRA = 'RÉF. SOUSCRIPTEUR';
        DRAFTCaption_Control1120002Lbl: TextConst ENU = 'DRAFT',
                                                  FRA = 'BROUILLON',
                                                  Comment = 'Translate draft and uppecase the result';
}

