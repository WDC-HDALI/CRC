pageextension 50805 "WDC-ED Company Information" extends "Company Information"
{
    layout
    {
        addafter(Shipping)
        {
            group("Trade Register")
            {
                CaptionML = ENU = 'Trade Register', FRA = 'Registre du commerce';
                // field("Registration No."; Rec."Registration No.")
                // {
                //     ApplicationArea = All;
                //     ToolTip = 'Specifies the company''s VAT registration number.';
                // }
                field(Control1120004; Rec."Trade Register")
                {
                    ApplicationArea = All;
                }
                field("APE Code"; Rec."APE Code")
                {
                    ApplicationArea = All;
                }
                field("Legal Form"; Rec."Legal Form")
                {
                    ApplicationArea = All;
                }
                field("Stock Capital"; Rec."Stock Capital")
                {
                    ApplicationArea = All;
                }
                field(CISD; Rec.CISD)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}