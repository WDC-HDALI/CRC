page 50000 "WDC Page"
{
    Caption = 'WDC Page ';
    ApplicationArea = Basic, Suite;
    PageType = List;
    Editable = false;
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            field(""; WDCText)
            {
                ApplicationArea = all;
                Style = StrongAccent;
                RowSpan = 5;
            }
        }


    }
    actions
    {
        area(Creation)
        {
            action(Import)
            {
                RunObject = xmlport "WDC Import grand livre";
                Image = Import;
                ApplicationArea = all;
                CaptionML = FRA = 'Import grand livre', ENU = 'Ledger Import';
                Promoted = true;
                PromotedCategory = New;
                PromotedIsBig = true;

            }
            action(Import2)
            {
                RunObject = xmlport "WDC Import Stock";
                Image = Import;
                ApplicationArea = all;
                CaptionML = FRA = 'Import stock';
                Promoted = true;
                PromotedCategory = New;
                PromotedIsBig = true;
            }
            action(ImportCoutStand)
            {
                RunObject = xmlport "WDC Import Cout Standard";
                Image = Import;
                ApplicationArea = all;
                CaptionML = FRA = 'Import Cout Standard';
                Promoted = true;
                PromotedCategory = New;
                PromotedIsBig = true;
            }
            action("Delete All Item")
            {
                ApplicationArea = all;
                CaptionML = ENU = 'Delete All Item', FRA = 'Supprimer tout les articles';
                Image = Delete;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    lItem: record Item;
                    lsubcategory: Record "WDC SubCategory Item";
                    lcategory: record 5722;
                    lUnitOfMesure: record "Unit of Measure";
                    lUserSetup: record "User Setup";
                    Text001: TextConst ENU = 'Do you want to delete all items  %1',
                           FRA = 'Confirmer vous de supprimer tout les article  %1';
                    Err001: TextConst ENU = 'Do not have permession for this actions',
                                    FRA = 'Vous n''etes pas autoriser ';
                    lCompanyInfo: record "Company Information";
                    lItemUnitOfMesure: record 5404;//"Item Unit of Measure"

                begin
                    lUserSetup.Get(UserId);
                    lCompanyInfo.get();
                    if lUserSetup."User ID" = 'WEDATA' then begin
                        if Confirm(StrSubstNo(Text001, lCompanyInfo.Name)) then
                            if Confirm(StrSubstNo(Text001, lCompanyInfo.Name)) then begin
                                lItem.DeleteAll();
                                lsubcategory.DeleteAll();
                                lcategory.DeleteAll();
                                lUnitOfMesure.DeleteAll();
                                lItemUnitOfMesure.DeleteAll();
                            end;
                    end
                    else
                        Error(Err001);

                end;
            }
            action("Delete All Customers")
            {
                ApplicationArea = all;
                CaptionML = ENU = 'Delete All Customers', FRA = 'Supprimer tout clients';
                Image = Delete;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    lCustomer: record Customer;
                    lcontact: record Contact;
                    lUserSetup: record "User Setup";
                    Text001: TextConst ENU = 'Do you want to delete all customers',
                           FRA = 'Confirmer vous de supprimer tout les clients %1';
                    Err001: TextConst ENU = 'Do not have permission for this action %1',
                                    FRA = 'Vous n''etes pas autoriser ';
                    lCompanyInfo: record "Company Information";

                begin
                    lUserSetup.Get(UserId);
                    lCompanyInfo.get();
                    if lUserSetup."User ID" = 'WEDATA' then begin
                        if Confirm(StrSubstNo(Text001, lCompanyInfo.Name)) then
                            if Confirm(StrSubstNo(Text001, lCompanyInfo.Name)) then begin
                                lCustomer.DeleteAll();
                                lcontact.DeleteAll();
                            end
                    end else
                        Error(Err001);
                end;

            }
            action(DeleteAll)
            {
                ApplicationArea = all;
                CaptionML = ENU = 'Delete All Vendors', FRA = 'Supprimer tout fournisseur';
                Image = Delete;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    lVendor: record Vendor;
                    lUserSetup: record "User Setup";
                    Text001: TextConst ENU = 'Do you want to delete all vendors %1',
                           FRA = 'Confirmer vous de supprimer tout les fournisseurs %1';
                    Err001: TextConst ENU = 'Do not have permission for this action',
                                    FRA = 'Vous n''etes pas autoriser ';
                    lCompanyInfo: record "Company Information";

                begin
                    lUserSetup.Get(UserId);
                    lCompanyInfo.get();
                    if lUserSetup."User ID" = 'WEDATA' then begin
                        if Confirm(StrSubstNo(Text001, lCompanyInfo.Name)) then
                            if Confirm(StrSubstNo(Text001, lCompanyInfo.Name)) then begin

                                lVendor.DeleteAll();
                            end
                    end else
                        Error(Err001);
                end;
            }
        }

    }
    var
        WDCText: Label 'WEDATA CONSULT';
}
