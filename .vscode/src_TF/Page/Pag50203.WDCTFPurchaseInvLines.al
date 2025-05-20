page 50203 "WDC-TF Purchase Inv. Lines"
{
    Caption = 'Ligne Facture Achat';
    Editable = false;
    PageType = ListPart;
    SourceTable = 123;
    SourceTableView = SORTING("Document No.", "Line No.");
    ApplicationArea = all;
    layout
    {
        area(content)
        {
            repeater(Control)
            {
                field("Document No."; Rec."Document No.")
                {
                    HideValue = "Document No.HideValue";
                    Style = Strong;
                    StyleExpr = TRUE;
                    ApplicationArea = all;
                }
                field("Buy-from Vendor No."; Rec."Buy-from Vendor No.")
                {
                    Caption = 'Vendor No.';
                    HideValue = "Buy-from Vendor No.HideValue";
                    ApplicationArea = all;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = all;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = all;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = all;
                }
                field("Expected Receipt Date"; Rec."Expected Receipt Date")
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        "Buy-from Vendor No.HideValue" := FALSE;
        "Document No.HideValue" := FALSE;
        DocumentNoOnFormat;
        BuyfromVendorNoOnFormat;
    end;

    var
        TempPurchInvLines: Record 123;
        "Document No.HideValue": Boolean;
        "Buy-from Vendor No.HideValue": Boolean;

    local procedure IsFirstDocLine(): Boolean
    begin
        TempPurchInvLines.RESET;

        TempPurchInvLines.SETRANGE("Document No.", REC."Document No.");
        TempPurchInvLines.SETRANGE(Type, TempPurchInvLines.Type::"Charge (Item)");
        TempPurchInvLines.SETRANGE("Transit Folder No.", REC."Transit Folder No.");

        IF TempPurchInvLines.FINDFIRST THEN
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