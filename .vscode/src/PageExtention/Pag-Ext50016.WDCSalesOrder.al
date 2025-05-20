pageextension 50016 "WDC Sales Order" extends "Sales Order"
{
    layout
    {
        modify("Shipping Agent Code")
        {
            Visible = false;
        }
        modify("Shipping Agent Service Code")
        {
            Visible = false;
        }

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
    var

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

        if SalesOrderHeader."Posting Date" <> 0D then
            SalesInvoiceHeader."Posting Date" := SalesOrderHeader."Posting Date"
        else
            SalesInvoiceHeader."Posting Date" := WorkDate();
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
    begin
        SalesOrderLine.Reset();
        SalesOrderLine.SetRange("Document Type", SalesOrderHeader."Document Type");
        SalesOrderLine.SetRange("Document No.", SalesOrderHeader."No.");
        if SalesOrderLine.FindSet() then
            repeat
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