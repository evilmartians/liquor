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
  border: 1px solid #E0DDDA;
  border-radius: 0.2em;
  padding: 1px;
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
dt em {

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

### 2.2 Types and Variables

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

Liquor has _expressions_, which can be used to perform computations with values. This section does not define a normative grammar; the full grammar is provided in section [Grammar](#grammar).

Order of evaluation of Liquor expressions is not defined. As every value is immutable, the value of the entire expression should not depend upon the order of evaluation. Implementation-provided tags and functions should not mutate any global state.

#### 2.4.1 Literals

All Liquor types except **External** can be specified as literals in expressions.

Identifiers _null_, _true_ and _false_ evaluate to the corresponding values.

Numeric literals evaluate to a corresponding **Integer** value, and always use base 10. Numeric literals can be specified with any amount of leading zeroes. There are no negative numeric literals.

String literals evaluate to a corresponding **String** value. String literals can be equivalently specified with single or double quotes. Strings support escaping with backslash, and there are exactly two escape sequences: one inserts a literal backslash, and the other one inserts a literal quote. More specifically, single quoted string supports escape sequences `\\` and `\'`, and double quoted string supports escape sequences `\\` and `\"`. A single backslash followed by any character not specified above is translated to a literal backslash.

Tuple literals evaluate to a corresponding **Tuple** value. Tuple literals are surrounded by square brackets and delimited with commas; that is, `[ 1, 2, 3 ]` is a tuple literal containing three integer values, one, two and three, in that exact order.

#### 2.4.2 Operators

Liquor supports unary and binary infix operators in expressions. All operators are left-associative.

Liquor operators are listed in order of precedence, from highest to lowest, by the following table:

1. `[]`, `.`
2. unary `-`, `!`
3. `*`, `/`, `%`
4. `+`, binary `-`
5. `==`, `!=`, `<`, `<=`, `>`, `>=`
6. `&&`
7. `||`

The following operators are infix and binary: `*`, `/`, `%`, `+`, `-`, `==`, `!=`, `<`, `<=`, `>`, `>=`, `&&`, `||`.
The following operators are infix and unary: `-`, `!`.

The indexing operator `[]` is binary but not infix. The access operator `.` is binary but only interprets its right-hand side argument lexically (i.e. does not evaluate it).

##### 2.4.2.1 Arithmetic Operators

Arithmetic operators are `*` (multiply), `/` (division), `%` (modulo), `+` (plus) and `-` (minus; binary and unary).

All arithmetic operators, whether unary or binary, require every argument to be of type **Integer**. If this is not the case, a runtime error condition is signaled.

If the result of an arithmetic operation exceeds the range an implementation can represent, the behavior is implementation-defined.

##### 2.4.2.2 Boolean Operators

Boolean operators are `!` (not; unary), `&&` (and) and `||` (or).

All boolean operators, whether unary or binary, convert each argument to type **Boolean** prior to evaluation. The rules of conversion are:

1. If the value equals _null_ or _false_, it is assumed to be _false_.
2. Else, the value is assumed to be _true_.

All boolean operators return a value of type **Boolean**. Binary boolean operators do not provide any guarantees on order or sequence of evaluation.

##### 2.4.2.3 Comparison Operators

Comparison operators are `==` (equals), `!=` (not equals), `<` (less), `<=` (less or equal), `>` (greater) and `>=` (greater or equal).

Operators `==` and `!=` compare values by equality, not identity. Thus, the expression `[ 1, 2 ] == [ 1, 2 ]` evluates to _true_. These operators never signal an error condition or implicitly convert types.

Operators `<`, `<=`, `>` and `>=` require both arguments to be of type **Integer**. If this is not the case, a runtime error condition is signaled. Otherwise, a corresponding value of type **Boolean** is returned.

##### 2.4.2.4 Indexing Operator

Indexing operator is `[]`.

Indexing operator requires its left-hand side argument to be of type **Tuple**, and right-hand side argument to be of type **Integer**. If this is not the case, a runtime error condition is signaled.

Indexing operator of form <code><em>t</em>[<em>n</em>]</code> evaluates to _n_-th value from tuple _t_ with zero-based indexing. If `n` is negative, then _n_+1-th element from the end of tuple is returned. For example, <code><em>t</em>[-1]</code> will evaluate to the last element of the tuple _t_.

If the requested element does not exist in the tuple, the indexing operator evaluates to _null_.

##### 2.4.2.5 Access Operator

Access operator is `.`.

Access operator requires its left-hand side argument to be of type **External**, and right-hand side argument to be a lexical identifier. If this is not the case, a runtime error condition is signaled.

Access operator of form <code><em>e</em>.<em>f</em></code> evaluates to the value of field _f_ of external object _e_. This evaluation is done in an implementation-defined way. Access operator can evaluate to any type.

If the requested field does not exist in the external object, a runtime error condition is signaled.

#### 2.4.3 Function Calls

Identifiers can be bound to functions prior to compilation. Identifiers _null_, _true_ and _false_ cannot be bound to a function.

Functions are defined in an implementation-specific way. Functions can have zero to one unnamed formal parameters and any amount of named formal parameters. If an unnamed formal parameter exists, it is mandatory. Named formal parameters can be either mandatory or optional. Absence of a mandatory formal parameter will result in a compile-time error. Named formal parameter order is irrelevant.

Function calls have mandatory parentheses, and arguments are whitespace-delimited.

If a function call includes two named parameters with the same name, a compile-time error is raised.

If a hypothetical function _substr_ has one unnamed formal parameter and two optional named formal parameters _from_ and _length_, then all of the following expressions are syntactically valid and will not result in a compile-time error: `substr("foobar")`, `substr("foobar" from: 1)`, `substr("foobar" from: 1 length:(5 - 2))`. The following expression, however, is syntactically valid but will result in a compile-time error: `substr(from: 1)`.

#### 2.4.4 Variable Access

Every identifier except _null_, _true_ and _false_ which is not bound to a function name is available to be bound as a variable name. Such identifier would evaluate to a value of the variable.

Variable definition and scoping will be further discussed in section [Tags](#tags).

Referencing an undefined variable shall result in a compile-time error.

#### 2.4.5 Filter Expressions

Filter expressions are a syntactic sugar for method composition and currying.

<p markdown="0">
In essence, <code><em>e</em> | <em>f</em> a: 1 | <em>g</em></code> is equivalent to <code><em>g</em>(<em>f</em>(<em>e</em>() a: 1))</code>.
</p>

### 2.5 Blocks

A block is a chunk of plaintext with _tags_ and _interpolations_ embedded into it. Every Liquor program has at least one block: the toplevel one.

A block consisting only of plaintext would return its literal value upon execution. Thus, the famous Hello World program would be as follows:

    Hello World!

This program would evaluate to a string `Hello World!`.

A block can have other elements embedded into it. When such a block is executed, these elements are executed in syntactical order and are replaced with the value returned by the element.

### 2.6 Interpolations

An interpolation is a syntactic construct of form `{{ expr }}` which can be embedded in a block. The expression `expr` should evaluate to a value of type **String**; an [implicit conversion](#type-conversion) might take place. If this is not the case, a runtime error condition is signaled.

An example of using an interpolation would be:

    The sum of two and three is: {{ 2 + 3 }}

This program would evaluate to a string `The sum of two and three is: 5`.

### 2.7 Tags

A tag is a syntactic construct of form `{% tag expr kw: arg do: %} ... {% endtag %}`. A tag has a syntax similar to a function call, but it can receive blocks of code as argument values and lazily evaluate passed expressions and blocks of code.

Tags are defined in an implementation-specific way. Tags can have zero to one unnamed formal parameters and any amount of named formal parameters. If an unnamed formal parameter exists, it is mandatory. Named formal parameters can be either mandatory or optional. Absence of a mandatory formal parameter will result in a compile-time error.

Tags have full control upon parameter evaluation. Tags can require arguments to be of a certain lexical form, e.g. a `for` tag could require its unnamed formal parameter to be a lexical identifier.

To pass a block of code to a tag, the closing tag delimiter should immediately follow a parameter name. Everything from the closing tag delimiter to the matching opening tag delimiter should be parsed as a block and passed as a value of the corresponding parameter. After the matching opening tag delimiter, the parameter list is continued.

If a tag <code><em>t</em></code> does not include any embedded blocks, it ends after a first matching closing tag delimiter. Otherwise, the tag ends after a first matching construct of the form <code>{% end<em>t</em> %}</code>.

Unlike functions, tags can receive multiple named parameters with the same name. Tag named parameters are a syntactic tool and should be thoroughly verified by the tag implementation. Incorrect names or order of named parameters should result in a compile-time error.

All of the following are examples of syntactically valid tags:

    {% yield %}

    {% if var > 10 do: %}
      Var is greater than 10.
    {% endif %}

    {% for i in: [ 1, 2, 3 ] do: %}
      Value: {{ i }}
    {% endfor %}

    {% if length(params.test) == 1 then: %}
      Test has length 1.
    {% elsif: length(params.test) == 2 then: %}
      Test has length 2.
    {% else: %}
      Test has unidentified length.
    {% endif %}

    {% capture "buffer" do: %}
      This text will be printed twice.
    {% endcapture %}
    {% yield from: "buffer" %}
    {% yield from: "buffer" %}


3 Grammar
---------

The following Extended Backus-Naur form grammar is normative. The native character set of Liquor is Unicode, and every character literal specified is an explicit codepoint or continuous codepoint set.

### 3.1 Basic syntax

Whitespace
: **U+0007** \| **U+0020**

Alpha
: **a** to **z** \| **A** to **Z**

Digit
: **0** to **9**

Any
: any Unicode character

Symbol
: _Alpha_ \| **_**

Identifier
: _Symbol_ ( _Symbol_ \| _Digit_ )*

IntegerLiteral
: _Digit_+

StringLiteral
: **\"** ( **\\\\**  \| **\\\"** \| _Any_ not **\"** )* **\"**
: **\'** ( **\\\\**  \| **\\\'** \| _Any_ not **\'** )* **\'**

TupleLiteral
: **[** _TupleLiteralContent_ **]**

TupleLiteralContent
: _Expression_ **,** _TupleLiteralContent_
: _Expression_
: empty

### 3.2 Expressions

Operator precedence table is present in section [Operators](#operators).

PrimaryExpression
: _Identifier_
: **(** _Expression_ **)**

Expression
: _IntegerLiteral_
: _StringLiteral_
: _TupleLiteral_
: _Identifier_ **(** _FunctionArguments_ **)**
: _PrimaryExpression_ **[** _Expression_ **]**
: _PrimaryExpression_ **.** _Identifier_
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

FunctionArguments
: _Expression_ _FunctionKeywordArguments_
: _FunctionKeywordArguments_
: _Expression_
: empty

FunctionKeywordArguments
: _Keyword_ _Expression_ _FunctionKeywordArguments_
: empty

### 3.3 Blocks

TODO

4 Compile-time Behavior
-----------------------

TODO

5 Runtime Behavior
------------------

TODO

6 Builtins
----------

