
//****************Documentation**************************
//WDC01  WDC.HG  10/06/2025  create the current object 
table 50004 "WDC borderau lookup"
{
    Captionml = ENU = 'list of payment slips', FRA = 'liste des bordereau de versement ';
    DataClassification = ToBeClassified;
    Permissions = tabledata "WDC borderau lookup" = Rimd;

    fields
    {
        field(1; "entryNo"; Integer)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'entryNo ', FRA = 'N°';
        }

        field(2; "Document No."; code[20])
        {
            DataClassification = ToBeClassified;
            Captionml = ENU = 'Document No.', FRA = 'N° Document';
        }

        field(3; "Posting date"; date)
        {
            DataClassification = ToBeClassified;
            Captionml = ENU = 'Posting Date', FRA = 'Date comptabilisation';
        }

    }
    keys
    {
        key(PK; entryNo, "Document No.")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; "Document No.", "Posting Date")
        {
        }

    }
    procedure GetEntryNo(): Integer
    var
        BordereauLookup: Record "WDC borderau lookup";
    begin
        BordereauLookup.reset();
        if BordereauLookup.FindLast() then
            exit(BordereauLookup.entryNo + 1)
        else
            exit(1)

    end;
}