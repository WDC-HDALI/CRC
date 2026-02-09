table 50006 "Payment Tracking Buffer"
{
    CaptionML = ENU = 'Payment Tracking Buffer', FRA = 'Tampon suivi paiement';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            CaptionML = ENU = 'Entry No.', FRA = 'N° séquence';
            DataClassification = SystemMetadata;
            AutoIncrement = true;
            Editable = false;
        }
        field(2; "Document No."; Code[20])
        {
            CaptionML = ENU = 'Document No.', FRA = 'N° document';
            DataClassification = CustomerContent;
        }
        field(3; "Customer No."; Code[20])
        {
            CaptionML = ENU = 'Customer No.', FRA = 'N° client';
            DataClassification = CustomerContent;
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
        field(4; "Customer Name"; Text[100])
        {
            CaptionML = ENU = 'Customer Name', FRA = 'Nom client';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(5; "Salesperson Code"; Code[20])
        {
            CaptionML = ENU = 'Salesperson Code', FRA = 'Code vendeur';
            DataClassification = CustomerContent;
            TableRelation = "Salesperson/Purchaser";
        }
        field(6; "Posting Date"; Date)
        {
            CaptionML = ENU = 'Posting Date', FRA = 'Date comptabilisation';
            DataClassification = CustomerContent;
        }
        field(7; "Item No."; Code[20])
        {
            CaptionML = ENU = 'Item No.', FRA = 'N° article';
            DataClassification = CustomerContent;
            //TableRelation = Item;

            trigger OnValidate()
            var
                Item: Record Item;
            begin
                if "Item No." <> '' then begin
                    if Item.Get("Item No.") then begin
                        "Item Description" := Item.Description;
                        "Item Category Code" := Item."Item Category Code";
                        "Unit Cost" := Item."Unit Cost";
                        "Item Type" := Format(Item.Type);
                        "Sub Category" := Item.SubCategorie;
                    end;
                end else begin
                    "Item Description" := '';
                    "Item Category Code" := '';
                    "Unit Cost" := 0;
                    "Item Type" := '';
                    "Sub Category" := '';
                end;
            end;
        }
        field(8; "Item Description"; Text[100])
        {
            CaptionML = ENU = 'Item Description', FRA = 'Désignation article';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(9; "Item Category Code"; Code[20])
        {
            CaptionML = ENU = 'Item Category Code', FRA = 'Code catégorie article';
            DataClassification = CustomerContent;
            TableRelation = "Item Category";
        }
        field(10; Quantity; Decimal)
        {
            CaptionML = ENU = 'Quantity', FRA = 'Quantité';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
        }
        field(11; "Amount Excl. VAT"; Decimal)
        {
            CaptionML = ENU = 'Amount Excl. VAT', FRA = 'Montant HT';
            DataClassification = CustomerContent;
            AutoFormatType = 1;
        }
        field(12; "Amount Incl. VAT"; Decimal)
        {
            CaptionML = ENU = 'Amount Incl. VAT', FRA = 'Montant TTC';
            DataClassification = CustomerContent;
            AutoFormatType = 1;
        }
        field(13; "Payment Document No."; Code[20])
        {
            CaptionML = ENU = 'Payment Document No.', FRA = 'N° document paiement';
            DataClassification = CustomerContent;
        }
        field(14; "Payment Amount"; Decimal)
        {
            CaptionML = ENU = 'Payment Amount', FRA = 'Montant paiement';
            DataClassification = CustomerContent;
            AutoFormatType = 1;
        }
        field(15; "Payment Type"; Code[30])
        {
            CaptionML = ENU = 'Payment Type', FRA = 'Type paiement';
            DataClassification = CustomerContent;
        }
        field(16; "Payment Date"; Date)
        {
            CaptionML = ENU = 'Payment Date', FRA = 'Date paiement';
            DataClassification = CustomerContent;
        }
        field(17; "Due Date"; Date)
        {
            CaptionML = ENU = 'Due Date', FRA = 'Date échéance';
            DataClassification = CustomerContent;
        }
        field(18; "Unit Cost"; Decimal)
        {
            CaptionML = ENU = 'Unit Cost', FRA = 'Coût unitaire';
            DataClassification = CustomerContent;
            AutoFormatType = 2;
        }
        field(19; "Customer Amount"; Decimal)
        {
            CaptionML = ENU = 'Customer Amount', FRA = 'Montant client';
            DataClassification = CustomerContent;
            AutoFormatType = 1;
        }
        field(20; "Item Type"; Code[15])
        {
            CaptionML = ENU = 'Item Type', FRA = 'Type article';
            DataClassification = CustomerContent;
        }
        field(21; "Document Type"; Code[15])
        {
            CaptionML = ENU = 'Document Type', FRA = 'Type document';
            DataClassification = CustomerContent;
        }
        field(22; "Sub Category"; Code[20])
        {
            CaptionML = ENU = 'Sub Category', FRA = 'Sous-catégorie';
            DataClassification = CustomerContent;
            TableRelation = "WDC SubCategory Item".Code;
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Posting Date", "Item Category Code", "Sub Category", "Item No.")
        {
        }
        key(Key3; "Customer No.", "Posting Date")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Entry No.", "Document No.", "Customer No.", "Customer Name")
        {
        }
        fieldgroup(Brick; "Entry No.", "Document No.", "Customer Name", "Amount Incl. VAT")
        {
        }
    }
}