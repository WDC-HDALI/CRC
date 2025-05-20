pageextension 54031 "WDC-ST Acc. Schedule Overview" extends "Acc. Schedule Overview"
{
    layout
    {


    }

    actions
    {

        addafter(Print)
        {

            action("Imprimer tableau analyse")
            {

                Caption = 'Imprimer tableau analyse';
                ApplicationArea = All;

                trigger OnAction()
                var
                    // AccSched: Report "Account Schedule 2";
                    DateFilter2: Text;
                    GLBudgetFilter2: Text;
                    BusUnitFilter: Text;
                    CostBudgetFilter2: Text;

                BEGIN
                    // AccSched.SetAccSchedName(CurrentSchedName);
                    //  AccSched.SetColumnLayoutName(CurrentColumnName);
                    DateFilter2 := Rec.GETFILTER("Date Filter");
                    GLBudgetFilter2 := Rec.GETFILTER("G/L Budget Filter");
                    CostBudgetFilter2 := Rec.GETFILTER("Cost Budget Filter");
                    BusUnitFilter := Rec.GETFILTER("Business Unit Filter");
                    //   AccSched.SetFilters(DateFilter2, GLBudgetFilter2, CostBudgetFilter2, BusUnitFilter, Dim1Filter, Dim2Filter, Dim3Filter, Dim4Filter);
                    //  AccSched.RUN;
                end;
            }
            action("Etats Financiers")
            {

                Caption = 'Etats Financiers';
                ApplicationArea = All;

                trigger OnAction()
                var
                    // AccSched: Report "Account Schedule4";
                    DateFilter2: Text;
                    GLBudgetFilter2: Text;
                    BusUnitFilter: Text;
                    CostBudgetFilter2: Text;

                BEGIN
                    //   AccSched.SetAccSchedName(CurrentSchedName);
                    //  AccSched.SetColumnLayoutName(CurrentColumnName);
                    DateFilter2 := Rec.GETFILTER("Date Filter");
                    GLBudgetFilter2 := Rec.GETFILTER("G/L Budget Filter");
                    CostBudgetFilter2 := Rec.GETFILTER("Cost Budget Filter");
                    BusUnitFilter := Rec.GETFILTER("Business Unit Filter");
                    // AccSched.SetFilters(DateFilter2, GLBudgetFilter2, CostBudgetFilter2, BusUnitFilter, Dim1Filter, Dim2Filter, Dim3Filter, Dim4Filter);
                    // AccSched.RUN;
                end;
            }
            action("Notes Etats Financiers")
            {

                Caption = 'Notes Etats Financiers';
                ApplicationArea = All;

                trigger OnAction()
                var
                    //  AccSched: Report "Account Schedule Note";
                    DateFilter2: Text;
                    GLBudgetFilter2: Text;
                    BusUnitFilter: Text;
                    CostBudgetFilter2: Text;

                BEGIN
                    // AccSched.SetAccSchedName(CurrentSchedName);
                    // AccSched.SetColumnLayoutName(CurrentColumnName);
                    DateFilter2 := Rec.GETFILTER("Date Filter");
                    GLBudgetFilter2 := Rec.GETFILTER("G/L Budget Filter");
                    CostBudgetFilter2 := Rec.GETFILTER("Cost Budget Filter");
                    BusUnitFilter := Rec.GETFILTER("Business Unit Filter");
                    // AccSched.SetFilters(DateFilter2, GLBudgetFilter2, CostBudgetFilter2, BusUnitFilter, Dim1Filter, Dim2Filter, Dim3Filter, Dim4Filter);
                    // AccSched.RUN;
                end;
            }

        }

    }
    Var
        CurrentSchedName: Code[10];
        CurrentColumnName: Code[10];
        Dim1Filter: Text;
        Dim2Filter: Text;
        Dim3Filter: Text;
        Dim4Filter: Text;

}





