namespace CRC.CRC;

using Microsoft.Purchases.Document;
//**************Documentation*******************
//WDC01  WDC.HG  02/07/2025  Create current object

pageextension 50051 "WDC Purchase Order List" extends "Purchase Order List"
{
    layout
    {
        addafter(Status)
        {
            field(Receive; Rec.Receive)
            {
                CaptionML = ENU = 'Fully received', FRA = 'Totalement reçue';
                ApplicationArea = all;
            }
        }
    }
    // trigger OnOpenPage()
    // begin
    //     rec.SetCurrentKey("Document Date");
    // end;
}
