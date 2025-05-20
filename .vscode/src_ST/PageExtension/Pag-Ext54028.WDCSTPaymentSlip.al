pageextension 54028 "WDC-ST Payment Slip" extends "WDC-ED Payment Slip"
{
    layout
    {

        addafter("Posting Date")
        {
            field("Payment Slip Type"; Rec."Payment Slip Type")
            {
                ApplicationArea = All;
            }
            field("Banque RIB"; Rec."Banque RIB")
            {
                ApplicationArea = All;
            }
            field(RIB; Rec.RIB)
            {
                ApplicationArea = All;
            }

        }
    }
    actions
    {

        addafter("P&osting")
        {
            action(GenaratingFile)
            {
                ApplicationArea = All;
                Image = CreateDocument;
                Caption = 'Générer fichier';
                trigger OnAction()
                var
                    Steps: Record "WDC-ED Payment Step";
                begin
                    Steps.SETRANGE("Payment Class", Rec."Payment Class");
                    Steps.SETRANGE("Previous Status", Rec."Status No.");
                    Steps.SETRANGE("Action Type", Steps."Action Type"::File);
                    ValidatePayment;
                end;
            }
        }
        modify(Post)
        {
            Visible = false;
            Enabled = false;

        }
        addafter(Post)
        {
            action("&Post")
            {
                Caption = 'Valider';
                ApplicationArea = All;
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    PaymentStatus_gr: Record "WDC-ED Payment Status";
                    PaymentLine_gr: Record "WDC-ED Payment Line";
                    Steps: Record "WDC-ED Payment Step";
                    RecUser: Record "User Setup";
                    RecEntetePayement: Record "WDC-ED Payment Header";
                    Text010: Label 'Veuillez saisir le N° Chèque dans la ligne %1';
                    Text013: Label 'N° chèque est Annulé ou Bloqué';
                    Text011: Label 'N° chèque %1 est utlisé plus qu''une fois';
                begin
                    VarReport := FALSE;
                    CurrPage.UPDATE(TRUE);
                    Steps.SETRANGE("Payment Class", Rec."Payment Class");
                    Steps.SETRANGE("Previous Status", Rec."Status No.");
                    Steps.SETFILTER("Action Type", '<>%1&<>%2&<>%3', Steps."Action Type"::Report, Steps."Action Type"::File, Steps."Action Type"::
                      "Create New Document");
                    ValidatePayment;
                    IF Rec."Status No." <> 0 THEN
                        BooGLineEditable := FALSE;

                end;
            }
        }
        modify(Print)
        {
            Visible = false;
            Enabled = false;

        }
        addafter(Print)
        {
            action("&Print")
            {
                Caption = 'Imprimer';
                ApplicationArea = All;
                Image = Print;
                trigger OnAction()
                var
                    Steps: Record "WDC-ED Payment Step";
                begin
                    VarReport := TRUE;
                    Steps.SETRANGE("Payment Class", Rec."Payment Class");
                    Steps.SETRANGE("Previous Status", Rec."Status No.");
                    Steps.SETRANGE("Action Type", Steps."Action Type"::Report);
                    ValidatePayment;
                    VarReport := FALSE;


                end;
            }
        }
    }
    trigger OnAfterGetRecord()
    var
        PaymentStatus: Record "WDC-ED Payment Status";
        PayementHeader: Record "WDC-ED Payment Header";
    begin
        CLEAR(PaymentClass);
        IF PaymentClass.GET(Rec."Payment Class") THEN
            CurrPage.Lines.PAGE.EnablePetiteDépense(PaymentClass."Small expense");
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        PaymentStatus: Record "WDC-ED Payment Status";
        PayementHeader: Record "WDC-ED Payment Header";
    begin
        IF PaymentClass.GET(Rec."Payment Class") THEN Begin
            CurrPage.Lines.PAGE.EnablePetiteDépense(PaymentClass."Small expense");

        end;
    end;


    local procedure ValidatePayment()
    var
        Steps: Record "WDC-ED Payment Step";
        PostingStatement: Codeunit "WDC-ST PaymentHook";
        Options: Text[800];
        Choice: Integer;
        I: Integer;
        Ok: Boolean;
    begin

        I := Steps.COUNT;
        Ok := FALSE;
        IF I = 1 THEN BEGIN
            Steps.Findfirst;
            Ok := CONFIRM(Steps.Name, TRUE);
        END ELSE
            IF I > 1 THEN BEGIN
                Steps.SETFILTER("Payment Class", '%1', Rec."Payment Class");
                Steps.SETFILTER("Previous Status", '%1', Rec."Status No.");
                Steps.SETFILTER("Action Type", '<>%1', Steps."Action Type"::"Create New Document");
                if VarReport THEN
                    Steps.SETRANGE("Action Type", Steps."Action Type"::Report) ELSE
                    Steps.SetFilter("Action Type", '<>%1', Steps."Action Type"::Report);
                IF Steps.FINDSET THEN BEGIN
                    REPEAT
                        IF Options = '' THEN
                            Options := Steps.Name
                        ELSE
                            Options := Options + ',' + Steps.Name;
                    UNTIL Steps.NEXT = 0;

                    Choice := STRMENU(Options, 1);

                    I := 1;
                    IF Choice > 0 THEN BEGIN
                        Ok := TRUE;
                        Steps.Findfirst;
                        WHILE Choice > I DO BEGIN
                            I += 1;
                            Steps.NEXT;
                        END;
                    END;
                END;
            END;

        IF Ok THEN
            PostingStatement.Valbord(Rec, Steps);
    end;

    var
        Text004: Label 'Vous n''êtes pas autorisé à faire des propositions de paiement chèques sur un bordereau validé.';
        PaymentClass: record 50860;
        BooGLineEditable: Boolean;
        VarReport: Boolean;

}