report 50872 "WDC-ED Duplicate parameter"
{
    captionML = ENU = 'Duplicate parameter', FRA = 'Dupliquer le paramètre';
    ProcessingOnly = true;

    dataset
    {
        dataitem(PaymentClass; "WDC-ED Payment Class")
        {
            DataItemTableView = SORTING(Code);

            trigger OnAfterGetRecord()
            var
                PaymtClass: Record "WDC-ED Payment Class";
            begin
                PaymtClass.Copy(PaymentClass);
                PaymtClass.Name := '';
                PaymtClass.Validate(Code, NewName);
                PaymtClass.Insert();
            end;

            trigger OnPreDataItem()
            begin
                VerifyNewName;
            end;
        }
        dataitem("Payment Status"; "WDC-ED Payment Status")
        {
            DataItemTableView = SORTING("Payment Class", "Line No.");

            trigger OnAfterGetRecord()
            var
                PaymtStatus: Record "WDC-ED Payment Status";
            begin
                PaymtStatus.Copy("Payment Status");
                PaymtStatus.Validate("Payment Class", NewName);
                PaymtStatus.Insert();
            end;

            trigger OnPreDataItem()
            begin
                SetRange("Payment Class", PaymentClass.Code);
            end;
        }
        dataitem("Payment Step"; "WDC-ED Payment Step")
        {
            DataItemTableView = SORTING("Payment Class", "Line No.");

            trigger OnAfterGetRecord()
            var
                PaymtStep: Record "WDC-ED Payment Step";
            begin
                PaymtStep.Copy("Payment Step");
                PaymtStep.Validate("Payment Class", NewName);
                PaymtStep.Insert();
            end;

            trigger OnPreDataItem()
            begin
                SetRange("Payment Class", PaymentClass.Code);
            end;
        }
        dataitem("Payment Step Ledger"; "WDC-ED Payment Step Ledger")
        {
            DataItemTableView = SORTING("Payment Class", "Line No.", Sign);

            trigger OnAfterGetRecord()
            var
                PaymtStepLedger: Record "WDC-ED Payment Step Ledger";
            begin
                PaymtStepLedger.Copy("Payment Step Ledger");
                PaymtStepLedger.Validate("Payment Class", NewName);
                PaymtStepLedger.Insert();
            end;

            trigger OnPreDataItem()
            begin
                SetRange("Payment Class", PaymentClass.Code);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    captionML = ENU = 'Options', FRA = 'Options';
                    group("Which name do you want to attribute to the new parameter?")
                    {
                        captionML = ENU = 'Which name do you want to attribute to the new parameter?', FRA = 'Quel nom voulez-vous attribuer au nouveau paramètre ?';
                        field(OldName; OldName)
                        {
                            ApplicationArea = All;
                            captionML = ENU = 'Old name', FRA = 'Ancien nom';
                            Editable = false;
                        }
                        field(NewName; NewName)
                        {
                            ApplicationArea = All;
                            captionML = ENU = 'New name', FRA = 'Nouveau nom';
                        }
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    procedure InitParameter("Code": Text[30])
    begin
        OldName := Code;
    end;

    procedure VerifyNewName()
    var
        PaymtClass: Record "WDC-ED Payment Class";
    begin
        if NewName = '' then
            Error(Text000);
        if PaymtClass.Get(NewName) then
            Error(Text001, NewName);
    end;

    var
        OldName: Text[30];
        NewName: Text[30];
        Text000: TextConst ENU = 'You must define a new name.',
                           FRA = 'Vous devez définir un nouveau nom.';
        Text001: TextConst ENU = 'Name %1 already exist. Please define another name.',
                           FRA = 'Le nom %1 existe déjà. Veuillez définir un autre nom.';
}

