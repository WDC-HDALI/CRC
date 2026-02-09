pageextension 50018 "WDC Shipping Agent Services" extends "Shipping Agent Services"
{
    CaptionML = FRA = 'Liste Chauffeurs';

    layout
    {
        modify("Base Calendar Code")
        {
            Visible = false;
        }
        modify("Shipping Time")
        {
            Visible = false;
        }

        modify(CustomizedCalendar)
        {
            Visible = false;
        }
        addafter(Description)
        {
            field("Company Transporter"; Rec."Company Transporter")
            {
                ApplicationArea = all;
            }
        }
    }
}