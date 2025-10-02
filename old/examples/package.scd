id: PL001
type: product_contract
tier: 1
name: Personal Loan
category: personal_loan
description: Personal loan with EMI installment method and periodic schedule type.
author: yurii.biurher@zorallabs.com
org_unit: Head Office
timezone: UTC

parameters:
    general_charge_1: {type: decimal, optional: true, group_name: General Charges, group_order: 1, description: ""}
    general_charge_2: {type: decimal, optional: true, group_name: General Charges, group_order: 2, description: ""}

    ledger: {type: ledger, default: general, group_name: "Core", group_order: 1, description: ""}
    currency_code: {type: currency, group_name: "Core", group_order: 2, description: ""}
    open_date: {type: date_time, optional: true, group_name: Core, group_order: 3, description: ""}
    close_date: {type: date_time, optional: true, group_name: Core, group_order: 3, description: ""}
    loan_amount: {type: decimal, group_name: "Core", group_order: 4, description: "Loan amount approved."}
    loan_period: {type: integer, default: 12, group_name: "Core", group_order: 5, description: "Loan period in months."}

    disbursement_transaction_type: {type: transaction_type, default: system, group_name: "Constants", group_order: 1, description: ""}
    interest_transaction_type: {type: transaction_type, default: debit_interest, group_name: "Constants", group_order: 2, description: ""}
    service_charge_transaction_type: {type: transaction_type, default: fee, group_name: "Constants", group_order: 3, description: ""}
    demand_generation_transaction_type: {type: transaction_type, default: system, group_name: "Constants", group_order: 4, description: "Transaction type for demand generation."}
    demand_satisfaction_transaction_type: {type: transaction_type, default: system, group_name: "Constants", group_order: 4, description: "Transaction type for demand satisfaction."}

    disbursement_posting_type: {type: posting_type, default: internal, group_name: "Constants", group_order: 5, description: ""}
    interest_posting_type: {type: posting_type, default: interest, group_name: "Constants", group_order: 6, description: ""}
    penalty_interest_posting_type: {type: posting_type, default: interest, group_name: "Constants", group_order: 7, description: ""}
    service_charge_posting_type: {type: posting_type, default: fee, group_name: "Constants", group_order: 8, description: ""}
    demand_posting_type: {type: posting_type, default: demand, group_name: "Constants", group_order: 9, description: "Posting type for demand."}
    system_recovery_posting_type: {type: posting_type, default: system_recovery, group_name: "Constants", group_order: 10, description: "Posting type for system recovery."}
    manual_recovery_posting_type: {type: posting_type, default: manual_recovery, group_name: "Constants", group_order: 11, description: "Posting type for manual recovery."}
    principle_posting_type: {type: posting_type, default: internal, group_name: "Constants", group_order: 12, description: "Posting type for principle."}

    interest_receivable_balance_id: {type: balance_id, group_name: "Balances", group_order: 1, description: "Balance sheet account for interest receivable."}
    interest_earned_balance_id: {type: balance_id, group_name: "Balances", group_order: 2, description: "P&L account for paid earned."}
    penalty_interest_earned_balance_id: {type: balance_id, group_name: "Balances", group_order: 3, description: "P&L account for penalty interest."}
    service_charge_collection_balance_id: {type: balance_id, group_name: "Balances", group_order: 4, description: "P&L account for charges collected."}
    loan_repayment_balance_id: {type: balance_id, group_name: "Balances", group_order: 5, description: "Account where repayment amount should be deducted from."}
    loan_disbursement_balance_id: {type: balance_id, group_name: "Balances", group_order: 6, description: "Account where loan is disbursed."}

    fixed_base_interest_rate: {type: dated_rate, group_name: "Interest", group_order: 2, description: "Base interest rate and effective date."}
    interest_day_basis: {type: enum, enum_values: ["360", "365", "actual"], default: actual, group_name: "Interest", group_order: 5, description: "Define interest day basis."}
    interest_book_frequency: {type: enum, enum_values: ["daily", "weekly", "monthly"], default: monthly, group_name: "Interest", group_order: 6, description: "Frequency of interest booking."}
    interest_book_date: {type: integer, default: 1, group_name: "Interest", group_order: 7, description: "Date of interest booking. Applicable only for interest_book_frequency=monthly."}
    interest_book_day: {type: enum, enum_values: ["sunday", "monday", "tuesday", "wednesday", "thursday", "friday", "saturday"], default: friday, group_name: "Interest", group_order: 8, description: "Day of interest booking. Applicable only for interest_book_frequency=weekly."}
    interest_review_start: {type: datetime, optional: true, group_name: "Interest", group_order: 9, description: "Only applicable for floating model."}
    interest_review_frequency: {type: enum, optional: true, enum_values: ["1W", "1M", "3M", "1Y"], default: "1M", group_name: "Interest", group_order: 10, description: ""}
    customer_preferential_rate: {type: decimal, default: -0.5, group_name: "Interest", group_order: 12, description: "Account specific interest margin in tiers. This will be added on top of fixed_base_interest_rate or floating_interest_margin."}
    min_interest_rate: {type: decimal, default: 5, group_name: "Interest", group_order: 13, description: "Minimum interest rate allowed for the loan product."}
    max_interest_rate: {type: decimal, default: 15, group_name: "Interest", group_order: 14, description: "Maximum interest rate allowed for the loan product."}
    penalty_interest_rate: {type: decimal, default: 3, group_name: "Interest", group_order: 15, description: "Additional interest to be charged for amount in arrears."}

    delinquency_classification_execution_frequency: {type: enum, enum_values: ["weekly", "monthly"], default: monthly, group_name: "Delinquency", group_order: 1, description: "The recurring cycle the batch process should be executed."}
    delinquency_classification_execution_date: {type: integer, default: 15, optional: true, group_name: "Delinquency", group_order: 2, description: "Date of the execution of the month."}
    delinquency_classification_execution_day: {type: enum, enum_values: ["sunday", "monday", "tuesday", "wednesday", "thursday", "friday", "saturday"], optional: true, group_name: "Delinquency", group_order: 3, description: "Date of the execution of the week."}
    delinquency_classification: {type: json, default: [{installments: 1, category: "current"}, {installments: 2, category: "watch"}, {installments: 3, category: "overdue"}, {installments: 6, category: "loss"}], group_name: "Delinquency", group_order: 4, description: "The classification of facility based on the arrears. This is based on the number of installments that are in arrears."}
    capital_provision_haircut: {type: json, default: [{category: "current", percentage: 0}, {category: "watch", percentage: 0}, {category: "overdue", percentage: 0.2}, {category: "loss", percentage: 1}], group_name: "Delinquency", group_order: 5, description: "Haircut for the capital provision."}
    interest_in_suspense_activation: {type: integer, default: 3, group_name: "Delinquency", group_order: 6, description: "Delinquency stage to activate interest in suspense (period count in arrears)."}

    term_type: {type: enum, enum_values: ["day", "week", "month"], default: month, group_name: "Installment", group_order: 1, description: "Type of product term. Applicable only for periodic type."}
    installment_demand_date: {type: integer, default: 25, group_name: "Installment", group_order: 2, description: "Applicable only for term_type=month."}
    installment_demand_day: {type: enum, enum_values: ["sunday", "monday", "tuesday", "wednesday", "thursday", "friday", "saturday"], default: friday, group_name: "Installment", group_order: 3, description: "Applicable only for term_type=week."}

    loan_processing_fee: {type: tiered_rate, default: "0:0.5, 50000:0.8", group_name: "Fees", group_order: 1, description: "Loan processing charge as a percentage of the loan value."}
    early_settlement_fee: {type: tiered_rate, default: "0:0, 3:0.25, 6:0.5", group_name: "Fees", group_order: 2, description: "Charge for settling the loan before the contract period (remaining_period:percentage). Use the same frequency (installment or principle)."}

    transaction_charges: {type: json, default: {"External FT": [{threshold: 50000, fee: 0.50}]}, group_name: "Other", group_order: 2, description: "Define types of transaction charges."}
    facility_classification: {type: string, default: current, group_name: "Other", group_order: 3, description: "Current faculty classification."}

    loan_interest_rate: {type: decimal, default: 0, group_name: "Calculated", group_order: 1, description: "Rate of the loan calculated based on fixed_base_interest_rate and account open date."}
    emi_amount: {type: decimal, default: 0, group_name: "Calculated", group_order: 2, description: "EMI amount calculated based on the loan amount, interest rate and period."}
    primary_is_zero: {type: boolean, default: false, group_name: "Calculated", group_order: 3, description: "Flag to indicate if the primary balance is zero."}
    arrears_principle_is_zero: {type: boolean, default: false, group_name: "Calculated", group_order: 4, description: "Flag to indicate if the arrears principle balance is zero."}
    arrears_interest_is_zero: {type: boolean, default: false, group_name: "Calculated", group_order: 5, description: "Flag to indicate if the arrears interest balance is zero."}
    debit_interest_accrual_is_zero: {type: boolean, default: false, group_name: "Calculated", group_order: 6, description: "Flag to indicate if the debit interest accrual balance is zero."}
    debit_interest_booked_is_zero: {type: boolean, default: false, group_name: "Calculated", group_order: 7, description: "Flag to indicate if the debit interest booked balance is zero."}
    penal_interest_accrual_is_zero: {type: boolean, default: false, group_name: "Calculated", group_order: 8, description: "Flag to indicate if the penalty interest accrual balance is zero."}

balances:
    primary: {ledger: general, type: assets, description: "Maintains the loan capital balance."}
    arrears_principle: {ledger: general, type: assets, description: "Maintains arrears principle balance."}
    arrears_interest: {ledger: general, type: assets, description: "Maintains arrears interest balance."}
    debit_interest_accrual: {ledger: general, type: assets, description: "Maintains debit accrual interest amount."}
    debit_interest_booked: {ledger: general, type: assets, description: "Maintains debit booked interest amount."}
    penal_interest_accrual: {ledger: general, type: assets, description: "Maintains penal interest amount calculated."}
    interest_in_suspense: {ledger: general, type: assets, description: "Maintains interest in suspense amount."}
    capital_provision: {ledger: general, type: assets, description: "Maintains capital provision amount."}
    internal_contra: {ledger: general, type: assets, description: "For sub account transaction double entry posting."}

events:
    activation:
        priority: 255
        trigger: activation
        source: on_activation.scl
        schedule: "@now"
        inputs:
            loan_amount: param
            loan_period: param
            open_date: param
            fixed_base_interest_rate: param
            max_interest_rate: param
            term_type: param
            installment_demand_date: param
            installment_demand_day: param
            interest_book_frequency: param
            interest_book_date: param
            interest_book_day: param
            disbursement_transaction_type: param
            loan_disbursement_balance_id: param
            ledger: param
            disbursement_posting_type: param
            loan_processing_fee: param
            service_charge_transaction_type: param
            service_charge_collection_balance_id: param
            service_charge_posting_type: param
            effective_time: {kind: effective_time}
            account_number: {kind: account_number}
            primary_balance_id: {kind: balance_id, ref: primary}

    accrual:
        priority: 100
        trigger: scheduled
        schedule: "@eod"
        source: on_accrual.scl
        description: Accrue interest
        inputs:
            interest_day_basis: param
            loan_interest_rate: param
            customer_preferential_rate: param
            penalty_interest_rate: param
            interest_transaction_type: param
            ledger: param
            interest_posting_type: param
            penalty_interest_posting_type: param
            arrears_interest_is_zero: param
            debit_interest_accrual_is_zero: param
            debit_interest_booked_is_zero: param
            penal_interest_accrual_is_zero: param
            effective_time: {kind: effective_time}
            account_number: {kind: account_number}
            primary_balance: {kind: balance, ref: primary}
            arrears_principle_balance: {kind: balance, ref: arrears_principle}
            debit_interest_accrual_balance_id: {kind: balance_id, ref: debit_interest_accrual}
            penal_interest_accrual_balance_id: {kind: balance_id, ref: penal_interest_accrual}
            internal_contra_balance_id: {kind: balance_id, ref: internal_contra}

    booking:
        priority: 90
        trigger: custom
        source: on_booking.scl
        description: Debit interest booking refers to recognition of profits for the general ledger
        inputs:
            term_type: param
            installment_demand_date: param
            installment_demand_day: param
            interest_book_frequency: param
            interest_book_date: param
            interest_book_day: param
            interest_transaction_type: param
            interest_receivable_balance_id: param
            interest_earned_balance_id: param
            ledger: param
            interest_posting_type: param
            primary_is_zero: param
            arrears_principle_is_zero: param
            arrears_interest_is_zero: param
            debit_interest_booked_is_zero: param
            penal_interest_accrual_is_zero: param
            effective_time: {kind: effective_time}
            account_number: {kind: account_number}
            debit_interest_accrual_balance: {kind: balance, ref: debit_interest_accrual}
            debit_interest_booked_balance_id: {kind: balance_id, ref: debit_interest_booked}
    
    demand_generation:
        priority: 80
        trigger: custom
        source: on_demand_generation.scl
        description: Demand generation logic
        inputs:
            emi_amount: param
            demand_generation_transaction_type: param
            ledger: param
            interest_posting_type: param
            principle_posting_type: param
            primary_is_zero: param
            arrears_principle_is_zero: param
            arrears_interest_is_zero: param
            debit_interest_accrual_is_zero: param
            penal_interest_accrual_is_zero: param
            term_type: param
            installment_demand_date: param
            installment_demand_day: param
            effective_time: {kind: effective_time}
            account_number: {kind: account_number}
            debit_interest_booked: {kind: balance, ref: debit_interest_booked}
            primary_balance: {kind: balance, ref: primary}
            arrears_principle_balance_id: {kind: balance_id, ref: arrears_principle}
            arrears_interest_balance_id: {kind: balance_id, ref: arrears_interest}
            internal_contra_balance_id: {kind: balance_id, ref: internal_contra}

    demand_satisfaction:
        priority: 70
        trigger: custom
        source: on_demand_satisfaction.scl
        description: Demand satisfaction logic
        inputs:
            term_type: param
            installment_demand_date: param
            installment_demand_day: param
            demand_satisfaction_transaction_type: param
            ledger: param
            system_recovery_posting_type: param
            interest_receivable_balance_id: param
            penalty_interest_earned_balance_id: param
            primary_is_zero: param
            debit_interest_accrual_is_zero: param
            debit_interest_booked_is_zero: param
            effective_time: {kind: effective_time}
            account_number: {kind: account_number}
            arrears_principle_balance: {kind: balance, ref: arrears_principle}
            arrears_interest_balance: {kind: balance, ref: arrears_interest}
            penal_interest_accrual_balance: {kind: balance, ref: penal_interest_accrual}
            primary_balance_id: {kind: balance_id, ref: primary}
            internal_contra_balance_id: {kind: balance_id, ref: internal_contra}
            repayment_balance: {kind: parameter_balance, ref: loan_repayment_balance_id}
