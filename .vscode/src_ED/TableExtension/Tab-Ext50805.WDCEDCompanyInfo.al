tableextension 50805 "WDC-ED CompanyInfo" extends "Company Information"
{
    fields
    {
        field(50801; "Trade Register"; Text[30])
        {
            captionML = ENU = 'Trade Register', FRA = 'Registre du commerce';
        }
        field(50802; "APE Code"; Code[10])
        {
            captionML = ENU = 'APE Code', FRA = 'Code APE';
        }
        field(50803; "Legal Form"; Text[30])
        {
            captionML = ENU = 'Legal Form', FRA = 'Forme juridique';
        }
        field(50804; "Stock Capital"; Text[30])
        {
            captionML = ENU = 'Stock Capital', FRA = 'Capital social';
        }
        field(50810; "Default Bank Account No."; Code[20])
        {
            captionML = ENU = 'Default Bank Account No.', FRA = 'N° compte banc. par déf.';
            TableRelation = "Bank Account";
        }
        field(50811; CISD; Code[10])
        {
            captionML = ENU = 'CISD', FRA = 'CISD';
        }
        field(50812; "Last Intrastat Declaration ID"; Integer)
        {
            captionML = ENU = 'Last Intrastat Declaration ID', FRA = 'ID dernière D.E.B.';
        }
    }
    procedure GetPartyID(): Code[18]
    begin
        exit("Country/Region Code" + GetControlSum + "Registration No.");
    end;

    local procedure GetControlSum(): Text[2]
    var
        ControlSum: Integer;
    begin
        ControlSum := (12 + 3 * (GetSIREN mod 97)) mod 97;
        exit(Format(ControlSum, 0, '<Integer,2><Filler,0>'));
    end;

    procedure GetSIREN() Result: Integer
    begin
        Evaluate(Result, CopyStr(DelChr("Registration No."), 1, 9));
    end;
}