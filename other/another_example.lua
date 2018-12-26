return {
text = [=[
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML>
<HEAD>
<TITLE>Lua 5.3 Reference Manual</TITLE>
<LINK REL="stylesheet" TYPE="text/css" HREF="lua.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="manual.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html; charset=iso-8859-1">
</HEAD>

<BODY>

<H1>
<A HREF="http://www.lua.org/"><IMG SRC="logo.gif" ALT="Lua"></A>
Lua 5.3 Reference Manual
</H1>

<P>
by Roberto Ierusalimschy, Luiz Henrique de Figueiredo, Waldemar Celes

<P>
<SMALL>
Copyright &copy; 2015&ndash;2018 Lua.org, PUC-Rio.
Freely available under the terms of the
<a href="http://www.lua.org/license.html">Lua license</a>.
</SMALL>

<DIV CLASS="menubar">
<A HREF="contents.html#contents">contents</A>
&middot;
<A HREF="contents.html#index">index</A>
&middot;
<A HREF="http://www.lua.org/manual/">other versions</A>
</DIV>

<!-- ====================================================================== -->
<p>

<!-- $Id: manual.of,v 1.167.1.2 2018/06/26 15:49:07 roberto Exp $ -->




<h1>1 &ndash; <a name="1">Introduction</a></h1>

<p>
Lua is a powerful, efficient, lightweight, embeddable scripting language.
It supports procedural programming,
object-oriented programming, functional programming,
data-driven programming, and data description.


<p>
Lua combines simple procedural syntax with powerful data description
constructs based on associative arrays and extensible semantics.
Lua is dynamically typed,
runs by interpreting bytecode with a register-based
virtual machine,
and has automatic memory management with
incremental garbage collection,
making it ideal for configuration, scripting,
and rapid prototyping.


<p>
Lua is implemented as a library, written in <em>clean C</em>,
the common subset of Standard&nbsp;C and C++.
The Lua distribution includes a host program called <code>lua</code>,
which uses the Lua library to offer a complete,
standalone Lua interpreter,
for interactive or batch use.
Lua is intended to be used both as a powerful, lightweight,
embeddable scripting language for any program that needs one,
and as a powerful but lightweight and efficient stand-alone language.


<p>
As an extension language, Lua has no notion of a "main" program:
it works <em>embedded</em> in a host client,
called the <em>embedding program</em> or simply the <em>host</em>.
(Frequently, this host is the stand-alone <code>lua</code> program.)
The host program can invoke functions to execute a piece of Lua code,
can write and read Lua variables,
and can register C&nbsp;functions to be called by Lua code.
Through the use of C&nbsp;functions, Lua can be augmented to cope with
a wide range of different domains,
thus creating customized programming languages sharing a syntactical framework.


<p>
Lua is free software,
and is provided as usual with no guarantees,
as stated in its license.
The implementation described in this manual is available
at Lua's official web site, <code>www.lua.org</code>.


<p>
Like any other reference manual,
this document is dry in places.
For a discussion of the decisions behind the design of Lua,
see the technical papers available at Lua's web site.
For a detailed introduction to programming in Lua,
see Roberto's book, <em>Programming in Lua</em>.



<h1>2 &ndash; <a name="2">Basic Concepts</a></h1>

<p>
This section describes the basic concepts of the language.



<h2>2.1 &ndash; <a name="2.1">Values and Types</a></h2>

<p>
Lua is a <em>dynamically typed language</em>.
This means that
variables do not have types; only values do.
There are no type definitions in the language.
All values carry their own type.


<p>
All values in Lua are <em>first-class values</em>.
This means that all values can be stored in variables,
passed as arguments to other functions, and returned as results.


<p>
There are eight basic types in Lua:
<em>nil</em>, <em>boolean</em>, <em>number</em>,
<em>string</em>, <em>function</em>, <em>userdata</em>,
<em>thread</em>, and <em>table</em>.
The type <em>nil</em> has one single value, <b>nil</b>,
whose main property is to be different from any other value;
it usually represents the absence of a useful value.
The type <em>boolean</em> has two values, <b>false</b> and <b>true</b>.
Both <b>nil</b> and <b>false</b> make a condition false;
any other value makes it true.
The type <em>number</em> represents both
integer numbers and real (floating-point) numbers.
The type <em>string</em> represents immutable sequences of bytes.

Lua is 8-bit clean:
strings can contain any 8-bit value,
including embedded zeros ('<code>\0</code>').
Lua is also encoding-agnostic;
it makes no assumptions about the contents of a string.


<p>
The type <em>number</em> uses two internal representations,
or two subtypes,
one called <em>integer</em> and the other called <em>float</em>.
Lua has explicit rules about when each representation is used,
but it also converts between them automatically as needed (see <a href="#3.4.3">&sect;3.4.3</a>).
Therefore,
the programmer may choose to mostly ignore the difference
between integers and floats
or to assume complete control over the representation of each number.
Standard Lua uses 64-bit integers and double-precision (64-bit) floats,
but you can also compile Lua so that it
uses 32-bit integers and/or single-precision (32-bit) floats.
The option with 32 bits for both integers and floats
is particularly attractive
for small machines and embedded systems.
(See macro <code>LUA_32BITS</code> in file <code>luaconf.h</code>.)


<p>
Lua can call (and manipulate) functions written in Lua and
functions written in C (see <a href="#3.4.10">&sect;3.4.10</a>).
Both are represented by the type <em>function</em>.


<p>
The type <em>userdata</em> is provided to allow arbitrary C&nbsp;data to
be stored in Lua variables.
A userdata value represents a block of raw memory.
There are two kinds of userdata:
<em>full userdata</em>,
which is an object with a block of memory managed by Lua,
and <em>light userdata</em>,
which is simply a C&nbsp;pointer value.
Userdata has no predefined operations in Lua,
except assignment and identity test.
By using <em>metatables</em>,
the programmer can define operations for full userdata values
(see <a href="#2.4">&sect;2.4</a>).
Userdata values cannot be created or modified in Lua,
only through the C&nbsp;API.
This guarantees the integrity of data owned by the host program.
]=]}
