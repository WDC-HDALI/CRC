
pageextension 50818 "WDC-ED FA Depreciation Books" extends "FA Depreciation Books"
{
    layout
    {
        addlast(Control1)
        {
            field(Derogatory; Rec.Derogatory)
            {
                ApplicationArea = All;
            }
            field("Last Derogatory Date"; Rec."Last Derogatory Date")
            {
                ApplicationArea = All;
            }

        }

    }
}