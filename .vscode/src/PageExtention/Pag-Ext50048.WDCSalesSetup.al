namespace CRC.CRC;

using Microsoft.Sales.Setup;
//*****************Documentation*********************
//WDC01  WDC.HG  26/06/2025  Create Current Object

pageextension 50048 "WDC Sales Setup" extends "Sales & Receivables Setup"
{
    layout
    {
        addlast(General)
        {
            field("Allow Document Deletion Before_"; Rec."Allow Document Deletion Before")
            {
                ApplicationArea = all;
            }
        }
        addlast("Number Series")
        {
            field("Posted Term Invoice No."; Rec."Posted Term Invoice No.")
            {
                ApplicationArea = all;
            }
            field("Posted Cash Invoice No."; Rec."Posted Cash Invoice No.")
            {
                ApplicationArea = all;
            }
        }
        addafter("Update Document Date When Posting Date Is Modified")
        {
            field("Standard Print Is Visible"; Rec."Standard Print Is Visible")
            {
                ApplicationArea = all;
            }
            field("Print Paiement Model2"; Rec."Print Paiement Model2")
            {
                ApplicationArea = all;
            }
        }
    }
}
