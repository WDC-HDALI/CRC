//****************Documentation**********************
//wdc01  WDC.FS  18/06/2025 create WDC User Setup to add View Fields

tableextension 50030 "WDC User Setup" extends "User Setup"
{
    fields
    {
        field(50000; "Display Purchase Cost"; Boolean)
        {
            CaptionML = ENU = 'Display Purchase Cost in Purch. Doc', FRA = 'Afficher Coût achat dans Doc Achats';
            DataClassification = ToBeClassified;
        }
        field(50001; "Modify Sales Prices"; Boolean)
        {
            CaptionML = ENU = 'Modify Sales Prices', FRA = 'Modifier prix vente';
            DataClassification = ToBeClassified;
        }
        field(50002; "View Sales Margin"; Boolean)
        {
            CaptionML = ENU = 'View Sales Margin', FRA = 'Voir Marge Vente';
            DataClassification = ToBeClassified;
        }
        field(50003; "Allow Modify Customer"; Boolean)
        {
            CaptionML = ENU = 'Allow Modify Customer', FRA = 'Autoriser Modif Client';
            DataClassification = ToBeClassified;
        }
        field(50004; "Allow Modify Item"; Boolean)
        {
            CaptionML = ENU = 'Allow Modify Item', FRA = 'Autoriser Modif article';
            DataClassification = ToBeClassified;
        }
        field(50005; "Allow Modify Vendor"; Boolean)
        {
            CaptionML = ENU = 'Allow Modify Vendor', FRA = 'Autoriser Modif fournisseur';
            DataClassification = ToBeClassified;
        }

        field(50006; "Use REGLEMENT Pay. Journ."; Boolean)
        {
            CaptionML = ENU = 'Use REGLEMENT Pay. Journ.', FRA = 'Utiliser Reglement Feui. paiement';
            DataClassification = ToBeClassified;
        }
        field(50007; "Allow Delete sales cr memo"; Boolean)
        {
            CaptionML = ENU = 'Allow Delete Sales Cr. Memo', FRA = 'Autoriser Suppression Avoir';
            DataClassification = ToBeClassified;
        }
        field(50008; "Allow Rename Item"; Boolean)
        {
            CaptionML = ENU = 'Allow Rename Item', FRA = 'Autoriser Renommer article';
            DataClassification = ToBeClassified;
        }
        field(50009; "Allow Delete sales Invoice"; Boolean)
        {
            CaptionML = ENU = 'Allow Delete sales Invoice', FRA = 'Autoriser Suppression facture enreg.';
            DataClassification = ToBeClassified;
        }
        field(50010; "Allow Upd Sales Posting Date"; Boolean)
        {
            CaptionML = ENU = 'Allow Upd Sales Posting Date', FRA = 'Autoriser modif date compta. Vente';
            DataClassification = ToBeClassified;
        }
    }
}