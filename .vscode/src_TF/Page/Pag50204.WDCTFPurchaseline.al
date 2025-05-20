page 50204 "WDC-TF Purchase line"
{
    Caption = 'Ligne Achat';
    Editable = false;
    PageType = ListPart;
    SourceTable = 39;
    layout
    {
        area(content)
        {
            repeater(Control)
            {
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = all;
                    Style = Strong;
                    StyleExpr = TRUE;

                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = all;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Buy-from Vendor No."; Rec."Buy-from Vendor No.")
                {
                    ApplicationArea = all;
                    CaptionML = ENU = 'Vendor No.', FRA = 'N° Fournisseur';
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
                field(Amount; Amount)
                {
                    ApplicationArea = all;
                    CaptionML = ENU = 'Amount', FRA = 'Montant';
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Amount := Rec.Quantity * Rec."Unit Cost (LCY)";
        "Buy-from Vendor No.HideValue" := FALSE;
        "Document No.HideValue" := FALSE;
        "Document TypeHideValue" := FALSE;
        DocumentTypeOnFormat;
        DocumentNoOnFormat;
        BuyfromVendorNoOnFormat;
    end;

    var
        TempPurchLines: Record 39;
        "Document TypeHideValue": Boolean;
        "Document No.HideValue": Boolean;
        "Buy-from Vendor No.HideValue": Boolean;

    local procedure IsFirstDocLine(): Boolean
    begin
        TempPurchLines.RESET;
        TempPurchLines.SETRANGE("Transit Folder No.", Rec."Transit Folder No.");
        TempPurchLines.SETRANGE("Document Type", Rec."Document Type");
        TempPurchLines.SETRANGE("Document No.", Rec."Document No.");
        TempPurchLines.SETRANGE(Type, TempPurchLines.Type::"Charge (Item)");

        IF TempPurchLines.FINDFIRST THEN
            IF TempPurchLines."Line No." = Rec."Line No." THEN
                EXIT(TRUE);

        EXIT(FALSE);
    end;

    local procedure DocumentTypeOnFormat()
    begin
        IF NOT IsFirstDocLine THEN
            "Document TypeHideValue" := TRUE;
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

    var
        Amount: Decimal;
}

