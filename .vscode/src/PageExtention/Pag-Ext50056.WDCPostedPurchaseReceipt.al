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
            field("Linked Invoice advance"; Rec."Linked Invoice advance")
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
                Enabled = BillByAdvIsEnable;
                PromotedOnly = true;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    lPurchRcptHeader: Record "Purch. Rcpt. Header";
                    lWDCUpdPurchRcpLine: Report "WDC Update Purch. RcpLine";
                begin
                    lPurchRcptHeader.reset;
                    lPurchRcptHeader.SetRange("No.", Rec."No.");
                    clear(lWDCUpdPurchRcpLine);
                    lWDCUpdPurchRcpLine.SetTableView(lPurchRcptHeader);
                    lWDCUpdPurchRcpLine.Run();
                end;
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        rec.calcfields(rec."Remain to Invoice");
        BillByAdvIsEnable := (not Rec."Bill in advance") and (rec."Remain to Invoice") And
                             (rec."Linked Invoice advance" = '');
    end;

    var
        BillByAdvIsEnable: Boolean;
}
