# Sample SCD (Smart Contract Definition) file
# This demonstrates the key features of the SCD language

id: PL001
type: product_contract
tier: 1
name: Personal Loan
category: personal_loan
description: Personal loan with EMI installment method and periodic schedule type
author: yurii.biurher@zorallabs.com
org_unit: Head Office
timezone: UTC

parameters:
    # Core parameters
    ledger: {type: ledger, default: general, group_name: "Core", group_order: 1, description: ""}
    currency_code: {type: currency, group_name: "Core", group_order: 2, description: ""}
    loan_amount: {type: decimal, group_name: "Core", group_order: 4, description: "Loan amount approved"}
    loan_period: {type: integer, default: 12, group_name: "Core", group_order: 5, description: "Loan period in months"}

    # Transaction types
    disbursement_transaction_type: {type: transaction_type, default: system, group_name: "Constants", group_order: 1}
    interest_transaction_type: {type: transaction_type, default: debit_interest, group_name: "Constants", group_order: 2}

    # Posting types
    disbursement_posting_type: {type: posting_type, default: internal, group_name: "Constants", group_order: 5}
    interest_posting_type: {type: posting_type, default: interest, group_name: "Constants", group_order: 6}

    # Interest configuration
    fixed_base_interest_rate: {type: dated_rate, group_name: "Interest", group_order: 2, description: "Base interest rate"}
    interest_day_basis: {type: enum, enum_values: ["360", "365", "actual"], default: actual, group_name: "Interest"}
    interest_book_frequency: {type: enum, enum_values: ["daily", "weekly", "monthly"], default: monthly}

    # Fees
    loan_processing_fee: {type: tiered_rate, default: "0:0.5, 50000:0.8", group_name: "Fees"}
    early_settlement_fee: {type: tiered_rate, default: "0:0, 3:0.25, 6:0.5", group_name: "Fees"}

    # Boolean flags
    primary_is_zero: {type: boolean, default: false, group_name: "Calculated"}
    optional_param: {type: string, optional: true, description: "Optional parameter"}

balances:
    primary: {ledger: general, type: assets, description: "Maintains the loan capital balance"}
    arrears_principle: {ledger: general, type: assets, description: "Maintains arrears principle balance"}
    arrears_interest: {ledger: general, type: assets, description: "Maintains arrears interest balance"}
    debit_interest_accrual: {ledger: general, type: assets, description: "Maintains debit accrual interest amount"}
    internal_contra: {ledger: general, type: assets, description: "For sub account transaction double entry posting"}

events:
    activation:
        priority: 255
        trigger: activation
        source: on_activation.scl
        schedule: "@now"
        inputs:
            loan_amount: param
            currency_code: param

    disbursement:
        priority: 200
        trigger: manual
        source: disbursement.scl
        inputs:
            amount: input
            transaction_date: input

    repayment:
        priority: 100
        trigger: scheduled
        source: repayment.scl
        schedule: monthly
        inputs:
            payment_amount: calculated

# Multi-line strings and complex values
rules: |
    Define business rules here
    Multiple lines supported
    Rules can be complex

metadata:
    version: "1.0.0"
    created_date: "2024-01-15"
    tags: ["loan", "personal", "emi"]
    config:
        enable_logging: true
        max_retries: 3
        timeout: 30
