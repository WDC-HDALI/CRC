tableextension 50803 "WDC-ED GLEntry" extends "G/L Entry"
{
    fields
    {
        field(50810; "Entry Type"; Option)
        {
            captionML = ENU = 'Entry Type', FRA = 'Type écriture';
            ObsoleteReason = 'Discountinued feature';
            ObsoleteState = Removed;
            OptionCaptionML = ENU = 'Definitive,Simulation', FRA = 'Définitive,Simulation';
            OptionMembers = Definitive,Simulation;
            ObsoleteTag = '15.0';
        }
        field(50811; "Applies-to ID"; Code[50])
        {
            captionML = ENU = 'Applies-to ID', FRA = 'ID lettrage';
            Editable = false;
        }
        field(50812; Letter; Text[10])
        {
            captionML = ENU = 'Letter', FRA = 'Lettre';
            Editable = false;
        }
        field(50813; "Letter Date"; Date)
        {
            captionML = ENU = 'Letter Date', FRA = 'Date de la lettre';
            Editable = false;
        }
    }
    keys
    {
        key(Key14; "Source Code", "Posting Date")
        { }
        key(Key15; "G/L Account No.", "Source Type", "Source No.")
        { }
    }
}