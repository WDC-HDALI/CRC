tableextension 50806 "WDC-ED Accounting Period" extends "Accounting Period"
{
    fields
    {
        field(50800; "Fiscally Closed"; Boolean)
        {
            captionML = ENU = 'Fiscally Closed', FRA = 'Clôturé fiscalement';
            Editable = false;
        }
        field(50801; "Fiscal Closing Date"; Date)
        {
            captionML = ENU = 'Fiscal Closing Date', FRA = 'Date de clôture fiscale';
            Editable = false;
        }
        field(50802; "Period Reopened Date"; Date)
        {
            captionML = ENU = 'Period Reopened Date', FRA = 'Date réouverture période';
            Editable = false;
        }

    }
    procedure UpdateGLSetup(PeriodEndDate: Date)
    begin
        Get;
        GLSetup.CalcFields("Posting Allowed From");
        if GLSetup."Allow Posting From" <= PeriodEndDate then begin
            GLSetup."Allow Posting From" := GLSetup."Posting Allowed From";
            Modify;
        end;
        if (GLSetup."Allow Posting To" <= PeriodEndDate) and (GLSetup."Allow Posting To" <> 0D) then begin
            GLSetup."Allow Posting To" := CalcDate('<+1M-1D>', GLSetup."Posting Allowed From");
            Modify;
        end;
    end;

    procedure UpdateUserSetup(PeriodEndDate: Date)
    begin
        if FindFirst then
            repeat
                if UserSetup."Allow Posting From" <= PeriodEndDate then begin
                    UserSetup."Allow Posting From" := GLSetup."Posting Allowed From";
                    Modify;
                end;
                if (UserSetup."Allow Posting To" <= PeriodEndDate) and (UserSetup."Allow Posting To" <> 0D) then begin
                    UserSetup."Allow Posting To" := CalcDate('<+1M-1D>', GLSetup."Posting Allowed From");
                    Modify;
                end;
            until Next = 0;
    end;

    var
        UserSetup: Record "User Setup";
        GLSetup: Record "General Ledger Setup";

}