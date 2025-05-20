report 50873 "WDC-ED Archive Payment Slips"
{
    ApplicationArea = All;
    captionML = ENU = 'Archive Payment Slips', FRA = 'Archiver les bordereaux de paiement';
    ProcessingOnly = true;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Payment Header"; "WDC-ED Payment Header")
        {
            CalcFields = "Archiving Authorized";
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.", "Payment Class";

            trigger OnAfterGetRecord()
            begin
                if "Archiving Authorized" then begin
                    PaymentManagement.ArchiveDocument("Payment Header");
                    ArchivedDocs += 1;
                end;
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPostReport()
    begin
        if ArchivedDocs = 0 then
            Message(Text002)
        else
            if ArchivedDocs = 1 then
                Message(Text003)
            else
                Message(Text001, ArchivedDocs);
    end;

    trigger OnPreReport()
    begin
        ArchivedDocs := 0;
    end;

    var
        PaymentManagement: Codeunit "WDC-ED Payment Management";
        ArchivedDocs: Integer;
        Text001: TextConst ENU = '%1 Payment Headers have been archived.',
                           FRA = '%1 bordereaux ont été archivés.';
        Text002: TextConst ENU = 'There is no Payment Header to archive.',
                           FRA = 'Il n''y a pas de bordereau à archiver.';
        Text003: TextConst ENU = 'One Payment Header has been archived.',
                           FRA = 'Un bordereau a été archivé.';
}

