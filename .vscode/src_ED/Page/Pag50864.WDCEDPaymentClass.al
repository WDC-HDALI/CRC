page 50864 "WDC-ED Payment Class"
{
    ApplicationArea = all;
    CaptionML = ENU = 'Payment Class', FRA = 'Paramètres bordereau paiement';
    DelayedInsert = true;
    PageType = List;
    SourceTable = "WDC-ED Payment Class";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field(Enable; Rec.Enable)
                {
                    ApplicationArea = All;
                }
                field("Code"; Rec.Code)
                {
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                }
                field("Header No. Series"; Rec."Header No. Series")
                {
                    ApplicationArea = All;
                }
                field("Line No. Series"; Rec."Line No. Series")
                {
                    ApplicationArea = All;
                }
                field(Suggestions; Rec.Suggestions)
                {
                    ApplicationArea = All;
                }
                field("Unrealized VAT Reversal"; Rec."Unrealized VAT Reversal")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("F&unctions")
            {
                CaptionML = ENU = 'F&unctions', FRA = 'Fonction&s';
                Image = "Action";
                action(DuplicateParameter)
                {
                    ApplicationArea = All;
                    CaptionML = ENU = 'Duplicate Parameter', FRA = 'Dupliquer le paramétrage';
                    Image = CopySerialNo;

                    trigger OnAction()
                    var
                        PaymentClass: Record "WDC-ED Payment Class";
                        DuplicateParameter: Report "WDC-ED Duplicate parameter";
                    begin
                        if Rec.Code <> '' then begin
                            PaymentClass.SetRange(Code, Rec.Code);
                            DuplicateParameter.SetTableView(PaymentClass);
                            DuplicateParameter.InitParameter(Rec.Code);
                            DuplicateParameter.RunModal;
                        end;
                    end;
                }
                action("Import Parameters")
                {
                    ApplicationArea = All;
                    CaptionML = ENU = 'Import Parameters', FRA = 'Importer paramètres';
                    Image = Import;

                    trigger OnAction()
                    var
                        Instream: InStream;
                        FromFile: Text;
                    begin

                        if UploadIntoStream('Sélectionner le fichier à importer', '', '', FromFile, Instream) then
                            XMLPORT.Import(XMLPORT::"WDC-ED Import/Exp Parameters", Instream);
                    end;
                }
                action("Export Parameters")
                {
                    ApplicationArea = All;
                    CaptionML = ENU = 'Export Parameters', FRA = 'Exporter paramètres';
                    Image = Export;

                    trigger OnAction()
                    var
                        TempBlob: Codeunit "Temp Blob";
                        Fileoutstream: OutStream;
                        InStr: InStream;
                        ToFile: Text[1024];
                    begin
                        ToFile := Text003;
                        TempBlob.CreateOutStream(Fileoutstream);
                        XMLPORT.Export(XMLPORT::"WDC-ED Import/Exp Parameters", Fileoutstream);
                        TempBlob.CreateInStream(InStr);
                        TempBlob.CreateOutStream(Fileoutstream, TextEncoding::UTF16);
                        DownloadFromStream(InStr, '', '', '', ToFile);
                    end;
                }
            }
            action(Status)
            {
                ApplicationArea = All;
                CaptionML = ENU = 'St&atus', FRA = 'Sta&tut';
                Image = "Report";
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "WDC-ED Payment Status";
                RunPageLink = "Payment Class" = FIELD(Code);
            }
            action(Steps)
            {
                ApplicationArea = All;
                CaptionML = ENU = 'Ste&ps', FRA = 'Eta&pes';
                Image = MoveToNextPeriod;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "WDC-ED Payment Steps";
                RunPageLink = "Payment Class" = FIELD(Code);
            }
        }
    }

    var
        Text002: TextConst ENU = '''txt''',
                           FRA = '''txt''';
        Text003: TextConst ENU = 'Import_Export Parameters.txt',
                           FRA = 'Import_Export parametres.txt';
}

