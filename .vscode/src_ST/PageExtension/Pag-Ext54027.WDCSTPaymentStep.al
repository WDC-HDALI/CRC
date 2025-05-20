pageextension 54027 "WDC-ST Payment Step" Extends "WDC-ED Payment Steps"
{

    layout
    {
        addlast(Control1)
        {
            field("Mandatory Ext. Doc No."; Rec."Mandatory Ext. Doc No.")
            {
                ApplicationArea = All;
            }
            field("Mandatory Drawer"; Rec."Mandatory Drawer")
            {
                ApplicationArea = All;
            }
            field("Mandatory Draw"; Rec."Mandatory Draw")
            {
                ApplicationArea = All;
            }
            field("Motif Obligatoire"; Rec."Mandatory Reason Code")
            {
                ApplicationArea = All;
            }
            field("Mandatory Bank Line"; Rec."Mandatory Bank Line")
            {
                ApplicationArea = All;
            }
            field("Mandatory Header Bank"; Rec."Mandatory Header Bank")
            {
                ApplicationArea = All;
            }
        }


    }
    // actions
    // {
    //     addlast(Creation)
    //     {
    //         action("Autorisation Etapes")
    //         {
    //             ApplicationArea = All;
    //             Promoted = true;
    //             PromotedCategory = Process;
    //             PromotedIsBig = true;
    //             RunObject = Page "WDC-ST Permission Step";
    //             RunPageView = SORTING(Step, "Payment Type", "Payment Slip Profile") ORDER(Ascending);
    //             RunPageLink = "Payment Type" = FIELD("Payment Class"), Step = FIELD(Line);
    //             RunPageOnRec = false;
    //         }

    //     }

    // }


}
