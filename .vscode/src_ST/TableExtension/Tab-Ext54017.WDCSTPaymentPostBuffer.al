tableextension 54017 "WDC-ST Payment Post. Buffer" extends "WDC-ED Payment Post. Buffer"
{
    fields
    {
        field(54000; "RS Code"; Code[20])
        {
            CaptionML = ENU = 'RS Code', FRA = 'Code Retenue à la Source';
        }
        field(54001; "RS Amount"; Decimal)
        {
            CaptionML = ENU = 'RS Amount', FRA = 'Montant RS';
        }
        field(54002; "RS Amount (LCY)"; Decimal)
        {
            CaptionML = ENU = 'RS Amount (LCY)', FRA = 'Montant RS DS';
        }
        field(54003; "VAT Account No."; Code[20])
        {
            CaptionML = ENU = 'RS VAT Account No.', FRA = 'N° Compte RS TVA';
        }
        field(54004; "RS VAT Amount"; Decimal)
        {
            CaptionML = ENU = 'RS VAT Amount', FRA = 'Montant TVA RS';
        }
        field(54005; "VAT Amount LCY"; Decimal)
        {
            CaptionML = ENU = 'VAT Amount LCY', FRA = 'Montant TVA RS DS';
        }
        field(54006; "RS Type"; Option)
        {
            CaptionML = ENU = 'RS Type', FRA = 'Type RS';
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Prêt,Avance,Opposition,Retenue';
            OptionMembers = " ","Prêt",Avance,Opposition,Retenue;
        }
        field(54007; "RS Account No."; Code[20])
        {
            CaptionML = ENU = 'RS Account No.', FRA = 'N° Compte RS';
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
        field(54008; "Comission Account No."; Code[20])
        {
            CaptionML = ENU = 'Comission Account No.', FRA = 'N° Compte Comission';
            DataClassification = ToBeClassified;
        }
        field(54009; "Amount Comission"; Decimal)
        {
            CaptionML = ENU = 'Amount Comission', FRA = 'Montant Comission';
            AutoFormatType = 1;
            DataClassification = ToBeClassified;
        }
        field(54010; "Amount Comission LCY "; Decimal)
        {
            CaptionML = ENU = 'Amount Comission LCY ', FRA = 'Montant Comission DS';
            DataClassification = ToBeClassified;
        }
        field(54011; "VAT Comission Account No."; Code[20])
        {
            CaptionML = ENU = 'VAT Comission Account No.', FRA = 'N° Compte TVA Comission';
            DataClassification = ToBeClassified;

        }
        field(54012; "VAT Comission Amount"; Decimal)
        {
            CaptionML = ENU = 'VAT Comission Amount', FRA = 'Montant TVA Commision';
            AutoFormatType = 1;
            DataClassification = ToBeClassified;
        }
        field(54013; "VAT Comission Amount LCY"; Decimal)
        {
            CaptionML = ENU = 'VAT Comission Amount LCY', FRA = 'Montant TVA Commision LCY';
            DataClassification = ToBeClassified;

        }

    }

}