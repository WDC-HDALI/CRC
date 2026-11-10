namespace CRC.CRC;

using System.Security.User;

tableextension 50819 "WDC-ED User Setup" extends "User Setup"
{
    fields
    {
        field(50800; "Allow Update Posted Document"; Boolean)
        {
            CaptionML = ENU = 'Allow Update Posted Document', FRA = 'Autoriser MAJ document validé';
            DataClassification = ToBeClassified;
        }
    }
}
