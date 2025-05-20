tableextension 50002 "WDC Sales Cue" extends "Sales Cue"
{
    //************** Documentation **************
    //  WDC01  26/06/2024 : Add fields & Add filter by cashier for all Rolecenter Value
    fields
    {
        // field(50005; "Cash Payment"; Decimal)
        // {
        //     CalcFormula = sum("WDC-ED Payment Line"."Amount" where("Payment Slip Type" = filter(),
        //                                                             "Payment Type" = filter(0 | 8),
        //                                                             "Posting Date" = field("Current Date Filter"),
        //                                                             "Location Code" = field("Location Filter"),
        //                                                             Cashier = field("Cashier Filter"),
        //                                                              Prepayment = const(False)
        //                                                             ));
        //     CaptionML = ENG = 'Total Cash for Today', FRA = 'Total espèce du jour';
        //     Editable = false;
        //     FieldClass = FlowField;
        // }
        // field(50006; "Cheque Payment"; Decimal)
        // {
        //     CalcFormula = sum("WDC-ED Payment Line"."Amount" where("Line Type" = filter(Payment),
        //                                                             "Payment Type" = filter(1),
        //                                                             "Posting Date" = field("Current Date Filter"),
        //                                                             "Location Code" = field("Location Filter"),
        //                                                             Cashier = field("Cashier Filter")
        //                                                             ));//WDC01
        //     CaptionML = ENG = 'Total Check for Today', FRA = 'Total chéque du jour';
        //     Editable = false;
        //     FieldClass = FlowField;
        // }
        // field(50007; "Draft Payment"; Decimal)
        // {
        //     CalcFormula = sum("WDC-ED Payment Line"."Amount" where("Line Type" = filter(Payment),
        //                                                             "Payment Type" = filter(2),
        //                                                             "Posting Date" = field("Current Date Filter"),
        //                                                             "Location Code" = field("Location Filter"),
        //                                                             Cashier = field("Cashier Filter")
        //                                                             ));//WDC01
        //     CaptionML = ENG = 'Total Processed for Today', FRA = 'Total traite du jour';
        //     Editable = false;
        //     FieldClass = FlowField;
        // }
        // field(50008; "TRANSFER Payment"; Decimal)
        // {
        //     CalcFormula = sum("WDC-ED Payment Line"."Amount" where("Line Type" = filter(Payment),
        //                                                             "Payment Type" = filter(3),
        //                                                             "Posting Date" = field("Current Date Filter"),
        //                                                             "Location Code" = field("Location Filter"),
        //                                                             Cashier = field("Cashier Filter")));//WDC01
        //     CaptionML = ENG = 'Total Transfer for Today', FRA = 'Total virement du jour';
        //     Editable = false;
        //     FieldClass = FlowField;
        // }
        // field(50009; "TPE Payment"; Decimal)
        // {
        //     CalcFormula = sum("WDC-ED Payment Line"."Amount" where("Payment Type" = filter(4),
        //                                                             "Posting Date" = field("Current Date Filter"),
        //                                                             "Location Code" = field("Location Filter"),
        //                                                             Cashier = field("Cashier Filter")));//chg
        //                                                                                                 //WDC01
        //     CaptionML = ENG = 'Total TPE for Today', FRA = 'Total TPE du jour';
        //     Editable = false;
        //     FieldClass = FlowField;
        // }

    }
}