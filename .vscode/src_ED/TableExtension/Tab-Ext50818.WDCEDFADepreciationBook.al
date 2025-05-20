tableextension 50818 "WDC-ED FA Depreciation Book" extends "FA Depreciation Book"
{
    fields
    {
        field(50800; Derogatory; Decimal)
        {
            CaptionML = ENU = 'Derogatory', FRA = 'Dérogatoire';
            DataClassification = ToBeClassified;
        }
        field(50801; "Last Derogatory Date"; Date)
        {
            CaptionML = ENU = 'Last Derogatory Date', FRA = 'Dernière date dérogation';
            DataClassification = ToBeClassified;
        }
    }

}