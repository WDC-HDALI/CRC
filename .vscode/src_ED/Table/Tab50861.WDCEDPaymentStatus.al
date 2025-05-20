table 50861 "WDC-ED Payment Status"
{
    CaptionML = ENU = 'Payment Status', FRA = 'Statut règlement';
    LookupPageID = "WDC-ED Payment Status List";

    fields
    {
        field(1; "Payment Class"; Text[30])
        {
            CaptionML = ENU = 'Payment Class', FRA = 'Type de règlement';
            TableRelation = "WDC-ED Payment Class";
        }
        field(2; "Line No."; Integer)
        {
            CaptionML = ENU = 'Line', FRA = 'Ligne';
        }
        field(3; Name; Text[50])
        {
            CaptionML = ENU = 'Name', FRA = 'Nom';
        }
        field(4; RIB; Boolean)
        {
            CaptionML = ENU = 'RIB', FRA = 'RIB';
        }
        field(5; Look; Boolean)
        {
            CaptionML = ENU = 'Look', FRA = 'Consultation';
        }
        field(6; ReportMenu; Boolean)
        {
            CaptionML = ENU = 'ReportMenu', FRA = 'ReportMenu';
        }
        field(7; "Acceptation Code"; Boolean)
        {
            CaptionML = ENU = 'Acceptation Code', FRA = 'Code acceptation';
        }
        field(8; Amount; Boolean)
        {
            CaptionML = ENU = 'Amount', FRA = 'Montant';
        }
        field(9; Debit; Boolean)
        {
            CaptionML = ENU = 'Debit', FRA = 'Débit';
        }
        field(10; Credit; Boolean)
        {
            CaptionML = ENU = 'Credit', FRA = 'Crédit';
        }
        field(11; "Bank Account"; Boolean)
        {
            CaptionML = ENU = 'Bank Account', FRA = 'Compte bancaire';
        }
        field(20; "Payment in Progress"; Boolean)
        {
            CaptionML = ENU = 'Payment in Progress', FRA = 'Paiement en cours';
        }
        field(21; "Archiving Authorized"; Boolean)
        {
            CaptionML = ENU = 'Archiving Authorized', FRA = 'Archivage autorisé';
        }
    }

    keys
    {
        key(Key1; "Payment Class", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        PaymentStep: Record "WDC-ED Payment Step";
        PaymentHeader: Record "WDC-ED Payment Header";
        PaymentLine: Record "WDC-ED Payment Line";
    begin
        if "Line No." = 0 then
            Error(Text000);
        PaymentStep.SetRange("Payment Class", "Payment Class");
        PaymentStep.SetRange("Previous Status", "Line No.");
        if PaymentStep.FindFirst then
            Error(Text001);
        PaymentStep.SetRange("Previous Status");
        PaymentStep.SetRange("Next Status", "Line No.");
        if PaymentStep.FindFirst then
            Error(Text001);
        PaymentHeader.SetRange("Payment Class", "Payment Class");
        PaymentHeader.SetRange("Status No.", "Line No.");
        if PaymentHeader.FindFirst then
            Error(Text001);
        PaymentLine.SetRange("Payment Class", "Payment Class");
        PaymentLine.SetRange("Status No.", "Line No.");
        if PaymentLine.FindFirst then
            Error(Text001);
    end;

    trigger OnInsert()
    var
        PaymentStatus: Record "WDC-ED Payment Status";
    begin
        if not PaymentStatus.Get("Payment Class", 0) then
            "Line No." := 0;
    end;

    var
        Text000: TextConst ENU = 'Deleting the first report is not allowed.',
                           FRA = 'Vous n''avez pas le droit de supprimer le premier état.';
        Text001: TextConst ENU = 'Deleting is not allowed because this Payment Status is already used.',
                           FRA = 'La suppression est impossible car ce statut règlement est déjà utilisé.';
}

