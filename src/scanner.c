#include "tree_sitter/parser.h"
#include <stdbool.h>
#include <string.h>

enum TokenType { INDENT, DEDENT, NEWLINE };

typedef struct {
  uint32_t stack[256];
  uint16_t top;
} Scanner;

void *tree_sitter_scd_external_scanner_create() {
  Scanner *scanner = (Scanner *)calloc(1, sizeof(Scanner));
  scanner->stack[0] = 0;
  scanner->top = 0;
  return scanner;
}

void tree_sitter_scd_external_scanner_destroy(void *payload) { free(payload); }

unsigned tree_sitter_scd_external_scanner_serialize(void *payload,
                                                    char *buffer) {
  Scanner *scanner = (Scanner *)payload;
  unsigned bytes = 0;

  memcpy(buffer + bytes, &scanner->top, sizeof(scanner->top));
  bytes += sizeof(scanner->top);

  memcpy(buffer + bytes, scanner->stack, (scanner->top + 1) * sizeof(uint32_t));
  bytes += (scanner->top + 1) * sizeof(uint32_t);

  return bytes;
}

void tree_sitter_scd_external_scanner_deserialize(void *payload,
                                                  const char *buffer,
                                                  unsigned length) {
  Scanner *scanner = (Scanner *)payload;
  memset(scanner, 0, sizeof(*scanner));

  if (!length) {
    scanner->stack[0] = 0;
    scanner->top = 0;
    return;
  }

  unsigned bytes = 0;
  memcpy(&scanner->top, buffer + bytes, sizeof(scanner->top));
  bytes += sizeof(scanner->top);

  memcpy(scanner->stack, buffer + bytes, (scanner->top + 1) * sizeof(uint32_t));
}

bool tree_sitter_scd_external_scanner_scan(void *payload, TSLexer *lexer,
                                           const bool *valid_symbols) {
  Scanner *scanner = (Scanner *)payload;

  // Only handle indentation at the start of lines
  // Check if we're at the beginning of a line by looking at the column
  // after skipping whitespace
  uint32_t start_col = lexer->get_column(lexer);

  // Skip horizontal whitespace
  while (lexer->lookahead == ' ' || lexer->lookahead == '\t') {
    lexer->advance(lexer, true);
  }

  // Skip comments
  if (lexer->lookahead == '#') {
    while (lexer->lookahead && lexer->lookahead != '\n' &&
           lexer->lookahead != '\r') {
      lexer->advance(lexer, true);
    }
  }

  // Handle newlines
  if (lexer->lookahead == '\n' || lexer->lookahead == '\r') {
    if (lexer->lookahead == '\r') {
      lexer->advance(lexer, false);
      if (lexer->lookahead == '\n') {
        lexer->advance(lexer, false);
      }
    } else {
      lexer->advance(lexer, false);
    }

    if (valid_symbols[NEWLINE]) {
      lexer->mark_end(lexer);
      lexer->result_symbol = NEWLINE;
      return true;
    }
    return false;
  }

  // End of file - emit remaining DEDENTs
  if (lexer->lookahead == 0) {
    if (scanner->top > 0 && valid_symbols[DEDENT]) {
      scanner->top--;
      lexer->mark_end(lexer);
      lexer->result_symbol = DEDENT;
      return true;
    }
    return false;
  }

  // Only handle indentation if we started at column 0 (beginning of line)
  if (start_col != 0) {
    return false;
  }

  // Get current indentation level after skipping whitespace
  uint32_t col = lexer->get_column(lexer);
  uint32_t current_indent = scanner->stack[scanner->top];

  // Indentation increased
  if (col > current_indent && valid_symbols[INDENT]) {
    scanner->stack[++scanner->top] = col;
    lexer->mark_end(lexer);
    lexer->result_symbol = INDENT;
    return true;
  }

  // Indentation decreased
  if (col < current_indent && valid_symbols[DEDENT]) {
    // Pop one level from stack and emit one DEDENT token
    // Tree-sitter will call us again if more DEDENTs are needed
    if (scanner->top > 0) {
      scanner->top--;
      lexer->mark_end(lexer);
      lexer->result_symbol = DEDENT;
      return true;
    }
  }

  return false;
}
