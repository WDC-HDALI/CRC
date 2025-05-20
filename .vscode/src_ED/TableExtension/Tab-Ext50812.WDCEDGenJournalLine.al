tableextension 50812 "WDC-ED Gen. Journal Line" extends "Gen. Journal Line"
{
    fields
    {
        field(50801; "Bank Account Name"; Text[100])
        {
            captionML = ENU = 'Bank Account Name', FRA = 'Nom compte bancaire';
        }
        field(50810; "Entry Type"; Option)
        {
            captionML = ENU = 'Entry Type', FRA = 'Type écriture';
            ObsoleteReason = 'Discontinued feature';
            ObsoleteState = Removed;
            OptionCaptionML = ENU = 'Definitive,Simulation', FRA = 'Définitive,Simulation';
            OptionMembers = Definitive,Simulation;
            ObsoleteTag = '15.0';
        }
        field(50860; "Entry No."; Integer)
        {
            captionML = ENU = 'Entry No.', FRA = 'N° séquence';
            Editable = false;
        }
        field(50861; "Derogatory Line"; Boolean)
        {
            captionML = ENU = 'Derogatory Line', FRA = 'Ligne dérogatoire';
            Editable = false;
        }
        field(50862; "Delayed Unrealized VAT"; Boolean)
        {
            CaptionML = ENU = 'Delayed Unrealized VAT', FRA = 'TVA sur encaissement différée';
        }
        field(50863; "Realize VAT"; Boolean)
        {
            CaptionML = ENU = 'Realize VAT', FRA = 'Réaliser TVA';
        }
        field(50864; "Created from No."; Code[20])
        {
            CaptionML = ENU = 'Created from No.', FRA = 'Créé à partir du n°';
        }
    }

}