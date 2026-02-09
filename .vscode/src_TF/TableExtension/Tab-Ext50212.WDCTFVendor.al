tableextension 50212 "WDC-TF Vendor" extends Vendor
{
    fields
    {
        // field(50200; Status; Option)
        // {
        //     CaptionML = ENU = 'Status', FRA = 'Statut';
        //     DataClassification = ToBeClassified;
        //     OptionMembers = Waiting,Validated;
        //     OptionCaptionML = ENU = 'Waiting,Validated', FRA = 'En attente,Validé';
        //     trigger OnValidate()
        //     var
        //         UserSetup: Record "User Setup";
        //     BEGIN

        //     END;

        // }
        field(50201; "Trade Register"; Code[20])
        {
            CaptionML = ENU = 'Trade Register', FRA = 'Regsitre de Commerce';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            BEGIN
                IF "Trade Register" = '' THEN EXIT;
                Vendor.RESET;
                Vendor.SETRANGE("Trade Register", "Trade Register");
                Vendor.SETFILTER("No.", '<>%1', "No.");
                IF Vendor.FINDSET THEN
                    ERROR(Text013);
            END;

        }
        field(50202; "Type"; Enum "WDC-TF Vendor Type")
        {
            CaptionML = ENU = 'Type', FRA = 'Type';
            DataClassification = ToBeClassified;
        }
        field(50203; Activity; Text[50])
        {
            CaptionML = ENU = 'Activity', FRA = 'Activité';
            DataClassification = ToBeClassified;
        }
        field(50204; "Foreign Vendor"; Boolean)
        {
            CaptionML = ENU = 'Foreign Vendor', FRA = 'Fournisseur Etranger';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var

            BEGIN
                IF "Foreign Vendor" THEN
                    TESTFIELD("Currency Code")
                ELSE
                    TESTFIELD("Currency Code", '');
            END;

        }

    }
    var
        Text013: TextConst FRA = 'Le Registre de Commerce existe déja';
        Vendor: Record 23;

}
