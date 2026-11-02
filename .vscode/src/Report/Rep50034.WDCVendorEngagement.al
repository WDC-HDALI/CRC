report 50034 "WDC Vendor Engagement"
{
    CaptionML = ENU = 'Vendor Engagement', FRA = 'Engagement fournisseur';
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = './.vscode/src/Report/RDLC/VendorEngagement.rdlc';
    ApplicationArea = All;
    DefaultLayout = RDLC;

    dataset
    {
        dataitem("Vendor Ledger Entry"; "Vendor Ledger Entry")
        {
            DataItemTableView = sorting("Vendor No.", Open, Positive, "Due Date", "Currency Code") order(ascending)
                                where("Document Type" = const(Payment),
                                      "Payment Slip Type" = Filter(Cheque | Draft | Transfer));



            RequestFilterFields = "Vendor No.", "Due Date";

            column(VendorNo; "Vendor No.")
            {

            }
            column(VendorName; "Vendor Name")
            {

            }
            column(DueDate; "Due Date")
            {

            }
            column(Document_No_; "Document No.")
            {

            }
            column(ReferencePayment; "Payment Reference")
            {

            }
            column(Payment_Slip_Type; "Payment Slip Type")
            {

            }
            column(Amount__LCY_; "Amount (LCY)")
            {

            }
            column(ExternalDocNo; "External Document No.")
            {

            }
            column(PostingDate; "Posting Date")
            {

            }
            column(TotalAmount; TotalAmount)
            {

            }
            column(BankTxt; BankTxt)
            {

            }
            column(Picture; Company.Picture)
            {
            }
            column(company; Company.Name)

            {
            }
            column(Address; Company.Address)
            {
            }
            column(City; Company.City)
            {
            }
            column(PhoneNo; Company."Phone No.")
            {
            }
            column(FaxNo; Company."Fax No.")
            {
            }
            column(Email; Company."E-mail")
            {
            }

            column(TaxRegistrationNo; Company."VAT Registration No.")
            {
            }
            column(postcode; Company."post Code")
            {
            }
            column(CountryRegionCode; Company."Country/Region Code")
            {
            }


            trigger OnAfterGetRecord()
            var
                Bordereau: Record "WDC-ED Payment Header";
                lBordLines: record "WDC-ED Payment Line";

            begin
                TotalAmount := 0;
                TotalRSAmount := 0;
                if Bordereau.get("Document No.") then
                    BankTxt := Bordereau."Account No.";
                Company.GEt;
                Company.CalcFields(Picture);
                "Vendor Ledger Entry".CalcFields("Amount (LCY)");

                lBordLines.Reset();
                lBordLines.SetRange("No.", "Vendor Ledger Entry"."Document No.");
                lBordLines.SetFilter("Validated RS Amount", '<>%1', 0);
                If lBordLines.FindFirst() then
                    repeat
                        TotalRSAmount := lBordLines."Validated RS Amount" * -1;
                    until lBordLines.next = 0;

                TotalAmount += "Vendor Ledger Entry"."Amount (LCY)" - TotalRSAmount;
            end;

            trigger OnPreDataItem()
            begin
                //"Vendor Ledger Entry".SetFilter("Due Date", '>=%1', WorkDate());
            end;

        }
    }

    var
        TotalAmount: Decimal;
        TotalRSAmount: Decimal;
        BankTxt: text[100];
        company: Record "Company Information";
}