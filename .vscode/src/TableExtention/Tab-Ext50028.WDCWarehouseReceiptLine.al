//**************Documentation**************
// WDC.FS 09/06/2025: Add fields
tableextension 50028 "WDC Warehouse Receipt Line" extends "Warehouse Receipt Line"
{
    fields
    {
        field(50000; "Unité de réception"; Code[20])
        {
            CaptionML = ENU = 'Receiving Unit', FRA = 'Unité de réception';
            DataClassification = ToBeClassified;
            TableRelation = "Unit of Measure";

        }
        field(50001; "Qté de réception"; Integer)
        {
            CaptionML = ENU = 'Receiving Qty', FRA = 'Qté de réception';
            DataClassification = ToBeClassified;
        }
        field(50002; "Direct Unit Cost"; Decimal)
        {
            CaptionML = ENU = 'Direct Unit Cost', FRA = 'Coût unitaire';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Purchase Line"."Direct Unit Cost" where("Document Type" = const(order),
                                                                          "Document No." = field("Source No."),
                                                                         "Line No." = field("Source Line No.")));
        }
        field(50003; "Line Discount %"; Decimal)
        {
            CaptionML = ENU = 'Line Discount %', FRA = 'Remise ligne %';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Purchase Line"."Line Discount %" where("Document Type" = const(order),
                                                                          "Document No." = field("Source No."),
                                                                         "Line No." = field("Source Line No.")));
        }
        field(50004; "Discount Amount"; Decimal)
        {
            CaptionML = ENU = 'Discount Amount', FRA = 'Montant remise';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Purchase Line"."Line Discount Amount" where("Document Type" = const(order),
                                                                          "Document No." = field("Source No."),
                                                                         "Line No." = field("Source Line No.")));
        }

        field(50005; "VAT %"; Decimal)
        {
            CaptionML = ENU = 'VAT %', FRA = 'TVA %';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Purchase Line"."VAT %" where("Document Type" = const(order),
                                                                  "Document No." = field("Source No."),
                                                                 "Line No." = field("Source Line No.")));
        }
        // field(50006; "VAT Amount"; Decimal)
        // {
        //     CaptionML = ENU = 'VAT %', FRA = 'TVA %';
        //     Editable = false;
        //     FieldClass = FlowField;
        //     CalcFormula = lookup("Purchase Line"."VAT %" where("Document Type" = const(order),
        //                                                           "Document No." = field("Source No."),
        //                                                          "Line No." = field("Source Line No.")));
        // }
    }
}
