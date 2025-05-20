tableextension 54025 "WDC-ST Acc. Schedule Line" extends "Acc. Schedule Line"
{
    fields
    {
        field(54000; "Debitor Totalization"; Text[250])
        {
            CaptionML = ENU = 'Debitor totalization', FRA = 'Totalisation débiteur';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                CASE "Totaling Type" OF
                    "Totaling Type"::"Posting Accounts", "Totaling Type"::"Total Accounts":
                        CpteGL.CALCFIELDS(Balance);
                    "Totaling Type"::Formula:
                        LigTabAna.SETFILTER(LigTabAna."Row No.", LigTabAna.Totaling);
                END;
            End;
        }
        field(54001; "Creditor Totalization"; Text[250])
        {
            CaptionML = ENU = 'Creditor Totalization', FRA = 'Totalisation créditeur';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                CASE "Totaling Type" OF
                    "Totaling Type"::"Posting Accounts", "Totaling Type"::"Total Accounts":
                        CpteGL.CALCFIELDS(Balance);
                    "Totaling Type"::Formula:
                        LigTabAna.SETFILTER(LigTabAna."Row No.", LigTabAna.Totaling);
                END;
            End;
        }
        field(54002; Note; Code[20])
        {
            CaptionML = ENU = 'Note', FRA = 'Note';
            DataClassification = ToBeClassified;

        }

    }
    var

        CpteGL: Record 15;

        LigTabAna: Record 85;
}


