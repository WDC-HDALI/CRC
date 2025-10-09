//****************Documentation**********************
//wdc01  WDC.FS  18/06/2025 Hide Some Fields
pageextension 50016 "WDC Sales Order" extends "Sales Order"
{
    layout
    {
        //<<WDC02
        addafter("Shipping Agent Service Code")
        {
            field(DestinationAddress; Rec.DestinationAddress)
            {
                ApplicationArea = all;
            }
        }
        //<<WDC02
        Moveafter("Sell-to Phone No."; "VAT Registration No.")
        modify("Posting Date")
        {
            ShowMandatory = true;
            Editable = DateIsEditable;
        }
        modify("Prices Including VAT")
        {
            Visible = false;
        }
        modify("Sell-to Customer No.")
        {
            ShowMandatory = true;
            trigger OnAfterValidate()
            var
                Customer: Record Customer;
                lText001: TextConst ENU = 'You cannot create a sales order for a passenger customer.',
                                    FRA = 'Vous ne pouvez pas créer une commande de vente pour un client passager.';
            begin
                if Customer.Get(Rec."Sell-to Customer No.") then begin
                    if Customer."Customer Posting Group" = 'C-PASSAGER' then
                        Error(lText001);
                end;

            end;
        }
        modify("Salesperson Code")
        {
            ShowMandatory = true;
        }
        modify("Sell-to Customer Name")
        {
            ShowMandatory = true;
        }
        modify("Sell-to Address")
        {
            ShowMandatory = true;
        }
        modify("Shipping Agent Code")
        {
            Visible = false;
        }
        modify("Shipping Agent Service Code")
        {
            Visible = false;
        }
        //<<wdc01
        modify("Bill-to Contact")
        {
            Visible = false;
        }
        modify(SellToMobilePhoneNo)
        {
            Editable = True;
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
        modify("Order Date")
        {
            Visible = false;
        }
        modify("Due Date")
        {
            Visible = false;
        }
        modify("Your Reference")
        {
            Visible = false;
        }
        modify("opportunity No.")
        {
            Visible = false;
        }
        modify("Responsibility Center")
        {
            Visible = false;
        }
        modify("Assigned User ID")
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
        modify("No. of Archived Versions")
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
        modify("VAT Country/Region Code")
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
        modify("ShippingOptions")
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
        modify("Compress Prepayment")
        {
            Visible = false;
        }
        modify("Prepayment Due Date")
        {
            Visible = false;
        }
        modify("Prepmt. Payment Discount %")
        {
            Visible = false;
        }
        modify("Ship-to Phone No.")
        {
            Visible = false;
        }
        modify("Campaign No.")
        {
            Visible = false;
        }
        modify("Prepmt. Pmt. Discount Date")
        {
            Visible = false;
        }
        modify("Package Tracking No.")
        {
            Visible = false;
        }
        modify("BillToOptions")
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
        modify("Shipping Advice")
        {
            Visible = false;
        }
        modify("Outbound Whse. handling Time")
        {
            Visible = false;
        }
        modify("Shipping Time")
        {
            Visible = false;
        }
        modify("Late Order Shipping")
        {
            Visible = false;
        }
        modify("Combine Shipments")
        {
            Visible = false;
        }
        modify("Completely Shipped")
        {
            Visible = false;
        }
        modify(Control1900201301)//Groupe accompte
        {
            Visible = false;
        }
        modify("Payment Method Code")
        {

            Visible = false;
        }
        //>>wdc01
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
        addafter("Create &Warehouse Shipment")
        {
            action(MakeInvoice)
            {
                ApplicationArea = all;
                CaptionML = ENU = 'Make Invoice', FRA = 'Créer une facture';
                Image = CreateJobSalesInvoice;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                enabled = Rec."Document Type" = Rec."Document Type"::Order;
                trigger OnAction()
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    ConfirmConvertToInvoiceQst: TextConst ENU = 'Do you want to convert the Sales order to an invoice?',
                                                          FRA = 'Voulez-vous convertir la commande de vente en facture?';
                    OpenNewInvoiceQst: TextConst ENU = 'The Order has been converted to invoice %1. Do you want to open the new invoice?',
                                                 FRA = 'La commande a été convertie en facture %1. Souhaitez-vous ouvrir la nouvelle facture?';
                begin
                    if ApprovalsMgmt.PrePostApprovalCheckSales(Rec) then begin
                        if Confirm(ConfirmConvertToInvoiceQst) then begin
                            CreateSalesInvoiceHeader(InvoiceSalesHeader, Rec);
                            commit;
                            rec.Delete(true);
                            if Confirm(StrSubstNo(OpenNewInvoiceQst, InvoiceSalesHeader."No.")) then begin
                                PAGE.Run(PAGE::"Sales Invoice", InvoiceSalesHeader);
                            end;

                        end;
                    end;
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        if UserSetup.Get(UserId) then
            DateIsEditable := UserSetup."Allow Upd Sales Posting Date";

    end;

    var

        UserSetup: Record "User Setup";
        DateIsEditable: Boolean;

    procedure CreateSalesInvoiceHeader(Var SalesInvoiceHeader: record "Sales Header"; SalesOrderHeader: Record "Sales Header")
    var
        GLSetup: Record "General Ledger Setup";
    begin
        rec.TestField(Status, Rec.status::Released);
        SalesInvoiceHeader := SalesOrderHeader;
        SalesInvoiceHeader."Document Type" := SalesInvoiceHeader."Document Type"::Invoice;

        SalesInvoiceHeader."No. Printed" := 0;
        SalesInvoiceHeader.Status := SalesInvoiceHeader.Status::Open;
        SalesInvoiceHeader."No." := '';

        SalesInvoiceHeader."Invoiced Order No." := SalesOrderHeader."No.";
        SalesInvoiceHeader.Insert(true);

        // if SalesOrderHeader."Posting Date" <> 0D then
        //     SalesInvoiceHeader."Posting Date" := SalesOrderHeader."Posting Date"
        // else
        SalesInvoiceHeader.Validate("Posting Date", WorkDate());
        SalesInvoiceHeader.InitFromSalesHeader(SalesOrderHeader);
        SalesInvoiceHeader."VAT Reporting Date" := GLSetup.GetVATDate(SalesInvoiceHeader."Posting Date", SalesInvoiceHeader."Document Date");

        SalesInvoiceHeader.Modify();
        CreateSalesInvoiceLines(SalesInvoiceHeader, SalesOrderHeader);
    end;

    procedure CreateSalesInvoiceLines(SalesInvoiceHeader: Record "Sales Header"; SalesOrderHeader: Record "Sales Header")
    var
        SalesInvoiceLine: Record "Sales Line";
        SalesOrderLine: Record "Sales Line";
        SalesLineReserve: Codeunit "Sales Line-Reserve";
        IsHandled: Boolean;
        ltext001: TextConst ENU = 'You cannot create an invoice from a sales order that has already been shipped.',
                            FRA = 'Vous ne pouvez pas créer une facture à partir d''une commande de vente qui a déjà été expédiée.';
    begin
        SalesOrderLine.Reset();
        SalesOrderLine.SetRange("Document Type", SalesOrderHeader."Document Type");
        SalesOrderLine.SetRange("Document No.", SalesOrderHeader."No.");
        if SalesOrderLine.FindSet() then
            repeat
                if SalesOrderLine."Quantity Shipped" > 0 then
                    Error(ltext001);
                SalesInvoiceLine := SalesOrderLine;
                SalesInvoiceLine."Document Type" := SalesInvoiceHeader."Document Type";
                SalesInvoiceLine."Document No." := SalesInvoiceHeader."No.";
                if SalesInvoiceLine."No." <> '' then
                    SalesInvoiceLine.DefaultDeferralCode();
                SalesInvoiceLine.InitQtyToShip();
                SalesInvoiceLine.Insert();

                SalesLineReserve.TransferSaleLineToSalesLine(SalesOrderLine, SalesInvoiceLine, SalesOrderLine."Outstanding Qty. (Base)");
                SalesLineReserve.VerifyQuantity(SalesInvoiceLine, SalesOrderLine);
            until SalesOrderLine.Next() = 0;
    end;

    var
        InvoiceSalesHeader: Record "Sales Header";
}