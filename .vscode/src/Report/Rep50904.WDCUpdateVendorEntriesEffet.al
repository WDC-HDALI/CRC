report 50904 "WDC Upd Vendor Entries Effet"
{
    Caption = 'Mise à jour des effets sur Vendor Ledger Entries';
    ProcessingOnly = true;
    UsageCategory = Tasks;
    ApplicationArea = All;

    dataset
    {
        dataitem("Vendor Ledger Entry"; "Vendor Ledger Entry")
        {
            trigger OnPreDataItem()
            var
                DocumentNo: Code[20];
            begin
                DocumentNo := 'CLOT-300625';
                SetRange("Document No.", DocumentNo);
            end;

            trigger OnAfterGetRecord()
            var
                DescText: Text;
                EffetPos: Integer;
                NPos: Integer;
                EffetDateText: Text[10];
                EffetDate: Date;
                RefNumber: Text[20];
                AfterNText: Text;
                SpacePos: Integer;
                i: Integer; // Variable pour la boucle
            begin
                DescText := "Vendor Ledger Entry"."Description";
                EffetPos := StrPos(UpperCase(DescText), 'EFFET');
                if EffetPos > 0 then begin
                    NPos := StrPos(DescText, 'N ');
                    if NPos > 0 then begin

                        AfterNText := COPYSTR(DescText, NPos + 2);

                        SpacePos := StrPos(AfterNText, ' ');
                        if SpacePos > 0 then
                            RefNumber := COPYSTR(AfterNText, 1, SpacePos - 1)
                        else
                            RefNumber := AfterNText;


                        RefNumber := '';
                        for i := 1 to StrLen(AfterNText) do begin
                            if (COPYSTR(AfterNText, i, 1) in ['0' .. '9']) then
                                RefNumber := RefNumber + COPYSTR(AfterNText, i, 1);
                        end;
                    end else
                        RefNumber := '';

                    EffetPos := StrPos(UpperCase(DescText), 'DU ');
                    if EffetPos > 0 then begin
                        EffetDateText := COPYSTR(DescText, EffetPos + 3, 10);
                        Evaluate(EffetDate, EffetDateText);
                    end else
                        EffetDate := 0D;
                    "Payment Slip Type" := "Payment Slip Type"::Draft;
                    "Payment Method Code" := 'Traite';
                    "Payment Reference" := RefNumber;
                    if EffetDate <> 0D then
                        "Due Date" := EffetDate;
                    Modify(true);
                end;
            end;

            trigger OnPostDataItem()
            begin
                Message('Mise à jour des effets sur les Vendor Ledger Entries terminée.');
            end;
        }
    }
}
