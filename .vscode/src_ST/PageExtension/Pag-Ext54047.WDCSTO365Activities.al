namespace CRC.CRC;

using Microsoft.Finance.RoleCenters;

pageextension 54047 "WDC-ST O365 Activities" extends "O365 Activities"
{
    layout
    {
        addbefore(Payments)
        {
            cuegroup(Sales)
            {
                CaptionML = ENU = 'Sales Statistics', FRA = 'Statistiques Ventes';
                field("Sales Cash"; Rec."Sales Cash")
                {
                    CaptionML = ENU = 'Cash Sales of the Day', FRA = 'Espèces Vente du jour';
                    ApplicationArea = All;
                }
                field("Sales Cheque"; Rec."Sales Cheque")
                {
                    CaptionML = ENU = 'Cheque Sales of the Day', FRA = 'Chèque Vente du jour';
                    ApplicationArea = All;

                }
                field("Sales Draft"; Rec."Sales Draft")
                {
                    CaptionML = ENU = 'Draft Sales of the Day', FRA = 'Effet Vente du jour';
                    ApplicationArea = All;
                }
                field("Sales Transfer"; Rec."Sales Transfer")
                {
                    CaptionML = ENU = 'Transfer Sales of the Day', FRA = 'Virement Vente du jour';
                    ApplicationArea = All;
                }
                field("Unpaid Draft"; Rec."Unpaid Draft")
                {
                    CaptionML = ENU = 'Impayed Draft', FRA = 'Impayé traite du jour';
                    ApplicationArea = All;
                }
                field("Unpaid Cheque"; Rec."Unpaid Cheque")
                {
                    CaptionML = ENU = 'Impayed Cheque', FRA = 'Impayé chèque du jour';
                    ApplicationArea = All;
                }
            }
            cuegroup(Purchase)
            {
                CaptionML = ENU = 'Purchase Statistics', FRA = 'Statistiques Achats';

                field("Purchase Cash"; Rec."Purchase Cash")
                {
                    CaptionML = ENU = 'Cash Purchase of the Day', FRA = 'Espèces Achat du jour';
                    ApplicationArea = All;
                }
                field("Purchase Cheque"; Rec."Purchase Cheque")
                {
                    CaptionML = ENU = 'Cheque Purchase of the Day', FRA = 'Chèque Achat du jour';
                    ApplicationArea = All;
                }
                field("Purchase Draft"; Rec."Purchase Draft")
                {
                    CaptionML = ENU = 'Draft Purchase of the Day', FRA = 'Effet Achat du jour';
                    ApplicationArea = All;
                }
                field("Purchase Transfer"; Rec."Purchase Transfer")
                {
                    CaptionML = ENU = 'Transfer Purchase of the Day', FRA = 'Virement Achat du jour';
                    ApplicationArea = All;
                }
            }
        }

        modify("My Incoming Documents")
        {
            Visible = false;
        }
        modify("Incoming Documents")
        {
            Visible = false;
        }
        modify(Camera)
        {
            Visible = false;
        }
        modify(Payments)
        {
            Visible = false;
        }
    }
    trigger OnOpenPage()
    begin
        Rec.SetRange("Date Filter", WorkDate());
    end;
}
