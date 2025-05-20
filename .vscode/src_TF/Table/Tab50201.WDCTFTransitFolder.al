table 50201 "WDC-TF Transit Folder"
{
    CaptionML = ENU = 'Transit Folder', FRA = 'Dossier Importation';
    LookupPageID = "WDC-TF Transit Folders";
    DrillDownPageID = "WDC-TF Transit Folders";
    DataClassification = ToBeClassified;
    Permissions = TableData 122 = rm,
                TableData 123 = rm,
                TableData 5802 = rm;
    DataCaptionFields = "No.", "Vendor Name";

    fields
    {
        field(1; "No."; Code[20])
        {
            CaptionML = ENU = 'No.', FRA = 'N°';
            Editable = true;
        }
        field(2; "Opening Date"; Date)
        {
            CaptionML = ENU = 'Opening Date', FRA = 'Date d''ouverture';
            Editable = false;
        }
        field(3; "Closing Date"; Date)
        {
            CaptionML = ENU = 'Closing Date', FRA = 'Date clôture';
            Editable = true;
        }
        field(4; "Vendor No."; Code[20])
        {
            CaptionML = ENU = 'Vendor No.', FRA = 'N° Fournisseur';
            TableRelation = Vendor."No." WHERE("Foreign Vendor" = const(true));
            trigger OnValidate()
            BEGIN
                IF Frs.GET("Vendor No.") THEN BEGIN
                    "Vendor Name" := Frs.Name;
                    "Vendor address" := Frs.Address;
                    "Vendor address 2" := Frs."Address 2";
                    "Vendor Post Code" := Frs."Post Code";
                    "Vendor City" := Frs.City;
                    "Vendor Country Code" := Frs."Country/Region Code"
                END;
            END;
        }
        field(5; Souche; Code[10])
        {
            TableRelation = "No. Series";
            CaptionML = ENU = 'Series No.', FRA = 'Souches de N°';
            Editable = false;
        }
        field(6; "Vendor Name"; Text[60])
        {
            FieldClass = Normal;
            CaptionML = ENU = 'Vendor Name', FRA = 'Nom fournisseur';
        }
        field(7; Statut; Enum "WDC-TF Dossier Import Status")
        {
            CaptionML = ENU = 'Status', FRA = 'Statut';
            Editable = true;
        }
        field(8; "Total Amount Cr. Memo LCY"; Decimal)
        {
            CaptionML = ENU = 'Total Amount Cr. Memo LCY', FRA = 'Montant total avoirs DS';
            FieldClass = FlowField;
            CalcFormula = Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE("Document Type" = FILTER("Credit Memo"), "Transit Folder No." = FIELD("No.")));
            Editable = False;
            AutoFormatType = 2;
        }
        field(9; Volume; Decimal)
        {
            CaptionML = ENU = 'Volume', FRA = 'Volume';
        }
        field(10; "Shipment Method Code"; Code[20])
        {
            Editable = false;
            CaptionML = ENU = 'Shipment Method Code', FRA = 'Code condition livraison';
        }
        field(11; "Decalaration Date"; Date)
        {
            CaptionML = ENU = 'Decalaration Date', FRA = 'Date Déclaration';
        }
        field(12; "Last Order No."; Code[20])
        {
            CaptionML = ENU = 'Last Order No.', FRA = 'Dern. N° Commande';
            TableRelation = "Purchase Header"."No.";
            ValidateTableRelation = false;
        }
        field(13; "Freight Forwarder Code"; Code[20])
        {
            CaptionML = ENU = 'Freight Forwarder Code', FRA = 'Code Transitaire';
            TableRelation = Vendor."No." WHERE(Status = filter(validated));
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                IF Frs.GET("Freight Forwarder Code") THEN BEGIN
                    "Freight Forwarder Name" := Frs.Name;
                    "Freight Forwarder address" := Frs.Address;
                    "Freight Forwarder address 2" := Frs."Address 2";
                    "Freight Forwarder Post Code" := Frs."Post Code";
                    "Freight Forwarder City" := Frs.City;
                END;
            END;

        }
        field(14; "Freight Forwarder Name"; Text[100])
        {
            CaptionML = ENU = 'Freight Forwarder Name', FRA = 'Nom Transitaire';
        }
        field(15; "Freight Forwarder address"; Text[100])
        {
            CaptionML = ENU = 'Freight Forwarder address', FRA = 'addresse Transitaire';
        }
        field(16; "Freight Forwarder address 2"; Text[100])
        {
            CaptionML = ENU = 'Freight Forwarder address 2', FRA = 'addresse 2 Transitaire';
        }
        field(17; "Freight Forwarder Post Code"; Code[20])
        {
            CaptionML = ENU = 'Freight Forwarder Post Code', FRA = 'Code postal Transitaire';
            TableRelation = "Post Code";
            ValidateTableRelation = false;
        }
        field(18; "Freight Forwarder City"; Text[30])
        {
            CaptionML = ENU = 'Freight Forwarder City', FRA = 'Ville Transitaire';
        }
        field(19; "Vendor address"; Text[100])
        {
            CaptionML = ENU = 'Vendor address', FRA = 'addresse Fournisseur';
        }
        field(20; "Vendor address 2"; Text[100])
        {
            CaptionML = ENU = 'Vendor address', FRA = 'addresse 2 Fournisseur';
        }
        field(21; "Vendor Post Code"; Code[20])
        {
            CaptionML = ENU = 'Vendor Post Code', FRA = 'Code Postal Fournisseur';
        }
        field(22; "Vendor City"; Text[30])
        {
            CaptionML = ENU = 'Vendor City', FRA = 'Ville Fournisseur';
        }
        field(23; "Vendor Country Code"; Code[10])
        {
            TableRelation = "Country/Region";
            CaptionML = ENU = 'Vendor Country Code', FRA = 'Code pays/région';
        }
        field(24; "Vendor Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            CaptionML = ENU = 'Vendor Filter', FRA = 'Filtre Fournisseur';
        }
        field(25; "External Document No."; Code[20])
        {
            CaptionML = ENU = 'External Document No.', FRA = 'N° Transit Externe';
        }
        field(26; "Type Dossier"; Option)
        {
            OptionMembers = ,VN,PR;
            Editable = true;
        }
        field(27; "Vendor Invoice Amount LCY"; Decimal)
        {
            CaptionML = ENU = 'Vendor Invoice Amount LCY', FRA = 'Montant factures fourn. principal DS';
            FieldClass = FlowField;
            CalcFormula = - Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE("Document Type" = FILTER(Invoice | "Credit Memo"),
                                                                                "Transit Folder No." = FIELD("No."),
                                                                                "Vendor No." = FIELD("Vendor No.")));
            Editable = False;
            AutoFormatType = 2;
        }
        field(28; "Frei. Forw. Inv. Amount LCY"; Decimal)

        {
            CaptionML = ENU = 'Frei. Forw. Inv. Amount LCY', FRA = 'Montant factures transitaire DS';
            FieldClass = FlowField;
            CalcFormula = - Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE("Document Type" = FILTER(Invoice | "Credit Memo"),
                                                                                "Transit Folder No." = FIELD("No."),
                                                                                "Vendor No." = FIELD("Freight Forwarder Code")));
            Editable = false;
            AutoFormatType = 2;
        }
        field(29; "Affected Charge Amount"; Decimal)
        {
            CaptionML = ENU = 'Affected Charge Amount', FRA = 'Montant frais affectés';
            FieldClass = FlowField;
            CalcFormula = Sum("Value Entry"."Cost Amount (Actual)" WHERE("Transit Folder No." = FIELD("No."),
                                                                         "Item Charge No." = FILTER(<> '')));

        }
        field(30; "Transporter code"; Code[20])
        {
            CaptionML = ENU = 'Transporter code', FRA = 'Code transporteur';
            TableRelation = Vendor."No." WHERE(Status = filter(Validated));
            trigger onValidate()
            var
                myInt: Integer;
            begin
                IF Frs.GET("Transporter code") THEN BEGIN
                    "Transporter Name" := Frs.Name;
                    "Transporter address" := Frs.Address;
                    "Transporter address 2" := Frs."Address 2";
                    "Transporter Post code" := Frs."Post Code";
                    "Transporter City" := Frs.City;
                END;
            END;
        }
        field(31; "Transporter Name"; Text[100])
        {
            CaptionML = ENU = 'Transporter Name', FRA = 'Nom transporteur';
        }
        field(32; "Transporter address"; Text[100])
        {
            CaptionML = ENU = 'Transporter address', FRA = 'addresse transporteur';
        }
        field(33; "Transporter address 2"; Text[100])
        {
            CaptionML = ENU = 'Transporter address 2', FRA = 'addresse 2 transporteur';
        }
        field(34; "Transporter City"; Text[100])
        {
            CaptionML = ENU = 'Transporter City', FRA = 'Ville transporteur';
        }
        field(35; "Transporter Post code"; Code[20])
        {
            TableRelation = "Post Code";
            CaptionML = ENU = 'Transporter Post code', FRA = 'Code postal transporteure';
        }
        field(36; "Folder profile"; Enum "WDC-TF Folder profile")
        {
            CaptionML = ENU = 'Folder profile', FRA = 'Profil dossier';
        }
        field(37; "Vessel Name / vol / Truck"; Text[100])
        {
            CaptionML = ENU = 'Vessel Name / vol / Truck', FRA = 'Nom navir / vol / camion';
        }
        field(38; "Trip No."; Text[30])
        {
            CaptionML = ENU = 'Trip No.', FRA = 'N° voyage';
        }
        field(39; "Transport Doc No."; Text[30])
        {
            CaptionML = ENU = 'Transport Doc No.', FRA = 'N° Doc Transport';
        }
        field(40; "Doc. Trans. sednding Date"; Date)
        {
            CaptionML = ENU = 'Doc. Trans. sednding Date', FRA = 'Date Emission Doc. transport';
        }
        field(41; "Place of loading"; Code[20])
        {
            TableRelation = "Entry/Exit Point".Code;
            CaptionML = ENU = 'Place of loading', FRA = 'Lieu de Chargement';
        }
        field(42; "Number of packages"; Integer)
        {
            CaptionML = ENU = 'Number of packages', FRA = 'Nombre de colis';
        }
        field(43; "Gross weight"; Decimal)
        {
            CaptionML = ENU = 'Gross weight', FRA = 'Poids brut';
        }
        field(44; "Arrival Date at port Unloading"; Date)
        {
            CaptionML = ENU = 'Arrival Date at port Unloading', FRA = 'Date arrivée port Déchargement';
        }
        field(45; "Arrival Date at ending dest."; Date)
        {
            CaptionML = ENU = 'Arrival Date at ending dest.', FRA = 'Date arrivée dest. finale';
        }
        field(46; "Confirmed Reception Date"; Date)
        {
            CaptionML = ENU = 'Confirmed Reception Date', FRA = 'Date de reception confirmé';
        }
        field(47; Quantity; Decimal)
        {
            CaptionML = ENU = 'Quantity', FRA = 'Quantité';
            FieldClass = FlowField;
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Transit Folder No." = FIELD("No."),
                                                                 "Entry Type" = FILTER(Purchase)));
            Editable = False;
        }
        field(48; "Proforma No."; Code[20])
        {
            CaptionML = ENU = 'Proforma No.', FRA = 'N° Proforma';
        }
        field(49; "Letter of credit No."; Code[20])
        {
            CaptionML = ENU = 'Letter of credit No.', FRA = 'N° Lettre de credit';
        }
        field(50; "Invoiced amount Vendor Dev"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = - Sum("Detailed Vendor Ledg. Entry".Amount WHERE("Document Type" = FILTER(Invoice | "Credit Memo"),
                                                                         "Transit Folder No." = FIELD("No."),
                                                                         "Vendor No." = FIELD("Vendor No.")));
            CaptionML = ENU = 'Invoiced amount Vendor Dev', FRA = 'Montant factures fourn. principal Dev';
            Editable = false;
            AutoFormatType = 2;
        }
    }
    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
        key(Key2; "Opening Date")
        {

        }
        key(Key3; "Freight Forwarder Code", "Decalaration Date", "No.")
        {

        }
    }
    trigger OnInsert()
    VAR
        Selection: Integer;
    BEGIN
        IF "No." = '' THEN BEGIN
            PurchSetup.GET;
            PurchSetup.TESTFIELD("Transit Folder Nos.");
            // NoSeriesMgt.InitSeries(PurchSetup."Transit Folder Nos.", xRec.Souche, WORKDATE, "No.", Souche);
            "No." := NoSeriesMgt.GetNextNo(PurchSetup."Transit Folder Nos.", WorkDate(), TRUE);
        END;
        "Opening Date" := TODAY;
        InsertDefaultCharges;
        Statut := Statut::Open;
    END;

    trigger OnDelete()
    var
        FraisDossier: Record "WDC-TF Item Charge Trans. Fold";
    BEGIN
        ValueEntry.RESET;
        ValueEntry.SETCURRENTKEY("Item Charge No.", "Inventory Posting Group", "Item No.", "Transit Folder No.");
        ValueEntry.SETRANGE("Transit Folder No.", "No.");
        IF ValueEntry.FINDFIRST THEN
            ERROR(CstError001);

        WhseReceiptHdr.RESET;
        WhseReceiptHdr.SETCURRENTKEY("Location Code", "Transit Folder No.");
        WhseReceiptHdr.SETRANGE("Transit Folder No.", "No.");
        IF WhseReceiptHdr.FINDFIRST THEN
            ERROR(CstError002);
        FraisDossier.SETRANGE("Transit Folder No.", "No.");
        IF FraisDossier.FINDFIRST THEN
            FraisDossier.DELETEALL;
    END;


    PROCEDURE Navigate();
    VAR
        NavigatePage: Page 344;
    BEGIN
        NavigatePage.SetDoc("Opening Date", "No.");
        NavigatePage.RUN;
    END;

    PROCEDURE InsertDefaultCharges();
    VAR
        FraisDossier: Record "WDC-TF Item Charge Trans. Fold";
        ItemCharges: Record "Item Charge";
    BEGIN
        ItemCharges.SETRANGE(ItemCharges."Dossier Import", TRUE);

        IF ItemCharges.FINDSET THEN
            REPEAT
                FraisDossier.INIT;
                FraisDossier."Transit Folder No." := "No.";
                FraisDossier."Charge Code" := ItemCharges."No.";
                FraisDossier.Assignable := ItemCharges.Assignable;
                FraisDossier.Description := ItemCharges.Description;
                IF FraisDossier.INSERT THEN;
            UNTIL ItemCharges.NEXT = 0
    END;

    PROCEDURE CloseFolder();
    VAR
        ItemCharges: Record "WDC-TF Item Charge Trans. Fold";
        Text001: TextConst FRA = 'Le frais %1 n''a pas encore  t  factur ';
        Text002: TextConst FRA = 'Voulez-Vous vraiment clôturer ce dossier?';
        lSumItemCharges: Decimal;
        ItemLedgerEntry: Record 32;
    BEGIN
        IF CONFIRM(Text002) = FALSE THEN
            EXIT;

        ItemCharges.SETRANGE(ItemCharges."Transit Folder No.", "No.");
        IF ItemCharges.FINDSET THEN
            REPEAT
                ItemCharges.CALCFIELDS(ItemCharges."Affected Charge Amount");
                IF (ItemCharges."Affected Charge Amount" = 0) AND (ItemCharges."Not included" = FALSE) THEN
                    ERROR(Text001, ItemCharges."Charge Code");

            UNTIL ItemCharges.NEXT = 0;

        Statut := Statut::Closed;
        "Closing Date" := WorkDate();
        MODIFY;
    END;

    PROCEDURE CalcChargeRate(): Decimal;
    VAR
        lItemCharges: Record "WDC-TF Item Charge Trans. Fold";
        lSumItemCharges: Decimal;
    BEGIN
        CALCFIELDS("Vendor Invoice Amount LCY", "Affected Charge Amount");

        IF "Vendor Invoice Amount LCY" <> 0 THEN
            EXIT(ABS(("Affected Charge Amount" / "Vendor Invoice Amount LCY") * 100))
        ELSE
            EXIT(0);
    END;

    PROCEDURE ReopenFolder();
    VAR
        ItemCharges: Record "WDC-TF Item Charge Trans. Fold";
        Text001: TextConst FRA = 'Le frais %1 n''a pas encore facturé';
        Text002: TextConst FRA = 'Voulez-Vous vraiment clôturer ce dossier?';
        lSumItemCharges: Decimal;
    BEGIN
        UserSetup.GET(USERID);
        UserSetup.TESTFIELD("Allow Open Transit Folder", TRUE);
        Statut := Statut::"Goods Receipt";
        "Closing Date" := 0D;
        MODIFY;
    END;

    PROCEDURE RefreshDefaultCharges();
    VAR
        FraisDossier: Record "WDC-TF Item Charge Trans. Fold";
        ItemCharges: Record "Item Charge";
    BEGIN
        ItemCharges.SETRANGE(ItemCharges."Dossier Import", TRUE);
        IF ItemCharges.FINDSET THEN
            REPEAT
                FraisDossier.INIT;
                FraisDossier."Transit Folder No." := "No.";
                FraisDossier."Charge Code" := ItemCharges."No.";
                FraisDossier.Assignable := ItemCharges.Assignable;
                FraisDossier.Description := ItemCharges.Description;
                IF NOT FraisDossier.INSERT THEN
                    FraisDossier.MODIFY;
            UNTIL ItemCharges.NEXT = 0
    END;

    VAR
        PurchSetup: Record 312;
        Frs: Record 23;
        NoSeriesMgt: Codeunit "No. Series";
        WhseReceiptHdr: Record 7316;
        UserSetup: Record 91;
        ValueEntry: Record 5802;
        CstError001: TextConst FRA = 'Vous ne pouvez pas supprimer ce dossier, car il existe des documents validés';
        CstError002: TextConst FRA = 'Vous ne pouvez pas supprimer ce dossier, car il existe des receptions administrative en cours';

}
