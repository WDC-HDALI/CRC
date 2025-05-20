table 50869 "WDC-ED Bank Account Buffer"
{
    CaptionML = ENU = 'Bank Account Buffer', FRA = 'Tampon compte bancaire';

    fields
    {
        field(1; "Customer No."; Code[20])
        {
            CaptionML = ENU = 'Customer No.', FRA = 'N° client';
        }
        field(2; "Bank Branch No."; Text[20])
        {
            CaptionML = ENU = 'Bank Branch No.', FRA = 'Code établissement';
        }
        field(3; "Agency Code"; Text[20])
        {
            CaptionML = ENU = 'Agency Code', FRA = 'Code agence';
        }
        field(4; "Bank Account No."; Text[30])
        {
            CaptionML = ENU = 'Bank Account No.', FRA = 'N° compte bancaire';
        }
    }

    keys
    {
        key(Key1; "Customer No.", "Bank Branch No.", "Agency Code", "Bank Account No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}