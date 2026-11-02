namespace CRC.CRC;

using Microsoft.Sales.Setup;
using Microsoft.Foundation.NoSeries;
//*******************Documentation*************************
//WDC01  WDC.HG  26/06/2025   Create Current Object
//WDC02  WDC.IM  02/03/2026   Add New Fields
tableextension 50038 "WDC Sales Setup" extends "Sales & Receivables Setup"
{
    fields
    {
        field(50000; "Posted Term Invoice No."; code[20])
        {
            Captionml = ENU = 'Posted Term Invoice No.', FRA = 'N° facture à terme enregistrée';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(50001; "Posted Cash Invoice No."; code[20])
        {
            Captionml = ENU = 'Posted Cash Invoice No.', FRA = 'N° facture comptant enregistrée';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(50002; "Standard Print Is Visible"; Boolean)
        {
            Captionml = ENU = 'Standard Print Is Visible', FRA = 'Impression standard visible';
            DataClassification = ToBeClassified;
        }
        field(50003; "Print Paiement Model2"; Boolean)
        {
            Captionml = ENU = 'Print Paiement Model2', FRA = 'Modèle imprime paiement 2';
            DataClassification = ToBeClassified;
        }
        //WDC02
        field(50004; "Authorized Cash Credit Period"; DateFormula)
        {
            Captionml = ENU = 'Authorized cash credit period', FRA = 'Période crédit comptant autorisée';
            DataClassification = ToBeClassified;
        }
        field(50005; "Enable Cash Credit Control"; Boolean)
        {
            CaptionML = ENU = 'Enable Cash Credit Control', FRA = 'Contrôle crédit comptant';
            DataClassification = ToBeClassified;
        }
        //WDC02
    }
}
