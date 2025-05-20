page 50205 "WDC-TF Purchase Recept. Lines"
{
    Caption = 'Ligne Reception Achat';
    Editable = false;
    PageType = ListPart;
    SourceTable = 121;
    SourceTableView = WHERE(Correction = FILTER(false));
    layout
    {
        area(content)
        {
            repeater(Control)
            {
                field("Document No."; Rec."Document No.")
                {
                    Editable = false;
                    Enabled = false;
                    HideValue = "Document No.HideValue";
                    Style = Strong;
                    StyleExpr = TRUE;
                    ApplicationArea = all;
                }
                field("Buy-from Vendor No."; Rec."Buy-from Vendor No.")
                {
                    Caption = 'Vendor No.';
                    HideValue = "Buy-from Vendor No.HideValue";
                    Style = AttentionAccent;
                    StyleExpr = Boolavoir;
                    ApplicationArea = all;

                }
                field("No."; Rec."No.")
                {
                    Style = AttentionAccent;
                    StyleExpr = Boolavoir;
                    ApplicationArea = all;
                }
                field(Description; Rec.Description)
                {
                    Style = StrongAccent;
                    StyleExpr = Boolavoir;
                    ApplicationArea = all;

                }
                field(Quantity; Rec.Quantity)
                {
                    Style = AttentionAccent;
                    StyleExpr = Boolavoir;
                    ApplicationArea = all;

                }
                field("Direct Unit Cost"; Rec."Direct Unit Cost")
                {
                    Style = AttentionAccent;
                    StyleExpr = Boolavoir;
                    ApplicationArea = all;

                }
                field("Expected Receipt Date"; Rec."Expected Receipt Date")
                {
                    Style = AttentionAccent;
                    StyleExpr = Boolavoir;
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

        Boolavoir := AvoirExist;
    end;

    var
        TempPurchRecepLines: Record 121;
        "Document No.HideValue": Boolean;
        "Buy-from Vendor No.HideValue": Boolean;
        Boolavoir: Boolean;

    local procedure IsFirstDocLine(): Boolean
    begin
        TempPurchRecepLines.RESET;
        TempPurchRecepLines.SETRANGE("Transit Folder No.", Rec."Transit Folder No.");
        TempPurchRecepLines.SETRANGE("Document No.", Rec."Document No.");
        TempPurchRecepLines.SETRANGE(Correction, FALSE);
        TempPurchRecepLines.SETFILTER(Quantity, '<>%1', 0);
        TempPurchRecepLines.SETFILTER(Type, '%1|%2'
                , TempPurchRecepLines.Type::Item, TempPurchRecepLines.Type::"Fixed Asset");

        IF TempPurchRecepLines.FIND('-') THEN
            IF TempPurchRecepLines."Line No." = Rec."Line No." THEN
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

    procedure AvoirExist(): Boolean
    var
        PurchCrMemoLine: Record 125;
    begin

        PurchCrMemoLine.SETCURRENTKEY("Appl.-to Item Entry");
        PurchCrMemoLine.SETRANGE("Appl.-to Item Entry", Rec."Item Rcpt. Entry No.");
        PurchCrMemoLine.SETRANGE("No.", Rec."No.");
        PurchCrMemoLine.SETRANGE(Type, Rec.Type);

        IF PurchCrMemoLine.FINDFIRST THEN
            EXIT(TRUE)
        ELSE
            EXIT(FALSE);
    end;
}