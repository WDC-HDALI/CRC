namespace CRC.CRC;
using Microsoft.Inventory.History;
using Microsoft.Inventory.Comment;
//****************Documentation********************
//WDC01  WDC.HG  19/05/2025  Create Current Object
page 50011 WDCPostedInvtShipment
{
    Captionml = ENU = 'Posted Invt. Shipment', FRA = 'Sortie stock validée';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Document;
    AboutText = 'Sortie Stock Validée';
    AboutTitle = 'Sortie Stock Validée';
    SourceTable = "Invt. Shipment Header";
    RefreshOnActivate = true;
    ApplicationArea = all;
    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                //>>WDC01
                field(CustomerNo; Rec.CustomerNo)
                {
                    ApplicationArea = Basic, Suite;

                }
                field(CustomerName; Rec.CustomerName)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(CustomerAddress; Rec.CustomerAddress)
                {
                    ApplicationArea = Basic, Suite;

                }
                field(CustomerPhoneNo; Rec.CustomerPhoneNo)
                {
                    ApplicationArea = Basic, Suite;
                }
                //>>WDC01
                field("Posting Description"; Rec."Posting Description")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = Location;
                    Editable = false;
                }

                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("External Document No."; Rec."External Document No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Salesperson Code"; Rec."Salesperson Code")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Correction; Rec.Correction)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
            }
            part(ShipmentLines; "Posted Invt. Shipment Subform")
            {
                ApplicationArea = Basic, Suite;
                SubPageLink = "Document No." = field("No.");
                UpdatePropagation = Both;
            }
            //<<WDC01
            group(totaux)
            {
                Caption = 'Totaux';
                ShowCaption = false;

                field("Total HT"; Rec."Total HT")
                {
                    ApplicationArea = all;
                }
                field("Total TVA"; Rec."Total TVA")
                {
                    ApplicationArea = all;
                }
                field("Total TTC"; Rec."Total TTC")
                {
                    ApplicationArea = all;
                }
            }
            //>>WDC01

        }
    }

    actions
    {

        area(processing)
        {
            action("&Print")
            {
                ApplicationArea = Basic, Suite;
                CaptionML = ENU = '&Print', FRA = 'Imprimer';
                Ellipsis = true;
                Image = Print;
                ToolTip = 'Prepare to print the document. A report request window for the document opens where you can specify what to include on the print-out.';

                trigger OnAction()
                var
                    InvtShptHeader: Record "Invt. Shipment Header";
                begin
                    CurrPage.SetSelectionFilter(InvtShptHeader);
                    if InvtShptHeader.FindSet() then begin
                        Report.Run(50005, true, false, InvtShptHeader);
                        InvtShptHeader.PrintRecords(true);
                    end;
                end;
            }
            action("&Navigate")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Find entries...';
                Image = Navigate;

                trigger OnAction()
                begin
                    Rec.Navigate();
                end;
            }
        }

    }

    trigger OnAfterGetRecord()
    begin
        CalcTotals();
    end;

    var
        LineQty: Decimal;
        TotalNetWeight: Decimal;
        TotalGrossWeight: Decimal;
        TotalVolume: Decimal;
        TotalParcels: Decimal;

    procedure CalcTotals()
    var
        InvtShptLine: Record "Invt. Shipment Line";
    begin
        ClearAll();

        InvtShptLine.SetRange("Document No.", Rec."No.");
        if InvtShptLine.Find('-') then
            repeat
                LineQty := LineQty + InvtShptLine.Quantity;
                TotalNetWeight += InvtShptLine.Quantity * InvtShptLine."Net Weight";
                TotalGrossWeight += InvtShptLine.Quantity * InvtShptLine."Gross Weight";
                TotalVolume += InvtShptLine.Quantity * InvtShptLine."Unit Volume";
                if InvtShptLine."Units per Parcel" > 0 then
                    TotalParcels += Round(InvtShptLine.Quantity / InvtShptLine."Units per Parcel", 1, '>');
            until InvtShptLine.Next() = 0;
    end;
}


