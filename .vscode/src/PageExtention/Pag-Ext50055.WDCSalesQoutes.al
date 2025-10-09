
//*************Documentation***************************
//WDC01  WDC.HG  09/07/2025  Create Current Object
namespace CRC.CRC;

using Microsoft.Sales.Document;

pageextension 50055 "WDC Sales Qoutes" extends "Sales Quotes"
{
    layout
    {
        addlast(Control1)
        {
            field(SystemCreatedAt; Rec.SystemCreatedAt)
            {
                ApplicationArea = all;
                Editable = false;
            }
        }
    }
    trigger OnOpenPage()
    begin
        rec.SetCurrentKey("Document Date");
    end;
}
