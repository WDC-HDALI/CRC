report 50876 "WDC-ED EC Sales List - Serv."
{
    DefaultLayout = RDLC;
    RDLCLayout = './.vscode/src_ED/report/RDLC/ECSalesListServices.rdlc';
    captionML = ENU = 'EC Sales List - Services', FRA = 'Liste des ventes UE - Services';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Country/Region"; "Country/Region")
        {
            DataItemTableView = SORTING("EU Country/Region Code") WHERE("EU Country/Region Code" = FILTER(<> ''));
            column(DATE2DMY_PeriodStart_3_; Date2DMY(PeriodStart, 3))
            {
            }
            column(FORMAT_DATE2DMY_PeriodStart_2___0____Integer_2__Filler_Character_0___; Format(Date2DMY(PeriodStart, 2), 0, '<Integer,2><Filler Character,0>'))
            {
            }
            column(CompanyInfo_Name; CompanyInfo.Name)
            {
            }
            column(ContactName; ContactName)
            {
            }
            column(CompanyInfo_Address; CompanyInfo.Address)
            {
            }
            column(PhoneNo; PhoneNo)
            {
            }
            column(Fax; Fax)
            {
            }
            column(VATRegNo; VATRegNo)
            {
            }
            column(CompanyInfo_City_________CompanyInfo__Post_Code_; CompanyInfo.City + ' ' + CompanyInfo."Post Code")
            {
            }
            column(Email; Email)
            {
            }
            column(AmountCaption; AmountCaption)
            {
            }
            column(Country_Region_Code; Code)
            {
            }
            column(Reserved_for_the_Authorities_Caption; Reserved_for_the_Authorities_CaptionLbl)
            {
            }
            column(French_Customs_and_ExciseCaption; French_Customs_and_ExciseCaptionLbl)
            {
            }
            column(B_ServiceCaption; B_ServiceCaptionLbl)
            {
            }
            column(EUROPEAN_DECLARATION_OF_SERVICESCaption; EUROPEAN_DECLARATION_OF_SERVICESCaptionLbl)
            {
            }
            column(French_Department_of_the_TreasuryCaption; French_Department_of_the_TreasuryCaptionLbl)
            {
            }
            column(A__Filling_PeriodCaption; A__Filling_PeriodCaptionLbl)
            {
            }
            column(DATE2DMY_PeriodStart_3_Caption; DATE2DMY_PeriodStart_3_CaptionLbl)
            {
            }
            column(FORMAT_DATE2DMY_PeriodStart_2___0____Integer_2__Filler_Character_0___Caption; FORMAT_DATE2DMY_PeriodStart_2___0____Integer_2__Filler_Character_0___CaptionLbl)
            {
            }
            column(Date_name_and_signatureCaption; Date_name_and_signatureCaptionLbl)
            {
            }
            column(VATRegNoCaption; VATRegNoCaptionLbl)
            {
            }
            column(CompanyInfo_NameCaption; CompanyInfo_NameCaptionLbl)
            {
            }
            column(CompanyInfo_AddressCaption; CompanyInfo_AddressCaptionLbl)
            {
            }
            column(City_and_Zip_Caption; City_and_Zip_CaptionLbl)
            {
            }
            column(Contact_Person_Caption; Contact_Person_CaptionLbl)
            {
            }
            column(Phone_Caption; Phone_CaptionLbl)
            {
            }
            column(EmailCaption; EmailCaptionLbl)
            {
            }
            column(Fax_Caption; Fax_CaptionLbl)
            {
            }
            column(C__Filled_By_Caption; C__Filled_By_CaptionLbl)
            {
            }
            column(V3Caption; V3CaptionLbl)
            {
            }
            column(V2Caption; V2CaptionLbl)
            {
            }
            column(V1Caption; V1CaptionLbl)
            {
            }
            column(Customer_VAT_NumberCaption; Customer_VAT_NumberCaptionLbl)
            {
            }
            column(Line_NumberCaption; Line_NumberCaptionLbl)
            {
            }
            dataitem("VAT Entry"; "VAT Entry")
            {
                DataItemLink = "Country/Region Code" = FIELD(Code);
                DataItemTableView = SORTING(Type, "Country/Region Code", "VAT Registration No.", "VAT Bus. Posting Group", "VAT Prod. Posting Group", "Posting Date") WHERE(Type = CONST(Sale), "Country/Region Code" = FILTER(<> ''), "EU Service" = FILTER(true));
                RequestFilterFields = "VAT Bus. Posting Group", "VAT Prod. Posting Group", "Posting Date";
                column(LineNo; LineNo)
                {
                }
                column(VATAmount; VATAmount)
                {
                    DecimalPlaces = 0 : 0;
                }
                column(VAT_Entry__VAT_Registration_No__; "VAT Registration No.")
                {
                }
                column(VAT_Entry_Entry_No_; "Entry No.")
                {
                }
                column(VAT_Entry_Country_Region_Code; "Country/Region Code")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if StrLen("VAT Registration No.") > 14 then
                        CustVATRegNo := CopyStr("VAT Registration No.", (StrLen("VAT Registration No.") + 1 - 14))
                    else
                        CustVATRegNo := "VAT Registration No.";
                    if UseAmtsInAddCurr then begin
                        VATAmount := "Additional-Currency Base";
                        VATAmountXML := Base;
                    end else
                        VATAmount := Base;

                    VATAmount := Round(VATAmount, 1, '=');
                    Evaluate(VATAmount, Format(-VATAmount, 0, '<Sign><Integer>'));
                    if UseAmtsInAddCurr then
                        Evaluate(VATAmountXML, Format(-VATAmountXML, 0, '<Sign><Integer>'));
                    if "VAT Registration No." <> PrevVATRegNo then begin
                        if CreateXMLFile and (VATAmountRTC <> 0) then
                            CreateXMLLine;
                        if VATAmount <> 0 then
                            LineNo := LineNo + 1
                        else begin
                            VATEntry.Reset();
                            VATEntry.CopyFilters("VAT Entry");
                            VATEntry.SetRange("VAT Registration No.", "VAT Registration No.");
                            VATEntry.SetFilter(Base, '>=%1|<=%2', 0.5, -0.5);
                            if VATEntry.FindFirst then
                                LineNo := LineNo + 1;
                        end;
                        VATAmountRTC := 0;
                        if not UseAmtsInAddCurr then
                            VATAmountXML := 0;
                        PrevVATRegNo := CustVATRegNo;
                    end;
                    VATAmountRTC := VATAmountRTC + VATAmount;
                    if not UseAmtsInAddCurr then
                        VATAmountXML := VATAmountXML + VATAmount;
                end;

                trigger OnPostDataItem()
                begin
                    if CreateXMLFile and (VATAmountRTC <> 0) then
                        CreateXMLLine;
                end;

                trigger OnPreDataItem()
                begin
                    VATAmountRTC := 0;
                    VATAmountXML := 0;
                    Clear(VATAmount);
                end;
            }

            trigger OnPreDataItem()
            begin
                CompanyInfo.Get();
                GLSetup.Get();
                if UseAmtsInAddCurr then begin
                    if GLSetup."Additional Reporting Currency" <> '' then
                        AmountCaption := StrSubstNo(Text10800, GLSetup."Additional Reporting Currency");
                end else
                    AmountCaption := StrSubstNo(Text10800, GLSetup."LCY Code");
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
                    field(ContactName; ContactName)
                    {
                        ApplicationArea = All;
                        captionML = ENU = 'Contact Person', FRA = 'Personne à contacter';
                    }
                    field(PhoneNo; PhoneNo)
                    {
                        ApplicationArea = All;
                        captionML = ENU = 'Phone', FRA = 'Téléphone';
                    }
                    field(Fax; Fax)
                    {
                        ApplicationArea = All;
                        captionML = ENU = 'Fax', FRA = 'Télécopieur';
                    }
                    field(Email; Email)
                    {
                        ApplicationArea = All;
                        captionML = ENU = 'Email Address', FRA = 'Adresse e-mail';
                    }
                    field(ShowAmountsInAddReportingCurrency; UseAmtsInAddCurr)
                    {
                        ApplicationArea = All;
                        captionML = ENU = 'Show Amounts in Add. Reporting Currency', FRA = 'Afficher montants en devise report';
                        MultiLine = true;
                    }
                    field(CreateXML; CreateXMLFile)
                    {
                        ApplicationArea = All;
                        captionML = ENU = 'Create XML', FRA = 'Créer un fichier XML';

                        trigger OnValidate()
                        begin
                            PageUpdateRequestForm;
                        end;
                    }
                    field(XMLFile; XMLFile)
                    {
                        ApplicationArea = All;
                        Enabled = XMLFileEnable;
                        Visible = XMLFileVisible;

                        trigger OnAssistEdit()
                        var
                            FileMgt: Codeunit "File Management";
                        begin
                            if XMLFile = '' then
                                XMLFile := '.xml';
                            //XMLFile := FileMgt.SaveFileDialog(Text002, XMLFile, '');
                        end;
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnInit()
        begin
            XMLFileEnable := true;
            XMLFileVisible := true;
        end;

        trigger OnOpenPage()
        begin
            PageUpdateRequestForm;
        end;
    }

    labels
    {
    }

    trigger OnPostReport()
    var
        ToFile: Text[1024];
    begin
        if CreateXMLFile then begin
            // if CheckXMLLine then
            //     XMLDoc.Save(XMLFile)
            // else
            //     Error(Text10801);
            // ToFile := Text005;
            // if not Download(XMLFile, Text002, '', Text001, ToFile) then
            //     exit;
            // Message(Text003);
        end;
    end;

    trigger OnPreReport()
    var
        Calendar: Record Date;
        FileMgt: Codeunit "File Management";
        PeriodEnd: Date;
    begin
        // if CreateXMLFile then
        //     XMLFile := FileMgt.ServerTempFileName('xml');

        if StrLen(CompanyInfo."VAT Registration No.") = 11 then
            VATRegNo := CompanyInfo."Country/Region Code" + CompanyInfo."VAT Registration No."
        else
            VATRegNo := CompanyInfo."VAT Registration No.";

        PeriodStart := "VAT Entry".GetRangeMin("Posting Date");
        PeriodEnd := "VAT Entry".GetRangeMax("Posting Date");

        Calendar.Reset();
        Calendar.SetRange("Period Type", Calendar."Period Type"::Month);
        Calendar.SetRange("Period Start", PeriodStart);
        Calendar.SetRange("Period End", ClosingDate(PeriodEnd));
        if not Calendar.FindFirst then
            Error(Text004, "VAT Entry".FieldCaption("Posting Date"), "VAT Entry".GetFilter("Posting Date"));

        // if CreateXMLFile then
        //     CreateXMLDocument;
    end;

    // procedure CreateXMLDocument()
    // var
    //     XMLCurrNode2: DotNet XmlNode;
    //     ProcessingInstruction: DotNet XmlProcessingInstruction;
    // begin
    //     XMLDoc := XMLDoc.XmlDocument;
    //     XMLCurrNode2 := XMLDoc.CreateElement('fichier_des');
    //     XMLDoc.AppendChild(XMLCurrNode2);
    //     XMLCurrNode := XMLDoc.CreateElement('declaration_des');
    //     XMLCurrNode2.AppendChild(XMLCurrNode);

    //     ProcessingInstruction := XMLDoc.CreateProcessingInstruction('xml', 'version="1.0" encoding="UTF-8"');

    //     XMLDOMMgt.AddElement(XMLCurrNode, 'num_des', '000001', '', NewChildNode);
    //     XMLDOMMgt.AddElement(XMLCurrNode, 'num_tvaFr', VATRegNo, '', NewChildNode);
    //     XMLDOMMgt.AddElement(XMLCurrNode, 'mois_des', Format(Date2DMY(PeriodStart, 2), 0, '<Integer,2><Filler Character,0>'), '', NewChildNode);
    //     XMLDOMMgt.AddElement(XMLCurrNode, 'an_des', Format(Date2DMY(PeriodStart, 3)), '', NewChildNode);
    // end;

    procedure CreateXMLLine()
    begin
        // CheckXMLLine := true;

        // XMLDOMMgt.AddElement(XMLCurrNode, 'ligne_des', '', '', NewChildNode);
        // XMLDOMMgt.AddElement(NewChildNode, 'numlin_des', Format(LineNo, 0, '<Integer,6><Filler Character,0>'), '', NewChildNode2);
        // XMLDOMMgt.AddElement(NewChildNode, 'valeur', Format(VATAmountXML, 0, '<Sign><Integer>'), '', NewChildNode2);
        // XMLDOMMgt.AddElement(NewChildNode, 'partner_des', PrevVATRegNo, '', NewChildNode2);
    end;

    local procedure PageUpdateRequestForm()
    begin
        CompanyInfo.Get();
        PhoneNo := CompanyInfo."Phone No.";
        Fax := CompanyInfo."Fax No.";
        Email := CompanyInfo."E-Mail";
        XMLFileVisible := false;
    end;

    var
        CompanyInfo: Record "Company Information";
        GLSetup: Record "General Ledger Setup";
        VATEntry: Record "VAT Entry";
        XMLDOMMgt: Codeunit "XML DOM Management";
        // XMLCurrNode: DotNet XmlNode;
        // XMLDoc: DotNet XmlDocument;
        // NewChildNode: DotNet XmlNode;
        // NewChildNode2: DotNet XmlNode;
        XMLFile: Text;
        Email: Text;
        ContactName: Text;
        PhoneNo: Text;
        Fax: Text;
        VATRegNo: Text;
        CustVATRegNo: Text;
        PrevVATRegNo: Text;
        CreateXMLFile: Boolean;
        LineNo: Integer;
        VATAmount: Decimal;
        UseAmtsInAddCurr: Boolean;
        PeriodStart: Date;
        VATAmountRTC: Decimal;
        XMLFileVisible: Boolean;
        XMLFileEnable: Boolean;
        AmountCaption: Text;
        VATAmountXML: Decimal;
        CheckXMLLine: Boolean;
        Text001: TextConst ENU = 'XML Files (*.xml)|*.xml|All Files (*.*)|*.*',
                           FRA = 'Fichiers XML (*.xml)|*.xml|Tous les fichiers (*.*)|*.*',
                           Comment = 'Only translate ''XML Files'' and ''All Files'' {Split=r"[\|\(]\*\.[^ |)]*[|) ]?"}';
        Text002: TextConst ENU = 'Export to XML File.',
                           FRA = 'Exporter en fichier XML.';
        Text003: TextConst ENU = 'XML file successfully created.',
                           FRA = 'Fichier XML créé avec succès.';
        Text004: TextConst ENU = '%1 filter %2 must be corrected, to run the report monthly.',
                           FRA = 'Le filtre %1 %2 doit être corrigé afin d''exécuter l''état par mois.';
        Text005: TextConst ENU = 'Default.xml',
                           FRA = 'Default.xml';
        Text10800: TextConst ENU = 'Amount( %1)',
                             FRA = 'Montant (%1)';
        Text10801: TextConst ENU = 'There is no data to export. No XML file is created.',
                             FRA = 'Aucune donnée à exporter. Aucun fichier XML n''est créé.';
        Reserved_for_the_Authorities_CaptionLbl: TextConst ENU = '(Reserved for the Authorities)',
                                                           FRA = '(Réservé à l''administration)';
        French_Customs_and_ExciseCaptionLbl: TextConst ENU = 'French Customs and Excise',
                                                       FRA = 'French Customs and Excise';
        B_ServiceCaptionLbl: TextConst ENU = 'B.Service',
                                       FRA = 'B.Service';
        EUROPEAN_DECLARATION_OF_SERVICESCaptionLbl: TextConst ENU = 'EUROPEAN DECLARATION OF SERVICES',
                                                              FRA = 'DÉCLARATION EUROPÉENNE DE SERVICES';
        French_Department_of_the_TreasuryCaptionLbl: TextConst ENU = 'French Department of the Treasury',
                                                               FRA = 'Direction générale des impôts';
        A__Filling_PeriodCaptionLbl: TextConst ENU = 'A. Filling Period',
                                               FRA = 'A. Période de déclaration';
        DATE2DMY_PeriodStart_3_CaptionLbl: TextConst ENU = 'Year:',
                                                     FRA = 'Année :';
        FORMAT_DATE2DMY_PeriodStart_2___0____Integer_2__Filler_Character_0___CaptionLbl: TextConst ENU = 'Month:',
                                                                                                   FRA = 'Mois :';
        Date_name_and_signatureCaptionLbl: TextConst ENU = 'Date,name and signature',
                                                     FRA = 'Date, nom et signature';
        VATRegNoCaptionLbl: TextConst ENU = 'VAT Registration Number:',
                                      FRA = 'N° identif. intracomm.';
        CompanyInfo_NameCaptionLbl: TextConst ENU = 'Company Name:',
                                              FRA = 'Nom de la société :';
        CompanyInfo_AddressCaptionLbl: TextConst ENU = 'Address:',
                                                 FRA = 'Adresse :';
        City_and_Zip_CaptionLbl: TextConst ENU = 'City and Zip:',
                                           FRA = 'Code postal/Ville';
        Contact_Person_CaptionLbl: TextConst ENU = 'Contact Person:',
                                             FRA = 'Personne à contacter:';
        Phone_CaptionLbl: TextConst ENU = 'Phone:',
                                    FRA = 'Téléphone :';
        EmailCaptionLbl: TextConst ENU = 'Email Address:',
                                   FRA = 'Adresse e-mail :';
        Fax_CaptionLbl: TextConst ENU = 'Fax:',
                                  FRA = 'Télécopieur :';
        C__Filled_By_CaptionLbl: TextConst ENU = 'C. Filled By:',
                                           FRA = 'C. complété par:';
        V3CaptionLbl: TextConst ENU = '3',
                                FRA = '3';
        V2CaptionLbl: TextConst ENU = '2',
                                FRA = '2';
        V1CaptionLbl: TextConst ENU = '1',
                                FRA = '1';
        Customer_VAT_NumberCaptionLbl: TextConst ENU = 'Customer VAT Number',
                                                 FRA = 'N° TVA client';
        Line_NumberCaptionLbl: TextConst ENU = 'Line Number',
                                         FRA = 'Numéro ligne';
}

