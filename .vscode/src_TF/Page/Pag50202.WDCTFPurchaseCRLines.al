page 50202 "WDC-TF Purchase CR. Lines"
{
    CaptionML = FRA = 'Ligne avoir achat';
    Editable = false;
    PageType = ListPart;
    SourceTable = 125;
    SourceTableView = WHERE(Quantity = FILTER(<> 0));
    ApplicationArea = all;
    layout
    {
        area(content)
        {
            repeater(Control)
            {
                field("Document No."; Rec."Document No.")
                {
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Buy-from Vendor No."; Rec."Buy-from Vendor No.")
                {
                    Caption = 'Vendor No.';
                    HideValue = "Buy-from Vendor No.HideValue";
                }
                field("No."; Rec."No.")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field(Quantity; Rec.Quantity)
                {
                }
                field(Amount; Rec.Amount)
                {
                }
                field("Reception No"; numdocreception)
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        "Buy-from Vendor No.HideValue" := FALSE;
        "Document No.HideValue" := FALSE;
        DocumentNoOnFormat;
        BuyfromVendorNoOnFormat;

        numdocreception := '';
        IF Rec."Appl.-to Item Entry" <> 0 THEN
            IF ItemLedgEntry.GET(Rec."Appl.-to Item Entry") THEN
                numdocreception := ItemLedgEntry."Document No.";
    end;

    var
        TempPurchInvLines: Record 123;
        "Document No.HideValue": Boolean;
        "Buy-from Vendor No.HideValue": Boolean;
        numdocreception: Code[20];
        ItemLedgEntry: Record 32;

    local procedure IsFirstDocLine(): Boolean
    begin
        TempPurchInvLines.RESET;
        TempPurchInvLines.SETCURRENTKEY("Transit Folder No.", "Document No.", "Line No.", Type);
        TempPurchInvLines.SETRANGE("Transit Folder No.", Rec."Transit Folder No.");
        TempPurchInvLines.SETRANGE("Document No.", Rec."Document No.");
        TempPurchInvLines.SETRANGE(Type, TempPurchInvLines.Type::"Charge (Item)");

        IF TempPurchInvLines.FIND('-') THEN
            IF TempPurchInvLines."Line No." = Rec."Line No." THEN
                EXIT(TRUE);

        EXIT(FALSE);
    end;

    local procedure DocumentNoOnFormat()
    begin
        IF NOT IsFirstDocLine THEN
            "Document No.HideValue" := TRUE;
    end;

    local procedure BuyfromVendorNoOnFormat()
    begin
        IF NOT IsFirstDocLine THEN
            "Buy-from Vendor No.HideValue" := TRUE;
    end;
}