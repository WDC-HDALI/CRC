pageextension 54020 "WDC-ST Payment Status" extends "WDC-ED Payment Status"
{
    layout
    {
        addlast(Control1)
        {
            field("Calculate RS"; Rec."Calculate RS")
            {
                ApplicationArea = All;
            }
            field("Calc. RS On VAT"; Rec."Calc. RS On VAT")
            {
                ApplicationArea = All;
            }
            field("VAT On Commission"; Rec."VAT On Commission")
            {
                ApplicationArea = All;
            }
            field(Commission; Rec.Commission)
            {
                ApplicationArea = All;
            }

            field("Calc. RS On Guarrantee"; Rec."Calc. RS On Guarrantee")
            {
                ApplicationArea = All;
            }
            field("Block Customer"; Rec."Block Customer")
            {
                ApplicationArea = All;
            }
            field(Situation; Rec.Situation)
            {
                ApplicationArea = All;
            }
            field(cancelation; Rec.cancelation)
            {
                ApplicationArea = All;
            }
            field(Modifiable; Rec.Modifiable)
            {
                ApplicationArea = All;
            }
            field("Allow Header Modification"; Rec."Allow Header Modification")
            {
                ApplicationArea = All;
            }
        }
    }

}