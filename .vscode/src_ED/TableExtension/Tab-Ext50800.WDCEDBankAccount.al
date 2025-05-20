tableextension 50800 "WDC-ED Bank Account" extends "Bank Account"
{
    fields
    {
        field(50851; "Agency Code"; Text[5])
        {
            captionML = ENU = 'Agency Code', FRA = 'Code agence';
            InitValue = '00000';

            trigger OnValidate()
            begin
                if StrLen("Agency Code") < 5 then
                    "Agency Code" := PadStr('', 5 - StrLen("Agency Code"), '0') + "Agency Code";
                "RIB Checked" := RIBKey.Check("Bank Branch No.", "Agency Code", "Bank Account No.", "RIB Key");
            end;
        }
        field(50852; "RIB Key"; Integer)
        {
            captionML = ENU = 'RIB Key', FRA = 'Clé RIB';

            trigger OnValidate()
            begin
                "RIB Checked" := RIBKey.Check("Bank Branch No.", "Agency Code", "Bank Account No.", "RIB Key");
            end;
        }
        field(50853; "RIB Checked"; Boolean)
        {
            captionML = ENU = 'RIB Checked', FRA = 'Vérification RIB';
            Editable = false;
        }
        field(50854; "National Issuer No."; Code[6])
        {
            captionML = ENU = 'National Issuer No.', FRA = 'N° émetteur national';
            Numeric = true;

            trigger OnValidate()
            begin
                if (StrLen("National Issuer No.") > 0) and (StrLen("National Issuer No.") < 6) then
                    Error(Text10800);
            end;
        }
    }
    var
        Text10800: TextConst ENU = 'You must enter 6 positions in this field.',
                             FRA = 'Vous devez entrer 6 positions dans ce champ.';
        RIBKey: Codeunit "WDC-ED RIB Key";

}