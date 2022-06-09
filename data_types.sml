structure W_datatypes =
struct

  datatype Integer_operators = 
      PLUS 	| MINUS | TIMES	| DIV | MOD;

  datatype Relational_operators = 
      EQ	| NEQ	| LT	| GT	| GEQ	| LEQ;

  datatype Logical_operators = 
      AND	| OR;

  datatype Unary_operators = 
      NOT | NEG;

  datatype Types = 
      INT | BOOL

  datatype Bool_terms = 
      TT | FF

  datatype Expressions  =
  		  Id       of string
        | Const    of string
        | Bool_Const  of Bool_terms
        | BEXP     of Expressions
        | IEXP     of Expressions
        | Add     of Expressions * Expressions
        | Subtract     of Expressions * Expressions
        | Multiply     of Expressions * Expressions
        | Divide     of Expressions * Expressions
        | Modulus     of Expressions * Expressions
        | And     of Expressions * Expressions
        | Or     of Expressions * Expressions
        | Equlaity     of Expressions * Expressions
        | NotEqual     of Expressions * Expressions
        | LessThen     of Expressions * Expressions
        | GreaterThen     of Expressions * Expressions
        | GreaterOrEqual     of Expressions * Expressions
        | LessOrEqual     of Expressions * Expressions
        | Negative        of Expressions
        | Not        of Expressions;

  datatype Commands = 
          CMD of Commands list
  		| IFT of Expressions * Commands * Commands
  		| WH of Expressions * Commands
  		| Assign of string * Expressions
        | Write of Expressions
        | Read of string;

  datatype ComSep = SEQ of string

  datatype Dtype = DataType of Types

  datatype Declarations = DEC of string * ComSep list * Dtype

  datatype Blocks = BLK of Declarations list * Commands
  
  datatype Program = PROG of string * Blocks

  fun d_int () = DataType(INT)
  fun d_bool () = DataType(BOOL)

  fun tr_ue () =  Bool_Const(TT)
  fun fl_ase () =  Bool_Const(FF)

end