; Comments
(comment) @comment

; Document markers
(document_start) @punctuation.special
(document_end) @punctuation.special

; Keys in mappings
(block_mapping_pair key: (identifier) @property)
(flow_mapping_pair key: (identifier) @property)

; SCD-specific types
(scd_type) @type.builtin

; Basic scalar types
(boolean) @constant.builtin.boolean
(null) @constant.builtin
(integer) @constant.numeric.integer
(float) @constant.numeric.float

; Strings
(double_quoted_string) @string
(single_quoted_string) @string
(double_quoted_content) @string
(single_quoted_content) @string
(string) @string

; Escape sequences
(escape_sequence) @constant.character.escape

; Identifiers
(identifier) @variable

; Anchors and aliases
(anchor "&" @punctuation.special)
(anchor_name) @label
(alias "*" @punctuation.special)
(alias_name) @label



; Punctuation
":" @punctuation.delimiter
"," @punctuation.delimiter
"-" @punctuation.delimiter

; Brackets
"{" @punctuation.bracket
"}" @punctuation.bracket
"[" @punctuation.bracket
"]" @punctuation.bracket



; Known SCD section names
((identifier) @keyword.control
 (#match? @keyword.control "^(parameters|balances|events|id|type|tier|name|category|description|author|org_unit|timezone)$"))

; Known parameter properties
((identifier) @attribute
 (#match? @attribute "^(type|optional|group_name|group_order|description|default|enum_values|ledger)$"))
