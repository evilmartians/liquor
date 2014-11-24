<style>
body {
  margin: 0 auto;
  color: #444444;
  line-height: 1;
  max-width: 960px;
  padding: 30px;
}
h1, h2, h3, h4 {
  color: #111111;
  font-weight: 400;
}
h1, h2, h3, h4, h5 {
  margin-bottom: 24px;
  padding: 0;
}
h1 {
  font-size: 48px;
}
h2 {
  font-size: 36px;
}
h3 {
  font-size: 24px;
}
h4 {
  font-size: 21px;
}
h5 {
  font-size: 18px;
}
a {
  color: #0099ff;
  margin: 0;
  padding: 0;
  vertical-align: baseline;
}
a:visited {
  color: #0047ff;
}
a:hover {
  text-decoration: none;
  color: #ff6600;
}
li {
  line-height: 24px;
}
p, ul, ol {
  font-size: 16px;
  line-height: 24px;
  max-width: 740px;
  margin-bottom: 14px;
}
pre {
  padding: 0px 24px;
  max-width: 800px;
  white-space: pre-wrap;
}
code {
  line-height: 1.5;
  font-size: 13px;
  background: #E9E8E7;
}
pre > code {
  border: none;
  background: none;
}
#markdown-toc, #markdown-toc ul {
  list-style-type: none;
  margin: 0 0 0 1em;
  padding: 0;
}
#markdown-toc {
  margin: 20px 0 0 0;
}
code, dd {
  font-family: Consolas, Monaco, Andale Mono, monospace;
}
body, em {
  font-family: Georgia, Palatino, serif;
}
dl {
  font-size: 16px;
  line-height: 24px;
}
dt {
  font-style: italic;
  margin-top: 10px;
}
dt:after {
  font-style: normal;
  padding-left: 0.5em;
  content: '::';
}
dd strong, code {
  padding: 1px;
  border: 1px solid #E0DDDA;
  border-radius: 0.2em;
}
</style>

Liquor 2.0 Language Specification
=================================

<p style="text-align: right" markdown="1">*This version of specification is a working draft.*</p>

Table of Contents
-----------------

* This list will get replaced with a table of contents.
{:toc}

1 Preface
---------

Liquor 2.0 language is developed with several goals in mind.

 * First, it should be secure. There must not be a way to bypass sandbox restrictions.
 * Second, it should not necessarily be compatible with Liquor 1.0, but should not have vastly different syntax. Liquor 1.0 syntax is easy to understand by frontend developers, and it should remain so.
 * Third, it should be as much statically verifiable as it is rationally possible. The amount of errors which can be detected only at runtime should be minimal. This will also lead to efficient implementations.
 * Fourth, it should be elegant and minimalistic.

This specification is primarily targeted at language implementors.

2 Overview
----------

### 2.1 Introduction

Liquor 2.0 language is a templating language for text-based content, e.g. HTML pages. As Liquor is a templating language, it is useless without extension with domain-specific features from a host environment; it is similar to [Lua](http://www.lua.org/) in this aspect.

Liquor is meant to be statically compiled to another language for efficiency, typically to the one the host environment is executed in. It also provides sandbox restrictions, which allow Liquor code to invoke certain methods on the host objects, but only ones explicitly marked as scriptable.

Liquor is a statically scoped, weakly and dynamically typed imperative language with lazily evaluated expressions. As it is essentially a domain-specific language for string concatenation, it has an unusual syntax where code is embedded in a text stream, and a final result of executing a Liquor program is always a string. All language constructs are similarly centered around string manipulation.

Liquor has four basic elements: _blocks_, _tags_, _interpolations_ and _expressions_. All four of these elements can be _executed_ and return a value. _Blocks_, _tags_ and _interpolations_ always return a string value.

Liquor does not have non-local control flow constructs by itself, such as exceptions and function definitions. This was done intentionally in order to simplify the language.

Liquor has distinct compile-time and runtime error checking. There are no fatal runtime errors, i.e. a Liquor program always evaluates to some value.

### 2.2 Types and Values

Liquor has the following basic types: **Null**, **Boolean**, **Integer**, **String**, **Tuple** and **External**. A value of every type except **External** can be created from within a Liquor program. Values of type **External** can only be returned by the host environment.

All Liquor values are immutable; once created, a value cannot change.

There is exactly one value of type **Null**, and it is called _null_.

There are exactly two values of type **Boolean**, and they are called _true_ and _false_.

The only values considered "falseful" in a conditional context are _null_ and _false_. Every other value, including **Integer** 0 (zero), is considered "truthful".

Type **Integer** denotes an integer value of unspecified size. Implementation may impose additional restrictions on the representable range of **Integer** type.

Type **String** denotes a sequence of [Unicode](http://unicode.org/) codepoints. Note that codepoints are not the same as characters or graphemes; there may exist an implementation-specific way of handling composite characters. See also the relevant [Unicode FAQ entry](http://www.unicode.org/faq/char_combmark.html).

Type **Tuple** denotes a heteromorphic sequence of values.

Type **External** denotes an object belonging to the host environment.

### 2.3 Type Conversion

Liquor supports exactly one implicit type conversion. In any context where a **String** value is expected, an **Integer** value can be provided. The **Integer** value will then be converted to a corresponding decimal ASCII representation without any leading zeroes.

### 2.4 Expressions

Liquor features _expressions_, which can be used to perform computations with values. This section does not define a normative grammar; the full grammar is provided in section [Grammar](#grammar).

Order of evaluation of Liquor expressions is not defined. As every value is immutable, the value of the entire expression should not depend upon the order of evaluation. Implementation-provided functions must not access or mutate global state; implementation-provided tags may access or mutate global state, but this is highly discouraged.

#### 2.4.1 Literals

All Liquor types except **External** can be specified as literals in expressions.

Identifiers _null_, _true_ and _false_ evaluate to the corresponding values.

Numeric literals evaluate to a corresponding **Integer** value, and always use base 10. Numeric literals can be specified with any amount of leading zeroes. There are no negative numeric literals.

String literals evaluate to a corresponding **String** value. String literals can be equivalently specified with single or double quotes. Strings support escaping with backslash, and there are exactly two escape sequences: one inserts a literal backslash, and the other one inserts a literal quote. More specifically, single quoted string supports escape sequences `\\` and `\'`, and double quoted string supports escape sequences `\\` and `\"`. A single backslash followed by any character not specified above is translated to a literal backslash.

Tuple literals evaluate to a corresponding **Tuple** value. Tuple literals are surrounded by square brackets and delimited with commas; that is, `[ 1, 2, 3 ]` is a tuple literal containing three integer values, one, two and three, in that exact order.

#### 2.4.2 Operators

Liquor supports unary and binary infix operators in expressions. All operators are left-associative.

Liquor operators are listed in order of precedence, from highest to lowest, by the following table:

1. `[]`, `.`, `()`, `.()`
2. unary `-`, `!`
3. `*`, `/`, `%`
4. `+`, binary `-`
5. `==`, `!=`, `<`, `<=`, `>`, `>=`
6. `&&`
7. `||`

The following operators are infix and binary: `*`, `/`, `%`, `+`, `-`, `==`, `!=`, `<`, `<=`, `>`, `>=`, `&&`, `||`.
The following operators are infix and unary: `-`, `!`.

The operators `[]`, `.`, `()`, `.()` are not infix and are provided in this table only to define precedence rules.

##### 2.4.2.1 Arithmetic Operators

Arithmetic operators are `*` (multiplication), `/` (division), `%` (modulo), `+` (plus) and `-` (minus; binary and unary).

All arithmetic operators except `+`, whether unary or binary, require every argument to be of type **Integer**. If this is not the case, a runtime error condition ([type error](#type-error)) is signaled.

Operator `+` requires both arguments to be of the same type, and only accepts arguments of type **Integer**, **String** or **Tuple**. If any of the conditions is not satisfied, a runtime error condition ([type error](#type-error)) is signaled. For arguments of type **String** or **Tuple**, the `+` operator evaluates to the concatenation of left and right arguments in that order.

If the result of an arithmetic operation, except operator `+` with non-**Integer** arguments, exceeds the range an implementation can represent, the behavior is implementation-defined.

##### 2.4.2.2 Boolean Operators

Boolean operators are `!` (not; unary), `&&` (and) and `||` (or).

All boolean operators, whether unary or binary, convert each argument to type **Boolean** prior to evaluation. The rules of conversion are:

1. If the value equals _null_ or _false_, it is assumed to be _false_.
2. Else, the value is assumed to be _true_.

All boolean operators return a value of type **Boolean**. Binary boolean operators do not provide any guarantees on order or sequence of evaluation. However, a correct implementation which does not feature functions with side effects will not suffer from this behavior.

##### 2.4.2.3 Comparison Operators

Comparison operators are `==` (equals), `!=` (not equals), `<` (less), `<=` (less or equal), `>` (greater) and `>=` (greater or equal).

Operators `==` and `!=` compare values by equality, not identity. Thus, the expression `[ 1, 2 ] == [ 1, 2 ]` evluates to _true_. These operators never signal an error condition or implicitly convert types.

Operators `<`, `<=`, `>` and `>=` require both arguments to be of type **Integer**. If this is not the case, a runtime error condition ([type error](#type-error)) is signaled. Otherwise, a corresponding value of type **Boolean** is returned.

##### 2.4.2.4 Indexing Operator

Indexing operator is `[]`.

Indexing operator requires its left-hand side argument to be of type **Tuple** or **External**, and right-hand side argument to be of type **Integer**. If this is not the case, a runtime error condition ([type error](#type-error)) is signaled.

If the left-hand side argument is of type **External**, the behavior is implementation-defined. A runtime error condition ([external error](#external-error)) is signaled if the particular external value does not support indexing.

Indexing operator of form <code><em>t</em>[<em>n</em>]</code> evaluates to _n_-th value from tuple _t_ with zero-based indexing. If `n` is negative, then _n_+1-th element from the end of tuple is returned. For example, <code><em>t</em>[-1]</code> will evaluate to the last element of the tuple _t_.

If the requested element does not exist in the tuple, the indexing operator evaluates to _null_.

#### 2.4.3 Function Calls

Identifiers can be bound to functions prior to compilation. Identifiers _null_, _true_ and _false_ cannot be bound to a function.

Functions are defined in an implementation-specific way. Functions can have zero to one unnamed formal parameters and any amount of named formal parameters. If an unnamed formal parameter is accepted, it is mandatory. Named formal parameters can be either mandatory or optional. Absence of a mandatory formal parameter will result in a compile-time error ([argument error](#argument-error)). Named formal parameter order is irrelevant.

Function calls have mandatory parentheses, and arguments are whitespace-delimited.

If a function call includes two named parameters with the same name, a compile-time error ([syntax error](#syntax-error)) is raised.

If a hypothetical function _substr_ has one unnamed formal parameter and two optional named formal parameters _from_ and _length_, then all of the following expressions are syntactically valid and will not result in a compile-time error: `substr("foobar")`, `substr("foobar" from: 1)`, `substr("foobar" from: 1 length:(5 - 2))`. The following expression, however, is syntactically valid but will result in a compile-time error: `substr(from: 1)`.

#### 2.4.4 Access Operators

Access operators are `.` and `.()`.

The `.` form is syntactic sugar for `.()` form without any arguments. That is, <code><em>e</em>.<em>f</em></code> is completely equivalent to <code><em>e</em>.<em>f</em>()</code>.

Access operator requires its left-hand side argument to be of type **External**. If this is not the case, a runtime error condition ([type error](#type-error)) is signaled.

Access operator of form <code><em>e</em>.<em>f</em>(<em>arg</em> <em>kw:</em> <em>value</em>)</code> evaluates to the result of calling method _f_ of external object _e_ with the corresponding arguments. Argument syntax is the same as for [function calls](#function-calls).

This evaluation is done in an implementation-defined way. Access operator can evaluate to any type.

If the requested method does not exist in the external object or cannot successfully evaluate, a runtime error condition ([external error](#external-error)) is signaled. Errors in the called method must not interrupt execution of the calling Liquor program.

#### 2.4.5 Variable Access

Every identifier except _null_, _true_ and _false_ which is not bound to a function name is available to be bound as a variable name. Such identifier would evaluate to a value of the variable.

Variable definition and scoping will be further discussed in section [Tags](#tags).

Referencing an undefined variable will result in a compile-time error ([name error](#name-error)).

#### 2.4.6 Filter Expressions

Filter expressions are a syntactic sugar for chaining method calls.

Filter expressions consist of a linear chain of function calls where _n_-th function's return value is passed to _n+1_-th function's unnamed parameter. Named parameters may be specified without parentheses within a corresponding chain element.

All functions used in a filter expression should accept an unnamed parameter. If this is not the case, a compile-time error ([argument error](#argument-error)) is raised. Semantics of mandatory and optional named parameters are the same as for [regular function calls](#function-calls).

<p markdown="0">
In essence, <code><em>e</em> | <em>f</em> a: 1 | <em>g</em></code> is equivalent to <code><em>g</em>(<em>f</em>(<em>e</em>() a: 1))</code>.
</p>

### 2.5 Blocks

A block is a chunk of plaintext with _tags_ and _interpolations_ embedded into it. Every Liquor program has at least one block: the toplevel one.

A block consisting only of plaintext would return its literal value upon execution. Thus, the famous Hello World program would be as follows:

    Hello World!

This program would evaluate to a string `Hello World!`.

A block can have other elements embedded into it. When such a block is executed, these elements are executed in lexical order and are replaced with the value returned by the element.

### 2.6 Interpolations

An interpolation is a syntactic construct of form `{{ expr }}` which can be embedded in a block. The expression `expr` should evaluate to a value of type **String** or **Null**; an [implicit conversion](#type-conversion) might take place. If this is not the case, a runtime error condition ([type error](#type-error)) is signaled.

If _expr_ evaluates to a **String**, the interpolation returns it. Otherwise, the interpolation returns an empty string.

An example of using an interpolation would be:

    The sum of two and three is: {{ 2 + 3 }}

This program would evaluate to a string `The sum of two and three is: 5`.

### 2.7 Tags

A tag is a syntactic construct of form `{% tag expr kw: arg do: %} ... {% end  tag %}`. A tag has a syntax similar to a function call, but it can receive blocks of code as argument values and lazily evaluate passed expressions and blocks of code.

Tags have full control upon parameter evaluation. Tags can require arguments to be of a certain lexical form, e.g. a `for` tag could require its unnamed formal parameter to be a lexical identifier.

To pass a block of code to a tag, the closing tag delimiter should immediately follow a parameter name. Everything from the closing tag delimiter to the matching opening tag delimiter should be parsed as a block and passed as a value of the corresponding parameter. After the matching opening tag delimiter, the parameter list is continued.

If a tag <code><em>t</em></code> does not include any embedded blocks, it ends after a first matching closing tag delimiter. Otherwise, the tag ends after a first matching construct of the form <code>{% end <em>t</em> %}</code>.

Unlike functions, tags can receive multiple named parameters with the same name. Named parameters of tags are a syntactic tool and should be thoroughly verified by the implementation. Specifying incorrect names or order of named parameters may result in a compile-time error ([syntax error](#syntax-error)).

All of the following are examples of syntactically valid tags:

    {% yield %}

    {% if var > 10 do: %}
      Var is greater than 10.
    {% end if %}

    {% for i in: [ 1, 2, 3 ] do: %}
      Value: {{ i }}
    {% end for %}

    {% if length(params.test) == 1 then: %}
      Test has length 1.
    {% elsif: length(params.test) == 2 then: %}
      Test has length 2.
    {% else: %}
      Test has unidentified length.
    {% end if %}

    {% capture "buffer" do: %}
      This text will be printed twice.
    {% end capture %}
    {% yield from: "buffer" %}
    {% yield from: "buffer" %}


3 Grammar
---------

The following Extended Backus-Naur Form grammar is normative. The native character set of Liquor is Unicode, and every character literal specified is an explicit codepoint.

Statement <code><em>a</em> to <em>b</em></code> is equivalent to codepoint set which includes every codepoint from _a_ to _b_ inclusive. Statement <code><em>a</em> except <em>b</em></code> means that both _a_ and _b_ are tokens which consist of exactly one codepoint, and every character satisfying _a_ and not satisfying in _b_ is accepted. Statement <code>lookahead <em>a</em></code> means that the current token should only be produced if the codepoint immediately following it satisfies _a_.

Strictly speaking, this grammar lies within _GLR_ domain, but if, as it is usually the case, an implementation has separate lexer and parser, a _LALR(1)_ parser could be used. This will be further explained in section [Blocks](#blocks-1).

### 3.1 Basic Syntax

Whitespace
: **U+0007** \| **U+000A** \| **U+0020**

Alpha
: **a** to **z** \| **A** to **Z**

Digit
: **0** to **9**

Any
: any Unicode character

Symbol
: _Alpha_ \| **_**

Identifier
: _Symbol_ ( _Symbol_ \| _Digit_ )* lookahead ( _Any_ except **:** )

Keyword
: _Symbol_ ( _Symbol_ \| _Digit_ )* **:**
: **=**

IntegerLiteral
: _Digit_+ lookahead ( _Any_ except _Symbol_ )

StringLiteral
: **\"** ( **\\\\**  \| **\\\"** \| _Any_ except **\"** )* **\"**
: **\'** ( **\\\\**  \| **\\\'** \| _Any_ except **\'** )* **\'**

TupleLiteral
: **\[** _TupleLiteralContent_ **]**

TupleLiteralContent
: _Expression_ **,** _TupleLiteralContent_
: _Expression_
: empty

### 3.2 Expressions

Operator precedence table is provided in section [Operators](#operators).

PrimaryExpression
: _Identifier_
: **(** _Expression_ **)**

Expression
: _IntegerLiteral_
: _StringLiteral_
: _TupleLiteral_
: _Identifier_ _FunctionArguments_
: _PrimaryExpression_ **\[** _Expression_ **]**
: _Expression_ **.** _Identifier_  _FunctionArguments_?
: **-** _Expression_
: **!** _Expression_
: _Expression_ **\*** _Expression_
: _Expression_ **/** _Expression_
: _Expression_ **%** _Expression_
: _Expression_ **+** _Expression_
: _Expression_ **-** _Expression_
: _Expression_ **==** _Expression_
: _Expression_ **!=** _Expression_
: _Expression_ **<** _Expression_
: _Expression_ **<=** _Expression_
: _Expression_ **>** _Expression_
: _Expression_ **>=** _Expression_
: _Expression_ **&&** _Expression_
: _Expression_ **\|\|** _Expression_

KeywordArguments
: ( _Keyword_ _Expression_ )*

FunctionArguments
: **(** _Expression_? _KeywordArguments_ **)**

FilterChain
: _Expression_ **\|** _FilterChainContinuation_

FilterChainContinuation
: _FilterFunctionCall_ **\|** _FilterChainContinuation_
: _FilterFunctionCall_

FilterFunctionCall
: _Identifier_ _FunctionKeywordArguments_

### 3.3 Blocks

Inside a _Tag_ or _Interpolation_ body any _Whitespace_ is used to separate adjacent tokens, but is otherwise ignored. The cases where na&iuml;vely removing _Whitespace_ would cause ambiguity can be determined by watching for `lookahead` clauses.

The _Tag_, _TagFirstContinuation_ and _EndTag_ production rules deviate from canonical _LR(1)_ grammar structure. To parse these rules correctly, a _LALR(1)_ parser should maintain a stack of tag identifiers and correctly decide on ambiguous reduction of rules _Identifier_ and _EndTag_.

When the parser follows the second reduction for rule _TagFirstContinuation_, it should push the corresponding _Tag_ _Identifier_ on the top of the tag stack.

When the parser is about to decide whether it should reduce the sequence satisfying _Identifier_ to _EndTag_ or leave it as is, it should only reduce the sequence to _EndTag_ if the _Identifier_ part of the _EndTag_ rule equals the value at the top of the tag stack. If this is the case, the topmost value is popped from the tag stack.

Block
: _Plaintext_ _Block_
: _Interpolation_ _Block_
: _Tag_ _Block_
: _Comment_ _Block_
: empty

Comment
: **{!** ( _Comment_ \| _Any_* )+  **!}**

Plaintext
: ( _Any_ except **{** \| **{** _Any_ except ( **{** \| **%** ) )+

Interpolation
: **{{** ( _Expression_ \| _FilterChain_ ) **}}**

Tag
: **{%** _Identifier_ _Expression_? _KeywordArguments_ _TagFirstContinuation_

TagFirstContinuation
: **%}**
: _TagBlock_ _TagNextContinuation_

TagNextContinuation
: _KeywordArguments_ _TagBlock_ _TagNextContinuation_
: _EndTag_ **%}**

TagBlock
: _Keyword_ **%}** _Block_ **{%**

EndTag
: **end** **U+0020** _Identifier_ at the top of tag stack

4 Compile-time Behavior
-----------------------

Liquor compiling process consists of three distinct parts: _parsing_, _scope resolution_ and _translation_. Each stage includes exhaustive error checking; additionally, translation and scope resolution are heavily dependent on the defined tags and their behavior.

### 4.1 Errors {#compile-time-errors}

To ease development process, an implementation generally should not stop compilation after encountering an error. As an exception to the general rule, implementation must stop parsing and abandon any intermediate result after encountering a syntax error. Rationale to this behavior is that with Liquor's interleaved structure, successful error recovery after parsing errors is unlikely.

Every error must carry precise location information: in particular, an error location must feature _line_, _start column_ and _end column_.

The following algorithm can be used to calculate precise location information for every Unicode character in the source code:

1. The initial line and column numbers equal 1.
2. For each character in the source, in order, perform the following:
    1. If the character is **U+000A**, increase line number by 1 and set column number to 1.
    2. If the character is **U+0007**, increase column number by 1 until it equals zero modulo 8. If the column number already equals zero modulo 8, increase it by 8.
    3. If the character is a combining character, the implementation may recognize this fact and do nothing.
    4. If nothing of the above applies, increase column number by 1.

This algorithm, unlike the rest of Liquor, is specified in terms of characters and not codepoints. This means that an implementation must recognize surrogate pairs and compose them into one character.

#### 4.1.1 Syntax Error

Syntax error will be signaled upon encountering any of the following conditions:

1. Parsing failure (section [Grammar](#grammar))
2. Duplicate function keyword arguments (section [Function Calls](#function-calls))
3. Incorrect tag syntax (section [Tags](#tags))

Syntax errors must include source location information and point to the exact token which caused the error.

#### 4.1.2 Argument Error

Argument error will be signaled upon encountering any of the following conditions:

1. Absence of a mandatory parameter, or presence of non-accepted parameter (sections [Function Calls](#function-calls), [Tags](#tags))

Argument errors must include source location information and point either to the exact parameter which caused the error, or to the argument list in case of a missing parameter.

#### 4.1.3 Name Error

Name error will be signaled upon encountering any of the following conditions:

1. Referencing an undefined variable (sections [Variable Access](#variable-access), [Scope Resolution](#scope-resolution))
2. Referencing an undefined function (section [Function Calls](#function-calls))
3. Encountering an undefined tag (section [Tags](#tags))
4. Trying to bind an already bound identifier (section [Scope Resolution](#scope-resolution))

Name errors must include source location information and point to the exact token which caused the error.

### 4.2 Scope Resolution

[Tags](#tags) control every aspect of scope construction and resolution.

Basically, tags can perform three scope-related actions: _declare_ a variable, _assign_ a variable and create a _nested scope_.

Declaring a variable binds the identifier to a value. To declare a variable, the identifier should not be bound in the current scope. If this is not the case, a compile-time error ([name error](#name-error)) is raised. If the identifier is bound in an outer scope, it will be rebound in the current scope. Such a binding ceases to exist when the current scope is left.

Assigning a variable, similarly to accessing, requires the variable to be declared in any of the scopes. Assigning a variable changes its value in the innermost scope.

Creating a nested scope allows for shadowing of the variables. Tags must only execute contents of the passed blocks in a nested scope. Passed expressions are always executed in the tag's scope. A tag must ensure that every scope it created will be left before the tag will finish executing.

An implementation should have a way to inject variables into the outermost scope.

5 Runtime Behavior
------------------

Evaluation of Liquor programs follows lexical order for blocks, and is undefined for expressions. As all expressions are pure, this does not result in ambiguity.

A Liquor program always evaluates to a string. Liquor recognizes the value of and attempts to produce sensible output even for partially invalid programs; to keep the codebase manageable, the runtime environment must report all runtime errors to the programmer.

### 5.1 Type Error {#type-error}

A type error arises when a value of certain type(s) is expected in a context, but a value of a different type is provided. In this case, the runtime records the error and substitutes the value for a zero value, respectively for every type:

 * **Null**: _null_.
 * **Boolean**: _false_.
 * **Integer**: _0_.
 * **String**: _""_.
 * **Tuple**: _[]_.
 * **External**: the [dummy external](#dummy-external).

### 5.2 External Error {#external-error}

An external error arises when an unknown external method is called, or there is a problem evaluating the external method. In this case, the runtime records the error and returns _null_ instead.

### 5.3 The dummy external

The dummy external is an external object which performs no operation when any method is called on it and returns _null_.

6 Builtins
----------

Implementations must implement every builtin tag and function mentioned in this section. Implementations may implement any additional tags, but must not alter behavior of the described ones.

### 6.1 Required tags {#builtin-tags}

#### 6.1.1 declare

Tag _declare_ has one valid syntactic form:

<pre><code>{% declare <em>var</em> = <em>expr</em> %}</code></pre>

_Declare_ binds the name _var_ to the result of executing _expr_ in the current scope. If _var_ is already bound in current scope, _declare_ mutates the binding. If _var_ is already bound in an outer scope, _declare_ creates a new binding in the current scope.

The _declare_ tag itself evaluates to an empty string.

#### 6.1.2 assign

Tag _assign_ has one valid syntactic form:

<pre><code>{% assign <em>var</em> = <em>expr</em> %}</code></pre>

_Assign_ binds the name _var_ to the result of executing _expr_ in the current scope. If _var_ is already bound, _assign_ mutates the binding.

The _assign_ tag itself evaluates to an empty string.

#### 6.1.3 for

Tag _for_ has two valid syntactic forms:

<pre><code>{% for <em>var</em> in: <em>list</em> do: %}
  <em>code</em>
{% end for %}</code></pre>

<pre><code>{% for <em>var</em> from: <em>lower-limit</em> to: <em>upper-limit</em> do: %}
  <em>code</em>
{% end for %}</code></pre>

In the _for..in_ form, this tag invokes _code_ with _var_ bound to each element of _list_ sequentally. If _list_ is not a *Tuple*, a runtime error condition ([type error](#type-error)) is signaled.

In the _for..from..to_ form, this tag invokes _code_ with _var_ bound to each integer between _lower-limit_ and _upper-limit_, inclusive. If _lower-limit_ or _upper-limit_ is not an *Integer*, a runtime error condition ([type error](#type-error)) is signaled.

The _for_ tag evaluates to the concatenation of the values its _code_ has evaluated to.

#### 6.1.4 if

Tag _if_ has one valid syntactic form:

<pre><code>{% if <em>cond-1</em> then: %}
  <em>code-1</em>
<em>[</em>{% elsif: <em>cond-2</em> then: %}
  <em>code-2</em><em>] ...</em>
<em>[</em>{% else: %}
  <em>code-else</em><em>]</em>
{% end if %}
</code></pre>

This tag can optionally have any amount of _elsif_ clauses and only one _else_ clause.

The _if_ tag sequentally evaluates each passed condition _cond-1_, _cond-2_, ... until a [truthful](#boolean-operators) value is computed. Then, it executes the corresponding code. If none of the conditions evaluate to a truthful value, the tag executes _code-else_ if it exists.

The _if_ tag returns the result of evaluating the corresponding code block, or an empty string if none of the blocks were executed.

#### 6.1.5 unless

Tag _unless_ has one valid syntactic form:

<pre><code>{% unless <em>cond</em> then: %}
  <em>code</em>
{% end unless %}</code></pre>

The _unless_ tag evaluates _cond_. Unless it yields a [truthful](#boolean-operators), _code_ is also evaluated.

The _unless_ tag returns the result of evaluating _code_, or an empty string.

#### 6.1.6 capture

Tag _capture_ has one valid syntactic form:

<pre><code>{% capture <em>var</em> = %}
  <em>code</em>
{% end capture %}</code></pre>

The _capture_ tag evaluates _code_ and binds the name _var_ to the result. If _var_ is already bound, _capture_ mutates the binding.

The _capture_ tag returns an empty string.

#### 6.1.7 content_for

Tag _content_for_ has one valid syntactic form:

<pre><code>{% content_for <em>"handle"</em> capture: %}
  <em>code</em>
{% end content_for %}</code></pre>

The _content_for_ tag accepts a **String** handle as an immediate value. It evaluates _code_ and assigns the result to the handle _handle_, which must be stored in an implementation-specific way.

The _content_for_ tag returns an empty string.

See also notes on [Layout implementation](#appendix-layouts).

#### 6.1.8 yield

Tag _yield_ has three valid syntactic forms:

<pre><code>{% yield %}</code></pre>

In this form, the _yield_ tag evaluates to the content of inner template.

<pre><code>{% yield <em>"handle"</em> %}</code></pre>
<pre><code>{% yield <em>"handle"</em> if_none: %}
  <em>code</em>
{% end yield %}</code></pre>

The _yield_ tag accepts a **String** _handle_ as an immediate value. If a string with handle _handle_ was captured previously with [{% content_for %}](#content_for), then _yield_ returns that string. If there is no captured string with that handle, _yield_ either returns the result of evaluating _if_none_ block if it exists, or an empty string.

See also notes on [Layout implementation](#appendix-layouts).

#### 6.1.9 include

Tag _include_ has one valid syntactic form:

<pre><code>{% include <em>"partial_name"</em> %}</code></pre>

The _include_ tag accepts a **String** _partial_name_ as an immediate value. It lexically includes the code of partial template _partial_name_ in a newly created scope.

The _include_ tag must not allow infinite recursion to happen. If such a condition is encountered, a compile-time error ([syntax error](#syntax-error)) is signaled.

See also notes on [Layout implementation](#appendix-layouts).

### 6.2 Functions

Liquor offers a number of builtin [functions](#function-calls). Their formal parameters are described using a shorthand notation:

<code>fn_name(<em>unnamed-arg-type</em> kwarg1: <em>kwarg1-type</em> [kwarg2: <em>kwarg2-type, kwarg2-alt-type</em>])</code>

In this case, function _fn_name_ has an unnamed parameter accepting value of type _unnamed-arg-type_, a mandatory keyword parameter _kwarg1_ accepting values of type _kwarg1-type_, and an optional keyword parameter _kwarg2_ accepting values of either type _kwarg2-type_ or _kwarg2-alt-type_.

#### 6.2.1 Universal functions

##### 6.2.1.1 is_empty

<code>is_empty(<em>Any</em>)</code>

Returns _true_ iff the unnamed argument is one of _null_, _""_, _[]_.

##### 6.2.1.2 size

<code>size(<em>String, Tuple</em>)</code>

Returns the length of the unnamed argument as an integer.

#### 6.2.2 Conversion functions

##### 6.2.2.1 strftime

<code>size(<em>String</em> format: <em>String</em>)</code>

Parses the unnamed argument as time in [ISO8601](http://www.w3.org/TR/NOTE-datetime) format, and reformats it using an implementation-defined [strftime](http://strftime.org/) alike function.

##### 6.2.2.2 to_number

<code>to_number(<em>String, Integer</em>)</code>

If the unnamed argument is an **Integer**, returns it. If it is a string, parses it as a decimal number, possibly with leading minus sign.

#### 6.2.3 Integer functions

##### 6.2.3.1 is_even

<code>is_even(<em>Integer</em>)</code>

Returns _true_ if the unnamed argument is even, _false_ otherwise.

##### 6.2.3.2 is_odd

<code>is_odd(<em>Integer</em>)</code>

Returns _true_ if the unnamed argument is odd, _false_ otherwise.

#### 6.2.4 String functions

##### 6.2.4.1 downcase

<code>downcase(<em>String</em>)</code>

Returns the unnamed argument, converted to lowercase, using the Unicode case folding.

##### 6.2.4.2 upcase

<code>upcase(<em>String</em>)</code>

Returns the unnamed argument, converted to uppercase, using the Unicode case folding.

##### 6.2.4.3 capitalize

<code>capitalize(<em>String</em>)</code>

Returns the unnamed argument with its first character converted to uppercase, using the Unicode case folding.

##### 6.2.4.4 starts_with

<code>starts_with(<em>String</em> pattern: <em>String</em>)</code>

Returns _true_ if the unnamed argument starts with _pattern_, _false_ otherwise. No normalization is performed.

##### 6.2.4.5 strip_newlines

<code>strip_newlines(<em>String</em>)</code>

Returns the unnamed argument without any **U+000A** characters.

##### 6.2.4.6 join

<code>join(<em>Tuple</em> with: <em>String</em>)</code>

Returns the concatenation of elements of the unnamed argument (which all must be **String**s) interpsersed with the value of _with_.

##### 6.2.4.7 split

<code>split(<em>String</em> by: <em>String</em>)</code>

Returns a tuple of fragments of the unnamed argument, extracted between occurences of _by_. If the unnamed argument is _""_, returns _[]_.

##### 6.2.4.8 replace

<code>replace(<em>String</em> pattern: <em>String</em> replacement: <em>String</em>)</code>

Returns the unnamed argument with all occurences of _pattern_ replaced with _replacement_.

##### 6.2.4.9 replace_first

<code>replace_first(<em>String</em> pattern: <em>String</em> replacement: <em>String</em>)</code>

Returns the unnamed argument with the first occurence of _pattern_ replaced with _replacement_.

##### 6.2.4.10 remove

<code>remove(<em>String</em> pattern: <em>String</em>)</code>

Returns the unnamed argument with all occurences of _pattern_ removed.

##### 6.2.4.11 remove_first

<code>remove_first(<em>String</em> pattern: <em>String</em>)</code>

Returns the unnamed argument with the first occurences of _pattern_ removed.

##### 6.2.4.12 newline_to_br

<code>newline_to_br(<em>String</em>)</code>

Returns the unnamed argument with `<br>` inserted before every **U+000A** character.

##### 6.2.4.13 url_escape

<code>url_escape(<em>String</em>)</code>

Returns the unnamed argument, processed using the [application/x-www-form-urlencoded encoding algorithm](http://www.w3.org/TR/html5/forms.html#url-encoded-form-data).

##### 6.2.4.14 html_escape {#function-html-escape}

<code>html_escape(<em>String</em>)</code>

Returns the unnamed argument with `&`, `<`, `>`, `'`, `"` and `/` escaped to the correpsonding HTML entities.

##### 6.2.4.15 html_escape_once, h

<code>html_escape(<em>String</em>)</code>

<code>h(<em>String</em>)</code>

Like [html_escape](#function-html-escape), but does not affect `&` that is a part of an HTML entity.

##### 6.2.4.16 strip_html

<code>strip_html(<em>String</em>)</code>

Returns the unnamed argument with all HTML tags and comments removed.

##### 6.2.4.17 decode_html_entities

<code>decode_html_entities(<em>String</em>)</code>

Returns the unnamed argument with all HTML entities replaced by the corresponding Unicode character.

#### 6.2.5 Tuple functions

##### 6.2.5.1 compact

<code>compact(<em>Tuple</em>)</code>

Returns the unnamed argument without _null_ elements.

##### 6.2.5.2 reverse

<code>reverse(<em>Tuple</em>)</code>

Returns the unnamed argument, reversed.

##### 6.2.5.3 uniq

<code>reverse(<em>Tuple</em>)</code>

Returns the unnamed argument with only first instance of non-unique elements left.

##### 6.2.5.4 min {#function-min}

<code>min(<em>Tuple</em> [by: <em>String</em>])

Returns the minimal element of the unnamed argument. The ordering between values of different types is implementation-defined. Including an **External** in the unnamed argument may lead to a runtime error ([type error](#type-error)).

If _by_ is passed, the unnamed argument must consist only of **External** values. In this case, the ordering is performed by calling the method specified by _by_.

##### 6.2.5.5 max

<code>max(<em>Tuple</em> [by: <em>String</em>])

See [the min function](#function-min).

##### 6.2.5.6 in_groups_of

<code>in_groups_of(<em>Tuple</em> size: <em>Integer</em> [fill_with: <em>String, Boolean</em>])</code>

Returns the unnamed argument, split into tuples of _size_ elements. If _fill_with_ is passed, appends the value of _fill_with_ to the last tuple, so that it is _size_ elements big.

##### 6.2.5.7 in_groups

<code>in_groups(<em>Tuple</em> count: <em>Integer</em> [fill_with: <em>String, Boolean</em>])</code>

Returns the unnamed argument, split into _count_ equally-sized (except the last one) tuples. If _fill_with_ is passed, appends the value of _fill_with_ to the last tuple, so that it is as big as the others.

##### 6.2.5.8 includes

<code>includes(<em>Tuple, External</em> element: <em>Any</em>)</code>

Returns _true_ if the unnamed argument contains _element_, _false_ otherwise. Not all externals support this operation; if an unsupported external is passed, runtime error condition ([type error](#type-error)) is signaled.

##### 6.2.5.9 index_of

<code>index_of(<em>Tuple, External</em> element: <em>Any</em>)</code>

Returns the index of _element_ in the unnamed argument or _null_ if it does not contain _element_. Not all externals support this operation; if an unsupported external is passed, runtime error condition ([type error](#type-error)) is signaled.

#### 6.2.6 Truncation functions

##### 6.2.6.1 truncate {#function-truncate}

<code>truncate(<em>String</em> [length: <em>Integer</em> omission: <em>String</em>])</code>

Returns the unnamed argument, truncated to _length_ (50 by default) characters and with _omission_ (`...` by default) appended.

##### 6.2.6.2 truncate_words

<code>truncate_words(<em>String</em> [length: <em>Integer</em> omission: <em>String</em>])</code>

Returns the unnamed argument, truncated to _length_ (15 by default) words and with _omission_ (`...` by default) appended.

##### 6.2.6.3 html_truncate

<code>html_truncate(<em>String</em> [length: <em>Integer</em> omission: <em>String</em>])</code>

Returns the unnamed argument, truncated to _length_ (50 by default) characters inside HTML text node and with _omission_ (`...` by default) appended to the last HTML text node.

##### 6.2.6.4 html_truncate_words

<code>html_truncate_words(<em>String</em> [length: <em>Integer</em> omission: <em>String</em>])</code>

Returns the unnamed argument, truncated to _length_ (15 by default) words inside HTML text node and with _omission_ (`...` by default) appended to the last HTML text node.

## A Layouts {#appendix-layouts}

TODO
