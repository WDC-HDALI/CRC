namespace CRC.CRC;

using Microsoft.Warehouse.Setup;
using Microsoft.Inventory.Item;
using System.Security.User;
using Microsoft.Finance.VAT.Setup;
//****************Documentation**********************
//wdc01  WDC.FS  18/06/2025 Hide Some Fields in Item Card and Add Few Fields
//wdc02  WDC.HG  03/07/2025 show TTC Price

pageextension 50005 "WDC Item Card" extends "Item Card"
{


    layout

    {
        //<<Group Vilsibility
        addafter("Unit Price")
        {
            field(PrixTTC; PrixTTC)
            {
                CaptionML = ENU = 'Unit Price TTC', FRA = 'Prix Unitaire TTC';
                Editable = false;
                ApplicationArea = all;
            }
        }

        modify(Replenishment)
        {
            Visible = false;
        }
        modify(Planning)
        {
            Visible = false;
        }
        modify(ItemTracking)
        {
            Visible = false;
        }
        modify(Warehouse)
        {
            Visible = false;
        }
        modify(ForeignTrade)
        {
            Visible = false;

        }
        //<<wdc01
        modify("Gross Weight")
        {
            Visible = false;
        }
        modify("Net Weight")
        {
            Visible = false;
        }
        modify("Unit Volume")
        {
            Visible = false;
        }
        modify("Automatic Ext. Texts")
        {
            Visible = false;
        }
        modify("Common Item No.")
        {
            Visible = false;
        }
        modify(VariantMandatoryDefaultNo)
        {
            Visible = false;
        }
        modify("Costs & Posting")
        {
            Visible = ShowFieldActivated;
        }

        //>>wdc01
        //>>Group Vilsibility
        modify(GTIN)
        {
            Visible = false;
        }
        modify("Purchasing Code")
        {
            Visible = false;
        }
        modify("Qty. on Asm. Component")
        {
            Visible = false;
        }
        modify("Qty. on Assembly Order")
        {
            Visible = false;
        }
        modify("Qty. on Job Order")
        {
            Visible = false;
        }
        modify("Created From Nonstock Item")
        {
            Visible = false;
        }
        modify("Stockkeeping Unit Exists")
        {
            Visible = false;
        }
        modify("Production BOM No.")
        {
            Visible = false;
        }
        modify("Routing No.")
        {
            Visible = false;
        }
        modify(VariantMandatoryDefaultYes)
        {
            Visible = false;
        }
        modify("Tax Group Code")
        {
            Visible = false;
        }
        modify(SpecialPricesAndDiscountsTxt)
        {
            Visible = ViewSalesMarginFields;
        }
        modify("Allow Invoice Disc.")
        {
            Visible = ViewSalesMarginFields;
        }
        modify("Item Disc. Group")
        {
            Visible = ViewSalesMarginFields;
        }
        modify("profit %")
        {
            Visible = ViewSalesMarginFields;
        }
        modify("Price/Profit Calculation")
        {
            Visible = ViewSalesMarginFields;
        }
        //>>wdc01

        modify("Default Deferral Template Code")
        {
            Visible = false;
        }
        addafter(Inventory)
        {
            field("Input Inventory"; Rec."Input Inventory")
            {
                ApplicationArea = All;
            }
            field("Output Inventory"; Rec."Output Inventory")
            {
                ApplicationArea = All;
            }
            field("Sold Qty not Delivered"; Rec."Sold Qty not Delivered")
            {
                ApplicationArea = All;
            }
        }

        MoveBefore("Qty. on Purch. Order"; "Qty. on Sales Order")

        addafter("Base Unit of Measure")
        {
            field("Qty per Package"; Rec."Qty per Package")
            {
                ApplicationArea = All;
            }
        }
        addafter("Item Category Code")
        {
            field(SubCategorie; Rec.SubCategorie)
            {
                ApplicationArea = all;
            }
            field("Transport Item"; Rec."Transport Item")
            {
                ApplicationArea = All;
            }
            field("Associed Transport Item No."; Rec."Associed Transport Item No.")
            {
                ApplicationArea = All;
            }
            field("Transport Unit Price LCY"; Rec."Transport Unit Price LCY")
            {
                ApplicationArea = All;
            }
            field("Associated Royalty"; Rec."Associated Royalty")
            {
                ApplicationArea = All;
            }
            field("Royalty Unit Price LCY"; Rec."Royalty Unit Price LCY")
            {
                ApplicationArea = All;
            }
            field("Associated With Cement"; Rec."Associated With Cement")
            {
                ApplicationArea = all;
            }
            field("Associated With Iron"; Rec."Associated With Iron")
            {
                ApplicationArea = all;
            }

        }


    }

    trigger OnAfterGetRecord()
    var
        UserSetup: Record "User Setup";
    begin
        UserSetup.Get(UserId);
        if not UserSetup."Allow Modify Item" then
            CurrPage.Editable(false)

    end;
    //<<wdc01
    trigger OnOpenPage();
    var
        UserSetup: Record 91;
        VATPostingSetup: Record "VAT Posting Setup";
    begin
        PrixTTC := 0;
        UserSetup.get(UserId);
        ShowFieldActivated := false;
        ViewSalesMarginFields := false;
        if not UserSetup."Allow Modify Item" then
            CurrPage.Editable(false);

        ShowFieldActivated := UserSetup."Display Purchase Cost";

        ViewSalesMarginFields := UserSetup."View Sales Margin";
        if rec."Unit Price" <> 0 then begin
            VATPostingSetup.reset();
            if VATPostingSetup.Get('ASSUJETTI', rec."VAT Prod. Posting Group") then
                PrixTTC := rec."Unit Price" * (1 + (VATPostingSetup."VAT %" / 100));
        end;


    end;

    var
        ShowFieldActivated: Boolean;
        ViewSalesMarginFields: Boolean;
        PrixTTC: decimal;
    //>>wdc01

}
