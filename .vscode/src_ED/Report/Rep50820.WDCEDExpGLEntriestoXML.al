report 50820 "WDC-ED Exp G/L Entries to XML"
{
    ApplicationArea = All;
    captionML = ENU = 'Export G/L Entries to XML', FRA = 'Exporter écritures comptables vers un fichier XML';
    ProcessingOnly = true;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Integer"; "Integer")
        {
            DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));

            trigger OnAfterGetRecord()
            begin
                // OutputFile.TextMode(true);
                // OutputFile.WriteMode(true);
                // OutputFile.Create(FileName);
                // OutputFile.CreateOutStream(OutputStream);

                // ExportGLEntries.InitializeRequest(GLEntry, StartingDate, EndingDate);
                // ExportGLEntries.SetDestination(OutputStream);
                // ExportGLEntries.Export;

                // OutputFile.Close;
                // Clear(OutputStream);
            end;

            trigger OnPostDataItem()
            var
                FileMgt: Codeunit "File Management";
            begin
                // ToFile := Text010 + '.xml';
                // if not FileMgt.DownloadHandler(FileName, Text004, '', Text005, ToFile) then
                //     exit;
                Message(Text006);
            end;

            trigger OnPreDataItem()
            begin
                if StartingDate = 0D then
                    Error(Text001);
                if EndingDate = 0D then
                    Error(Text002);
                if FileName = '' then
                    Error(Text003);

                GLEntry.SetRange("Posting Date", StartingDate, EndingDate);
                if GLEntry.Count = 0 then
                    Error(Text007);
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    captionML = ENU = 'Options', FRA = 'Options';
                    field(StartingDate; StartingDate)
                    {
                        ApplicationArea = All;
                        captionML = ENU = 'Starting Date', FRA = 'Date début';
                    }
                    field(EndingDate; EndingDate)
                    {
                        ApplicationArea = All;
                        captionML = ENU = 'Ending Date', FRA = 'Date fin';
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    var
        FileMgt: Codeunit "File Management";
    begin
        //FileName := FileMgt.ServerTempFileName('xml');
    end;

    var
        Text010: TextConst ENU = 'Default',
                           FRA = 'Par défaut';
        Text001: TextConst ENU = 'You must enter a Starting Date.',
                           FRA = 'Vous devez entrer une date de début.';
        Text002: TextConst ENU = 'You must enter an Ending Date.',
                           FRA = 'Vous devez entrer une date de fin.';
        Text003: TextConst ENU = 'You must enter a File Name.',
                           FRA = 'Vous devez entrer un nom de fichier.';
        Text004: TextConst ENU = 'Export to XML File',
                           FRA = 'Exporter en fichier XML';
        Text005: TextConst ENU = 'XML Files (*.xml)|*.xml|All Files (*.*)|*.*',
                           FRA = 'Fichiers XML (*.xml)|*.xml|Tous les fichiers (*.*)|*.*';
        Text006: TextConst ENU = 'XML File created successfully.',
                           FRA = 'Fichier XML correctement créé.';
        Text007: TextConst ENU = 'There are no entries to export within the defined filter. The file was not created.',
                           FRA = 'Il n''y a pas d''écriture à exporter dans le filtre défini. Le fichier n''a pas été créé.';
        GLEntry: Record "G/L Entry";
        ExportGLEntries: XMLport "WDC-ED Export G/L Entries";
        OutputStream: OutStream;
        StartingDate: Date;
        EndingDate: Date;
        FileName: Text[1024];
        ToFile: Text[1024];
        OutputFile: File;

}

