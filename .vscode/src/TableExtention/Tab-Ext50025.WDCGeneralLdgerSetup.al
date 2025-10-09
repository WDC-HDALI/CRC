namespace CRC.CRC;

using Microsoft.Finance.GeneralLedger.Setup;
using Microsoft.Finance.GeneralLedger.Journal;
//****************Documentation*******************************
//WDC01 WDC.HG  09/06/2025  Create Current object 
tableextension 50025 "WDC General Ldger Setup" extends "General Ledger Setup"
{
    fields
    {
        field(50000; "Check Slip Sheet"; Code[10])
        {
            CaptionML = ENU = 'check slip sheet', FRA = 'Feuille bordereau chèque';
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Journal Batch".name where("Journal Template Name" = filter('PAYMENTS'));

        }
        field(50001; "Bank Draft Slip Sheet"; Code[10])
        {
            CaptionML = ENU = 'Bank Draft Slip Sheet', FRA = 'Feuille bordereau Traite';
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Journal Batch".name where("Journal Template Name" = filter('PAYMENTS'));
        }
        field(50002; "Payment Sheet"; Code[10])
        {
            CaptionML = ENU = 'Payment Sheet', FRA = 'feuille paiement';
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Journal Batch".name where("Journal Template Name" = filter('PAYMENTS'));
        }
        field(50003; "Go Live Date"; Date)
        {
            CaptionML = ENU = 'Go Live Date', FRA = 'Date démarrage';
            DataClassification = ToBeClassified;
        }
    }
}
