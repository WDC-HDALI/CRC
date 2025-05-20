report 50821 "WDC-ED Export DEB DTI"
{
    captionML = ENU = 'Export DEB DTI', FRA = 'Exporter DEB DTI';
    ProcessingOnly = true;

    dataset
    {
        // dataitem("Intrastat Jnl. Batch"; "Intrastat Jnl. Batch")
        // {
        //     DataItemTableView = SORTING("Journal Template Name", Name);

        //     trigger OnAfterGetRecord()
        //     begin
        //         ExportToXML("Intrastat Jnl. Batch");
        //     end;
        // }
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
                    field(FileName; FileName)
                    {
                        ApplicationArea = All;
                        captionML = ENU = 'File Name', FRA = 'Nom du fichier';

                        trigger OnAssistEdit()
                        var
                            FileMgt: Codeunit "File Management";
                        begin
                            if FileName = '' then
                                FileName := '.xml';
                            //FileName := FileMgt.SaveFileDialog(Text002, FileName, '');
                        end;
                    }
                    field("Obligation Level"; ObligationLevel)
                    {
                        ApplicationArea = All;
                        captionML = ENU = 'Obligation Level', FRA = 'Niveau d''obligation';
                        OptioncaptionML = ENU = ',1,2,3,4';
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

    trigger OnInitReport()
    begin
        ObligationLevel := 1;
    end;

    trigger OnPreReport()
    begin
        if FileName = '' then
            Error(Text004);
    end;

    procedure InitializeRequest(NewFileName: Text)
    begin
        FileName := NewFileName;
    end;

    // local procedure ExportToXML(IntrastatJnlBatch: Record "Intrastat Jnl. Batch")
    // var
    //     IntrastatJnlLine: Record "Intrastat Jnl. Line";
    //     ExportDEBDTI: Codeunit "WDC-ED Export DEB DTI";
    // begin
    //     IntrastatJnlLine.SetCurrentKey(Type, "Country/Region Code", "Tariff No.", "Transaction Type", "Transport Method");
    //     IntrastatJnlLine.SetRange("Journal Template Name", IntrastatJnlBatch."Journal Template Name");
    //     IntrastatJnlLine.SetRange("Journal Batch Name", IntrastatJnlBatch.Name);
    //     if ExportDEBDTI.ExportToXML(IntrastatJnlLine, ObligationLevel, FileName) then
    //         Message(Text001);
    // end;
    var
        FileName: Text;
        Text001: TextConst ENU = 'The journal lines were successfully exported.',
                           FRA = 'Les lignes de la feuille ont été validées avec succès.';
        ObligationLevel: Option ,"1","2","3","4";
        Text002: TextConst ENU = 'Export DEB DTI+ to XML.',
                           FRA = 'Exporter DEB DTI+ vers XML.';
        Text004: TextConst ENU = 'A destination file must be specified.',
                           FRA = 'Un fichier de destination doit être spécifié.';
}

