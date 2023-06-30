%{

/*----------------------------------------------------------------------------
    ChucK Concurrent, On-the-fly Audio Programming Language
      Compiler and Virtual Machine

    Copyright (c) 2004 Ge Wang and Perry R. Cook.  All rights reserved.
      http://chuck.cs.princeton.edu/
      http://soundlab.cs.princeton.edu/

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
    U.S.A.
-----------------------------------------------------------------------------*/

//-----------------------------------------------------------------------------
// file: chuck.tab.c
// desc: chuck parser
//
// author: Ge Wang (gewang@cs.princeton.edu) - generated by yacc
//         Perry R. Cook (prc@cs.princeton.edu)
//
// initial version created by Ge Wang;
// based on ansi C grammar by Jeff Lee, maintained by Jutta Degener
//
// date: Summer 2002
//-----------------------------------------------------------------------------
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#ifndef __PLATFORM_WIN32__
#include <unistd.h>
#else
#define YY_NO_UNISTD_H 1
#include <io.h>
#endif
#include "chuck_utils.h"
#include "chuck_errmsg.h"
#include "chuck_absyn.h"

// function
int yylex( void );

void yyerror( char * s )
{
    EM_error( EM_tokPos, "%s", s );
}

a_Program g_program = NULL;

%}

//-----------------------------------------------------------------------------
// enable location and the yylloc
%locations

// better position reporting
// https://developer.ibm.com/tutorials/l-flexbison/
// example code
// https://github.com/sunxfancy/flex-bison-examples/
// advanced uses of bison / make things less singleton-esque
// https://www.lrde.epita.fr/~tiger/doc/gnuprog2/Advanced-Use-of-Bison.html
//-----------------------------------------------------------------------------
// uncomment line below for more informative error messages
// %error-verbose
// [test1.ck]:line(5).char(9): syntax error, unexpected ID, expecting COMMA or SEMICOLON
//   it @ is not ! valid => syntax!
//           ^
//-----------------------------------------------------------------------------

%union
{
    int pos;
    int ival;
    double fval;
    c_str sval;

    a_Program program;
    a_Section program_section;
    a_Stmt_List stmt_list;
    a_Class_Def class_def;
    a_Class_Ext class_ext;
    a_Class_Body class_body;
    a_Stmt stmt;
    a_Exp exp;
    a_Func_Def func_def;
    a_Var_Decl_List var_decl_list;
    a_Var_Decl var_decl;
    a_Type_Decl type_decl;
    a_Arg_List arg_list;
    a_Id_List id_list;
    a_Array_Sub array_sub;
    a_Complex complex_exp;
    a_Polar polar_exp;
    a_Vec vec_exp; // ge: added 1.3.5.3
};

// expect shift/reduce conflicts
// 1.3.3.0: changed to 38 for char literal - spencer
// 1.3.5.3: changed to 39 for vec literal
// 1.3.6.0: changed to 40 for external keyword
// 1.4.0.0: changed to 41 for global keyword
// 1.4.0.1: changed to 79 for left recursion
%expect 79

%token <sval> ID STRING_LIT CHAR_LIT
%token <ival> NUM
%token <fval> FLOAT

%token
  POUND COMMA COLON SEMICOLON LPAREN RPAREN
  LBRACK RBRACK LBRACE RBRACE DOT
  PLUS MINUS TIMES DIVIDE PERCENT
  EQ NEQ LT LE GT GE AND OR ASSIGN
  IF THEN ELSE WHILE FOR DO LOOP
  BREAK CONTINUE NULL_TOK FUNCTION RETURN
  QUESTION EXCLAMATION S_OR S_AND S_XOR
  PLUSPLUS MINUSMINUS DOLLAR POUNDPAREN PERCENTPAREN ATPAREN
  SIMULT PATTERN CODE TRANSPORT HOST
  TIME WHENEVER NEXT UNTIL EXTERNAL GLOBAL EVERY BEFORE
  AFTER AT AT_SYM ATAT_SYM NEW SIZEOF TYPEOF
  SAME PLUS_CHUCK MINUS_CHUCK TIMES_CHUCK
  DIVIDE_CHUCK S_AND_CHUCK S_OR_CHUCK
  S_XOR_CHUCK SHIFT_RIGHT_CHUCK
  SHIFT_LEFT_CHUCK PERCENT_CHUCK
  SHIFT_RIGHT SHIFT_LEFT TILDA CHUCK
  COLONCOLON S_CHUCK AT_CHUCK LEFT_S_CHUCK
  UNCHUCK UPCHUCK CLASS INTERFACE EXTENDS IMPLEMENTS
  PUBLIC PROTECTED PRIVATE STATIC ABSTRACT CONST 
  SPORK ARROW_RIGHT ARROW_LEFT L_HACK R_HACK


%type <program> program
%type <program_section> program_section
%type <stmt> code_segment
%type <func_def> function_definition
%type <class_def> class_definition
%type <class_body> class_body
%type <class_body> class_body2
%type <class_ext> class_ext
%type <ival> class_decl 
%type <class_ext> iface_ext
%type <program_section> class_section
%type <stmt_list> statement_list
%type <stmt> statement
//%type <stmt_label> label_statement
%type <stmt> loop_statement
%type <stmt> selection_statement
%type <stmt> jump_statement
%type <stmt> expression_statement
%type <exp> expression
%type <exp> chuck_expression
%type <exp> arrow_expression
%type <exp> conditional_expression
%type <exp> logical_or_expression
%type <exp> logical_and_expression
%type <exp> inclusive_or_expression
%type <exp> exclusive_or_expression
%type <exp> and_expression
%type <exp> equality_expression
%type <exp> relational_expression
%type <exp> shift_expression
%type <exp> additive_expression
%type <exp> multiplicative_expression
%type <exp> tilda_expression
%type <exp> cast_expression
%type <exp> unary_expression
%type <exp> dur_expression
%type <exp> postfix_expression
%type <exp> primary_expression
%type <exp> decl_expression
%type <ival> unary_operator
%type <ival> chuck_operator
%type <ival> arrow_operator
%type <var_decl_list> var_decl_list
%type <var_decl> var_decl
%type <type_decl> type_decl_a
%type <type_decl> type_decl_b
%type <type_decl> type_decl
%type <type_decl> type_decl2
%type <ival> function_decl
%type <ival> static_decl
%type <arg_list> arg_list
%type <id_list> id_list
%type <id_list> id_dot
%type <array_sub> array_exp
%type <array_sub> array_empty
%type <complex_exp> complex_exp
%type <polar_exp> polar_exp
%type <vec_exp> vec_exp // ge: added 1.3.5.3

%start program

%%

program
        : program_section                   { $$ = g_program = new_program( $1, @1.first_column ); }
        | program program_section           { $$ = g_program = append_program( $1, $2, @1.first_column ); }
        ;
        
program_section
        : statement_list                    { $$ = new_section_stmt( $1, @1.first_column ); }
        | function_definition               { $$ = new_section_func_def( $1, @1.first_column ); }
        | class_definition                  { $$ = new_section_class_def( $1, @1.first_column ); }
        ;

class_definition
        : class_decl CLASS id_list LBRACE class_body RBRACE
            { $$ = new_class_def( $1, $3, NULL, $5, @1.first_column ); }
        | class_decl CLASS id_list class_ext LBRACE class_body RBRACE 
            { $$ = new_class_def( $1, $3, $4, $6, @1.first_column ); }
        | class_decl INTERFACE id_list LBRACE class_body RBRACE
            { $$ = new_iface_def( $1, $3, NULL, $5, @1.first_column ); }
        | class_decl INTERFACE id_list iface_ext LBRACE class_body RBRACE
            { $$ = new_iface_def( $1, $3, $4, $6, @1.first_column ); }
        ;

class_ext
        : IMPLEMENTS id_list                { $$ = new_class_ext( NULL, $2, @1.first_column ); }
        | IMPLEMENTS id_list EXTENDS id_dot { $$ = new_class_ext( $4, $2, @1.first_column ); }
        | EXTENDS id_dot                    { $$ = new_class_ext( $2, NULL, @1.first_column ); }
        | EXTENDS id_dot IMPLEMENTS id_list { $$ = new_class_ext( $2, $4, @1.first_column ); }
        ;

class_body
        : class_body2                       { $$ = $1; }
		|                                   { $$ = NULL; }
        ;

class_body2
        : class_section                     { $$ = new_class_body( $1, @1.first_column ); }
        | class_section class_body2         { $$ = prepend_class_body( $1, $2, @1.first_column ); }
        ;


class_section
        : statement_list                    { $$ = new_section_stmt( $1, @1.first_column ); }
        | function_definition               { $$ = new_section_func_def( $1, @1.first_column ); }
        | class_definition                  { $$ = new_section_class_def( $1, @1.first_column ); }
        ;
        
iface_ext
        : EXTENDS id_list                   { $$ = new_class_ext( NULL, $2, @1.first_column ); }
        ;

id_list
        : ID                                { $$ = new_id_list( $1, @1.first_column /*, &@1 */ ); }
        | ID COMMA id_list                  { $$ = prepend_id_list( $1, $3, @1.first_column /*, &@1 */ ); }
        ;

id_dot
        : ID                                { $$ = new_id_list( $1, @1.first_column /*, &@1*/ ); }
        | ID DOT id_dot                     { $$ = prepend_id_list( $1, $3, @1.first_column /*, &@1*/ ); }
        ;

function_definition
        : function_decl static_decl type_decl2 ID LPAREN arg_list RPAREN code_segment
            { $$ = new_func_def( $1, $2, $3, $4, $6, $8, @1.first_column ); }
        | function_decl static_decl type_decl2 ID LPAREN RPAREN code_segment
            { $$ = new_func_def( $1, $2, $3, $4, NULL, $7, @1.first_column ); }
        | function_decl static_decl type_decl2 ID LPAREN arg_list RPAREN SEMICOLON
            { $$ = new_func_def( $1, $2, $3, $4, $6, NULL, @1.first_column ); }
        | function_decl static_decl type_decl2 ID LPAREN RPAREN SEMICOLON
            { $$ = new_func_def( $1, $2, $3, $4, NULL, NULL, @1.first_column ); }
        ;

class_decl
        : PUBLIC                            { $$ = ae_key_public; }
        | PRIVATE                           { $$ = ae_key_private; }
        |                                   { $$ = ae_key_private; }
        ;

function_decl
        : FUNCTION                          { $$ = ae_key_func; }
        | PUBLIC                            { $$ = ae_key_public; }
        | PROTECTED                         { $$ = ae_key_protected; }
        | PRIVATE                           { $$ = ae_key_private; }
        ;

static_decl
        : STATIC                            { $$ = ae_key_static; }
        | ABSTRACT                          { $$ = ae_key_abstract; }
        |                                   { $$ = ae_key_instance; }
        ;

type_decl_a
        : ID                                { $$ = new_type_decl( new_id_list( $1, @1.first_column /*, &@1*/ ), 0, @1.first_column ); }
        | ID AT_SYM                         { $$ = new_type_decl( new_id_list( $1, @1.first_column /*, &@1*/ ), 1, @1.first_column ); }
        ;

type_decl_b
        : LT id_dot GT                      { $$ = new_type_decl( $2, 0, @1.first_column ); }
        | LT id_dot GT AT_SYM               { $$ = new_type_decl( $2, 1, @1.first_column ); }
        ;

//type_decl_c
//        : LPAREN id_dot RPAREN              { $$ = new_type_decl( $3, 0, @1.first_column ); }
//        // | LPAREN id_dot RPAREN AT_SYM       { $$ = new_type_decl( $1, 1, @1.first_column ); }
//        ;

type_decl
        : type_decl_a                       { $$ = $1; }
        | type_decl_b                       { $$ = $1; }
        // | type_decl_c                       { $$ = $1; }
        ;

type_decl2
        : type_decl                         { $$ = $1; }
        | type_decl array_empty             { $$ = add_type_decl_array( $1, $2, @1.first_column ); }
        ;

arg_list
        : type_decl var_decl                { $$ = new_arg_list( $1, $2, @1.first_column ); }
        | type_decl var_decl COMMA arg_list { $$ = prepend_arg_list( $1, $2, $4, @1.first_column ); }
        ;

statement_list
        : statement                         { $$ = new_stmt_list( $1, @1.first_column ); }
        | statement_list statement          { $$ = append_stmt_list( $1, $2, @1.first_column ); }
        ;
        
statement
        : expression_statement              { $$ = $1; }
        | loop_statement                    { $$ = $1; }
        | selection_statement               { $$ = $1; }
        | jump_statement                    { $$ = $1; }
        // | label_statement                   { }
        | code_segment                      { $$ = $1; }
        ;

jump_statement
        : RETURN SEMICOLON                  { $$ = new_stmt_from_return( NULL, @1.first_column ); }
        | RETURN expression SEMICOLON       { $$ = new_stmt_from_return( $2, @1.first_column ); }
        | BREAK SEMICOLON                   { $$ = new_stmt_from_break( @1.first_column ); }
        | CONTINUE SEMICOLON                { $$ = new_stmt_from_continue( @1.first_column ); }
        ;

selection_statement
        : IF LPAREN expression RPAREN statement
            { $$ = new_stmt_from_if( $3, $5, NULL, @1.first_column ); }
        | IF LPAREN expression RPAREN statement ELSE statement
            { $$ = new_stmt_from_if( $3, $5, $7, @1.first_column ); }
        ;
        
loop_statement
        : WHILE LPAREN expression RPAREN statement
            { $$ = new_stmt_from_while( $3, $5, @1.first_column ); }
        | DO statement WHILE LPAREN expression RPAREN SEMICOLON
            { $$ = new_stmt_from_do_while( $5, $2, @1.first_column ); }
        | FOR LPAREN expression_statement expression_statement RPAREN statement
            { $$ = new_stmt_from_for( $3, $4, NULL, $6, @1.first_column ); }
        | FOR LPAREN expression_statement expression_statement expression RPAREN statement
            { $$ = new_stmt_from_for( $3, $4, $5, $7, @1.first_column ); }
        | UNTIL LPAREN expression RPAREN statement
            { $$ = new_stmt_from_until( $3, $5, @1.first_column ); }
        | DO statement UNTIL LPAREN expression RPAREN SEMICOLON
            { $$ = new_stmt_from_do_until( $5, $2, @1.first_column ); }
        | LOOP LPAREN expression RPAREN statement
            { $$ = new_stmt_from_loop( $3, $5, @1.first_column ); }
        ;

code_segment
        : LBRACE RBRACE                     { $$ = new_stmt_from_code( NULL, @1.first_column ); }
        | LBRACE statement_list RBRACE      { $$ = new_stmt_from_code( $2, @1.first_column ); }
        ;
        
expression_statement
        : SEMICOLON                         { $$ = NULL; }
        | expression SEMICOLON              { $$ = new_stmt_from_expression( $1, @1.first_column ); }
        ;
        
expression
        : chuck_expression                  { $$ = $1; }
        | expression COMMA chuck_expression  { $$ = append_expression( $1, $3, @1.first_column ); }
        ;

chuck_expression
        : arrow_expression                   { $$ = $1; }
        | chuck_expression chuck_operator arrow_expression
            { $$ = new_exp_from_binary( $1, $2, $3, @2.first_column ); }
        ;

arrow_expression
        : decl_expression                   { $$ = $1; }
        | arrow_expression arrow_operator decl_expression
            { $$ = new_exp_from_binary( $1, $2, $3, @2.first_column ); }
        ;

array_exp
        : LBRACK expression RBRACK          { $$ = new_array_sub( $2, @1.first_column ); }
        | LBRACK expression RBRACK array_exp
            { $$ = prepend_array_sub( $4, $2, @1.first_column ); }
        ;

array_empty
        : LBRACK RBRACK                     { $$ = new_array_sub( NULL, @1.first_column ); }
        | array_empty LBRACK RBRACK         { $$ = prepend_array_sub( $1, NULL, @1.first_column ); }
        ;

decl_expression
        : conditional_expression            { $$ = $1; }
        | type_decl var_decl_list           { $$ = new_exp_decl( $1, $2, 0, @1.first_column ); }
        | EXTERNAL type_decl var_decl_list  { $$ = new_exp_decl_external( $2, $3, 0, @1.first_column ); }
        | GLOBAL type_decl var_decl_list    { $$ = new_exp_decl_global( $2, $3, 0, @1.first_column ); }
        | STATIC type_decl var_decl_list    { $$ = new_exp_decl( $2, $3, 1, @1.first_column ); }
        | SAME var_decl_list                { $$ = new_exp_decl( NULL, $2, 0, @1.first_column ); }
        | STATIC SAME var_decl_list         { $$ = new_exp_decl( NULL, $3, 1, @1.first_column ); }
        ;

var_decl_list
        : var_decl                          { $$ = new_var_decl_list( $1, @1.first_column ); }
        | var_decl COMMA var_decl_list      { $$ = prepend_var_decl_list( $1, $3, @1.first_column ); }
        ;

var_decl
        : ID                                { $$ = new_var_decl( $1, NULL, @1.first_column ); }
        | ID array_exp                      { $$ = new_var_decl( $1, $2, @1.first_column ); }
        | ID array_empty                    { $$ = new_var_decl( $1, $2, @1.first_column ); }
        ;

complex_exp
        : POUNDPAREN expression RPAREN
            { $$ = new_complex( $2, @1.first_column ); }
        ;

polar_exp
        : PERCENTPAREN expression RPAREN
            { $$ = new_polar( $2, @1.first_column ); }
        ;

vec_exp // ge: added 1.3.5.3
        : ATPAREN expression RPAREN
            { $$ = new_vec( $2, @1.first_column ); }
        ;

chuck_operator
        : CHUCK                             { $$ = ae_op_chuck; }
        | AT_CHUCK                          { $$ = ae_op_at_chuck; }
        | PLUS_CHUCK                        { $$ = ae_op_plus_chuck; }
        | MINUS_CHUCK                       { $$ = ae_op_minus_chuck; }
        | TIMES_CHUCK                       { $$ = ae_op_times_chuck; }
        | DIVIDE_CHUCK                      { $$ = ae_op_divide_chuck; }
        | SHIFT_RIGHT_CHUCK                 { $$ = ae_op_shift_right_chuck; }
        | SHIFT_LEFT_CHUCK                  { $$ = ae_op_shift_left_chuck; }
        | PERCENT_CHUCK                     { $$ = ae_op_percent_chuck; }
        | UNCHUCK                           { $$ = ae_op_unchuck; }
        | UPCHUCK                           { $$ = ae_op_upchuck; }
        | S_AND_CHUCK                       { $$ = ae_op_s_and_chuck; }
        | S_OR_CHUCK                        { $$ = ae_op_s_or_chuck; }
        | S_XOR_CHUCK                       { $$ = ae_op_s_xor_chuck; }
        ;

arrow_operator
        : ARROW_LEFT                        { $$ = ae_op_arrow_left; }
        | ARROW_RIGHT                       { $$ = ae_op_arrow_right; }
        ;

conditional_expression
        : logical_or_expression             { $$ = $1; }
        | logical_or_expression QUESTION expression COLON conditional_expression
            { $$ = new_exp_from_if( $1, $3, $5, @1.first_column ); }
        ;

logical_or_expression
        : logical_and_expression            { $$ = $1; }
        | logical_or_expression OR logical_and_expression
            { $$ = new_exp_from_binary( $1, ae_op_or, $3, @2.first_column ); }
        ;

logical_and_expression
        : inclusive_or_expression           { $$ = $1; }
        | logical_and_expression AND inclusive_or_expression
            { $$ = new_exp_from_binary( $1, ae_op_and, $3, @2.first_column ); }
        ;
        
inclusive_or_expression
        : exclusive_or_expression           { $$ = $1; }
        | inclusive_or_expression S_OR exclusive_or_expression
            { $$ = new_exp_from_binary( $1, ae_op_s_or, $3, @2.first_column ); }
        ;
        
exclusive_or_expression
        : and_expression                    { $$ = $1; }
        | exclusive_or_expression S_XOR and_expression
            { $$ = new_exp_from_binary( $1, ae_op_s_xor, $3, @2.first_column ); }
        ;
        
and_expression
        : equality_expression               { $$ = $1; }
        | and_expression S_AND equality_expression
            { $$ = new_exp_from_binary( $1, ae_op_s_and, $3, @2.first_column ); }
        ;
        
equality_expression
        : relational_expression             { $$ = $1; }
        | equality_expression EQ relational_expression
            { $$ = new_exp_from_binary( $1, ae_op_eq, $3, @1.first_column ); }
        | equality_expression NEQ relational_expression
            { $$ = new_exp_from_binary( $1, ae_op_neq, $3, @2.first_column ); }
        ;

relational_expression
        : shift_expression                  { $$ = $1; }
        | relational_expression LT shift_expression
            { $$ = new_exp_from_binary( $1, ae_op_lt, $3, @2.first_column ); }
        | relational_expression GT shift_expression
            { $$ = new_exp_from_binary( $1, ae_op_gt, $3, @2.first_column ); }
        | relational_expression LE shift_expression
            { $$ = new_exp_from_binary( $1, ae_op_le, $3, @2.first_column ); }
        | relational_expression GE shift_expression
            { $$ = new_exp_from_binary( $1, ae_op_ge, $3, @2.first_column ); }
        ;

shift_expression
        : additive_expression               { $$ = $1; }
        | shift_expression SHIFT_LEFT additive_expression
            { $$ = new_exp_from_binary( $1, ae_op_shift_left, $3, @2.first_column ); }
        | shift_expression SHIFT_RIGHT additive_expression
            { $$ = new_exp_from_binary( $1, ae_op_shift_right, $3, @2.first_column ); }
        ;

additive_expression
        : multiplicative_expression          { $$ = $1; }
        | additive_expression PLUS multiplicative_expression
            { $$ = new_exp_from_binary( $1, ae_op_plus, $3, @2.first_column ); }
        | additive_expression MINUS multiplicative_expression
            { $$ = new_exp_from_binary( $1, ae_op_minus, $3, @2.first_column ); }
        ;

multiplicative_expression
        : tilda_expression                   { $$ = $1; }
        | multiplicative_expression TIMES tilda_expression
            { $$ = new_exp_from_binary( $1, ae_op_times, $3, @2.first_column ); }
        | multiplicative_expression DIVIDE tilda_expression
            { $$ = new_exp_from_binary( $1, ae_op_divide, $3, @2.first_column ); }
        | multiplicative_expression PERCENT tilda_expression
            { $$ = new_exp_from_binary( $1, ae_op_percent, $3, @2.first_column ); }
        ;

tilda_expression
        : cast_expression                   { $$ = $1; }
        | tilda_expression TILDA cast_expression
            { $$ = new_exp_from_binary( $1, ae_op_tilda, $3, @2.first_column ); }
        ;
        
cast_expression
        : unary_expression                  { $$ = $1; }
        | cast_expression DOLLAR type_decl
            { $$ = new_exp_from_cast( $3, $1, @1.first_column, @2.first_column ); }
        ;
        
unary_expression
        : dur_expression                    { $$ = $1; }
        | PLUSPLUS unary_expression
            { $$ = new_exp_from_unary( ae_op_plusplus, $2, @1.first_column ); }
        | MINUSMINUS unary_expression
            { $$ = new_exp_from_unary( ae_op_minusminus, $2, @1.first_column ); }
        | unary_operator unary_expression
            { $$ = new_exp_from_unary( $1, $2, @1.first_column ); }
        | TYPEOF unary_expression
            { $$ = new_exp_from_unary( ae_op_typeof, $2, @1.first_column ); }
        | SIZEOF unary_expression
            { $$ = new_exp_from_unary( ae_op_sizeof, $2, @1.first_column ); }
        | NEW type_decl
            { $$ = new_exp_from_unary2( ae_op_new, $2, NULL, @1.first_column ); }
        | NEW type_decl array_exp
            { $$ = new_exp_from_unary2( ae_op_new, $2, $3, @1.first_column ); }
//		| SPORK TILDA code_segment
//		    { $$ = new_exp_from_unary3( ae_op_spork, $3, @1.first_column ); }
        ;

unary_operator
        : PLUS                              { $$ = ae_op_plus; }
        | MINUS                             { $$ = ae_op_minus; }
        | TILDA                             { $$ = ae_op_tilda; }
        | EXCLAMATION                       { $$ = ae_op_exclamation; }
        | TIMES                             { $$ = ae_op_times; }
        | SPORK TILDA                       { $$ = ae_op_spork; }
        // | S_AND                             { $$ = ae_op_s_and; }
        ;

dur_expression
        : postfix_expression
        | dur_expression COLONCOLON postfix_expression
            { $$ = new_exp_from_dur( $1, $3, @1.first_column ); }
        ;
            
postfix_expression
        : primary_expression                { $$ = $1; }
        | postfix_expression array_exp
            { $$ = new_exp_from_array( $1, $2, @1.first_column ); }
        | postfix_expression LPAREN RPAREN
            { $$ = new_exp_from_func_call( $1, NULL, @1.first_column ); }
        | postfix_expression LPAREN expression RPAREN
            { $$ = new_exp_from_func_call( $1, $3, @1.first_column ); }
        | postfix_expression DOT ID
            { $$ = new_exp_from_member_dot( $1, $3, @1.first_column, @3.first_column ); }
        | postfix_expression PLUSPLUS
            { $$ = new_exp_from_postfix( $1, ae_op_plusplus, @1.first_column ); }
        | postfix_expression MINUSMINUS
            { $$ = new_exp_from_postfix( $1, ae_op_minusminus, @1.first_column ); }
        ;

// 1.3.3.0: added CHAR_LIT - spencer
primary_expression
        : ID                                { $$ = new_exp_from_id( $1, @1.first_column ); }
        | NUM                               { $$ = new_exp_from_int( $1, @1.first_column ); }
        | FLOAT                             { $$ = new_exp_from_float( $1, @1.first_column ); }
        | STRING_LIT                        { $$ = new_exp_from_str( $1, @1.first_column ); }
        | CHAR_LIT                          { $$ = new_exp_from_char( $1, @1.first_column ); }
        | array_exp                         { $$ = new_exp_from_array_lit( $1, @1.first_column ); }
        | complex_exp                       { $$ = new_exp_from_complex( $1, @1.first_column ); }
        | polar_exp                         { $$ = new_exp_from_polar( $1, @1.first_column ); }
        | vec_exp                           { $$ = new_exp_from_vec( $1, @1.first_column ); }
        | L_HACK expression R_HACK          { $$ = new_exp_from_hack( $2, @1.first_column ); }
        | LPAREN expression RPAREN          { $$ = $2; }
		| LPAREN RPAREN                     { $$ = new_exp_from_nil( @1.first_column ); }
        ;
