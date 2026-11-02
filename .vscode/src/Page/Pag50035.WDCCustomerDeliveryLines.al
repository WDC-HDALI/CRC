namespace CRC.CRC;

page 50035 "WDC Customer Delivery Lines"
{
    ApplicationArea = All;
    Caption = 'Customer Delivery Lines';
    PageType = ListPart;
    SourceTable = "WDC Customer Shipment Lines";
    InsertAllowed = false;
    DeleteAllowed = true;
    ModifyAllowed = true;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                CaptionML = ENU = 'General', FRA = 'Général';
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Description"; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Quantity"; Rec.Quantity)
                {
                    ApplicationArea = All;
                }
                field("Unit of Measure"; Rec."Unit of Measure")
                {

                    ApplicationArea = All;
                }
                field("Qty to Ship"; Rec."Qty to Ship")
                {
                    ApplicationArea = All;
                    Editable = Rec.Quantity > Rec."Qty Shipped";
                    trigger OnValidate()
                    var
                        lText001: TextConst ENU = 'Qty to ship must be less than  %1',
                                            FRA = 'La quantité à livrer doit-etre inferiuer ou égale à %1';
                    begin
                        if rec."Qty to Ship" > Rec.Quantity - Rec."Qty Shipped" then
                            Error(lText001, Rec.Quantity - Rec."Qty Shipped");
                    end;
                }
                field("Qty Shipped"; Rec."Qty Shipped")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
