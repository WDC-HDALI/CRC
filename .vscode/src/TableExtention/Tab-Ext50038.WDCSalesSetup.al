namespace CRC.CRC;

using Microsoft.Sales.Setup;
using Microsoft.Foundation.NoSeries;
//*******************Documentation*************************
//WDC01  WDC.HG  26/06/2025   Create Current Object
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

    }
}
