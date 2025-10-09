namespace CRC.CRC;

using Microsoft.Purchases.History;
using Microsoft.Purchases.Document;

pageextension 50056 "WDC Posted Purchase Receipt" extends "Posted Purchase Receipt"
{
    layout
    {
        addafter("Order No.")
        {
            field(SystemCreatedBy; Rec.SystemCreatedBy)
            {
                ApplicationArea = all;
            }
            field(Note; Rec.Note)
            {
                Editable = false;
                MultiLine = true;
                ApplicationArea = all;
            }
            field("Bill in advance"; Rec."Bill in advance")
            {
                Editable = false;
                ApplicationArea = all;
            }
        }
    }
    actions
    {
        addafter("&Print")
        {
            action("Bill in advanced")
            {
                CaptionML = ENU = 'Bill in advance', FRA = 'Facturer à l"avance';
                ApplicationArea = All;
                Image = Invoice;
                PromotedOnly = true;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    lPurchRcptHeader: Record "Purch. Rcpt. Header";
                    lWDCUpdPurchRcpLine: Report 50031;
                begin
                    lPurchRcptHeader.reset;
                    lPurchRcptHeader.SetRange("No.", Rec."No.");
                    clear(lWDCUpdPurchRcpLine);
                    lWDCUpdPurchRcpLine.SetTableView(lPurchRcptHeader);
                    lWDCUpdPurchRcpLine.Run();

                    rec."Bill in advance" := true;
                    rec.Modify();

                end;
            }
        }
    }

}
