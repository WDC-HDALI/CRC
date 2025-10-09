namespace CRC.CRC;

using Microsoft.Finance.RoleCenters;

pageextension 50036 "WDC Business Manager Role Cent" extends "Business Manager Role Center"
{
    layout
    {
        modify(ApprovalsActivities)
        {
            Visible = false;
        }
        modify("Job Queue Tasks Activities")
        {
            Visible = false;
        }
        modify("My Job Queue")
        {
            Visible = false;
        }
        modify("User Tasks Activities")
        {
            Visible = false;
        }
        modify("Intercompany Activities")
        {
            Visible = false;
        }
        modify(Control46)
        {
            Visible = false;
        }

    }
}
