table 50007 "WDC Payment In Coffre"
{
    CaptionML = ENU = 'Payment in Coffre', FRA = 'Payment en coffre';
    DrillDownPageId = "WDC Payment in Coffre";
    LookupPageId = "WDC Payment in Coffre";
    fields
    {
        field(1; "Entry No."; Integer)
        {
            CaptionML = ENU = 'Entry No.', FRA = 'N° séquence';
            AutoIncrement = true;
            Editable = false;
        }

        field(2; "Customer No."; Code[20])
        {
            CaptionML = ENU = 'Customer No.', FRA = 'N° client';

            TableRelation = Customer;

            trigger OnValidate()
            var
                Customer: Record Customer;
            begin
                if "Customer No." <> '' then begin
                    if Customer.Get("Customer No.") then
                        "Customer Name" := Customer.Name;
                end else
                    "Customer Name" := '';
            end;
        }
        field(3; "Customer Name"; Text[100])
        {
            CaptionML = ENU = 'Customer Name', FRA = 'Nom client';

            Editable = false;
        }
        field(4; "Salesperson Code"; Code[20])
        {
            CaptionML = ENU = 'Salesperson Code', FRA = 'Code vendeur';

            TableRelation = "Salesperson/Purchaser";
        }
        field(5; "Document Date"; Date)
        {
            CaptionML = ENU = 'Document Date', FRA = 'Date document';
            //Editable = false;
        }
        field(6; "Due Date"; Date)
        {
            CaptionML = ENU = 'Due Date', FRA = 'Date échéance';
        }
        field(7; "Payment Type"; Enum "WDC-ST Payment Slip Type")
        {
            CaptionML = ENU = 'Payment Type', FRA = 'Type paiement';
        }
        field(8; "Payment Reference"; Code[30])
        {
            CaptionML = ENU = 'Payment Reference', FRA = 'Référence paiement';
        }
        field(9; "Bank Name"; Code[30])
        {
            CaptionML = ENU = 'Bank Name', FRA = 'Nom banque';
        }
        field(10; "Payment Amount"; Decimal)
        {
            CaptionML = ENU = 'Payment Amount', FRA = 'Montant paiement';
            AutoFormatType = 1;
        }
        field(11; Status; Enum "WDC Payment in coffre Status")
        {
            CaptionML = ENU = 'Status', FRA = 'Statut';
            Editable = false;
        }
        field(12; "Payment Date"; Date)
        {
            CaptionML = ENU = 'Payment Date', FRA = 'Date paiement';
            Editable = false;
        }


    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Document Date", "Payment Type")
        {

        }
        key(Key3; "Customer No.", "Document Date")
        {

        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Document Date", "Payment Type", "Customer No.", "Customer Name")
        {

        }

    }
    trigger OnInsert()
    begin
        "Document Date" := WorkDate();
    end;

    trigger OnDelete()
    var
        lText001: TextConst ENU = 'You can delete only the payment with status open.',
                            FRA = 'Vous pouvez supprimer uniquement les paiements avec le statut ouvert.';
    begin
        if rec.Status = rec.Status::Released then
            Error(lText001);
    end;
}