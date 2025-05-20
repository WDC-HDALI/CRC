tableextension 54005 "WDC-ST Purchase Header" extends "Purchase Header"
{
    fields
    {
        field(54000; "Apply Fiscal Stamp"; Boolean)
        {
            CaptionML = ENU = 'Apply Fiscal Stamp', FRA = 'Appliquer timbre fiscal';
            DataClassification = ToBeClassified;
            Editable = false;
            trigger OnValidate()
            var
                lVendorPostingGroup: Record "Vendor Posting Group";
            begin
                IF "Apply Fiscal Stamp" = FALSE THEN
                    "Stamp Amount" := 0
                ELSE BEGIN
                    lVendorPostingGroup.GET("Vendor Posting Group");
                    IF lVendorPostingGroup."Apply Fiscal Stamp" THEN
                        "Stamp Amount" := lVendorPostingGroup."Stamp Amount";
                END
            end;


        }
        field(54001; "Stamp Amount"; Decimal)
        {
            CaptionML = ENU = 'Stamp Amount', FRA = 'Montant timbre fiscal';
            DataClassification = ToBeClassified;
        }
    }

}