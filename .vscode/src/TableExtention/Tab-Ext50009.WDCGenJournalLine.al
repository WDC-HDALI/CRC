//******************Documantation********************
//WDC01  WDC.HG  25/05/2025  Add new fields 
tableextension 50009 "WDC GenJournalLine" extends "Gen. Journal Line"
{
    fields
    {
        modify("Payment Method Code")
        {
            trigger OnAfterValidate()
            var
                lPaymentMethodCode: Record "Payment Method";
            begin
                if lPaymentMethodCode.Get(rec."Payment Method Code") then
                    if lPaymentMethodCode.Unpaid then
                        Rec."Document Type" := Rec."Document Type"::" "
                    else
                        rec."Document Type" := rec."Document Type"::Payment;
            end;
        }
        field(50000; "Initial Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50001; "Initial Document No."; code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50002; Lettrage; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        //<<WDC01 
        field(50003; "Taux RS"; code[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'RS Rate', FRA = 'Taux RS';
            TableRelation = IF ("Account Type" = CONST(Customer)) "WDC-ST Retained Group".Code WHERE("Type Retenue" = FILTER("à la source"),
            "RS Type" = const(Customer))
            ELSE IF ("Account Type" = CONST(Vendor)) "WDC-ST Retained Group".Code WHERE("Type Retenue" = FILTER("à la source"),
            "RS Type" = const(Vendor));
        }
        field(50004; "Rs Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'RS Amount', FRA = 'Montant RS';
        }
        field(50005; "Bank Name"; code[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Name Bank', FRA = 'Nom banque';
        }
        //<<WDC02
        field(50006; "Payment Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Amount To Pay', FRA = 'montant à payer';
        }
        field(50007; "Company Bank"; code[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'CRC BANK', FRA = 'Banque CRC';
            TableRelation = "Bank Account";
        }

        //>>WDC02

    }
}