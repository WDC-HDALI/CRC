//*********************Documentation************************
//WDC01  WDC.HG  29/05/2025   Show field "PaymentStatut"
//wdc02  WDC.FS  20/06/2025   Show field "Vendor Name" in Detailed Vendor Ledger Entries
//WDC03  WDC.HG  22/07/2025   display the "reference payement" in vendor ledger entries 
pageextension 54052 "WDC-ST Det. Ven. Ledg. Entries" extends "Detailed Vendor Ledg. Entries"
{
    layout
    {

        addafter("Currency Code")
        {
            field("Payment Slip Type"; Rec."Payment Slip Type")
            {
                ApplicationArea = all;
            }


        }
        //<<WDC03
        addafter("Payment Slip Type")
        {
            field("Payment Reference"; Rec."Payment Reference")
            {
                ApplicationArea = all;
            }
        }
        //>>WDC03
        //<<WDC02
        addafter("Vendor No.")
        {
            field("Vendor Name"; Rec."Vendor Name")
            {
                ApplicationArea = all;
                CaptionML = ENU = 'Vendor Name', FRA = 'Nom du fournisseur';

            }

        }

    }
    trigger OnAfterGetRecord()
    var
        lVendor: Record Vendor;

    begin
        if rec."Vendor Name" = '' then
            if lVendor.Get(Rec."Vendor No.") then
                Rec."Vendor Name" := lVendor.Name;

    end;

    //>>WDC02
}