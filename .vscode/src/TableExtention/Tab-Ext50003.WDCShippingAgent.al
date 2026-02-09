namespace CRC.CRC;

using Microsoft.Foundation.Shipping;

tableextension 50003 "WDC Shipping Agent" extends "Shipping Agent"
{
    fields
    {
        field(50000; "Tech. insp. End Date"; Date)
        {
            CaptionML = ENU = 'Tech insp. End Date', FRA = 'Date fin Visite Technique';
            DataClassification = ToBeClassified;
        }
        field(50001; "Taxe End Date"; Date)
        {
            CaptionML = ENU = 'Taxe End Date', FRA = 'Date fin taxe';
            DataClassification = ToBeClassified;
        }
        field(50002; "Tax Amount LCY"; Decimal)
        {
            CaptionML = ENU = 'Tax Amount LCY', FRA = 'Montant taxe DS';
            DataClassification = ToBeClassified;
        }
        field(50003; "Truck Insurance End Date"; Date)
        {
            CaptionML = ENU = 'Truck Insurance End Date', FRA = 'Date fin Assurance';
            DataClassification = ToBeClassified;
        }
        field(50004; "Insurance Amount LCY"; Decimal)
        {
            CaptionML = ENU = 'Insurance Amount LCY', FRA = 'Montant assurance DS';
            DataClassification = ToBeClassified;
        }
        field(50005; "Fuel Amount LCY"; Decimal)
        {
            CaptionML = ENU = 'Fuel Amount LCY', FRA = 'Montant Carburant DS';
            DataClassification = ToBeClassified;
        }
        field(50006; "Rep & Spare Part Amount LCY"; Decimal)
        {
            CaptionML = ENU = 'Rep & Spare Part Amount LCY', FRA = 'Montant Rép. & Pièce';
            DataClassification = ToBeClassified;
        }
        field(50007; "Company Vehicule"; Boolean)
        {
            CaptionML = ENU = 'Company Vehicle', FRA = 'Véhicule de l''entreprise';
            DataClassification = ToBeClassified;
        }
    }
}
