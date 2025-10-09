namespace CRC.CRC;

using Microsoft.Sales.Document;
using Microsoft.Sales.Pricing;
using Microsoft.Inventory.Ledger;
using Microsoft.Inventory.Item;
using Microsoft.Finance.VAT.Setup;
//****************Documentation**********************
//wdc01  WDC.FS  17/06/2025 Show Error Message if the line discount exceeds the allowed discount plan font
//wdc02  WDC.HG  03/07/2025 Add "Unit Price Incl Discount" field 
tableextension 50011 "WDC Sales Lines" extends "Sales Line"
{
    fields
    {
        //<<wdc01
        //<<WDC02
        modify("No.")
        {
            trigger OnAfterValidate()
            begin
                rec."Unit Price Incl Discount" := GetUnitPriceTTC()
            end;
        }
        //>>WDC02
        modify("Line Discount %")
        {
            trigger OnAfterValidate()
            begin
                controlPercent_Discount_Ceiling();
                //<<WDC02
                if (Quantity <> 0) then begin
                    if "Line Discount %" <> 0 then begin
                        rec."Unit Price Incl Discount" := "Amount Including VAT" / Quantity;
                    end;
                    if "Line Discount %" = 0 then
                        rec."Unit Price Incl Discount" := GetUnitPriceTTC();
                end
                //>>WDC02
            end;
        }

        modify("Line Amount")
        {
            trigger OnAfterValidate()
            begin
                controlAmountPercent_Discount_Ceiling();
            end;
        }
        //>>wdc01
        field(50000; "Assoc. Transport Line No."; Integer)
        {
            CaptionML = ENU = 'Assoc. Transport Line No.', FRA = 'N° ligne Transport associée';
            DataClassification = ToBeClassified;
        }
        field(50001; "Assoc. Royality Line No."; Integer)
        {
            CaptionML = ENU = 'Assoc. Royality Line No.', FRA = 'N° ligne Redevance associée';
            DataClassification = ToBeClassified;
        }
        //<<WDC02
        field(50002; "Unit Price Incl Discount"; Decimal)
        {
            CaptionML = ENU = 'Unit Price Incl. Discount', FRA = 'Prix Unitaire Incl. Remise';
            DataClassification = ToBeClassified;
        }
        //>>WDC02

        field(50003; "Location Item Inventory"; Decimal)
        {
            CaptionML = ENU = 'Location Item Inventory', FRA = 'Stock magasin';
            FieldClass = FlowField;
            CalcFormula = sum("Item Ledger Entry".Quantity where("Item No." = field("No."),
                                                                  "Location Code" = field("Location Code")));
            DecimalPlaces = 0 : 5;
            Editable = false;

        }
    }
    //<<wdc01
    procedure controlPercent_Discount_Ceiling()
    var
        lSalesLineDiscount: Record "Sales Line Discount";
        AllowedDiscount: Decimal;
        DiscountPlanFont: Decimal;
        Text001: TextConst ENU = 'The line discount cannot exceed the allowed discount plan font %1',
                                    FRA = 'La remise de ligne ne peut pas dépasser le planfont de remise autorisée %1';


    begin
        lSalesLineDiscount.Reset();
        lSalesLineDiscount.SETRANGE(Code, Rec."No.");
        lSalesLineDiscount.SETRANGE("Sales Type", lSalesLineDiscount."Sales Type"::"All Customers");
        lSalesLineDiscount.SetRange("Type", lSalesLineDiscount."Type"::Item);
        lSalesLineDiscount.SetRange("Currency Code", Rec."Currency Code");
        lSalesLineDiscount.SetRange("Variant Code", Rec."Variant Code");
        lSalesLineDiscount.SetRange("Unit of Measure Code", Rec."Unit of Measure Code");
        IF lSalesLineDiscount.findset() then begin
            repeat
                if lSalesLineDiscount."Discount Ceiling %" <> 0 then begin
                    if Rec."Line Discount %" > lSalesLineDiscount."Discount Ceiling %" then
                        Error(Text001, lSalesLineDiscount."Discount Ceiling %");
                end;
            until lSalesLineDiscount.Next() = 0;
            //end else begin
            lSalesLineDiscount.Reset();
            lSalesLineDiscount.SETRANGE(Code, Rec."No.");
            lSalesLineDiscount.SETRANGE("Sales Type", lSalesLineDiscount."Sales Type"::Customer);
            lSalesLineDiscount.SETRANGE("Sales Code", Rec."Sell-to Customer No.");
            lSalesLineDiscount.SetRange("Type", lSalesLineDiscount."Type"::Item);
            lSalesLineDiscount.SetRange("Currency Code", Rec."Currency Code");
            lSalesLineDiscount.SetRange("Variant Code", Rec."Variant Code");
            lSalesLineDiscount.SetRange("Unit of Measure Code", Rec."Unit of Measure Code");
            if lSalesLineDiscount.FindSet() then
                repeat
                    if lSalesLineDiscount."Discount Ceiling %" <> 0 then begin
                        if Rec."Line Discount %" > lSalesLineDiscount."Discount Ceiling %" then
                            Error(Text001, lSalesLineDiscount."Discount Ceiling %");
                    end;
                until lSalesLineDiscount.Next() = 0;

            lSalesLineDiscount.Reset();
            lSalesLineDiscount.SETRANGE(Code, Rec."No.");
            lSalesLineDiscount.SETRANGE("Sales Type", lSalesLineDiscount."Sales Type"::"Customer Disc. Group");
            lSalesLineDiscount.SETRANGE("Sales Code", Rec."Customer Disc. Group");
            lSalesLineDiscount.SetRange("Type", lSalesLineDiscount."Type"::Item);
            lSalesLineDiscount.SetRange("Currency Code", Rec."Currency Code");
            lSalesLineDiscount.SetRange("Variant Code", Rec."Variant Code");
            lSalesLineDiscount.SetRange("Unit of Measure Code", Rec."Unit of Measure Code");
            if lSalesLineDiscount.FindSet() then
                repeat
                    if lSalesLineDiscount."Discount Ceiling %" <> 0 then begin
                        if Rec."Line Discount %" > lSalesLineDiscount."Discount Ceiling %" then
                            Error(Text001, lSalesLineDiscount."Discount Ceiling %");
                    end;
                until lSalesLineDiscount.Next() = 0;
        end;
    end;

    procedure controlAmountPercent_Discount_Ceiling()
    var
        lSalesLineDiscount: Record "Sales Line Discount";
        AllowedDiscount: Decimal;
        Found: Boolean;
        MaxAllowedAmount: Decimal;
        Text001: TextConst ENU = 'The amount cannot Be less than the allowed amount %1.',
                                    FRA = 'Le montant ne peut pas être inférieur au montant autorisé %1.';


    begin
        lSalesLineDiscount.Reset();
        lSalesLineDiscount.SETRANGE(Code, Rec."No.");
        lSalesLineDiscount.SETRANGE("Sales Type", lSalesLineDiscount."Sales Type"::"All Customers");
        lSalesLineDiscount.SetRange("Type", lSalesLineDiscount."Type"::Item);
        lSalesLineDiscount.SetRange("Currency Code", Rec."Currency Code");
        lSalesLineDiscount.SetRange("Variant Code", Rec."Variant Code");
        lSalesLineDiscount.SetRange("Unit of Measure Code", Rec."Unit of Measure Code");
        Found := false;
        if lSalesLineDiscount.FindSet() then begin
            repeat
                if Rec."Line Amount" < Rec.Quantity * Rec."Unit Price" - (lSalesLineDiscount."Discount Ceiling %" * Rec.Quantity * Rec."Unit Price") / 100 then
                    Found := true;
                MaxAllowedAmount := Rec.Quantity * Rec."Unit Price" - (lSalesLineDiscount."Discount Ceiling %" * Rec.Quantity * Rec."Unit Price") / 100;
            until lSalesLineDiscount.Next() = 0;


            if Found then
                Error(Text001, MaxAllowedAmount);
        end else begin

            lSalesLineDiscount.Reset();
            lSalesLineDiscount.SETRANGE(Code, Rec."No.");
            lSalesLineDiscount.SETRANGE("Sales Type", lSalesLineDiscount."Sales Type"::Customer);
            lSalesLineDiscount.SETRANGE("Sales Code", Rec."Sell-to Customer No.");
            lSalesLineDiscount.SetRange("Type", lSalesLineDiscount."Type"::Item);
            lSalesLineDiscount.SetRange("Currency Code", Rec."Currency Code");
            lSalesLineDiscount.SetRange("Variant Code", Rec."Variant Code");
            lSalesLineDiscount.SetRange("Unit of Measure Code", Rec."Unit of Measure Code");


            Found := false;
            if lSalesLineDiscount.FindSet() then
                repeat
                    if Rec."Line Amount" < Rec.Quantity * Rec."Unit Price" - (lSalesLineDiscount."Discount Ceiling %" * Rec.Quantity * Rec."Unit Price") / 100 then
                        Found := true;
                    MaxAllowedAmount := Rec.Quantity * Rec."Unit Price" - (lSalesLineDiscount."Discount Ceiling %" * Rec.Quantity * Rec."Unit Price") / 100;
                until lSalesLineDiscount.Next() = 0;


            if Found then
                Error(Text001, MaxAllowedAmount);

        end;
    end;

    procedure GetUnitPriceTTC(): Decimal
    var
        item: record Item;
        VATPostingSetup: Record "VAT Posting Setup";
    begin
        item.reset();
        if item.get("No.") then
            if item."Unit Price" <> 0 then begin
                VATPostingSetup.reset();
                if VATPostingSetup.Get('ASSUJETTI', item."VAT Prod. Posting Group") then
                    exit(item."Unit Price" * (1 + (VATPostingSetup."VAT %" / 100)));
            end;
    end;
    //>>wdc01
}
