namespace CRC.CRC;

using Microsoft.Sales.History;

// WDC.FS 27/08/2025: Set default sorting on Posting Date desc
pageextension 50061 "WDC Cost Sales Document Lines" extends "Get Post.Doc - S.InvLn Subform"
{
    trigger OnOpenPage()
    begin
        //<<wdc01
        //rec.SetCurrentKey("Document No.", "Line No.");
        // Rec.SetCurrentKey("Posting Date", "Document No.", "Line No.");
        // rec.Ascending(false);
        // if rec.FindFirst() then
        //     CurrPage.UPDATE(false);
        //>>wdc01
    end;
}