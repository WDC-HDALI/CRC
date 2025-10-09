pageextension 50063 "WDC Vendor List" extends "Vendor List"
{
    layout
    {
        modify("Search Name")
        {
            Visible = false;
        }
        modify("Balance Due (LCY)")
        {
            Visible = false;
        }
        modify("Balance (LCY)")
        {
            Visible = false;
        }
        modify("Responsibility Center")
        {
            Visible = false;
        }
        modify("Location Code")
        {
            Visible = false;
        }
        modify(Blocked)
        {
            Visible = true;
        }

        modify(Contact)
        {
            Visible = false;
        }
        addafter(Name)
        {
            field(Address; Rec.Address)
            {
                ApplicationArea = All;
            }
            field(City; Rec.City)
            {
                ApplicationArea = All;
            }

        }
        addafter("Phone No.")
        {
            field(Report; Rec.Report)
            {
                ApplicationArea = all;
                Style = StrongAccent;
            }
            field(VendorInvoice; Rec.VendorInvoice)
            {
                ApplicationArea = all;
                Style = Strong;
            }
            field("TotalReceiptNotInv"; Rec."Total Receipt")
            {
                CaptionML = ENU = 'Receipts not invoiced', FRA = 'Réceptions Non facturées';
                ApplicationArea = all;
                Style = Strong;
            }
            field(VendorPayment; Rec.VendorPayment)
            {
                CaptionML = ENU = 'Payments', FRA = 'Paiements';
                ApplicationArea = all;
                Style = StrongAccent;
            }

            field("Draft Not Due"; Rec."Draft Not Due")
            {
                ApplicationArea = all;
                Style = StrongAccent;
            }
            field(TotalVendorAmount; TotalvendorAmount)
            {
                CaptionML = ENU = 'Total Vendor Amount', FRA = 'Solde fournisseur';
                ApplicationArea = all;
                Style = Strong;
                StyleExpr = StyleTxt;
                Editable = false;
            }



        }
    }
    actions
    {

        modify("Ledger E&ntries")
        {
            ApplicationArea = All;
            Promoted = true;
            PromotedCategory = Process;
            PromotedIsBig = true;
            PromotedOnly = true;
        }
        addafter(ApplyTemplate)
        {
            action("Customer Extract")
            {
                CaptionML = ENU = 'Vendor Extract', FRA = 'Extrait fournisseur';
                ApplicationArea = All;
                Image = Invoice;
                PromotedOnly = true;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    lVendor: Record Vendor;
                begin
                    lVendor.Reset;
                    lVendor.SetRange("No.", Rec."No.");
                    Report.RunModal(50028, true, false, lVendor);
                end;

            }
        }
    }


    trigger OnAfterGetRecord()
    var
        UserSetup: Record "User Setup";
        GLSetup: record "General Ledger Setup";
    begin
        GLSetup.get;
        UserSetup.Get(UserId);

        Rec.SetFilter("Start Year Filter", '..%1', GLSetup."Allow Deferral Posting From");
        rec.SetFilter("Due Date Filter", '%1..', WorkDate);

        TotalvendorAmount := rec."Balance (LCY)" - rec."Total Receipt";

        StyleTxt := Color();
    end;

    procedure Color(): text[50]
    begin
        if TotalvendorAmount < 0 then
            exit('unfavorable')
        else
            exit('favorable');

    end;


    var
        TotalvendorAmount: decimal;
        StyleTxt: text[50];
}