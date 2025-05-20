tableextension 54015 "WDC-ST Payment Status" extends "WDC-ED Payment Status"
{
    fields
    {
        field(54000; "Calculate RS"; Boolean)
        {
            CaptionML = FRA = 'Calculate RS', ENU = 'Calculer RS';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                CLEAR(PaymentStatus);
                PaymentStatus.RESET;
                PaymentStatus.SETCURRENTKEY("Payment Class", "Calculate RS");
                PaymentStatus.SETFILTER("Payment Class", "Payment Class");
                PaymentStatus.SETFILTER("Calculate RS", '%1', TRUE);
                IF PaymentStatus.Findfirst AND ("Calculate RS" = TRUE) THEN
                    ERROR(Error001);
            end;
        }
        field(54001; "Calc. RS On VAT"; Boolean)
        {
            CaptionML = ENU = 'Calc RS On VAT', FRA = 'Calculer Retenue Sur TVA';
            DataClassification = ToBeClassified;
        }
        field(54002; "Calc. RS On Guarrantee"; Boolean)
        {
            CaptionML = ENU = 'Calc. RS On Guarrantee', FRA = 'Calculer Retenue sur Garantie';
            DataClassification = ToBeClassified;
        }
        field(54003; "Commission"; Boolean)
        {
            CaptionML = ENU = 'Commission', FRA = 'Commission';
            DataClassification = ToBeClassified;
        }
        field(54004; "VAT On Commission"; Boolean)
        {
            CaptionML = ENU = 'VAT On Commission', FRA = 'Tva Sur Commission';
            DataClassification = ToBeClassified;
        }
        field(54005; "Block Customer"; Boolean)
        {
            CaptionML = ENU = 'Block Customer', FRA = 'Bloquer Client';
            DataClassification = ToBeClassified;

        }


        field(54006; Cancelation; Boolean)
        {
            CaptionML = ENU = 'Cancelation', FRA = 'Annulation';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                PaymentLine: Record 50866;
            begin
                PaymentLine.RESET;
                PaymentLine.SETRANGE(PaymentLine."Payment Class", "Payment Class");
                PaymentLine.SETRANGE(PaymentLine."Status No.", "Line No.");
                IF PaymentLine.FindSet() THEN BEGIN
                    PaymentLine.Cancelation := TRUE;
                    PaymentLine.MODIFY;
                END;
            end;
        }
        field(54007; Editable; Boolean)
        {
            CaptionML = ENU = 'Editable', FRA = 'Modifiable';
            DataClassification = ToBeClassified;

        }
        field(54008; "Contrepartie Ligne de paiement"; Boolean)
        {
            CaptionML = ENU = 'Counterparty Payment Line', FRA = 'Contrepartie Ligne paiement';
            DataClassification = ToBeClassified;

        }
        field(54009; "Type Compte Contrepartie"; Boolean)
        {
            CaptionML = ENU = 'Counterparty Account Type', FRA = 'Type Compte Contrepartie';
            DataClassification = ToBeClassified;

        }
        field(54010; "Pay Line Counterparty Acc."; Boolean)
        {
            CaptionML = ENU = 'Payment Line Counterparty Acc.', FRA = 'Cpte Contrepartie Ligne de paiement';
            DataClassification = ToBeClassified;

        }
        field(54011; Situation; Enum "WDC-ST Payment Situation")
        {
            CaptionML = ENU = 'Situation', FRA = 'Situation';
            DataClassification = ToBeClassified;
        }
        field(54012; "Cheque/Traite Required"; Boolean)
        {
            CaptionML = ENU = 'Cheque/Traite Required', FRA = 'Obligatoire Cheque/Traite';
            DataClassification = ToBeClassified;
        }
        field(54013; "Obligatoire Code Banque"; Boolean)
        {
            CaptionML = ENU = 'Bank Code Required', FRA = 'Obligatoire Code Banque';
            DataClassification = ToBeClassified;
        }
        field(54014; "Obligatoire Commentaire"; Boolean)
        {
            CaptionML = ENU = 'Comment Required', FRA = 'Obligatoire Commentaire';
            DataClassification = ToBeClassified;
        }
        field(54015; "Allow Header Modification"; Boolean)
        {
            CaptionML = ENU = 'Allow Header Modification', FRA = 'Autoriser Modifcation Entête';
            DataClassification = ToBeClassified;
        }
        field(54016; "Header Account"; Boolean)
        {
            CaptionML = ENU = 'Header Account', FRA = 'Compte en-tête';
            DataClassification = ToBeClassified;
        }
        field(54017; "Mofi automatique BQ Entê"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }
    var
        PaymentStatus: Record 50861;
        Error001: Label 'Le calcul de Retenu à la Source ce fait une seule fois !';

}