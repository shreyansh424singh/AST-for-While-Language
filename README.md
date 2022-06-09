# Assignment 3

Converts WHILE language code to abstract syntax tree using Ml-Lex and Ml-Yacc.


## How to run:

1. $ `sml`
2. -`CM.make("s.cm");`
3. -`Control.Print.printDepth:=30;`
4. -`Wh.tree "a";`

(Command `Control.Print.printDepth:=15;` is optional. Replace a with filename in command 4)


## Files Description

1. while_lex.lex    : Converts input file into tokens.
2. parser.grm       : Holds the grammar and converts it to an abstract syntax tree.
3. data_types.sml   : The ML datatype declarations for the elements in the abstract syntax tree.
4. while_ast.sml    : A glue code and a driver that reads the sources file and displays the output.
5. s.cm             : Provides a list of files that the Compiler Manager will use to build the project.

## Context-free grammar

* start  $\rightarrow$  **program** ID **::** block
* block  $\rightarrow$  declarations **{** statements **}**
* declarations  $\rightarrow$  declaration declarations_a  |   $\epsilon$
* declarations_a  $\rightarrow$  declaration declarations_a | $\epsilon$
* declaration  $\rightarrow$  **var** ID idlist **:** typea **;**
* idlist  $\rightarrow$  idlist_a idlist  |   $\epsilon$
* idlist_a  $\rightarrow$  **,** ID
* statements  $\rightarrow$  statements_a
* statements_a  $\rightarrow$  statement statements_a     |    $\epsilon$
* statement $\rightarrow$   **while** rel_exp **do** **{** statements **}** **endwh** **;**    |    **if** rel_exp **then** **{** statements **}** **else** **{** statements **}** **endif** **;**   |   **write** sum_exp **;**     |  **read** ID **;**    |  ID **:=** rel_exp **;**
* rel_exp $\rightarrow$ rel_exp **=** unary_rel_exp | rel_exp **<** unary_rel_exp   | rel_exp **<=** unary_rel_exp  | rel_exp **>=** unary_rel_exp  | rel_exp **<>** unary_rel_exp  | rel_exp **>** unary_rel_exp   | unary_rel_exp               
* unary_rel_exp $\rightarrow$ **!** unary_rel_exp  | or_exp 
* or_exp $\rightarrow$ or_exp **||** and_exp    | and_exp
* and_exp $\rightarrow$ and_exp **&&** sum_exp | sum_exp 
* sum_exp $\rightarrow$ sum_exp **+** mul_exp    | sum_exp **-** mul_exp        | mul_exp                   
* mul_exp $\rightarrow$ mul_exp **\*** unary_exp    | mul_exp **/** unary_exp   | mul_exp **%** unary_exp   | unary_exp                 
* unary_exp $\rightarrow$ **~** unary_exp  | numb           
* numb $\rightarrow$ **ID** | imm
* imm $\rightarrow$ **INT_CONST** | exp_a  | **(** rel_exp **)** 
* exp_a $\rightarrow$ **tt** | **ff**
* typea $\rightarrow$ **int** | **bool**

(Terminals are in bold.)


## AST datatype definition

* datatype Integer_operators =  PLUS    | MINUS | TIMES | DIV | MOD
* datatype Relational_operators = EQ    | NEQ   | LT    | GT    | GEQ   | LEQ
* datatype Logical_operators = AND  | OR
* datatype Unary_operators =   NOT | NEG
* datatype Types = INT | BOOL
* datatype Bool_terms = TT | FF
* datatype Expressions  = Id       of string | Const    of string | Bool_Const  of Bool_terms | BEXP     of Expressions | IEXP     of Expressions | Add     of Expressions * Expressions | Subtract     of Expressions * Expressions | Multiply     of Expressions * Expressions | Divide     of Expressions * Expressions | Modulus     of Expressions * Expressions | And     of Expressions * Expressions | Or     of Expressions * Expressions | Equlaity     of Expressions * Expressions | NotEqual     of Expressions * Expressions | LessThen     of Expressions * Expressions | GreaterThen     of Expressions * Expressions | GreaterOrEqual     of Expressions * Expressions | LessOrEqual     of Expressions * Expressions | Negative        of Expressions | Not        of Expressions
* datatype Commands =    CMD of Commands list | IFT of Expressions * Commands * Commands | WH of Expressions * Commands | Assign of string * Expressions | Write of Expressions | Read of string
* datatype Program = PROG of string * Blocks


## Syntax-directed translation

* **INT_CONST** token are numerals (+/~ followed by one or more digits).
* **ID** token is an identifier that starts with a letter followed by letters and digits.
* Input file should always start with token **program** followed by an identifier and a token **::** .
* After this, there is a block that consists of declarations and CommandSeq.
* All the declaration and command ends with token **;** .
* Declarations constitute of zero or more declaration.
* A declaration starts with token **var** then a list of identifiers separated by token **,** . After the list token **:** and Type of declaration comes.
* Type of declaration can be tokens **int** or **bool** .
* CommandSeq is enclosed by token **{** and **}**. Inside them, it has a list of commands.
* There are five possible types of commands possible, namely "set", "read", "write", "if then else", and "while".
* read command starts with token **read** followed by a token **ID**.
* write command start with token **write** followed by an expression.
* set command start with token **ID** then token **:=** followed by an expression
* while command consists of a comparison and a CommandSeq, with a format **while** comparison **do** **{** CommandSeq **}** **endwh**.
* if then else command consists of a comparison and two CommandSeq, with a format **if** comparison **then {** CommandSeq **} else {** CommandSeq **} endif**.
* A comparison has two expression with a relational operator in between them.
* Relation operator consists of **>**, **<**, **<=**, **>=**, **<>** and **=** tokens.
* An expression can be either arithmetic or boolean.
* Arithmetic expression has two arithmetic expression with an integer operator in between them.
* Integer operator consists of **+**, **-**, **\***, **/** and **%** tokens.
* **~** token can be used before any arithmetic expression.
* Arithmetic expression can also be an identifier or a numeral.
* Boolean expression has boolean operators operated on them and also comparison.
* Boolean operator consists of **&&**, **||** and **!** tokens, where **!** operates on one boolean expression whereas **&&** and **||** operates on two boolean expression.
* Boolean expression can be identifier and tokens **tt**, **ff** but not a numeral.
* tokens **(** **)** can be around any expression or comparison.


## Auxiliary functions and Data

* datatype ComSep = SEQ of string
* datatype Declarations = DEC of string * ComSep list * Dtype
* datatype Blocks = BLK of Declarations list * Commands
* datatype Dtype = DataType of Types
* fun d_int () = DataType(INT)
* fun d_bool () = DataType(BOOL)
* fun tr_ue () =  Bool_Const(TT)
* fun fl_ase () =  Bool_Const(FF)

## Other Design Decisions

* The precedence order in increasing order is boolean operators, relational operators, arithmetic operators.
* In boolean operators, the precedence is not is highest followed by and followed by or.
* In relation operators less than, less than equal, greater than, and greater than equal have more precedence than equal and not equal operators.
* In arithmetic operators, neg operator (denoted by token **~**) has highest priority followed by times, mod and div followed by plus and minus.
* not, neg and set have right associativity.
* or, and, not, less than, less than equal, greater than, greater than equal, equal, not equal, plus, minus, times, div, and mod have left associativity.


## Other Implementation Decisions

* An argument (name of the file) of type string is passed to lex and yacc files.
* The lex code throws an Invalid character error when an invalid character is encountered. In the error, the line number and the column number are specified along with the invalid character.
* If there is any syntax error, then an appropriate error is thrown, which includes the line number and the column number and the error message by yacc.
* The name of the parser is WhlParser.


## Acknowledgements

* User’s Guide to ML-Lex and ML-Yacc by Roger Price.
    - I have used this as the primary reference material for learning the basics. The Pi project given in it has been used as a reference for syntax.
* A lexical analyzer generator for Standard ML. The Ml-Lex manual by Princeton University.
    - Used for deeper understanding of Ml-Lex.
* ML-Yacc User's Manual by Princeton University.
    - Used for deeper understanding of ML-Yacc. Example codes were referred for syntax while writing grammar and datatypes.
* I referred Stack Overflow for some general doubts and errors in ML-Yacc and Ml-Lex.