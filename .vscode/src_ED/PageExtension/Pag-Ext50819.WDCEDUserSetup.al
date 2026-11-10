namespace CRC.CRC;

using System.Security.User;

pageextension 50819 "WDC-ED User Setup" extends "User Setup"
{
    layout
    {
        addafter(Email)
        {

            field("Allow Update Posted Document"; Rec."Allow Update Posted Document")
            {
                ApplicationArea = All;
            }
        }
    }
}
