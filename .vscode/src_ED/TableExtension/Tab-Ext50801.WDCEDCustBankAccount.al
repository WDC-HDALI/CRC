tableextension 50801 "WDC-ED Cust. Bank Account" extends "Customer Bank Account"
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
    }
    var
        RIBKey: Codeunit "WDC-ED RIB Key";
}