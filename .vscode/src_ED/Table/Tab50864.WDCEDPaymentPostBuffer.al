table 50864 "WDC-ED Payment Post. Buffer"
{
    CaptionML = ENU = 'Payment Post. Buffer', FRA = 'Tampon validation paiement';

    fields
    {
        field(1; "Account Type"; enum "Gen. Journal Account Type")
        {
            CaptionML = ENU = 'Account Type', FRA = 'Type compte';
        }
        field(2; "Account No."; Code[20])
        {
            CaptionML = ENU = 'Account No.', FRA = 'N° compte';
            TableRelation = IF ("Account Type" = CONST("G/L Account")) "G/L Account"
            ELSE
            IF ("Account Type" = CONST(Customer)) Customer
            ELSE
            IF ("Account Type" = CONST(Vendor)) Vendor
            ELSE
            IF ("Account Type" = CONST("Bank Account")) "Bank Account"
            ELSE
            IF ("Account Type" = CONST("Fixed Asset")) "Fixed Asset";
        }
        field(4; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            CaptionML = ENU = 'Global Dimension 1 Code', FRA = 'Code axe principal 1';
        }
        field(5; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            CaptionML = ENU = 'Global Dimension 2 Code', FRA = 'Code axe principal 2';
        }
        field(6; "Job No."; Code[20])
        {
            CaptionML = ENU = 'Job No.', FRA = 'N° projet';
        }
        field(7; Amount; Decimal)
        {
            AutoFormatType = 1;
            CaptionML = ENU = 'Amount', FRA = 'Montant';

            trigger OnValidate()
            begin
                if Amount < 0 then
                    Sign := Sign::Negative
                else
                    Sign := Sign::Positive;
            end;
        }
        field(8; "VAT Amount"; Decimal)
        {
            AutoFormatType = 1;
            CaptionML = ENU = 'VAT Amount', FRA = 'Montant TVA';
        }
        field(9; "Line Discount Amount"; Decimal)
        {
            AutoFormatType = 1;
            CaptionML = ENU = 'Line Discount Amount', FRA = 'Montant remise ligne';
        }
        field(10; "Gen. Bus. Posting Group"; Code[20])
        {
            CaptionML = ENU = 'Gen. Bus. Posting Group', FRA = 'Groupe compta. marché';
            TableRelation = "Gen. Business Posting Group";
        }
        field(11; "Gen. Prod. Posting Group"; Code[20])
        {
            CaptionML = ENU = 'Gen. Prod. Posting Group', FRA = 'Groupe compta. produit';
            TableRelation = "Gen. Product Posting Group";
        }
        field(12; "VAT Calculation Type"; Enum "Tax Calculation Type")
        {
            CaptionML = ENU = 'VAT Calculation Type', FRA = 'Mode calcul TVA';
        }
        field(13; "Inv. Discount Amount"; Decimal)
        {
            AutoFormatType = 1;
            CaptionML = ENU = 'Inv. Discount Amount', FRA = 'Montant remise facture';
        }
        field(14; "VAT Base Amount"; Decimal)
        {
            AutoFormatType = 1;
            CaptionML = ENU = 'VAT Base Amount', FRA = 'Montant base TVA';
        }
        field(15; "Line Discount Account"; Code[20])
        {
            CaptionML = ENU = 'Line Discount Account', FRA = 'Compte remise ligne';
            TableRelation = "G/L Account";
        }
        field(16; "Inv. Discount Account"; Code[20])
        {
            CaptionML = ENU = 'Inv. Discount Account', FRA = 'Compte remise facture';
            TableRelation = "G/L Account";
        }
        field(17; "System-Created Entry"; Boolean)
        {
            CaptionML = ENU = 'System-Created Entry', FRA = 'Écriture système';
        }
        field(18; "Tax Area Code"; Code[20])
        {
            CaptionML = ENU = 'Tax Area Code', FRA = 'Code zone recouvrement';
            TableRelation = "Tax Area";
        }
        field(19; "Tax Liable"; Boolean)
        {
            CaptionML = ENU = 'Tax Liable', FRA = 'Soumis à recouvrement';
        }
        field(20; "Tax Group Code"; Code[20])
        {
            CaptionML = ENU = 'Tax Group Code', FRA = 'Code groupe taxes';
            TableRelation = "Tax Group";
        }
        field(21; Quantity; Decimal)
        {
            CaptionML = ENU = 'Quantity', FRA = 'Quantité';
            DecimalPlaces = 1 : 5;
        }
        field(22; "Use Tax"; Boolean)
        {
            CaptionML = ENU = 'Use Tax', FRA = 'Use Tax';
        }
        field(23; "VAT Bus. Posting Group"; Code[20])
        {
            CaptionML = ENU = 'VAT Bus. Posting Group', FRA = 'Groupe compta. marché TVA';
            TableRelation = "VAT Business Posting Group";
        }
        field(24; "VAT Prod. Posting Group"; Code[20])
        {
            CaptionML = ENU = 'VAT Prod. Posting Group', FRA = 'Groupe compta. produit TVA';
            TableRelation = "VAT Product Posting Group";
        }
        field(25; "Amount (ACY)"; Decimal)
        {
            AutoFormatType = 1;
            CaptionML = ENU = 'Amount (ACY)', FRA = 'Montant DR';
        }
        field(26; "VAT Amount (ACY)"; Decimal)
        {
            AutoFormatType = 1;
            CaptionML = ENU = 'VAT Amount (ACY)', FRA = 'Montant TVA DR';
        }
        field(27; "Line Discount Amt. (ACY)"; Decimal)
        {
            AutoFormatType = 1;
            CaptionML = ENU = 'Line Discount Amt. (ACY)', FRA = 'Montant remise ligne DR';
        }
        field(28; "Inv. Discount Amt. (ACY)"; Decimal)
        {
            AutoFormatType = 1;
            CaptionML = ENU = 'Inv. Discount Amt. (ACY)', FRA = 'Montant remise facture DR';
        }
        field(29; "VAT Base Amount (ACY)"; Decimal)
        {
            AutoFormatType = 1;
            CaptionML = ENU = 'VAT Base Amount (ACY)', FRA = 'Montant base TVA DR';
        }
        field(30; "Dimension Entry No."; Integer)
        {
            CaptionML = ENU = 'Dimension Entry No.', FRA = 'N° séquence analytique';
        }
        field(31; "VAT Difference"; Decimal)
        {
            AutoFormatType = 1;
            CaptionML = ENU = 'VAT Difference', FRA = 'Différence TVA';
        }
        field(32; "VAT %"; Decimal)
        {
            CaptionML = ENU = 'VAT %', FRA = '% TVA';
            DecimalPlaces = 1 : 1;
        }
        field(33; "GL Entry No."; Integer)
        {
            CaptionML = ENU = 'GL Entry No.', FRA = 'N° séquence compta.';
        }
        field(34; "Applies-to Doc. Type"; Enum "Gen. Journal Document Type")
        {
            CaptionML = ENU = 'Applies-to Doc. Type', FRA = 'Type doc. lettrage';
        }
        field(35; "Applies-to Doc. No."; Code[20])
        {
            CaptionML = ENU = 'Applies-to Doc. No.', FRA = 'N° doc. lettrage';
        }
        field(36; "Amount (LCY)"; Decimal)
        {
            CaptionML = ENU = 'Amount (LCY)', FRA = 'Montant DS';
        }
        field(37; "Currency Code"; Code[10])
        {
            CaptionML = ENU = 'Currency Code', FRA = 'Code devise';
        }
        field(38; "Currency Factor"; Decimal)
        {
            CaptionML = ENU = 'Currency Factor', FRA = 'Facteur devise';
        }
        field(63; "External Document No."; Code[35])
        {
            CaptionML = ENU = 'External Document No.', FRA = 'N° doc. externe';
        }
        field(78; "Source Type"; Enum "Gen. Journal Source Type")
        {
            CaptionML = ENU = 'Source Type', FRA = 'Type origine';
        }
        field(79; "Source No."; Code[20])
        {
            CaptionML = ENU = 'Source No.', FRA = 'N° origine';
            TableRelation = IF ("Source Type" = CONST(Customer)) Customer
            ELSE
            IF ("Source Type" = CONST(Vendor)) Vendor
            ELSE
            IF ("Source Type" = CONST("Bank Account")) "Bank Account"
            ELSE
            IF ("Source Type" = CONST("Fixed Asset")) "Fixed Asset";
        }
        field(90; "Auxiliary Entry No."; Integer)
        {
            CaptionML = ENU = 'Auxiliary Entry No.', FRA = 'N° séquence écr. auxiliaire';
        }
        field(91; "Created from No."; Code[20])
        {
            CaptionML = ENU = 'Created from No.', FRA = 'Créé à partir du n°';
        }
        field(200; Sign; Option)
        {
            CaptionML = ENU = 'Sign', FRA = 'Signe';
            OptionCaptionML = ENU = 'Negative,Positive', FRA = 'Négatif,Positif';
            OptionMembers = Negative,Positive;
        }
        field(480; "Dimension Set ID"; Integer)
        {
            CaptionML = ENU = 'Dimension Set ID', FRA = 'ID ensemble de dimensions';
            Editable = false;
            TableRelation = "Dimension Set Entry";
        }
        field(5600; "FA Posting Date"; Date)
        {
            CaptionML = ENU = 'FA Posting Date', FRA = 'Date compta. immo.';
        }
        field(5601; "FA Posting Type"; Option)
        {
            CaptionML = ENU = 'FA Posting Type', FRA = 'Type compta. immo.';
            OptionCaptionML = ENU = ' ,Acquisition Cost,Maintenance', FRA = ' ,Coût acquisition ,Maintenance';
            OptionMembers = " ","Acquisition Cost",Maintenance;
        }
        field(5602; "Depreciation Book Code"; Code[10])
        {
            CaptionML = ENU = 'Depreciation Book Code', FRA = 'Code loi d''amortissement';
            TableRelation = "Depreciation Book";
        }
        field(5603; "Salvage Value"; Decimal)
        {
            AutoFormatType = 1;
            CaptionML = ENU = 'Salvage Value', FRA = 'Valeur résiduelle';
        }
        field(5605; "Depr. until FA Posting Date"; Boolean)
        {
            CaptionML = ENU = 'Depr. until FA Posting Date', FRA = 'Amort. jusqu''à date compta.';
        }
        field(5606; "Depr. Acquisition Cost"; Boolean)
        {
            CaptionML = ENU = 'Depr. Acquisition Cost', FRA = 'Amortir coût acquisition';
        }
        field(5609; "Maintenance Code"; Code[10])
        {
            CaptionML = ENU = 'Maintenance Code', FRA = 'Code maintenance';
            TableRelation = Maintenance;
        }
        field(5610; "Insurance No."; Code[20])
        {
            CaptionML = ENU = 'Insurance No.', FRA = 'N° assurance';
            TableRelation = Insurance;
        }
        field(5611; "Budgeted FA No."; Code[20])
        {
            CaptionML = ENU = 'Budgeted FA No.', FRA = 'N° immo. budgétée';
            TableRelation = "Fixed Asset";
        }
        field(5612; "Duplicate in Depreciation Book"; Code[10])
        {
            CaptionML = ENU = 'Duplicate in Depreciation Book', FRA = 'Dupliquer dans journaux amort.';
            TableRelation = "Depreciation Book";
        }
        field(5613; "Use Duplication List"; Boolean)
        {
            CaptionML = ENU = 'Use Duplication List', FRA = 'Utiliser liste duplication';
        }
        field(5614; "Fixed Asset Line No."; Integer)
        {
            CaptionML = ENU = 'Fixed Asset Line No.', FRA = 'N° ligne immobilisation';
        }
        field(5615; "FA Discount Account"; Code[20])
        {
            CaptionML = ENU = 'FA Discount Account', FRA = 'Compte remise immo.';
            TableRelation = "G/L Account";
        }
        field(5616; "Payment Line No."; Integer)
        {
            CaptionML = ENU = 'Payment Line No.', FRA = 'N° ligne de paiement';
        }
        field(5617; "Posting Group"; Code[20])
        {
            CaptionML = ENU = 'Posting Group', FRA = 'Groupe comptabilisation';
        }
        field(5618; "Applies-to ID"; Code[50])
        {
            CaptionML = ENU = 'Applies-to ID', FRA = 'ID lettrage';
        }
        field(5619; "Due Date"; Date)
        {
            CaptionML = ENU = 'Due Date', FRA = 'Date d''échéance';
        }
        field(5620; "Document Type"; Enum "Gen. Journal Document Type")
        {
            CaptionML = ENU = 'Document Type', FRA = 'Type document';
        }
        field(5621; "Document No."; Code[20])
        {
            CaptionML = ENU = 'Document No.', FRA = 'N° document';
        }
        field(5622; Description; Text[50])
        {
            CaptionML = ENU = 'Description', FRA = 'Description';
        }
        field(5623; Correction; Boolean)
        {
            CaptionML = ENU = 'Correction', FRA = 'Correction';
        }
        field(5624; "Header Document No."; Code[20])
        {
            CaptionML = ENU = 'Header Document No.', FRA = 'N° document en-tête';
        }
        field(5625; "Line No."; Integer)
        {
            CaptionML = ENU = 'Line No.', FRA = 'N° ligne';
        }
    }

    keys
    {
        key(Key1; "Account Type", "Account No.", "Gen. Bus. Posting Group", "Gen. Prod. Posting Group", "VAT Bus. Posting Group", "VAT Prod. Posting Group", "Use Tax", "Job No.", "Fixed Asset Line No.", "Payment Line No.", "Posting Group", "Applies-to ID", "Due Date", Sign, "Currency Code", "Auxiliary Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Document No.")
        {
        }
    }

    fieldgroups
    {
    }
}

