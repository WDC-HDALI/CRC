namespace CRC.CRC;
using Microsoft.Sales.History;

page 50006 "WDC Posted Customer Delivery"
{
    ApplicationArea = All;
    CaptionML = ENU = 'Posted Customer Delivery', FRA = 'Livraison client Validé';
    PageType = Document;
    SourceTable = "WDC Customer Shipment Header";
    Editable = false;
    InsertAllowed = false;
    layout
    {
        area(Content)
        {
            group(General)
            {
                CaptionML = ENU = 'General', FRA = 'Général';
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }

                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                    ApplicationArea = All;
                }
                field("Sell-to Customer Name"; Rec."Sell-to Customer Name")
                {
                    ApplicationArea = All;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                }
                field("Shipment No."; Rec."Shipment No.")
                {
                    ApplicationArea = All;
                }
                field("Ship-to Address"; Rec."Ship-to Address")
                {
                    ApplicationArea = All;
                }
                field("Ship-to Address 2"; Rec."Ship-to Address 2")
                {
                    ApplicationArea = All;
                }
                field("Ship-to City"; Rec."Ship-to City")
                {
                    ApplicationArea = All;
                }
                field("Ship-to Post Code"; Rec."Ship-to Post Code")
                {
                    ApplicationArea = All;
                }
                field("Transport Method"; Rec."Transport Method")
                {
                    ApplicationArea = All;
                }
                field("Shipping Agent Code"; Rec."Shipping Agent Code")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }

            }
            part("Customer Shipment Lines"; "WDC Customer Delivery Lines")
            {
                ApplicationArea = All;
                CaptionML = ENU = 'Lines', FRA = 'Lignes';
                SubPageLink = "Document No." = field("No.");
            }
        }
    }
}