module.exports = grammar({
    name: "scd",

    extras: ($) => [/\s/, $.comment],

    conflicts: ($) => [[$.scalar, $._key], [$.block_mapping_pair], [$.anchor]],

    rules: {
        // Entry point
        document: ($) => seq(optional($.document_start), optional($._value), optional($.document_end)),

        document_start: ($) => "---",
        document_end: ($) => "...",

        // Comments
        comment: ($) => /#.*/,

        // Main value types
        _value: ($) => choice($.block_mapping, $.flow_mapping, $.block_sequence, $.flow_sequence, $.scalar, $.alias, $.anchor),

        // Block mapping
        block_mapping: ($) => prec.left(repeat1($.block_mapping_pair)),

        block_mapping_pair: ($) => seq(field("key", $._key), ":", optional(field("value", $._value))),

        _key: ($) => choice($.identifier, $.quoted_string, $.scalar),

        // Block sequence
        block_sequence: ($) => prec.left(repeat1($.block_sequence_item)),

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

        plain_scalar: ($) => choice($.boolean, $.null, $.integer, $.float, $.scd_type, $.string),

        // SCD-specific types
        scd_type: ($) =>
            choice(
                "decimal",
                "ledger",
                "currency",
                "date_time",
                "integer",
                "transaction_type",
                "posting_type",
                "balance_id",
                "dated_rate",
                "enum",
                "datetime",
                "tiered_rate",
                "json",
                "string",
                "boolean",
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
