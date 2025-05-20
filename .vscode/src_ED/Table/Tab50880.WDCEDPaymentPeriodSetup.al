table 50880 "WDC-ED Payment Period Setup"
{
    CaptionML = ENU = 'Payment Period Setup', FRA = 'Configuration de la période de paiement';

    fields
    {
        field(1; ID; Integer)
        {
            AutoIncrement = true;
            CaptionML = ENU = 'ID', FRA = 'ID';
            Editable = false;
        }
        field(2; "Days From"; Integer)
        {
            CaptionML = ENU = 'Days From', FRA = 'A partir du jour';
            NotBlank = true;

            trigger OnValidate()
            begin
                CheckDatePeriodConsistency;
            end;
        }
        field(3; "Days To"; Integer)
        {
            CaptionML = ENU = 'Days To', FRA = 'Jours à';
            MinValue = 0;

            trigger OnValidate()
            begin
                CheckDatePeriodConsistency;
            end;
        }
    }

    keys
    {
        key(Key1; ID)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    local procedure CheckDatePeriodConsistency()
    begin
        if ("Days From" <> 0) and ("Days To" <> 0) and ("Days From" > "Days To") then
            Error(DaysFromLessThanDaysToErr);
    end;

    var
        DaysFromLessThanDaysToErr: TextConst ENU = 'Days From must not be less than Days To.',
                                             FRA = 'Le champ "A partir du jour" ne doit pas être inférieur au champ "Jours à"';
}

