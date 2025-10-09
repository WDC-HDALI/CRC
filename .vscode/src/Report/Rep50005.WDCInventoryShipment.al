namespace CRC.CRC;

using Microsoft.Inventory.History;
using Microsoft.Warehouse.Document;
using Microsoft.Warehouse.Activity;
using Microsoft.Foundation.Reporting;

report 50005 "WDC Inventory Shipment"
{
    CaptionML = ENU = 'Inventory Shipment', FRA = 'Expédition stock';
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    Permissions = tabledata "Invt. Shipment Header" = RIMD;
    RDLCLayout = './.vscode/src/Report/RDLC/InventoryShipment.rdlc';

    dataset
    {
        dataitem(InvtShipmentHeader; "Invt. Shipment Header")
        {
            column(No_; "No.")
            {

            }
            column(Posting_Date; "Posting Date")
            {

            }
            column(CustomerNo; CustomerNo)
            {

            }
            column(CustomerName; CustomerName)
            {

            }
            column(CustomerAddress; CustomerAddress)
            {

            }
            column(CustomerPhoneNo; CustomerPhoneNo)
            {

            }
            column(No__Printed; "No. Printed")
            {

            }
            column(TotalBrut; TotalBrut)
            {

            }
            column(TotalRemise; TotalRemise)
            {

            }
            column(TotalNetHTVA; TotalNetHTVA)
            {

            }
            column(montantTVA7; montantTVA7)
            {

            }
            column(MontantTVA13; MontantTVA13)
            {

            }
            column(MontantTVA19; MontantTVA19)
            {

            }
            column(Nettopay; Nettopay)
            {

            }
            column(AmountLetter; AmountLetter)
            {

            }
            dataitem("Invt. Shipment Line"; "Invt. Shipment Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemLinkReference = InvtShipmentHeader;
                DataItemTableView = SORTING("Document No.", "Line No.");
                column(Item_No_; "Item No.")
                {


                }
                column(Description; Description)
                {

                }
                column(Quantity; Quantity)
                {

                }
                column(Unit_Amount; "Unit Amount")
                {

                }
                column(Amount; Amount)
                {

                }
                column(Unit_of_Measure_Code; "Unit of Measure Code")
                {

                }
                column(Line_Amount_HT; "Line Amount HT")
                {

                }
                column(Line_Discount__; "Line Discount %")
                {

                }
                column(VAT__; "VAT %")
                {

                }

            }
            trigger OnAfterGetRecord()
            begin
                TotalBrut := 0;
                TotalRemise := 0;
                TotalNetHTVA := 0;
                montantTVA7 := 0;
                MontantTVA13 := 0;
                MontantTVA19 := 0;
                Nettopay := 0;
                vInvtShipmentLine.reset();
                vInvtShipmentLine.SetCurrentKey("Document No.", "Line No.");
                vInvtShipmentLine.setrange("Document No.", InvtShipmentHeader."No.");
                if vInvtShipmentLine.findset() then
                    repeat
                        TotalBrut += vInvtShipmentLine.Amount;
                        TotalRemise += vInvtShipmentLine."Line Discount Amount";
                        TotalNetHTVA += vInvtShipmentLine."Line Amount HT";
                        if vInvtShipmentLine."VAT %" = 7 then
                            montantTVA7 += vInvtShipmentLine."Line VAT Amount";
                        if vInvtShipmentLine."VAT %" = 19 then
                            montantTVA19 += vInvtShipmentLine."Line VAT Amount";
                        if vInvtShipmentLine."VAT %" = 13 then
                            montantTVA13 += vInvtShipmentLine."Line VAT Amount";
                        Nettopay += vInvtShipmentLine."Amount Including VAT";
                    until vInvtShipmentLine.Next() = 0;
                ConvAmounttoLetter."Montant en texte sans millimes"(AmountLetter, Nettopay);

            end;
        }

    }
    trigger OnPostReport()

    begin
        if not CurrReport.Preview then begin
            InvtShipmentHeader."No. Printed" := InvtShipmentHeader."No. Printed" + 1;
            InvtShipmentHeader.modify();
        end

    end;

    var
        TotalBrut: Decimal;
        TotalRemise: Decimal;
        TotalNetHTVA: Decimal;
        montantTVA7: Decimal;
        MontantTVA13: Decimal;
        MontantTVA19: Decimal;
        Nettopay: Decimal;
        vInvtShipmentLine: record "Invt. Shipment Line";
        ConvAmounttoLetter: codeunit "WDC-ED Conv Amount to Letter";
        AmountLetter: text[250];
}
