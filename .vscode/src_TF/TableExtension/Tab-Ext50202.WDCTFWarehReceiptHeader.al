tableextension 50202 "WDC-TF Wareh. Receipt Header" extends "Warehouse Receipt Header"
{
    fields
    {
        field(50200; "Transit Folder No."; Code[20])
        {
            CaptionML = ENU = 'Transit Folder No.', FRA = 'N° dossier import';
            DataClassification = ToBeClassified;
            TableRelation = "WDC-TF Transit Folder" WHERE(Statut = FILTER(<> Closed));
            trigger OnValidate()
            var
                LWhseRcptLine: Record 7317;
                lDossiersTransit: Record "WDC-TF Transit Folder";
                lLocation: Record 14;
            BEGIN
                LWhseRcptLine.SETRANGE("No.", "No.");
                IF LWhseRcptLine.FINDFIRST THEN
                    LWhseRcptLine.MODIFYALL(LWhseRcptLine."Transit Folder No.", "Transit Folder No.");

                IF lDossiersTransit.GET("Transit Folder No.") THEN BEGIN
                    IF "Vendor No." = '' THEN
                        "Vendor No." := lDossiersTransit."Vendor No.";
                END;
                lLocation.SETRANGE(Import, TRUE);
                IF lLocation.FINDFIRST THEN
                    VALIDATE("Location Code", lLocation.Code);
            END;
        }
        field(50201; "Vendor No."; Code[20])
        {
            CaptionML = ENU = 'Vendor No.', FRA = 'N° fourniseur';
            DataClassification = ToBeClassified;
            TableRelation = Vendor;
        }
        field(50202; "Order No."; Code[20])
        {
            CaptionML = ENU = 'Order No.', FRA = 'N° commande';
            DataClassification = ToBeClassified;
            TableRelation = "Purchase Header"."No.";
        }
        field(50203; "Administrative Receipt"; Boolean)
        {
            CaptionML = ENU = 'Administrative Receipt', FRA = 'Réception administrative';
            DataClassification = ToBeClassified;
        }

    }
}