//***************Documentation*********************
//WDC01  WDC.HG  30/05/2025  Add New Fields 
tableextension 50010 "WDC JLEntry" extends "G/L Entry"
{
    fields
    {
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
        field(50003; "Cheque No."; code[50])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Payment Reference', FRA = 'Réference Paiement';
        }
        field(50004; "Initial Payment No."; code[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Initial Payment No.', FRA = 'N° paiement initial';
        }
        //>>WDC01


    }

}