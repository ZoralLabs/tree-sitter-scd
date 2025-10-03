module.exports = grammar({
    name: "scd",

    // Remove \n from extras - newlines should be meaningful tokens
    extras: ($) => [/[ \t\f]/, $.comment],

    // External tokens for indentation handling
    externals: ($) => [$.INDENT, $.DEDENT, $._NEWLINE],

    conflicts: ($) => [[$.scalar, $._key], [$.anchor]],

    rules: {
        // Entry point
        document: ($) => repeat(choice($.block_mapping_pair, $.block_sequence_item, $.scalar, $.alias, $.anchor, $.document_start, $.document_end, $._NEWLINE)),

        document_start: ($) => "---",
        document_end: ($) => "...",

        // Comments
        comment: ($) => /#.*/,

        // Main value types
        _value: ($) => choice($.block_mapping, $.flow_mapping, $.block_sequence, $.flow_sequence, $.scalar, $.alias, $.anchor),

        // Block mapping - handle newlines properly
        block_mapping: ($) => seq($.INDENT, repeat1(seq($.block_mapping_pair, optional($._NEWLINE))), $.DEDENT),

        // Block mapping pair - handle block values after colon
        block_mapping_pair: ($) =>
            prec.right(
                seq(
                    field("key", $._key),
                    ":",
                    choice(
                        // Inline value (same line) with optional trailing newline
                        seq(field("value", $._value), optional($._NEWLINE)),
                        // Block value (newline then indented content)
                        seq($._NEWLINE, field("value", $._value)),
                        // Empty (just colon)
                        $._NEWLINE,
                    ),
                ),
            ),

        _key: ($) => choice($.identifier, $.quoted_string, $.scalar),

        // Block sequence - handle newlines properly
        block_sequence: ($) => seq($.INDENT, repeat1(seq($.block_sequence_item, optional($._NEWLINE))), $.DEDENT),

        block_sequence_item: ($) => prec.right(seq("-", optional($._value))),

        // Flow mapping
        flow_mapping: ($) => seq("{", optional($.flow_mapping_content), "}"),
        flow_mapping_content: ($) => seq($.flow_mapping_pair, repeat(seq(",", $.flow_mapping_pair)), optional(",")),
        flow_mapping_pair: ($) => seq(field("key", $._key), ":", optional(field("value", $._value))),

        // Flow sequence
        flow_sequence: ($) => seq("[", optional($.flow_sequence_content), "]"),
        flow_sequence_content: ($) => seq($._value, repeat(seq(",", $._value)), optional(",")),

        // Scalars
        scalar: ($) => choice($.quoted_string, $.plain_scalar),
        quoted_string: ($) => choice($.double_quoted_string, $.single_quoted_string),
        double_quoted_string: ($) => seq('"', repeat(choice($.double_quoted_content, $.escape_sequence)), '"'),
        double_quoted_content: ($) => /[^"\\]+/,
        single_quoted_string: ($) => seq("'", repeat(choice($.single_quoted_content, "''")), "'"),
        single_quoted_content: ($) => /[^']+/,
        escape_sequence: ($) => /\\./,
        plain_scalar: ($) => choice($.boolean, $.null, $.integer, $.float, $.scd_type, $.scd_keyword, $.string),

        // SCD-specific types
        scd_type: ($) =>
            choice(
                "boolean",
                "bool",
                "integer",
                "int",
                "string",
                "str",
                "decimal",
                "dec",
                "currency",
                "time_zone",
                "timezone",
                "ledger",
                "tiered_rate",
                "balance_id",
                "snapshot_type",
                "posting_type",
                "uid",
                "date_time",
                "datetime",
                "json",
                "enum",
                "transaction_type",
                "dated_rate",
            ),

        scd_keyword: ($) =>
            choice(
                "product_contract",
                "transaction_contract",
                "scheduled",
                "posting",
                "activation",
                "deactivation",
                "migration",
                "custom",
                "transaction",
                "reverse_transaction",
                "parameter",
                "param",
                "parameter_balance",
                "param_balance",
                "pb",
                "balance",
                "bid",
                "snapshot",
                "effective_time",
                "value_time",
                "et",
                "transaction",
                "postings",
                "account_type",
                "product_code",
                "account_category",
                "product_category",
                "account_number",
                "accnum",
                "transaction_deps",
                "txn_deps",
                "tx_deps",
                "op_context",
                "context",
                "avg",
                "min",
                "max",
                "sum",
                "count",
            ),

        // Basic scalar types
        boolean: ($) => choice("true", "false", "True", "False", "TRUE", "FALSE", "yes", "no", "Yes", "No", "YES", "NO", "on", "off", "On", "Off", "ON", "OFF"),
        null: ($) => choice("null", "Null", "NULL", "~"),
        integer: ($) => choice(/[+-]?[0-9]+/, /0o[0-7]+/, /0x[0-9a-fA-F]+/),

        float: ($) =>
            choice(/[+-]?[0-9]*\.[0-9]+([eE][+-]?[0-9]+)?/, /[+-]?[0-9]+[eE][+-]?[0-9]+/, /[+-]?\.inf/, /[+-]?\.Inf/, /[+-]?\.INF/, /\.nan/, /\.NaN/, /\.NAN/),

        string: ($) => /[^\s\[\]{},:\"'#\-][^\[\]{},:#\r\n\-]*/,
        identifier: ($) => /[a-zA-Z_][a-zA-Z0-9_]*/,

        // Anchors and aliases
        anchor: ($) => seq("&", $.anchor_name, optional($._value)),
        alias: ($) => seq("*", $.alias_name),

        anchor_name: ($) => /[a-zA-Z_][a-zA-Z0-9_-]*/,
        alias_name: ($) => /[a-zA-Z_][a-zA-Z0-9_-]*/,

        // Tags
        tag: ($) => choice(/![a-zA-Z_][a-zA-Z0-9_-]*/, /!<[^>]+>/, /![^!\s]*/),

        // Directives
        directive: ($) => seq("%", $.directive_name, repeat($.directive_parameter)),
        directive_name: ($) => /[a-zA-Z_][a-zA-Z0-9_-]*/,
        directive_parameter: ($) => /[^\s#]+/,
    },
});
