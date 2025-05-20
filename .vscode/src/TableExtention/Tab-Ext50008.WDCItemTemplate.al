tableextension 50008 "WDC Item Template" extends "Item Templ."
{
    fields
    {
        //50001 don't use it on account of transferField
        field(50004; "SubCategorie"; Code[20])
        {
            CaptionML = FRA = 'Code sous catégorie', ENU = 'SubCategorie Code';
            DataClassification = ToBeClassified;
            trigger OnLookup()
            var
                SubCatgList: page "WDC SubCategory Item";
                SubCategories: Record "WDC SubCategory Item";
            begin
                CLEAR(SubCatgList);
                SubCategories.RESET;
                SubCategories.SETRANGE("Item Category Code", rec."Item Category Code");
                SubCatgList.SETTABLEVIEW(SubCategories);
                SubCatgList.SETRECORD(SubCategories);
                IF SubCatgList.RUNMODAL = ACTION::OK THEN BEGIN
                    SubCatgList.GETRECORD(SubCategories);
                    SubCategorie := SubCategories.Code;
                END;
            end;
        }
    }

}