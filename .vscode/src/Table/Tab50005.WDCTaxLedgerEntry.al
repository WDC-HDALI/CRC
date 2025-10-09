//**************Documentation****************
//WDC01  WDC.HG 25/09/2025 Add Fields "Customer No." and "Customer Name"
table 50005 "WDC Tax Ledger Entry"
{
    CaptionML = ENU = 'Tax Ledger Entry', FRA = 'Ecritures TVA';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = SystemMetadata;
            AutoIncrement = true;
        }
        field(2; "Type Taxe"; Option)
        {
            OptionMembers = Vente,Achat;
            DataClassification = ToBeClassified;
        }
        field(3; "Type Document"; Option)
        {
            OptionMembers = "Facture Vente","Avoir Vente","Facture Achat","Avoir Achat";
            DataClassification = ToBeClassified;
        }
        field(4; "Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }

        field(5; "External Document No."; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Posting Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Type Mouvement"; Option)
        {
            OptionMembers = "","Compte","Article","Immobilisation","Frais Annexe";
        }
        field(8; "Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(9; "No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Description"; Code[80])
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Quantité"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Prix unitaire"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(13; "Montant HT"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(14; "TVA %"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(15; "Montant TVA"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(16; "Montant TTC"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(17; "Posting group"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(18; "TVA group"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(19; "Catégorie article"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(20; "DateFilter"; Date)
        {
            FieldClass = FlowFilter;
        }
        //<<WDC01
        field(21; "orderer No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(22; "Orderer Name"; text[100])
        {
            DataClassification = ToBeClassified;
        }
        //>>WDC01
    }


    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }
}
