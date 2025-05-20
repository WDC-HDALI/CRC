tableextension 50219 "WDC-TF User Setup" extends "User Setup"
{
    fields
    {
        field(50200; "Allow Item Charge Assignement"; Boolean)
        {
            CaptionML = ENU = 'Allow Item Charge Assignement', FRA = 'Autoriser affectation frais annexes';
            DataClassification = ToBeClassified;
        }
        field(50201; "Allow Open Transit Folder"; Boolean)
        {
            CaptionML = ENU = 'Allow Open Transit Folder', FRA = 'Autorisation ouverture dossier import';
            DataClassification = ToBeClassified;
        }
    }
}
