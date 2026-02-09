namespace CRC.CRC;

using Microsoft.Sales.Document;
using Microsoft.Sales.Setup;
using Microsoft.Sales.Customer;
using Microsoft.Foundation.Shipping;
//****************Documentation***************
//WDC01  WDC.HG  27/06/2025  Change Posting Serie No.
//WDC04  WDC.FS  05/01/2026  Add Fields   

tableextension 50016 "WDC Sales Header" extends "Sales Header"
{
    fields
    {

        //   field(50000; Créé dans le sales shipment header)
        field(50001; "Invoiced Order No."; Code[20])
        {
            CaptionML = ENU = 'Invoiced Order No.', FRA = 'N° commande facturée';
            DataClassification = ToBeClassified;
        }
        //<<WDC01
        modify("Payment Terms Code")
        {
            trigger OnAfterValidate()
            var
                lSalesSetup: record "Sales & Receivables Setup";
            begin
                lSalesSetup.get();
                if rec."Document Type" = rec."Document Type"::Invoice then
                    if rec."Customer Posting Group" = 'C-PASSAGER' then
                        REC."Posting No. Series" := lSalesSetup."Posted Cash Invoice No."
                    else
                        rec."Posting No. Series" := lSalesSetup."Posted Term Invoice No.";
            end;
        }
        //>>WDC01
        //field(50009; Canceled; Boolean) //Reservéééééé

        //field(50010; "Replacment Invoice No."; Code[20]) //Reservéééééé
        //<<WDC03
        field(50015; DestinationAddress; Text[250])
        {
            CaptionML = ENU = 'Destination', FRA = 'Destination';
            DataClassification = ToBeClassified;
        }
        //>WDC03
        //<<WDC04
        field(50017; "Truck No."; Code[20])
        {
            CaptionML = ENU = 'Truck No.', FRA = 'N° camion';
            DataClassification = ToBeClassified;
        }
        field(50018; "Driver Name"; Text[100])
        {
            CaptionML = ENU = 'Driver Name', FRA = 'Nom chauffeur';
            DataClassification = ToBeClassified;
        }
        //>>WDC04
    }
}
