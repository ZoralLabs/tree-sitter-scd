# Sample SCD (Smart Contract Definition) file
# This demonstrates the key features of the SCD language

id: ABC123
type: product_contract
tier: 1
name: Personal Loan
category: personal_loan
description: Personal loan.
author: Yurii Biurher
org_unit: Head Office
timezone: UTC

"x1": 10
x2: true
x3: "string value"
x4: string value

parameters:
    # Core parameters
    ledger: {type: ledger, default: general, group_name: "Core", group_order: 1, description: ""}
    currency_code: {type: currency, group_name: "Core", group_order: 2, description: ""}
    loan_amount: {type: decimal, group_name: "Core", group_order: 4, description: "Loan amount approved"}
    loan_period: {type: integer, default: 12, group_name: "Core", group_order: 5, description: "Loan period in months"}
    disbursement_transaction_type: {type: transaction_type, default: system, group_name: "Constants", group_order: 1}
    disbursement_posting_type: {type: posting_type, default: internal, group_name: "Constants", group_order: 5}
    fixed_base_interest_rate: {type: dated_rate, group_name: "Interest", group_order: 2, description: "Base interest rate"}
    interest_day_basis: {type: enum, enum_values: ["360", "365", "actual"], default: actual, group_name: "Interest"}
    loan_processing_fee: {type: tiered_rate, default: "0:0.5, 50000:0.8", group_name: "Fees"}
    primary_is_zero: {type: boolean, default: false, group_name: "Calculated"}
    optional_param: {type: string, optional: true, description: "Optional parameter"}

balances:
    primary: {ledger: general, type: assets, description: "Maintains the loan capital balance"}
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
