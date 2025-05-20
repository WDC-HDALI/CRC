report 50887 "WDC-ED Pay. Practices Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './.vscode/src_ED/report/RDLC/PaymentPracticesReporting.rdlc';
    ApplicationArea = All;
    captionML = ENU = 'Payment Practices Reporting', FRA = 'Génération d''états des pratiques de paiement';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Integer"; "Integer")
        {
            DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
            column(ShowInvoices; ShowInvoices)
            {
            }
            column(CurrDate; Format(CurrentDateTime))
            {
            }
            column(CompanyNameCaption; CompanyName)
            {
            }
            column(ReportNameLbl; ReportNameLbl)
            {
            }
            column(PageLbl; PageLbl)
            {
            }
            column(StartingDate; Format(StartingDate))
            {
            }
            column(EndingDate; Format(EndingDate))
            {
            }
            column(WorkDate; Format(WorkDate))
            {
            }
            column(StartingDateLbl; StartingDateLbl)
            {
            }
            column(EndingDateLbl; EndingDateLbl)
            {
            }
            column(WorkDateLbl; WorkDateLbl)
            {
            }
            column(TotalNotPaidLbl; TotalInvoicesLbl)
            {
            }
            column(InvoicesReceivedNotPaidLbl; InvoicesReceivedNotPaidLbl)
            {
            }
            column(InvoicesIssuedNotPaidLbl; InvoicesIssuedNotPaidLbl)
            {
            }
            column(InvoicedReceivedDelayedLbl; InvoicedReceivedDelayedLbl)
            {
            }
            column(InvoicesIssuedDelayedLbl; InvoicesIssuedDelayedLbl)
            {
            }
            column(AmountLbl; AmountLbl)
            {
            }
            column(TotalAmountLbl; TotalAmountLbl)
            {
            }
            column(PercentLbl; PercentLbl)
            {
            }
            column(TotalPercentLbl; TotalPercentLbl)
            {
            }
            column(TotalAmountOfInvoicesLbl; TotalAmountOfInvoicesLbl)
            {
            }
            column(TotalVendAmount; TotalVendAmount)
            {
            }
            column(TotalCustAmount; TotalCustAmount)
            {
            }
            column(VendPeriodLbl; PeriodLbl)
            {
            }
            column(VendPeriodAmountLbl; AmountLbl)
            {
            }
            column(VendPercentLbl; PercentLbl)
            {
            }
        }
        dataitem(VendNotPaidInDays; "WDC-ED Payment Period Setup")
        {
            DataItemTableView = SORTING(ID);
            column(NotPaidVendShowInvoices; ShowInvoices)
            {
            }
            column(NotPaidVendPeriod; Format("Days From") + '-' + Format("Days To"))
            {
            }
            column(NotPaidVendAmount; AmountByPeriod)
            {
            }
            column(NotPaidVendPct; PctByPeriod)
            {
            }
            column(NotPaidVendPctGrpNumber; GroupingNum)
            {
            }
            column(NotPaidVendPeriodLbl; PeriodLbl)
            {
            }
            column(NotPaidVendPeriodAmountLbl; AmountLbl)
            {
            }
            column(NotPaidVendPercentLbl; PercentLbl)
            {
            }
            dataitem(VendEntriesNotPaidInDays; "Integer")
            {
                DataItemTableView = SORTING(Number) WHERE(Number = FILTER(1 ..));
                column(NotPaidVendEntryNoLbl; EntryNoLbl)
                {
                }
                column(NotPaidVendNoLbl; VendNoLbl)
                {
                }
                column(NotPaidVendInvNoLbl; InvNoLbl)
                {
                }
                column(NotPaidVendExtDocNolbl; ExtDocNoLbl)
                {
                }
                column(NotPaidVendDueDateLbl; DueDateLbl)
                {
                }
                column(NotPaidVendAmountLbl; InitialAmountLbl)
                {
                }
                column(NotPaidVendAmountCorrectedLbl; AmountCorrectedLbl)
                {
                }
                column(NotPaidVendRemainingAmountLbl; RemainingAmountLbl)
                {
                }
                column(NotPaidVendInvEntryNo; TempVendPmtApplicationBuffer."Invoice Entry No.")
                {
                }
                column(NotPaidVendNo; TempVendPmtApplicationBuffer."CV No.")
                {
                }
                column(NotPaidVendDocNo; TempVendPmtApplicationBuffer."Invoice Doc. No.")
                {
                }
                column(NotPaidVendExtDocNo; TempVendPmtApplicationBuffer."Inv. External Document No.")
                {
                }
                column(NotPaidVendDueDate; Format(TempVendPmtApplicationBuffer."Due Date"))
                {
                }
                column(NotPaidVendInvAmount; TempVendPmtApplicationBuffer."Entry Amount (LCY)")
                {
                }
                column(NotPaidVendInvAmountCorrected; TempVendPmtApplicationBuffer."Entry Amount Corrected (LCY)")
                {
                }
                column(NotPaidVendRemainingAmount; TempVendPmtApplicationBuffer."Remaining Amount (LCY)")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if Number <> 1 then
                        if TempVendPmtApplicationBuffer.Next = 0 then
                            CurrReport.Break();
                end;

                trigger OnPreDataItem()
                begin
                    if ShowInvoices then
                        TempVendPmtApplicationBuffer.FindSet
                    else
                        CurrReport.Break();
                end;
            }

            trigger OnAfterGetRecord()
            begin
                if not PaymentReportingMgt.PrepareNotPaidInDaysSource(TempVendPmtApplicationBuffer, "Days From", "Days To") then
                    CurrReport.Skip();

                TempVendPmtApplicationBuffer.CalcSumOfAmountFields;
                AmountByPeriod := TempVendPmtApplicationBuffer."Remaining Amount (LCY)";
                PctByPeriod := PaymentReportingMgt.GetPctOfPmtsNotPaidInDays(TempVendPmtApplicationBuffer, TotalVendAmount);
                TotalInvoices += TempVendPmtApplicationBuffer.Count();
                TotalAmtByPeriod += AmountByPeriod;
                TotalPctByPeriod += PctByPeriod;
                GroupingNum += 1;
            end;

            trigger OnPreDataItem()
            begin
                TotalInvoices := 0;
                TotalAmtByPeriod := 0;
                TotalPctByPeriod := 0;
            end;
        }
        dataitem(NotPaidVendTotal; "Integer")
        {
            DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
            column(NotPaidVendTotalInvoices; TotalInvoices)
            {
            }
            column(NotPaidVendTotalAmtByPeriod; TotalAmtByPeriod)
            {
            }
            column(NotPaidVendTotalPctByPeriod; TotalPctByPeriod)
            {
            }
        }
        dataitem(VendDelayedInDays; "WDC-ED Payment Period Setup")
        {
            DataItemTableView = SORTING(ID);
            column(DelayedVendShowInvoices; ShowInvoices)
            {
            }
            column(DelayedVendPeriod; Format("Days From") + '-' + Format("Days To"))
            {
            }
            column(DelayedVendAmount; AmountByPeriod)
            {
            }
            column(DelayedVendPct; PctByPeriod)
            {
            }
            column(DelayedVendPctGrpNumber; GroupingNum)
            {
            }
            column(DelayedVendPeriodLbl; PeriodLbl)
            {
            }
            column(DelayedVendPeriodAmountLbl; AmountLbl)
            {
            }
            column(DelayedVendPercentLbl; PercentLbl)
            {
            }
            dataitem(VendEntriesDelayedInDays; "Integer")
            {
                DataItemTableView = SORTING(Number) WHERE(Number = FILTER(1 ..));
                column(DelayedVendEntryNoLbl; EntryNoLbl)
                {
                }
                column(DelayedVendPmtEntryNoLbl; PmtEntryNoLbl)
                {
                }
                column(DelayedVendNoLbl; VendNoLbl)
                {
                }
                column(DelayedVendInvNoLbl; InvNoLbl)
                {
                }
                column(DelayedVendPmtNoLbl; PmtNoLbl)
                {
                }
                column(DelayedVendExtDocNolbl; ExtDocNoLbl)
                {
                }
                column(DelayedVendDueDateLbl; DueDateLbl)
                {
                }
                column(DelayedVendPmtPostingDateLbl; PmtPostingDateLbl)
                {
                }
                column(DelayedVendPmtAmountLbl; PmtAmountLbl)
                {
                }
                column(DelayedVendInvEntryNo; TempVendPmtApplicationBuffer."Invoice Entry No.")
                {
                }
                column(DelayedVendNo; TempVendPmtApplicationBuffer."CV No.")
                {
                }
                column(DelayedVendDocNo; TempVendPmtApplicationBuffer."Invoice Doc. No.")
                {
                }
                column(DelayedVendExtDocNo; TempVendPmtApplicationBuffer."Inv. External Document No.")
                {
                }
                column(DelayedVendDueDate; Format(TempVendPmtApplicationBuffer."Due Date"))
                {
                }
                column(DelayedVendPmtPostingDate; Format(TempVendPmtApplicationBuffer."Pmt. Posting Date"))
                {
                }
                column(DelayedVendPmtEntryNo; TempVendPmtApplicationBuffer."Pmt. Entry No.")
                {
                }
                column(DelayedVendPmtNo; TempVendPmtApplicationBuffer."Pmt. Doc. No.")
                {
                }
                column(DelayedVendPmtAmount; TempVendPmtApplicationBuffer."Pmt. Amount (LCY)")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if Number <> 1 then
                        if TempVendPmtApplicationBuffer.Next = 0 then
                            CurrReport.Break();
                end;

                trigger OnPreDataItem()
                begin
                    if ShowInvoices then
                        TempVendPmtApplicationBuffer.FindSet
                    else
                        CurrReport.Break();
                end;
            }

            trigger OnAfterGetRecord()
            begin
                if not PaymentReportingMgt.PrepareDelayedPmtInDaysSource(TempVendPmtApplicationBuffer, "Days From", "Days To") then
                    CurrReport.Skip();

                TempVendPmtApplicationBuffer.CalcSumOfAmountFields;
                AmountByPeriod := TempVendPmtApplicationBuffer."Pmt. Amount (LCY)";
                PctByPeriod := PaymentReportingMgt.GetPctOfPmtsDelayedInDays(TempVendPmtApplicationBuffer, TotalVendAmount);
                TotalInvoices += TempVendPmtApplicationBuffer.Count();
                TotalAmtByPeriod += AmountByPeriod;
                TotalPctByPeriod += PctByPeriod;
                GroupingNum += 1;
            end;

            trigger OnPreDataItem()
            begin
                TotalInvoices := 0;
                TotalAmtByPeriod := 0;
                TotalPctByPeriod := 0;
            end;
        }
        dataitem(VendDelayedTotal; "Integer")
        {
            DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
            column(DelayedVendTotalInvoices; TotalInvoices)
            {
            }
            column(DelayedVendTotalAmtByPeriod; TotalAmtByPeriod)
            {
            }
            column(DelayedVendTotalPctByPeriod; TotalPctByPeriod)
            {
            }

            trigger OnPostDataItem()
            begin
                TotalInvoices := 0;
                TotalAmtByPeriod := 0;
                TotalPctByPeriod := 0;
            end;
        }
        dataitem(CustNotPaidInDays; "WDC-ED Payment Period Setup")
        {
            DataItemTableView = SORTING(ID);
            column(NotPaidCustShowInvoices; ShowInvoices)
            {
            }
            column(NotPaidCustPeriod; Format("Days From") + '-' + Format("Days To"))
            {
            }
            column(NotPaidCustAmount; AmountByPeriod)
            {
            }
            column(NotPaidCustPct; PctByPeriod)
            {
            }
            column(NotPaidCustPctGrpNumber; GroupingNum)
            {
            }
            column(NotPaidCustPeriodLbl; PeriodLbl)
            {
            }
            column(NotPaidCustPeriodAmountLbl; AmountLbl)
            {
            }
            column(NotPaidCustPercentLbl; PercentLbl)
            {
            }
            dataitem(CustEntriesNotPaidInDays; "Integer")
            {
                DataItemTableView = SORTING(Number) WHERE(Number = FILTER(1 ..));
                column(NotPaidCustEntryNoLbl; EntryNoLbl)
                {
                }
                column(NotPaidCustNoLbl; CustNoLbl)
                {
                }
                column(NotPaidCustInvNoLbl; InvNoLbl)
                {
                }
                column(NotPaidCustDueDateLbl; DueDateLbl)
                {
                }
                column(NotPaidCustAmountLbl; InitialAmountLbl)
                {
                }
                column(NotPaidCustAmountCorrectedLbl; AmountCorrectedLbl)
                {
                }
                column(NotPaidCustRemainingAmountLbl; RemainingAmountLbl)
                {
                }
                column(NotPaidCustInvEntryNo; TempCustPmtApplicationBuffer."Invoice Entry No.")
                {
                }
                column(NotPaidCustNo; TempCustPmtApplicationBuffer."CV No.")
                {
                }
                column(NotPaidCustDocNo; TempCustPmtApplicationBuffer."Invoice Doc. No.")
                {
                }
                column(NotPaidCustDueDate; Format(TempCustPmtApplicationBuffer."Due Date"))
                {
                }
                column(NotPaidCustInvAmount; TempCustPmtApplicationBuffer."Entry Amount (LCY)")
                {
                }
                column(NotPaidCustInvAmountCorrected; TempCustPmtApplicationBuffer."Entry Amount Corrected (LCY)")
                {
                }
                column(NotPaidCustRemainingAmount; TempCustPmtApplicationBuffer."Remaining Amount (LCY)")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if Number <> 1 then
                        if TempCustPmtApplicationBuffer.Next = 0 then
                            CurrReport.Break();
                end;

                trigger OnPreDataItem()
                begin
                    if ShowInvoices then
                        TempCustPmtApplicationBuffer.FindSet
                    else
                        CurrReport.Break();
                end;
            }

            trigger OnAfterGetRecord()
            begin
                if not PaymentReportingMgt.PrepareNotPaidInDaysSource(TempCustPmtApplicationBuffer, "Days From", "Days To") then
                    CurrReport.Skip();

                TempCustPmtApplicationBuffer.CalcSumOfAmountFields;
                AmountByPeriod := TempCustPmtApplicationBuffer."Remaining Amount (LCY)";
                PctByPeriod := PaymentReportingMgt.GetPctOfPmtsNotPaidInDays(TempCustPmtApplicationBuffer, TotalCustAmount);
                TotalInvoices += TempCustPmtApplicationBuffer.Count();
                TotalAmtByPeriod += AmountByPeriod;
                TotalPctByPeriod += PctByPeriod;
                GroupingNum += 1;
            end;

            trigger OnPreDataItem()
            begin
                TotalInvoices := 0;
                TotalAmtByPeriod := 0;
                TotalPctByPeriod := 0;
            end;
        }
        dataitem(NotPaidCustTotal; "Integer")
        {
            DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
            column(NotPaidCustTotalInvoices; TotalInvoices)
            {
            }
            column(NotPaidCustTotalAmtByPeriod; TotalAmtByPeriod)
            {
            }
            column(NotPaidCustTotalPctByPeriod; TotalPctByPeriod)
            {
            }
        }
        dataitem(CustDelayedInDays; "WDC-ED Payment Period Setup")
        {
            DataItemTableView = SORTING(ID);
            column(DelayedCustShowInvoices; ShowInvoices)
            {
            }
            column(DelayedCustPeriod; Format("Days From") + '-' + Format("Days To"))
            {
            }
            column(DelayedCustAmount; AmountByPeriod)
            {
            }
            column(DelayedCustPct; PctByPeriod)
            {
            }
            column(DelayedCustPctGrpNumber; GroupingNum)
            {
            }
            column(DelayedCustPeriodLbl; PeriodLbl)
            {
            }
            column(DelayedCustPeriodAmountLbl; AmountLbl)
            {
            }
            column(DelayedCustPercentLbl; PercentLbl)
            {
            }
            dataitem(CustEntriesDelayedInDays; "Integer")
            {
                DataItemTableView = SORTING(Number) WHERE(Number = FILTER(1 ..));
                column(DelayedCustEntryNoLbl; EntryNoLbl)
                {
                }
                column(DelayedCustPmtEntryNoLbl; PmtEntryNoLbl)
                {
                }
                column(DelayedCustNoLbl; CustNoLbl)
                {
                }
                column(DelayedCustInvNoLbl; InvNoLbl)
                {
                }
                column(DelayedCustPmtNoLbl; PmtNoLbl)
                {
                }
                column(DelayedCustDueDateLbl; DueDateLbl)
                {
                }
                column(DelayedCustPmtPostingDateLbl; PmtPostingDateLbl)
                {
                }
                column(DelayedCustPmtAmountLbl; PmtAmountLbl)
                {
                }
                column(DelayedCustInvEntryNo; TempCustPmtApplicationBuffer."Invoice Entry No.")
                {
                }
                column(DelayedCustNo; TempCustPmtApplicationBuffer."CV No.")
                {
                }
                column(DelayedCustDocNo; TempCustPmtApplicationBuffer."Invoice Doc. No.")
                {
                }
                column(DelayedCustDueDate; Format(TempCustPmtApplicationBuffer."Due Date"))
                {
                }
                column(DelayedCustPmtPostingDate; Format(TempCustPmtApplicationBuffer."Pmt. Posting Date"))
                {
                }
                column(DelayedCustPmtEntryNo; TempCustPmtApplicationBuffer."Pmt. Entry No.")
                {
                }
                column(DelayedCustPmtNo; TempCustPmtApplicationBuffer."Pmt. Doc. No.")
                {
                }
                column(DelayedCustPmtAmount; TempCustPmtApplicationBuffer."Pmt. Amount (LCY)")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if Number <> 1 then
                        if TempCustPmtApplicationBuffer.Next = 0 then
                            CurrReport.Break();
                end;

                trigger OnPreDataItem()
                begin
                    if ShowInvoices then
                        TempCustPmtApplicationBuffer.FindSet
                    else
                        CurrReport.Break();
                end;
            }

            trigger OnAfterGetRecord()
            begin
                if not PaymentReportingMgt.PrepareDelayedPmtInDaysSource(TempCustPmtApplicationBuffer, "Days From", "Days To") then
                    CurrReport.Skip();

                TempCustPmtApplicationBuffer.CalcSumOfAmountFields;
                AmountByPeriod := TempCustPmtApplicationBuffer."Pmt. Amount (LCY)";
                PctByPeriod := PaymentReportingMgt.GetPctOfPmtsDelayedInDays(TempCustPmtApplicationBuffer, TotalCustAmount);
                TotalInvoices += TempCustPmtApplicationBuffer.Count();
                TotalAmtByPeriod += AmountByPeriod;
                TotalPctByPeriod += PctByPeriod;
                GroupingNum += 1;
            end;

            trigger OnPreDataItem()
            begin
                TotalInvoices := 0;
                TotalAmtByPeriod := 0;
                TotalPctByPeriod := 0;
            end;
        }
        dataitem(CustDelayedTotal; "Integer")
        {
            DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
            column(DelayedCustTotalInvoices; TotalInvoices)
            {
            }
            column(DelayedCustTotalAmtByPeriod; TotalAmtByPeriod)
            {
            }
            column(DelayedCustTotalPctByPeriod; TotalPctByPeriod)
            {
            }

            trigger OnPostDataItem()
            begin
                TotalInvoices := 0;
                TotalAmtByPeriod := 0;
                TotalPctByPeriod := 0;
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    captionML = ENU = 'Options', FRA = 'Options';
                    field(StartingDate; StartingDate)
                    {
                        ApplicationArea = All;
                        captionML = ENU = 'Starting Date', FRA = 'Date début';

                        trigger OnValidate()
                        begin
                            CheckDateConsistency;
                        end;
                    }
                    field(EndingDate; EndingDate)
                    {
                        ApplicationArea = All;
                        captionML = ENU = 'Ending Date', FRA = 'Date fin';
                        trigger OnValidate()
                        begin
                            CheckDateConsistency;
                        end;
                    }
                    field(ShowInvoices; ShowInvoices)
                    {
                        ApplicationArea = All;
                        captionML = ENU = 'Show Invoices', FRA = 'Afficher les factures';
                    }
                    field(PaymentsWithinPeriod; PaymentsWithinPeriod)
                    {
                        ApplicationArea = All;
                        captionML = ENU = 'Payments within period', FRA = 'Paiements sur la période';
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

    trigger OnPreReport()
    var
        PaymentPeriodSetup: Record "WDC-ED Payment Period Setup";
    begin
        if (StartingDate = 0D) or (EndingDate = 0D) then
            Error(DatesNotSpecifiedErr);
        if PaymentPeriodSetup.IsEmpty then
            Error(PaymentPeriodSetupEmptyErr);
        PaymentReportingMgt.BuildVendPmtApplicationBuffer(TempVendPmtApplicationBuffer, StartingDate, EndingDate, PaymentsWithinPeriod);
        PaymentReportingMgt.BuildCustPmtApplicationBuffer(TempCustPmtApplicationBuffer, StartingDate, EndingDate, PaymentsWithinPeriod);
        if TempVendPmtApplicationBuffer.IsEmpty and TempCustPmtApplicationBuffer.IsEmpty then
            Error(NoInvoicesForPeriodErr);
        TotalVendAmount := PaymentReportingMgt.GetTotalAmount(TempVendPmtApplicationBuffer);
        TotalCustAmount := PaymentReportingMgt.GetTotalAmount(TempCustPmtApplicationBuffer);
    end;

    local procedure CheckDateConsistency()
    begin
        if (StartingDate <> 0D) and (EndingDate <> 0D) and (StartingDate > EndingDate) then
            Error(StartingDateLaterThanEndingDateErr);
    end;

    var
        TempVendPmtApplicationBuffer: Record "WDC-ED Pay. Application Buffer" temporary;
        TempCustPmtApplicationBuffer: Record "WDC-ED Pay. Application Buffer" temporary;
        PaymentReportingMgt: Codeunit "WDC-ED Payment Reporting Mgt.";
        StartingDate: Date;
        EndingDate: Date;
        ShowInvoices: Boolean;
        PaymentsWithinPeriod: Boolean;
        TotalVendAmount: Decimal;
        TotalCustAmount: Decimal;
        AmountByPeriod: Decimal;
        PctByPeriod: Decimal;
        TotalInvoices: Integer;
        TotalAmtByPeriod: Decimal;
        TotalPctByPeriod: Decimal;
        GroupingNum: Integer;
        StartingDateLaterThanEndingDateErr: TextConst ENU = 'Starting date cannot be later than ending date.',
                                                      FRA = 'La date de début ne peut pas être postérieure à la date de fin.';
        DatesNotSpecifiedErr: TextConst ENU = 'Both starting date and ending date must be specified.',
                                        FRA = 'Une date de début et une date de fin doivent être spécifiées.';
        PaymentPeriodSetupEmptyErr: TextConst ENU = 'You must update Payment Period Setup before running this report.',
                                              FRA = 'Vous devez mettre à jour la configuration de l''échéance avant d''exécuter cet état.';
        NoInvoicesForPeriodErr: TextConst ENU = 'No invoices posted for specified period.',
                                          FRA = 'Aucune facture validée pour la période spécifiée.';
        StartingDateLbl: TextConst ENU = 'Starting date',
                                   FRA = 'Date début';
        EndingDateLbl: TextConst ENU = 'Ending date',
                                 FRA = 'Date fin';
        WorkDateLbl: TextConst ENU = 'Work date',
                               FRA = 'Date de travail';
        ReportNameLbl: TextConst ENU = 'Payment Practices Reporting',
                                 FRA = 'Génération d''états des pratiques de paiement';
        PageLbl: TextConst ENU = 'Page',
                           FRA = 'Page';
        InvoicesReceivedNotPaidLbl: TextConst ENU = 'Invoices received not paid on the closing date of the year in which the term has expired:',
                                              FRA = 'Factures reçues non payées à la date de clôture de l''année à laquelle la condition a expiré:';
        InvoicesIssuedNotPaidLbl: TextConst ENU = 'Invoices issued not paid on the closing date of the year in which the term has expired:',
                                            FRA = 'Factures émises non payées à la date de clôture de l''année à laquelle la condition a expiré:';
        InvoicedReceivedDelayedLbl: TextConst ENU = 'Invoices received that have been delayed in payment during the year:',
                                              FRA = 'Factures reçues qui ont eu un retard de paiement au cours de l''année:';
        InvoicesIssuedDelayedLbl: TextConst ENU = 'Invoices issued that have been delayed in payment during the year:',
                                            FRA = 'Factures émises qui ont eu un retard de paiement au cours de l''année:';
        PeriodLbl: TextConst ENU = 'Period',
                             FRA = 'Période.';
        VendNoLbl: TextConst ENU = 'Vendor No.',
                             FRA = 'N° de fournisseur';
        CustNoLbl: TextConst ENU = 'Customer No.',
                             FRA = 'N° de client';
        InvNoLbl: TextConst ENU = 'Invoice No.',
                            FRA = 'N° de facture';
        PmtNoLbl: TextConst ENU = 'Payment No.',
                            FRA = 'N° de règlement';
        DueDateLbl: TextConst ENU = 'Due Date',
                              FRA = 'Date d''échéance';
        PercentLbl: TextConst ENU = '%',
                              FRA = '%';
        TotalPercentLbl: TextConst ENU = 'Total %',
                                   FRA = '% total';
        EntryNoLbl: TextConst ENU = 'Entry No.',
                              FRA = 'N° séquence';
        PmtEntryNoLbl: TextConst ENU = 'Pmt. Entry No.',
                                 FRA = 'N° écriture paiem.';
        ExtDocNoLbl: TextConst ENU = 'External Doc. No.',
                               FRA = 'N° doc. externe';
        InitialAmountLbl: TextConst ENU = 'Amount',
                                    FRA = 'Montant';
        AmountLbl: TextConst ENU = 'Amount',
                             FRA = 'Montant';
        TotalAmountLbl: TextConst ENU = 'Total Amount',
                                  FRA = 'Montant total';
        AmountCorrectedLbl: TextConst ENU = 'Amount Corrected',
                                      FRA = 'Montant corrigé';
        PmtPostingDateLbl: TextConst ENU = 'Payment posting date',
                                     FRA = 'Date comptabilisation règlement';
        PmtAmountLbl: TextConst ENU = 'Payment amount',
                                FRA = 'Montant du règlement';
        RemainingAmountLbl: TextConst ENU = 'Amount Due',
                                      FRA = 'Montant dû';
        TotalInvoicesLbl: TextConst ENU = 'Total invoices',
                                    FRA = 'Factures totales';
        TotalAmountOfInvoicesLbl: TextConst ENU = 'Total amount of invoices (Corrected)',
                                            FRA = 'Montant total des factures (corrigé)';
}

