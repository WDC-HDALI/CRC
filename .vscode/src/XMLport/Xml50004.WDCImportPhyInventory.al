xmlport 50004 "WDC Import Phy. Inventory"
{
    Direction = Import;
    Format = VariableText;
    TextEncoding = UTF8;
    FieldDelimiter = '"';
    FieldSeparator = ';';
    UseRequestPage = false;
    //Permissions = TableData "G/L Entry" = rimd, tabledata "G/L Account" = rimd;
    schema
    {
        textelement(Root)
        {
            tableelement("Item Journal Line"; "Item Journal Line")
            {
                AutoReplace = false;
                AutoSave = false;
                AutoUpdate = false;
                XmlName = 'ItemJrnLine';
                fieldelement(TemplateName; "Item Journal Line"."Journal Template Name")
                {

                }
                fieldelement(BatchName; "Item Journal Line"."Journal Batch Name")
                {

                }
                fieldelement(DocNo; "Item Journal Line"."Document No.")
                {

                }
                // fieldelement(LineNo; "Item Journal Line"."Line No.")
                // {

                // }
                fieldelement(ItemCode; "Item Journal Line"."Item No.")
                {

                }
                fieldelement(LocationCode; "Item Journal Line"."Location Code")
                {

                }
                fieldelement(QtyToApply; "Item Journal Line"."Qty to apply")
                {

                }

                trigger OnBeforeInsertRecord()
                begin
                    // IF "Item Journal Line"."Item No." = '' THEN
                    //     currXMLport.SKIP;

                    ItemJournalLine.Reset();
                    ItemJournalLine.SetRange("Journal Template Name", "Item Journal Line"."Journal Template Name");
                    ItemJournalLine.SetRange("Journal Batch Name", "Item Journal Line"."Journal Batch Name");
                    ItemJournalLine.SetRange("Document No.", "Item Journal Line"."Document No.");
                    //ItemJournalLine.SetRange("Line No.", "Item Journal Line"."Line No.");
                    ItemJournalLine.SetRange("Item No.", "Item Journal Line"."Item No.");
                    if ItemJournalLine.FindSet() then begin
                        ItemJournalLine.Validate("Qty to apply", "Item Journal Line"."Qty to apply");

                        // ItemJournalLine.Quantity := 0;
                        // if ItemJournalLine."Qty. (Phys. Inventory)" >= ItemJournalLine."Qty. (Calculated)" then begin
                        //     ItemJournalLine."Entry Type" := ItemJournalLine."Entry Type"::"Positive Adjmt.";
                        //     ItemJournalLine.Quantity := ItemJournalLine."Qty. (Phys. Inventory)" - ItemJournalLine."Qty. (Calculated)";
                        // end else begin
                        //     ItemJournalLine."Entry Type" := ItemJournalLine."Entry Type"::"Negative Adjmt.";
                        //     ItemJournalLine.Quantity := ItemJournalLine."Qty. (Calculated)" - ItemJournalLine."Qty. (Phys. Inventory)";
                        // end;

                        ItemJournalLine.Modify();
                        //  Error('ok');
                    end;

                end;
            }
        }

    }

    var
        lReservationEntry: Record "Reservation Entry";
        ItemJournalLine: Record "Item Journal Line";
        lItem: Record Item;
        Quantites: Decimal;
        DateCompatabilisation: Date;
        ModeleFeuille: Code[20];
        NomFeuille: Code[20];


    trigger OnInitXmlPort()
    begin

    end;

    trigger OnPostXmlPort()
    begin
        MESSAGE('Stock importé avec succés');
    end;


}