//***************Documentation********************
//WDC01  WDC.HG  24/07/2025  Show  "Payment Method Code"  field 
pageextension 50010 "WDC Gen Journal Batch" extends 251
{
    layout
    {
        addafter(Description)
        {

            field("Account Type"; Rec."Account Type")
            {
                ApplicationArea = All;
            }
            field("Account No."; Rec."Account No.")
            {
                ApplicationArea = All;
            }
            //<<WDC01
            field("Payment Method Code"; Rec."Payment Method Code")
            {
                ApplicationArea = All;
            }
            //>>WDC01
        }
    }
    // trigger OnClosePage()
    // var
    //     myInt: Integer;
    // begin
    //       if rec.Name = 'BANQUE' then
    //         true
    //     else
    //         visible := false;
    // end;

}