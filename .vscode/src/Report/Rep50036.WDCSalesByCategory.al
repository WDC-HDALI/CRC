report 50036 "WDC Sales By Category"
{
    ApplicationArea = All;
    CaptionML = ENU = 'Sales By Category', FRA = 'Ventes par Categorie';
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = './.vscode/src/Report/RDLC/SalesByCategory.rdl';
    dataset
    {


        dataItem("Item Category"; "Item Category")
        {

            dataItem("WDC SubCategory Item"; "WDC SubCategory Item")
            {
                DataItemLink = "Item Category Code" = field(Code);

                dataItem(Item; Item)
                {
                    DataItemTableView = sorting("No.");
                    DataItemLink = "Item Category Code" = field("Item Category Code"),
                                    SubCategorie = field(Code);
                    column(No_; Item."No.")
                    {

                    }
                    column(Description; Item.Description)
                    {

                    }
                    column(Item_Category_Code; "Item Category Code")
                    {

                    }
                    column(SubCategorie; SubCategorie)
                    {

                    }
                    column(Quantity; Quantity)
                    {
                    }
                    column(CA; CA)
                    {
                    }
                    column(CompanyCity; companyinfo.City)
                    {
                    }
                    column(CompanyName; CompanyInfo."Name")
                    {
                    }
                    column(CompanyPostCod; companyinfo."Post Code")
                    {
                    }
                    column(CompanyAdress; companyinfo.Address)
                    {
                    }
                    column(CompanyPicture; CompanyInfo.Picture)
                    {
                    }
                    column(CompanyPhoneNo; CompanyInfo."Phone No.")
                    {
                    }
                    trigger OnAfterGetRecord()
                    var
                        lItemLedgEnt: Record "Item Ledger Entry";
                        lSalesShipmentLine: Record "Sales Shipment Line";
                        lReturnReceiptLine: Record "Return Receipt Line";
                    begin
                        CA := 0;
                        Quantity := 0;
                        lItemLedgEnt.Reset();
                        lItemLedgEnt.SetCurrentKey("Item No.", "Entry Type", "Variant Code", "Drop Shipment", "Location Code", "Posting Date", "SIFT Bucket No.");
                        lItemLedgEnt.SetRange("Entry Type", lItemLedgEnt."Entry Type"::Sale);
                        lItemLedgEnt.SetFilter("Document Type", '%1|%2|%3|%4', lItemLedgEnt."Document Type"::"Sales Invoice", lItemLedgEnt."Document Type"::"Sales Credit Memo",
                                              lItemLedgEnt."Document Type"::"Sales Return Receipt", lItemLedgEnt."Document Type"::"Sales Shipment");
                        lItemLedgEnt.SetRange("Item No.", Item."No.");
                        if (StartDate <> 0D) and (EndingDate <> 0D) then
                            lItemLedgEnt.SetRange("Posting Date", StartDate, EndingDate);
                        if lItemLedgEnt.FindSet() then
                            repeat
                                lItemLedgEnt.CalcFields("Sales Amount (Expected)");
                                if lItemLedgEnt."Sales Amount (Expected)" <> 0 then begin
                                    CA += lItemLedgEnt."Sales Amount (Expected)";
                                    Quantity += lItemLedgEnt.Quantity * -1;
                                end ELSE IF lItemLedgEnt."Document Type" = lItemLedgEnt."Document Type"::"Sales Shipment" then begin
                                    lSalesShipmentLine.Reset();
                                    lSalesShipmentLine.SetRange("Document No.", lItemLedgEnt."Document No.");
                                    lSalesShipmentLine.SetRange("No.", lItemLedgEnt."Item No.");
                                    lSalesShipmentLine.SetRange("Line No.", lItemLedgEnt."Document Line No.");
                                    if lSalesShipmentLine.FindSet() then
                                        repeat
                                            CA += lSalesShipmentLine."VAT Base Amount";
                                            Quantity += lSalesShipmentLine.Quantity;
                                        until lSalesShipmentLine.Next() = 0;
                                end else if lItemLedgEnt."Document Type" = lItemLedgEnt."Document Type"::"Sales Return Receipt" then begin
                                    lReturnReceiptLine.Reset();
                                    lReturnReceiptLine.SetRange("Document No.", lItemLedgEnt."Document No.");
                                    lReturnReceiptLine.SetRange("No.", lItemLedgEnt."Item No.");
                                    lReturnReceiptLine.SetRange("Line No.", lItemLedgEnt."Document Line No.");
                                    if lReturnReceiptLine.FindSet() then
                                        repeat
                                            CA -= lReturnReceiptLine."VAT Base Amount";
                                            Quantity -= lReturnReceiptLine.Quantity;
                                        until lReturnReceiptLine.Next() = 0;
                                end;

                            until lItemLedgEnt.Next() = 0;
                    end;

                    trigger OnPreDataItem()
                    begin
                        if ItemNo <> '' then
                            Item.SetFilter("No.", ItemNo);
                    end;
                }

                trigger OnPreDataItem()
                begin

                    if SubCategorie <> '' then
                        "WDC SubCategory Item".SetFilter(Code, SubCategorie);
                end;
            }
            trigger OnAfterGetRecord()
            begin
                CA := 0;
                Quantity := 0;
            end;

            trigger OnPreDataItem()
            begin

                if ItemCategoryCode <> '' then
                    "Item Category".SetFilter("Code", ItemCategoryCode);
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    CaptionML = ENG = 'Filter', FRA = 'Filtrer par';
                    field(StartDate; StartDate)
                    {
                        ApplicationArea = all;
                        CaptionML = ENG = 'Start Date', FRA = 'Date début';
                        trigger OnValidate()
                        var
                            Err001: TextConst ENG = 'Starting date must be less then ending date',
                                              FRA = 'Date début doit être inférieur à la date fin ';
                        begin
                            if (StartDate > EndingDate) and (EndingDate <> 0D) then
                                Error(Err001);
                        end;
                    }
                    field(EndingDate; EndingDate)
                    {
                        ApplicationArea = ALL;
                        CaptionML = ENG = 'End Date', FRA = 'Date fin';
                        trigger OnValidate()
                        var
                            Err001: TextConst ENG = 'Ending date must be greater then starting date', FRA = 'Date Fin doit être supérieur à date début ';
                        begin
                            if (StartDate > EndingDate) and (StartDate <> 0D) then
                                Error(Err001);
                        end;
                    }


                    field(ItemCategoryCode; ItemCategoryCode)
                    {
                        ApplicationArea = ALL;
                        CaptionML = ENG = 'Famille', FRA = 'Famille';
                        TableRelation = "Item Category".code;
                    }
                    field(SubCategorie; SubCategorie)
                    {
                        ApplicationArea = ALL;
                        CaptionML = ENG = 'SubCategorie', FRA = 'Sous-Famille';
                        //TableRelation = "WDC SubCategory Item".Code;
                        trigger OnLookup(Var Text: Text): Boolean
                        var
                            WDCSubCategoryItemPage: Page "WDC SubCategory Item";
                            WDCSubCategory: Record "WDC SubCategory Item";
                        begin
                            WDCSubCategory.reset;
                            WDCSubCategory.SetRange("Item Category Code", ItemCategoryCode);
                            WDCSubCategoryItemPage.SetTableView(WDCSubCategory);
                            WDCSubCategoryItemPage.Editable(False);
                            if WDCSubCategoryItemPage.RunModal() = Action::OK then begin
                                WDCSubCategoryItemPage.GETRECORD(WDCSubCategory);
                                SubCategorie := WDCSubCategory.Code;
                            end;
                        end;
                    }
                    field(ItemNo; ItemNo)
                    {
                        ApplicationArea = ALL;
                        CaptionML = ENG = 'Item No.', FRA = 'N° article';
                        TableRelation = Item."No.";
                    }
                }
            }
        }
    }
    trigger OnInitReport()
    begin
        CompanyInfo.Get();
        CompanyInfo.CalcFields(Picture);
    end;

    var
        ItemNo: Code[20];
        ItemCategoryCode: Code[20];
        SubCategorie: Code[50];
        StartDate: Date;
        EndingDate: Date;
        CompanyInfo: record "Company Information";
        CA: Decimal;
        Quantity: Decimal;
}