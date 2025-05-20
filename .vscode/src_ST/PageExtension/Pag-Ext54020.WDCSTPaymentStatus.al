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
            field("Cheque/Traite Required"; Rec."Cheque/Traite Required")
            {
                ApplicationArea = All;
            }
            field("Obligatoire Code Banque"; Rec."Obligatoire Code Banque")
            {
                ApplicationArea = All;
            }
            field("Obligatoire Commentaire"; Rec."Obligatoire Commentaire")
            {
                ApplicationArea = All;
            }
            field("Allow Header Modification"; Rec."Allow Header Modification")
            {
                ApplicationArea = All;
            }
            field("Header Account"; Rec."Header Account")
            {
                ApplicationArea = All;
            }
            field("Mofi automatique BQ Entê"; Rec."Mofi automatique BQ Entê")
            {
                ApplicationArea = All;
            }
            field(Editable; Rec.Editable)
            {
                ApplicationArea = All;
            }

            field("Type Compte Contrepartie"; Rec."Type Compte Contrepartie")
            {
                ApplicationArea = All;
            }
            field("Contrepartie Ligne de paiement"; Rec."Contrepartie Ligne de paiement")
            {
                ApplicationArea = All;
            }
            field("Pay Line Counterparty Acc."; Rec."Pay Line Counterparty Acc.")
            {
                ApplicationArea = All;
            }
            field(cancelation; Rec.cancelation)
            {
                ApplicationArea = All;
            }

        }
    }

}