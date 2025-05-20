pageextension 50018 "WDC Shipping Agent Services" extends "Shipping Agent Services"
{
    Caption = 'Liste Chauffeur';

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

    }
}