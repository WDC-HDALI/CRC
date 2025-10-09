//WDC01  WDC.HG  02/06/2025  Add New Action 
//wdc02  WDC.FS  18/06/2025 Hide Some Fields
pageextension 50021 "WDC Posted Sales Invoice" extends "Posted Sales Invoice"
{
    layout
    {
        addafter("Sell-to Post Code")
        {
            field("Sell-to Phone No."; Rec."Sell-to Phone No.")
            {
                ApplicationArea = all;
            }
        }
        moveafter("Sell-to Phone No."; "VAT Registration No.")

        modify("Shipping Agent Code")
        {
            Visible = false;
        }
        modify("Shipping Agent Service Code")
        {
            Visible = false;
        }
        //<<wdc02
        modify("Bill-to Contact")
        {
            Visible = false;
        }
        modify("Sell-to Contact")
        {
            Visible = false;
        }
        modify("Ship-to Contact")
        {
            Visible = false;
        }
        modify("Sell-to Country/Region Code")
        {
            Visible = false;
        }
        modify("VAT Reporting Date")
        {
            Visible = false;
        }

        // modify("Due Date")
        // {
        //     Visible = false;
        // }
        modify("Your Reference")
        {
            Visible = false;
        }

        modify("Responsibility Center")
        {
            Visible = false;
        }

        modify("Sell-to County")
        {
            Visible = false;
        }
        modify("Sell-to Address 2")
        {
            Visible = false;
        }

        modify("Document Date")
        {
            Visible = false;
        }
        modify("Work Description")
        {
            Visible = false;
        }
        modify("Currency Code")
        {
            Visible = false;
        }
        modify("Company bank account Code")
        {
            Visible = false;
        }

        modify("EU 3-Party Trade")
        {
            Visible = false;
        }
        modify("SelectedPayments")
        {
            Visible = false;
        }
        modify("Shortcut Dimension 1 Code")
        {
            Visible = false;
        }
        modify("Shortcut Dimension 2 Code")
        {
            Visible = false;
        }
        modify("Payment Discount %")
        {
            Visible = false;
        }
        modify("pmt. Discount Date")
        {
            Visible = false;
        }
        modify("Direct debit Mandate ID")
        {
            Visible = false;
        }


        modify("Sell-to Contact No.")
        {
            Visible = false;
        }
        modify("Foreign Trade")
        {
            Visible = false;
        }


        modify(BillToContactPhoneNo)
        {
            Visible = false;
        }
        modify(BillToContactMobilePhoneNo)
        {
            Visible = false;
        }
        modify(BillToContactEmail)
        {
            Visible = false;
        }


        // modify("Sell-to Customer Name")
        // {
        //     Visible = false;
        // }

        modify("Ship-to County")
        {
            Visible = false;
        }
        modify("Ship-to Name")
        {
            Visible = false;
        }
        modify("Shipment Method Code")
        {
            Visible = false;
        }
        modify("Ship-to City")
        {
            Visible = false;
        }
        modify("Ship-to Code")
        {
            Visible = false;
        }
        modify("Ship-to address")
        {
            Visible = false;
        }
        modify("Ship-to address 2")
        {
            Visible = false;
        }
        modify("Ship-to Phone No.")
        {
            Visible = false;
        }

        modify("Ship-to post Code")
        {
            Visible = false;
        }
        modify("Ship-to Country/Region Code")
        {
            Visible = false;
        }




        modify("Sell-to City")
        {
            Visible = false;
        }
        modify("Sell-to Post Code")
        {
            Visible = false;
        }
        modify(SellToEmail)
        {
            Visible = false;
        }
        modify(SellToPhoneNo)
        {
            Visible = false;
        }
        modify(SellToMobilePhoneNo)
        {
            Visible = false;
        }



        modify("Package Tracking No.")
        {
            Visible = false;
        }

        modify("Location Code")
        {
            Visible = false;
        }
        modify("Shipment Date")
        {
            Visible = false;
        }
        modify("Bill-to Name")
        {

            Visible = false;
        }
        modify("Bill-to Address")
        {

            Visible = false;
        }
        modify("Bill-to Address 2")
        {

            Visible = false;
        }
        modify("Bill-to City")
        {

            Visible = false;
        }
        modify("Bill-to Post Code")
        {

            Visible = false;
        }
        modify("Bill-to County")
        {

            Visible = false;
        }
        modify("Bill-to Contact No.")
        {

            Visible = false;
        }

        modify("Bill-to Country/Region Code")
        {

            Visible = false;
        }

        modify("Dispute Status")
        {

            Visible = false;
        }
        modify(Closed)
        {

            Visible = false;
        }
        modify("Payment Method Code")
        {

            Visible = false;
        }
        addafter("Pre-Assigned No.")
        {
            field("Remaining Amount"; Rec."Remaining Amount")
            {
                ApplicationArea = All;
            }
        }
        //>>wdc02

        addafter("Shipment Method Code")
        {
            field(ShippingAgentCode; Rec."Shipping Agent Code")
            {
                CaptionML = FRA = 'N° camion';
                ApplicationArea = All;
            }
            field(ShippingAgentServiceCode; Rec."Shipping Agent Service Code")
            {
                CaptionML = FRA = 'Code chauffeur';
                ApplicationArea = All;
            }
        }

    }
    actions
    {
        addlast(Processing)
        {
            action(Payment)
            {
                ApplicationArea = All;
                CaptionML = ENU = 'Payment', FRA = 'Règlement';
                Image = Payment;
                PromotedCategory = Process;
                Promoted = true;
                PromotedIsBig = true;
                Visible = IsVisible;
                trigger OnAction()
                var
                    lCustPaymentPage: page "WDC Customer Payment";
                    lPostedSalesInvoice: Record "Sales Invoice Header";
                    lText001: TextConst ENU = 'This invoice is totally paid',
                                         FRA = 'La facture est totallement payée';
                begin
                    rec.CalcFields("Remaining Amount");
                    if rec."Remaining Amount" = 0 then
                        Error(lText001);
                    lPostedSalesInvoice.Reset();
                    lPostedSalesInvoice.SetRange("No.", Rec."No.");
                    if lPostedSalesInvoice.FindFirst() then begin
                        lCustPaymentPage.SetDataFromInvoice(lPostedSalesInvoice);
                        lCustPaymentPage.Run();
                    end;
                end;
            }
            action(PaymentByCrMemo)
            {
                ApplicationArea = All;
                CaptionML = ENU = 'Payment By Cr Memo', FRA = 'Payer par avoir';
                Image = PaymentDays;
                PromotedCategory = Process;
                Promoted = true;
                PromotedIsBig = true;
                RunObject = page "Customer Ledger Entries";
                RunPageLink = "Entry No." = field("Cust. Ledger Entry No.");
            }
            //<<WDC01
            action(PrintPayment)
            {
                ApplicationArea = All;
                CaptionML = ENU = 'Print Payment', FRA = 'Imprimer Règlement';
                Image = PrintDocument;
                PromotedCategory = Process;
                Promoted = true;
                PromotedIsBig = true;
                Visible = IsVisible;
                trigger OnAction()
                var
                    PayementDocument: report "WDC payment Document";
                begin
                    PayementDocument.GetCustomerLedgerEntryNo(rec."No.");
                    PayementDocument.Run();

                end;

            }
            action(DeleteInvoice)
            {
                ApplicationArea = All;
                CaptionML = ENU = 'Cancel Invoice', FRA = 'Annuler la facture';
                Image = Delete;
                PromotedCategory = Process;
                Promoted = true;
                PromotedIsBig = true;
                Visible = IsVisible;
                trigger OnAction()
                var
                    lDeleteSalesInv: Report "WDC Cancel Pstd Sales Invoice";
                    lSalesInvceHeader: Record "Sales Invoice Header";
                    lText001: textconst ENU = 'You cannot delete this invoice, please contact your administrator!',
                                     FRA = 'Vous n''avez pas l''autorisation de supprimer la facture';
                begin
                    if Not UserSetup."Allow Delete sales Invoice" then
                        error(lText001);
                    lSalesInvceHeader.Reset();
                    lSalesInvceHeader.SetRange("No.", Rec."No.");
                    If lSalesInvceHeader.FindFirst() then begin
                        lDeleteSalesInv.SetTableView(lSalesInvceHeader);
                        lDeleteSalesInv.Run();
                    end;
                end;

            }
            //     action(LinkedPayment)
            //     {
            //         ApplicationArea = All;
            //         CaptionML = ENU = 'Linked Payment', FRA = 'Payments liés';
            //         Image = LinkWithExisting;
            //         PromotedCategory = Process;
            //         Promoted = true;
            //         PromotedIsBig = true;
            //         trigger OnAction()
            //         var
            //             lPayementDocument: Page "WDC Customer Payments";
            //             lDetCustLedEnt: Record "Detailed Cust. Ledg. Entry";
            //             lText001: TextConst ENU = 'No payment', FRA = 'Pas de payments pour cette facture';
            //         begin
            //             lDetCustLedEnt.Reset();
            //             lDetCustLedEnt.SetFilter("Document No.", '*FC252770*');
            //             if lDetCustLedEnt.FindFirst() then begin
            //                 lPayementDocument.SetTableView(lDetCustLedEnt);
            //                 lPayementDocument.Run();
            //             end else begin
            //                 Message(lText001)
            //             end;
            //         end;
            //     }
            //     //>>WDC01
        }

    }
    trigger OnAfterGetRecord()

    begin
        UserSetup.get(UserId);
        IsDeleteInvoiceVisible := UserSetup."Allow Delete sales Invoice";

        IsVisible := Rec."Customer Posting Group" = 'C-PASSAGER';
        CurrPage.Update(false);
    end;

    var

    Var
        UserSetup: Record "User Setup";
        IsVisible: Boolean;
        IsDeleteInvoiceVisible: Boolean;
}