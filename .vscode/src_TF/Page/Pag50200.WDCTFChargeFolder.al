page 50200 "WDC-TF Charge Folder"
{
    CaptionML = ENU = 'Charges Folder', FRA = 'Frais dossier';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = ListPart;
    SourceTable = "WDC-TF Item Charge Trans. Fold";
    ApplicationArea = all;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Charge Code"; Rec."Charge Code")
                {
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                }
                field(Assignable; Rec.Assignable)
                {
                    Editable = false;
                }
                field("Affected Charge Amount"; Rec."Affected Charge Amount")
                {
                }
                field("Non inclus"; Rec."Not Included")
                {
                }
                field("Facteur dossier"; FolderPercent)
                {
                    Editable = false;
                    Enabled = false;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin

        FolderPercent := 0;

        IF InvoiceAmount <> 0 THEN
            FolderPercent := ROUND((Rec."Affected Charge Amount" / InvoiceAmount) * 100, 0.001, '=');
    end;

    var
        FolderPercent: Decimal;
        TransitFolder: Record "WDC-TF Transit Folder";
        InvoiceAmount: Decimal;

    procedure SetFolderNo(FolderNo: Code[20])
    begin

        InvoiceAmount := 0;

        IF TransitFolder.GET(FolderNo) THEN
            TransitFolder.CALCFIELDS(TransitFolder."Vendor Invoice Amount LCY");

        InvoiceAmount := TransitFolder."Vendor Invoice Amount LCY";
    end;
}

