namespace CRC.CRC;

using Microsoft.Foundation.Shipping;

pageextension 50009 "WDC Trucks List" extends "Shipping Agents"
{
    CaptionML = ENU = 'Trucks List', FRA = 'Liste Camions';
    AdditionalSearchTermsML = ENU = 'Trucks List', FRA = 'Liste Camions';
    AboutTitle = 'Liste Camions';
    DataCaptionExpression = 'Liste Camions';
    layout
    {
        addafter(Name)
        {
            field("Tech. insp. End Date"; Rec."Tech. insp. End Date")
            {
                ApplicationArea = all;
            }
            field("Taxe End Date"; Rec."Taxe End Date")
            {
                ApplicationArea = all;
            }
            field("Tax Amount LCY"; Rec."Tax Amount LCY")
            {
                ApplicationArea = all;
            }
            field("Truck Insurance End Date"; Rec."Truck Insurance End Date")
            {
                ApplicationArea = all;
            }
            field("Insurance Amount LCY"; Rec."Insurance Amount LCY")
            {
                ApplicationArea = all;
            }
            field("Fuel Amount LCY"; Rec."Fuel Amount LCY")
            {
                ApplicationArea = all;
            }
            field("Rep & Spare Part Amount LCY"; Rec."Rep & Spare Part Amount LCY")
            {
                ApplicationArea = all;
            }
        }
    }
}
