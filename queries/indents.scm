; Increase indent for block mapping values
(block_mapping_pair
  value: (_) @indent)

; Increase indent for block sequence items
(block_sequence_item
  (_) @indent)

; Increase indent inside flow mappings
(flow_mapping
  (flow_mapping_content) @indent)

; Increase indent inside flow sequences
(flow_sequence
  (flow_sequence_content) @indent)

; Dedent closing brackets
("}" @outdent)
("]" @outdent)

; Zero indent for document markers
(document_start @outdent)
(document_end @outdent)

; Indent after colons in block mappings
(block_mapping_pair
  ":" @indent)

; Indent after dashes in block sequences
(block_sequence_item
  "-" @indent)
