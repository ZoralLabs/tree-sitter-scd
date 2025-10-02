; SCD document sections
(block_mapping_pair
  key: (identifier) @name
  (#match? @name "^(id|type|name|category|description)$")) @definition.constant

; Parameters section
(block_mapping_pair
  key: (identifier) @section_name
  (#eq? @section_name "parameters")
  value: (block_mapping
    (block_mapping_pair
      key: (identifier) @name) @definition.field))

; Balances section
(block_mapping_pair
  key: (identifier) @section_name
  (#eq? @section_name "balances")
  value: (block_mapping
    (block_mapping_pair
      key: (identifier) @name) @definition.field))

; Events section
(block_mapping_pair
  key: (identifier) @section_name
  (#eq? @section_name "events")
  value: (block_mapping
    (block_mapping_pair
      key: (identifier) @name) @definition.method))

; Event properties
(block_mapping_pair
  key: (identifier) @parent_key
  (#eq? @parent_key "events")
  value: (block_mapping
    (block_mapping_pair
      key: (identifier) @event_name
      value: (block_mapping
        (block_mapping_pair
          key: (identifier) @name
          (#match? @name "^(trigger|source|schedule|inputs)$")) @definition.property))))

; Anchors
(anchor_name) @name @definition.constant

; Main SCD sections as references
(block_mapping_pair
  key: (identifier) @name
  (#match? @name "^(parameters|balances|events|contracts|rules)$")) @reference.class
