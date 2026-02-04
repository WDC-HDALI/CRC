namespace CRC.CRC;

using Microsoft.Purchases.Vendor;
using Microsoft.Finance.GeneralLedger.Setup;
using System.Security.User;
//  ************Documentation***************
//WDC01  WDC.HG 13/08/2025  Update Vendor Card 
pageextension 50037 "WDC Vendor Card" extends "Vendor Card"
{
    //<<wdc01
    layout
    {
        moveafter(Blocked; "Currency Code")
        modify("Balance Due (LCY)")
        {
            Visible = false;
        }
        modify("Company Size Code")
        {
            Visible = false;
        }
        modify("Responsibility Center")
        {
            Visible = false;
        }
        modify("Preferred Bank Account Code")
        {
            Visible = false;
        }
        modify(BalanceAsCustomer)
        {
            Visible = false;
        }
        modify("Search Name")
        {
            Visible = false;
        }
        //         modify(defa)
        // {
        //     Visible = false;
        // }
        modify("Disable Search by Name")
        {
            Visible = false;
        }
        modify("Document Sending Profile")
        {
            Visible = false;
        }
        modify("Privacy Blocked")
        {
            Visible = false;
        }
        modify("Foreign Trade")
        {
            Visible = false;
        }
        modify("Currency Code")
        {
            Visible = true;
        }
        modify("Prices Including VAT")
        {
            Visible = false;
        }
        modify("Prepayment %")
        {
            Visible = false;
        }

        modify("Application Method")
        {
            Visible = false;
        }
        modify("Partner Type")
        {
            Visible = false;
        }
        modify("IC Partner Code")
        {
            Visible = false;
        }
        modify("Intrastat Partner Type")
        {
            Visible = false;
        }
        modify("Cash Flow Payment Terms Code")
        {
            Visible = false;
        }

        modify("Block Payment Tolerance")
        {
            Visible = false;

        }

        modify("Exclude from Pmt. Practices")
        {
            Visible = false;

        }

        addafter(General)
        {
            group(Detail)
            {
                group(GR01)
                {
                    ShowCaption = false;
                    field(Report; Rec.Report)
                    {
                        ApplicationArea = all;
                        Style = Strong;
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
            group(Historics)
            {
                CaptionML = ENU = 'Vendor Historics', FRA = 'Extrait fournisseur';
                part(VendorHistorics; "WDC Vendor Historics")
                {

                    ApplicationArea = Basic, Suite;
                    SubPageLink = "Vendor No." = field("No.");
                    UpdatePropagation = Both;
                }
                fixed(FTotal)
                {
                    ShowCaption = false;
                    label(DebitLabel)
                    {
                        CaptionML = ENU = 'Total Debit ', FRA = 'Total Débit';
                        ApplicationArea = all;
                        Style = StrongAccent;
                    }
                    field("Open Debit"; Rec."Open Debit")
                    {
                        ShowCaption = true;
                        CaptionML = ENU = 'Total Debit ', FRA = 'Total Débit';
                        ApplicationArea = all;
                        Style = StrongAccent;
                    }

                    label(CreditLabel)
                    {
                        CaptionML = ENU = 'Total Credit', FRA = 'Total Crédit';
                        ApplicationArea = all;
                        Style = StrongAccent;
                    }
                    field("Open Credit"; Rec."Open Credit")
                    {
                        CaptionML = ENU = 'Total Credit', FRA = 'Total Crédit';
                        ApplicationArea = all;
                        Style = StrongAccent;
                    }
                }

            }
            group(ShippedNotInvoiced)
            {
                CaptionML = ENU = 'Purchase Receipt Not Inv.', FRA = 'Réceptions non facturées';
                part("PurchaseReceptNotInvoiced"; "WDC Purch. Recept Not Invoiced")
                {
                    ApplicationArea = Basic, Suite;
                    SubPageLink = "Buy-from Vendor No." = field("No.");
                    UpdatePropagation = Both;
                }
                fixed(Totalrecp)
                {
                    label(TotalReceipt)
                    {
                        CaptionML = ENU = 'Total Receipt', FRA = 'Total Réceptions';
                        ApplicationArea = all;
                        Style = StrongAccent;
                    }
                    field("Total Receipt"; Rec."Total Receipt")
                    {
                        CaptionML = ENU = 'Total RCA', FRA = 'Total Réceptions';
                        ApplicationArea = all;
                        Style = StrongAccent;
                    }
                }

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
        addafter(ContactBtn)
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
    //>>WDC01

    trigger OnOpenPage()
    var
        UserSetup: Record "User Setup";
    begin
        UserSetup.Get(UserId);
        if not UserSetup."Allow Modify Vendor" then
            CurrPage.Editable(false)

    end;

    trigger OnAfterGetRecord()
    var
        UserSetup: Record "User Setup";
        GLSetup: record "General Ledger Setup";
    begin
        GLSetup.get;
        UserSetup.Get(UserId);

        //Rec.SetFilter("Start Year Filter", '..%1', GLSetup."Allow Deferral Posting From");
        Rec.SetFilter("Start Year Filter", '..%1', GLSetup."Go Live Date");//WDC;HG
        rec.SetFilter("Due Date Filter", '%1..', WorkDate);

        if not UserSetup."Allow Modify Vendor" then
            CurrPage.Editable(false);
        rec.CalcFields("Balance (LCY)", "Total Receipt");
        TotalvendorAmount := rec."Balance (LCY)" - rec."Total Receipt";

        StyleTxt := Color();
    end;

    procedure Color(): text[50]
    begin
        if TotalvendorAmount > 0 then
            exit('unfavorable')
        else
            exit('favorable');

    end;


    var
        TotalvendorAmount: decimal;
        StyleTxt: text[50];
}
