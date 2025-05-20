pageextension 54021 "WDC-ST Payment Slip Subform" extends "WDC-ED Payment Slip Subform"
{
    layout
    {
        addafter("Bank Account Code")
        {
            field("RS Code"; Rec."RS Code")
            {
                ApplicationArea = All;
            }

        }
        addafter("RIB Checked")
        {
            field("Validated RS Amount"; Rec."Validated RS Amount")
            {
                ApplicationArea = All;
            }
            field("RS Amount"; Rec."RS Amount")
            {
                ApplicationArea = All;
            }
            field("Commission VAT Amount"; Rec."Commission VAT Amount")
            {
                ApplicationArea = All;
            }
            field("Commission Amount"; Rec."Commission Amount")
            {
                ApplicationArea = All;
            }
            field("Payment Label"; Rec."Payment Label")
            {
                ApplicationArea = All;
            }
            field("Payment Object"; Rec."Payment Object")
            {
                ApplicationArea = All;
            }
            field(Comments; Rec.Comments)
            {
                ApplicationArea = All;
            }
            field("Drawee Reference1"; Rec."Drawee Reference1")
            {
                ApplicationArea = All;
            }

            field("External Invoice No."; Rec."External Invoice No.")
            {
                ApplicationArea = All;
            }
            field("In Bank"; Rec."In Bank")
            {
                ApplicationArea = All;
            }
            field(Cancelation; Rec.Cancelation)
            {
                ApplicationArea = All;
            }
            field("Payment Amount Type"; Rec."Payment Amount Type")
            {
                ApplicationArea = All;
            }
            field("Payment Slip No."; Rec."Payment Slip No.")
            {
                ApplicationArea = All;
            }
            field("Commande No."; Rec."Commande No.")
            {
                ApplicationArea = All;
            }
            field("Invoice No."; Rec."Invoice No.")
            {
                ApplicationArea = All;
            }
            field(Replaced; Rec.Replaced)
            {
                ApplicationArea = All;
            }
            field("Payment Credit"; Rec."Payment Credit")
            {
                ApplicationArea = All;
            }

            field("Header Account Type"; Rec."Header Account Type")
            {
                ApplicationArea = All;
            }
            field("Header Account No."; Rec."Header Account No.")
            {
                ApplicationArea = All;
            }

            field("Open Advance"; Rec."Open Advance")
            {
                ApplicationArea = All;
            }
            field("Open Amount"; Rec."Open Amount")
            {
                ApplicationArea = All;
            }
            field("Open Amount LCY"; Rec."Open Amount LCY")
            {
                ApplicationArea = All;
            }

            field("Counterparty Payment Line"; Rec."Counterparty Payment Line")
            {
                ApplicationArea = All;
            }
            field("Counterparty Account Type"; Rec."Counterparty Account Type")
            {
                ApplicationArea = All;
            }
            field("Contr. Associ. Acc. LP Type"; Rec."Contr. Associ. Acc. LP Type")
            {
                ApplicationArea = All;
            }
            field("Contr. Associ. Acc. LP No."; Rec."Contr. Associ. Acc. LP No.")
            {
                ApplicationArea = All;
            }
            field("Payment State"; Rec."Payment State")
            {
                ApplicationArea = All;
            }
            field("Invoice Source No."; Rec."Invoice Source No.")
            {
                ApplicationArea = All;
            }
            field("Payment Methode Code"; Rec."Payment Methode Code")
            {
                ApplicationArea = All;
            }
            field("Header RIB"; Rec."Header RIB")
            {
                ApplicationArea = All;
            }

            field("Montant Frais a Déduire"; Rec."Montant Frais a Déduire")
            {
                ApplicationArea = All;
            }
            field("Assiette RS"; Rec."Assiette RS")
            {
                ApplicationArea = All;
            }
            field("Mnt Déduction"; Rec."Mnt Déduction")
            {
                ApplicationArea = All;
            }
            field("Date de validation"; Rec."Date de validation")
            {
                ApplicationArea = All;
            }
            field("No. chèque"; Rec."No. chèque")
            {
                ApplicationArea = All;
            }
            field("Référence chèque"; Rec."Référence chèque")
            {
                ApplicationArea = All;
            }
            field("Petite Dépense"; Rec."Petite Dépense")
            {
                ApplicationArea = All;
            }
            field("Reason Code"; Rec."Reason Code")
            {
                ApplicationArea = All;
            }
        }

    }
    actions
    {
        addafter("F&unctions")
        {
            group("&Validation")
            {
                action(Imprimer)
                {
                    ApplicationArea = All;
                    Image = Print;
                    trigger OnAction()
                    var
                        myInt: Integer;
                    begin
                        PrintPayments;
                    end;
                }
            }
        }
        addafter(Insert)
        {
            action("Calculate RS")
            {
                CaptionML = ENU = 'Calculate RS', FRA = 'Calculer retenu à la source';
                ApplicationArea = All;
                Image = CalculateSalesTax;
                trigger OnAction()
                var
                    lText001: TextConst ENU = 'Do you want to calculate the RS for this payment?',
                                        FRA = 'Voulez-vous calculer la retenue à la source pour ce paiement?';
                begin
                    if Confirm(lText001) then begin
                        CalculateRS;
                    end;
                end;
            }
        }
    }

    procedure CalculateRS()
    begin
        CLEAR(paymentline);
        paymentline.RESET;
        paymentline.SETFILTER("Payment Class", Rec."Payment Class");
        paymentline.SETFILTER("Status No.", '%1', rec."Status No.");
        paymentline.SETFILTER("No.", Rec."No.");
        IF paymentline.Findfirst THEN BEGIN
            REPEAT
                paymentline.CalcRetenu;
                paymentline.CalcAmount;
                paymentline.MODIFY;
            UNTIL paymentline.NEXT = 0;
        end;
    end;

    local procedure PrintPayments()
    var
        PaymentFunctions: Codeunit "WDC-ST PaymentHook";
        PaymentStep: Record "WDC-ED Payment Step";
    begin
        Header.GET(Rec."No.");
        Header.CALCFIELDS("No. of Lines");
        IF Header."No. of Lines" = 0 THEN
            ERROR(Text004);
        PaymentFunctions.PrintLine(Header, PaymentStep."Action Type"::Report);

    end;

    Procedure EnablePetiteDépense(PetiteDépense: Boolean)
    begin
        IF PetiteDépense THEN BEGIN
            BoolPetiteDépense1 := TRUE;
            BoolPetiteDépense2 := FALSE;
        END
        ELSE BEGIN
            BoolPetiteDépense2 := TRUE;
            BoolPetiteDépense1 := FALSE;
        END;
    end;

    var
        Header: Record "WDC-ED Payment Header";
        Text004: Label 'Il n''existe aucune ligne à imprimer.';
        BoolPetiteDépense1: Boolean;
        BoolPetiteDépense2: Boolean;
        paymentline: Record "WDC-ED Payment Line";

}