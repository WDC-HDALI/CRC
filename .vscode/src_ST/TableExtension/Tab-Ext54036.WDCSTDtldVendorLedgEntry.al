//**************Documentation********************
//WDC01  WDC.HG  22/07/2025   display the "reference payement" in vendor ledger entries 
tableextension 54036 "WDC-ST Dtld Vendor Ledg. Entry" extends "Detailed Vendor Ledg. Entry"
{
    fields
    {
        field(54075; "Payment Slip Type"; Enum "WDC-ST Payment Slip Type")
        {
            CaptionML = ENU = 'Payment Slip Type', FRA = 'Type paiement';
            Editable = false;
        }
        field(54076; "Vendor Name"; Text[100])
        {
            CaptionML = ENU = 'Vendor Name', FRA = 'Nom fournisseur';
            Editable = false;
        }
        //<<WDC01
        field(54077; "Payment Reference"; code[50])
        {
            CaptionML = ENU = '"Payment Reference"', FRA = 'Reference Paiement';
            Editable = false;
        }
        //<<WDC01
    }
}