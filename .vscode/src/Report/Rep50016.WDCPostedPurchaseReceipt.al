report 50016 "WDC Posted Purchase Receipt"
{

    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './.vscode/src/Report/RDLC/PosPurchReceipt.rdlc';
    CaptionML = ENU = 'Posted Purchase Receipt Report', FRA = 'Rapport de réception d''achat comptabilisée';
    dataset
    {
        DataItem("Purch. Rcpt. Header"; "Purch. Rcpt. Header")
        {
            //DataItemTableView = sorted;
            RequestFilterFields = "No.";

            column("No"; "No.")
            {

            }
            column(Note; Note)
            {

            }
            column("BuyfromVendorNo"; "Buy-from Vendor No.")
            {

            }

            column("BuyfromVendorName"; "Buy-from Vendor Name")
            {

            }
            column("DueDate"; "Due Date")
            {
            }


            column("BuyfromVendorContact"; "Buy-from Contact No.")
            {
            }
            column("PaymentTermsCode"; "Payment Terms Code")
            {
            }
            column("PaymentMethodCode"; "Payment Method Code")
            {
            }
            column("VATRegistrationNo"; "VAT Registration No.")
            {
            }
            column("BuyfromVendorAddress"; "Buy-from Address")
            {
            }




            column("BuyfromVendorAddress2"; "Buy-from Address 2")
            {
            }

            column("BuyfromVendorPostCode"; "Buy-from Post Code")
            {
            }
            column("LocationCode"; "Location Code")
            {
            }
            column(CompanyName; CompanyInfo.Name)
            {

            }
            column(CompanyAddress; CompanyInfo.Address)
            {

            }
            column(CompanyAddress2; CompanyInfo."Address 2")
            {

            }
            column(CompanyPostCode; CompanyInfo."Post Code") { }
            column(CompanyCity; CompanyInfo.City) { }
            column(CompanyCountry; CompanyInfo."Country/Region Code") { }
            column(CompanyPhoneNo; CompanyInfo."Phone No.") { }
            column(CompanyVATRegistrationNo; CompanyInfo."VAT Registration No.") { }
            column(CompanyGiroNo; CompanyInfo."Giro No.") { }
            column(CompanyBank; CompanyInfo."Bank Name") { }
            column(CompanyEmail; CompanyInfo."E-Mail") { }

            column("BuyfromVendorCity"; "Buy-from City")
            {
            }
            column(AdresseText; AdresseText)
            {
            }

            column("BuyfromVendorCountry"; "Buy-from Country/Region Code")
            {
            }
            column("SelltoCustomerNo"; "Sell-to Customer No.")
            {

            }


            column(OrderNoText; OrderNoText)
            {

            }
            column(PaytoCityText; PaytoCityText)
            {

            }
            column(PaytoPostCodeText; PaytoPostCodeText)
            {

            }
            column(PaytoCountryText; PaytoCountryText)
            {

            }
            column("PostingDate"; "Posting Date")
            {

            }
            column("DocumentDate"; "Document Date")
            {

            }
            column("VendorOrderNo"; "Vendor Order No.")
            {

            }
            column("VendorShipmentNo"; "Vendor Shipment No.")
            {

            }
            column("PhoneNo"; "Ship-to Phone No.")
            {

            }
            column(LineDiscountText; LineDiscountText)
            {
            }
            column("ShiptoAddress"; "Ship-to Address")
            {

            }
            column(VendorOrderNoText; VendorOrderNoText)
            {
            }


            column("ShiptoAddress2"; "Ship-to Address 2")
            {

            }
            column("ShiptoPostCode"; "Ship-to Post Code")
            {

            }
            column(CompanyNameText; CompanyNameText)
            {

            }
            column(CompanyAddressText; CompanyAddressText)
            {

            }
            column(CompanyAddress2Text; CompanyAddress2Text)
            {

            }
            column(CompanyPostCodeText; CompanyPostCodeText)
            {

            }
            column(CompanyCityText; CompanyCityText)
            {

            }
            column(CompanyCountryText; CompanyCountryText)
            {

            }
            column(CompanyPhoneNoText; CompanyPhoneNoText)
            {

            }
            column(CompanyVATRegistrationNoText; CompanyVATRegistrationNoText)
            {

            }
            column(CompanyGiroNoText; CompanyGiroNoText)
            {

            }
            column(CompanyBankText; CompanyBankText)
            {

            }
            column(CompanyHomePageText; CompanyHomePageText)
            {

            }
            column(CompanyEmailText; CompanyEmailText)
            {

            }
            column("ShiptoCity"; "Ship-to City")
            {

            }
            column("ShiptoCountry"; "Ship-to Country/Region Code")
            {

            }
            column("ShiptoContact"; "Ship-to Contact")
            {

            }


            column("PaytoVendorNo"; "Pay-to Vendor No.")
            {

            }
            column("PaytoName"; "Pay-to Name")
            {

            }
            column("OrderDate"; "Order Date")
            {

            }
            column("ShiptoName"; "Ship-to Name")
            {

            }
            column(VendorShipmentNoText; VendorShipmentNoText)
            {
            }
            column(PurchaseReceiptText; PurchaseReceiptText)
            {
            }
            column(PaymentTermsText; PaymentTermsText)
            {
            }
            column(ShipmentMethodText; ShipmentMethodText)
            {
            }
            column(PostingDateText; PostingDateText)
            {
            }
            column(InvoiceNoText; InvoiceNoText)
            {
            }
            column(NoText; NoText)
            {

            }
            column(DescriptionText; DescriptionText)
            {

            }
            column(Paytoaddress; "Pay-to address")
            {

            }
            column(Paytoaddress2; "Pay-to address 2")
            {

            }
            column(PaytoPostCode; "Pay-to Post Code")
            {

            }
            column(PaytoCity; "Pay-to City")
            {

            }
            column(PaytoCountry; "Pay-to Country/Region Code")
            {

            }


            column(Paytocontact; "Pay-to Contact")
            {

            }


            column(QuantityText; QuantityText)
            {

            }
            column(TypeText; TypeText)
            {

            }
            column(VATRegistrationNoText; VATRegistrationNoText)
            {
            }
            column(PhoneNoText; PhoneNoText)
            {

            }
            column(UnitOfMeasureCodeText; UnitOfMeasureCodeText)
            {

            }
            column(DirectUnitCostFromOrderText; DirectUnitCostFromOrderText)
            {

            }

            column(LocationCodeText; LocationCodeText)
            {

            }
            column(DueDateText; DueDateText)
            {
            }
            column(PaytoVendorNoText; PaytoVendorNoText)
            {
            }

            column("ExpectedReceiptDate"; "Expected Receipt Date")
            {

            }
            column(No_; "No.")
            {

            }
            column(Posting_Date; "Posting Date")
            {

            }
            column(Sell_to_Customer_No_; "Sell-to Customer No.")
            {

            }

            column(Order_No_; "Order No.")
            {

            }


            column(Picture; CompanyInfo."Picture")
            {

            }


            dataitem("Purch. Rcpt. Line"; "Purch. Rcpt. Line")
            {

                DataItemLink = "Document No." = field("No.");
                //DataItemTableView = sorted;

                column("LineNo"; "Line No.")
                {

                }
                column("locationcode1"; "location code")
                {

                }
                column("Type"; Type)
                {

                }
                column("No1"; "No.")
                {

                }
                column("Description"; Description)
                {

                }
                column("Quantity"; Quantity)
                {

                }
                column("UnitofMeasure"; "Unit of Measure Code")
                {

                }
                column("DirectUnitCost"; "Direct Unit Cost")
                {

                }
                column(ItemNo; "No.")
                {

                }

                column(Unit_of_Measure_Code; "Unit of Measure Code")
                {

                }

                column(Line_Discount__; "Line Discount %")
                {

                }
                column(VAT__; "VAT %")
                {

                }
                column(UnitCostFromOrder; PurchLine."Unit Cost")
                {

                }
                column(DirectUnitCostFromOrder; PurchLine."Direct Unit Cost")
                {

                }
                column(lineDiscountFromOrder; PurchLine."line discount %")
                {

                }


                column(LineAmountFromOrder; PurchLine."Line Amount")
                {

                }
                column(UnitCostFromOrderText; UnitCostFromOrderText)
                {

                }
                column(LineAmountFromOrderText; LineAmountFromOrderText)
                {

                }
                column(lineDiscountFromOrderText; lineDiscountFromOrderText)
                {

                }
                column(TotalAmount; TotalAmount)
                {

                }
                column(TotalAmounttext; TotalAmounttext)
                {

                }
                column(LineVATAmount; LineVATAmount)
                {

                }
                column(TotalTTCLine; TotalTTCLine)
                {

                }

                column(TotalVATAmount; TotalVATAmount)
                {

                }
                column(TotalIncVATAmount; TotalIncVATAmount)
                {

                }
                column(TotalIncVATAmountText; TotalTTCtext)
                {

                }
                column(TotalVATAmounttext; TotalVATAmounttext)
                {

                }
                column(MontantligneTVAtext; MontantligneTVAtext)
                {

                }

                trigger OnPreDataItem()
                var

                begin
                    TotalAmount := 0;
                    TotalVATAmount := 0;

                end;

                trigger OnAfterGetRecord()
                var
                    PurchRcptLine: Record "Purch. Rcpt. Line";
                    PurchLineLocal: Record "Purchase Line";

                begin
                    TotalTTCLine := 0;
                    TotalAmount := 0;
                    LineVATAmount := 0;
                    PurchLine.Get(PurchLine."Document Type"::Order, "Order No.", "Order Line No.");

                    if Type = Type::Item then begin
                        if Item.Get("No.") then begin
                            if PurchHeader.Get(PurchLine."Document Type", PurchLine."Document No.") then begin
                                if VATPostingSetup.Get(
                                        PurchHeader."VAT Bus. Posting Group",
                                        Item."VAT Prod. Posting Group") then begin
                                    LineVATAmount := ("Quantity" * "Unit Cost") * VATPostingSetup."VAT %" / 100;
                                    TotalVATAmount += LineVATAmount;
                                end;
                            end;
                        end;
                    end;

                    TotalTTCLine := "Quantity" * "Unit Cost" + LineVATAmount;//HD01

                    PurchRcptLine.Reset();
                    PurchRcptLine.SetRange("Document No.", "Document No.");
                    if PurchRcptLine.FindSet() then
                        repeat
                            if PurchLineLocal.Get(PurchLineLocal."Document Type"::Order, PurchRcptLine."Order No.", PurchRcptLine."Order Line No.") and (PurchLineLocal.Quantity <> 0) then
                                TotalAmount += PurchRcptLine."quantity" * PurchLineLocal."Unit Cost";

                        until PurchRcptLine.Next() = 0;





                    TotalIncVATAmount := TotalAmount + TotalVATAmount;
                end;
            }
        }

    }
    trigger OnPreReport()
    var
    begin

        CompanyInfo.Get();
        CompanyInfo.CalcFields(Picture);
    end;

    var
        PurchaseReceiptText: TextConst ENU = 'Purchase - Receipt', FRA = 'Réceptions d''achat';
        PaymentTermsText: TextConst ENU = 'Payment Terms', FRA = 'Conditions de paiement';
        ShipmentMethodText: TextConst ENU = 'Shipment Method', FRA = 'Mode d''expédition';
        PostingDateText: TextConst ENU = 'Posting Date', FRA = 'Date de comptabilisation';
        InvoiceNoText: TextConst ENU = 'Invoice No.', FRA = 'N° de facture';
        DueDateText: TextConst ENU = 'Due Date', FRA = 'Date d''échéance';
        PaytoVendorNoText: TextConst ENU = 'Pay-to Vendor No.', FRA = 'N° fournisseur paiement';
        NoText: TextConst ENU = 'No.', FRA = 'N°';
        DescriptionText: TextConst ENU = 'Description', FRA = 'Description';
        QuantityText: TextConst ENU = 'Quantity', FRA = 'Quantité';
        TypeText: TextConst ENU = 'Type', FRA = 'Type';
        UnitOfMeasureCodeText: TextConst ENU = 'Unit of Measure', FRA = 'Unité';
        LocationCodeText: TextConst ENU = 'Location Code', FRA = 'Code emplacement';
        PhoneNoText: TextConst ENU = 'Phone No.', FRA = 'N° de téléphone';
        VATRegistrationNoText: TextConst ENU = 'VAT Registration No.', FRA = 'N° d''identification TVA';
        Paytoaddress: TextConst ENU = 'Vendor Shipment No.', FRA = 'Numéro d''expédition du fournisseur';
        OrderNoText: TextConst ENU = 'Order No.', FRA = 'N° de commande';
        PaytoCityText: TextConst ENU = 'Pay-to City', FRA = 'Ville de paiement';
        PaytoPostCodeText: TextConst ENU = 'Pay-to Post Code', FRA = 'Code postal de paiement';
        PaytoCountryText: TextConst ENU = 'Pay-to Country/Region Code', FRA = 'Code pays/région de paiement';
        LineDiscountText: TextConst ENU = 'Line Discount %', FRA = 'Remise %';
        VendorOrderNoText: TextConst ENU = 'Vendor Order No.', FRA = 'N° commande fournisseur';
        VendorShipmentNoText: TextConst ENU = 'Vendor Shipment No.', FRA = 'N° expédition fournisseur';
        AdresseText: TextConst ENU = 'Pay-to Address', FRA = 'Adresse';
        CompanyInfo: Record "Company Information";
        CompanyNameText: TextConst ENU = 'Company Name', FRA = 'Nom de la société';
        CompanyAddressText: TextConst ENU = 'Company Address', FRA = 'Adresse de la société';
        CompanyAddress2Text: TextConst ENU = 'Company Address 2', FRA = 'Adresse 2 de la société';
        CompanyPostCodeText: TextConst ENU = 'Company Post Code', FRA = 'Code postal de la société';
        CompanyCityText: TextConst ENU = 'Company City', FRA = 'Ville de la société';
        CompanyCountryText: TextConst ENU = 'Company Country/Region Code', FRA = 'Code pays/région de la société';
        CompanyPhoneNoText: TextConst ENU = 'Phone No.', FRA = 'N° téléphone';
        CompanyVATRegistrationNoText: TextConst ENU = 'VAT Registration No.', FRA = 'N° TVA';
        CompanyGiroNoText: TextConst ENU = 'Giro No.', FRA = 'N° de virement';
        CompanyBankText: TextConst ENU = 'Bank', FRA = 'Banque';
        CompanyHomePageText: TextConst ENU = 'Home Page', FRA = 'Page d''accueil';
        CompanyEmailText: TextConst ENU = 'Email', FRA = 'Courriel';
        PurchLine: Record "Purchase Line";
        UnitCostFromOrderText: TextConst ENU = 'Unit Cost', FRA = 'Coût unitaire';
        DirectUnitCostFromOrderText: TextConst ENU = ' Direct Unit Cost', FRA = 'Coût unitaire';
        lineDiscountFromOrderText: TextConst ENU = 'Line Discount %', FRA = 'Remise %';
        LineAmountFromOrderText: TextConst ENU = 'Line Amount', FRA = 'Montant';
        TotalAmounttext: TextConst ENU = 'Total Exc TAX ', FRA = 'Montant HT';
        TotalVATAmounttext: TextConst ENU = 'Total VAT', FRA = 'Montant TVA';
        TotalTTCtext: TextConst ENU = 'Total Inc VAT', FRA = 'Montant TTC';
        MontantligneTVAtext: TextConst ENU = 'Line VAT Amount', FRA = 'Montant TVA';
        TotalAmount: Decimal;
        TotalVATAmount: Decimal;
        VATPostingSetup: Record "VAT Posting Setup";
        PurchHeader: Record "Purchase Header";
        Item: Record Item;
        LineVATAmount: Decimal;
        TotalIncVATAmount: Decimal;
        TotalTTCLine: Decimal;
}