; Comments
(comment) @comment

; Document markers
(document_start) @punctuation.special
(document_end) @punctuation.special

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

; Identifiers (fallback for non-key identifiers like values)
(identifier) @variable

; Basic scalar types
(null) @constant.builtin
(boolean) @constant.builtin.boolean
(integer) @constant.numeric.integer
(float) @constant.numeric.float

; Strings
(double_quoted_string) @string
(single_quoted_string) @string
(double_quoted_content) @string
(single_quoted_content) @string
(string) @string
(scd_type) @string

; Escape sequences
(escape_sequence) @constant.character.escape

; Generic keys in mappings
(block_mapping_pair key: (identifier) @key)
(flow_mapping_pair key: (identifier) @key)

; Quoted keys in mappings
(block_mapping_pair key: (quoted_string) @string.special)
(flow_mapping_pair key: (quoted_string) @string.special)

; Top-level SCD keywords in block mappings
(document
  (block_mapping
    (block_mapping_pair
      key: (scalar
        (plain_scalar
          (string) @property))
      (#match? @property "^(id|type|name|category|description|schema|org_unit|author|timezone|parameters|snapshots|modules|events|balances|tier)$"))))

; Error nodes for debugging
(ERROR) @error
