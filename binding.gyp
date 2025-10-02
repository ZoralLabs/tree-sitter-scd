{
  "targets": [
    {
      "target_name": "tree_sitter_scd_binding",
      "include_dirs": [
        "<!(node -e \"console.log(require('node-addon-api').include)\")",
        "src"
      ],
      "dependencies": [
        "<!(node -e \"console.log(require('node-addon-api').gyp)\")"
      ],
      "sources": [
        "bindings/node/binding.cc",
        "src/parser.c",
        # NOTE: if your language has an external scanner, add it here.
      ],
      "conditions": [
        ["OS!='win'", {
          "cflags_c": [
            "-std=c99",
          ]
        }],
        ["OS=='win'", {
          "cflags_c": [
            "/std:c99",
          ]
        }],
      ],
      "defines": [
        "NAPI_DISABLE_CPP_EXCEPTIONS"
      ],
    }
  ]
}
