<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0"
                xmlns="http://www.w3.org/1999/xhtml"
                xmlns:saxon="http://icl.com/saxon"
                extension-element-prefixes="saxon"
>

<xsl:import href="verb.xsl"/>
<xsl:param name="changelog">no</xsl:param>
<xsl:param name="showdiffs" select="false()"/>
<xsl:param name="chunk" select="false()"/>
<xsl:output method="xml" encoding="iso-8859-1"/>

<xsl:key name="new"  match="*[@revisionflag='added']" use="ancestor-or-self::section[1]/@id"/>
<xsl:key name="ids" match="*[@id]" use="@id"/>

<xsl:variable name="prefix" select="'omstd20html-'"/>

<xsl:variable name="chapterlevel">
 <xsl:choose>
  <xsl:when test="$chunk">1</xsl:when>
  <xsl:otherwise>2</xsl:otherwise>
 </xsl:choose>
</xsl:variable>

<xsl:variable name="css">
<style>

body {
margin-left: 1em;
margin-right: 1em;
}

div.mdata {
margin-top: .5em;
margin-bottom: .5em;
margin-left: 5em;
}

span.mdatahead {
font-weight: bold;
}

div.minitoc {
border-width: thin;
border-style: solid;
border-color: blue;
font-size: 90%;
margin-top: 1em;
margin-bottom: 1em;
padding: 1em 1em 1em 1em;
}

p {text-align:justify;	   
  }
code {font-size: 125%;
      font-family: monospace; 
     }
.figure {
border-width:thin;
border-style: solid;
border-color: black;
margin: 0.5em 0.5em 0.5em 0.5em;
padding: 0.5em 0.5em 0.5em 0.5em;
}

div.caption {
margin-top: 1em;
}

.footnote{
font-size: 75%;
font-style: italic;
}
.delliteral {
font-size: 75%;
background-color: #efefef;
border-color: black;
border-style: solid;
border-width: 1px;
padding: 1em;
color: red;
text-decoration: line-through;
}
.newliteral {
font-size: 75%;
background-color: #efefef;
border-color: black;
border-style: solid;
border-width: 1px;
padding: 1em;
color: green;
}
.literal {
font-size: 75%;
background-color: #efefef;
border-color: black;
border-style: solid;
border-width: 1px;
padding: 1em;
margin:bottom: 1em;
}
.del {
color: red;
text-decoration: line-through;
}
.new {
color: green;
}
.chg {
color: blue;
}
.changetoc {
border-style: solid;
border-color: black;
border-width: 1px;
margin: 2em 2em 2em 2em;
background-color: yellow;
}

.lowerroman {
list-style-type: lower-roman;
}
</style>
</xsl:variable>

<xsl:variable name="xsl">
<xsl:text>&#10;</xsl:text>
<xsl:processing-instruction name="xml-stylesheet"
> type="text/xsl" href="pmathml.xsl"</xsl:processing-instruction>
<xsl:text>&#10;</xsl:text>
</xsl:variable>

<xsl:template match="*">
<xsl:message>[<xsl:value-of select="local-name()"/>]</xsl:message>
<font color="red">[[[<xsl:value-of select="name()"/>]]]</font>
</xsl:template>

<xsl:template match="book">
<xsl:variable name="book">
<xsl:copy-of select="$xsl"/>
<html  xml:space="preserve" xmlns:m="http://www.w3.org/1998/Math/MathML">
<xsl:text>&#10;</xsl:text>
<head>
<title><xsl:value-of select="title"/></title>

<xsl:copy-of select="$css"/>
</head>
<body>
<h1><xsl:apply-templates select="title/node()"/></h1>

<div>
<div class="mdata">
<img src="keylogo.png" alt="OM logo"/>
</div>

<div class="mdata">
Version: <xsl:apply-templates select="bookinfo/releaseinfo"/>
</div>

<div class="mdata">
<xsl:apply-templates select="bookinfo/author"/>
</div>

<div class="mdata"><span class="mdatahead">Editors</span><br/>
<xsl:apply-templates select="bookinfo/editor"/>
</div>

<div class="mdata">
<xsl:value-of select="bookinfo/date"/>
</div>

<div class="mdata">&#169; <xsl:value-of select="bookinfo/copyright/year"/> <xsl:value-of select="bookinfo/copyright/holder"/></div>
</div>

<div>
<h3>Abstract</h3>
<xsl:apply-templates select="bookinfo/abstract/*"/>
</div>

<xsl:if test="$showdiffs">
<div class="changetoc">
<h3>Change-marked edition notes</h3>
<p>
This edition contains colour coded change markings
relative to the OpenMath 1.0 document...</p>
<ul>
<li class="new">New text is marked with css class "new" (green).</li>
<li class="del">Deleted text is marked with css class "del" (red).</li>
</ul>

<p>Sections with modified text</p>
<xsl:for-each select="//*[self::section or self::appendix]">
<xsl:if test="key('new',@id)">
<span>
<xsl:for-each select="ancestor::section">&#160;</xsl:for-each>
<a href="#{@id}" class="new">
<xsl:apply-templates mode="number" select="."/>&#160;<span>
<xsl:apply-templates select="title[1]/@revisionflag|title[1]/node()"/>
</span>
</a>
</span>
<br/>
</xsl:if>
</xsl:for-each>
</div>
</xsl:if>

<xsl:apply-templates/>
</body>

</html>
</xsl:variable>
<xsl:choose>
<xsl:when test="$chunk">
  <saxon:output method="xml" encoding="iso-8859-1" href="{$prefix}0.xml">
<xsl:copy-of select="$xsl"/>
<html  xml:space="preserve" xmlns:m="http://www.w3.org/1998/Math/MathML">
<xsl:text>&#10;</xsl:text>
<head>
<title><xsl:value-of select="title"/></title>

<xsl:copy-of select="$css"/>
</head>
<body>
  <xsl:copy-of select="$book"/>
</body>
</html>
  </saxon:output>
</xsl:when>
<xsl:otherwise>
  <xsl:copy-of select="$book"/>
</xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template match="bookinfo"/>
<xsl:template match="title"/>



<xsl:template match="formalpara">
<xsl:if test="$showdiffs or not(@revisionflag='deleted')">
<p>
<xsl:apply-templates select="@revisionflag"/>
<b><xsl:value-of select="title"/></b>
<xsl:text>&#160;&#160;</xsl:text>
<xsl:apply-templates select="*[not(self::title)][1]/node()"/>
<xsl:apply-templates select="*[not(self::title)][position()&gt;1]"/>
</p>
</xsl:if>
</xsl:template>

<xsl:template match="para">
<xsl:if test="$showdiffs or not(@revisionflag='deleted')">
<p>
<xsl:apply-templates select="@revisionflag"/>
<xsl:if test="@id">
<a name="{@id}" id="{@id}"/>
</xsl:if>
<xsl:apply-templates select="node()"/>
</p>
</xsl:if>
</xsl:template>


<xsl:template match="emphasis">
<xsl:if test="$showdiffs or not(@revisionflag='deleted')">
<xsl:choose>
  <xsl:when test="@role='bold' or @role='Bold'">
<b>
<xsl:apply-templates select="@revisionflag|node()"/>
</b>
  </xsl:when>
  <xsl:otherwise>
<i>
<xsl:apply-templates select="@revisionflag|node()"/>
</i>
  </xsl:otherwise>
</xsl:choose>
</xsl:if>
</xsl:template>

<xsl:template match="acronym">
<acronym>
<xsl:value-of select=
"translate(.,'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
</acronym>
</xsl:template>

<xsl:template match="chapter">
<xsl:if test="$showdiffs or not(@revisionflag='deleted')">
<xsl:variable name="n">
<xsl:apply-templates mode="number" select="."/>
</xsl:variable>
<xsl:variable name="chap">
<div>
<xsl:apply-templates select="@revisionflag"/>
<xsl:element name="h{$chapterlevel}">
  <xsl:attribute name="name"><xsl:value-of select="@id"/></xsl:attribute>
  <xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
  Chapter&#160;<xsl:value-of select="$n"/>
  <br/>
  <xsl:apply-templates select="title/node()"/>
</xsl:element>
<xsl:apply-templates/>
</div>
</xsl:variable>
<xsl:choose>
<xsl:when test="$chunk">
  <saxon:output method="xml" encoding="iso-8859-1" href="{$prefix}{$n}.xml">
<xsl:copy-of select="$xsl"/>
<html  xml:space="preserve" xmlns:m="http://www.w3.org/1998/Math/MathML">
<xsl:text>&#10;</xsl:text>
<head>
<title><xsl:value-of select="title"/></title>
<xsl:copy-of select="$css"/>
</head>
<body>
  <xsl:call-template name="minitoc"/>
  <xsl:copy-of select="$chap"/>
  <xsl:call-template name="minitoc">
  <xsl:with-param name="top" select ="false()"/>
  </xsl:call-template>
</body>
</html>
  </saxon:output>
</xsl:when>
<xsl:otherwise>
  <xsl:copy-of select="$chap"/>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
</xsl:template>


<xsl:template name="minitoc">
   <xsl:param name="top" select="true()"/>
<xsl:variable name="n">
<xsl:apply-templates mode="number" select="."/>
</xsl:variable>
  <div class="minitoc">
   <a href="{$prefix}0.xml">OpenMath 2</a><xsl:text> </xsl:text>
 <a href="{$prefix}0.xml#toc">Table of Contents</a><br/><br/>
 <xsl:for-each  select="(preceding-sibling::chapter|preceding-sibling::appendix|preceding-sibling::bibliography)[not(@revisionflag='deleted')][last()]">
 <xsl:variable name="next"><xsl:apply-templates mode="number" select="."/></xsl:variable>
  <a href="{$prefix}{translate($next,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz')}.xml">Previous: <xsl:value-of select="$next"/><xsl:text> </xsl:text>
 <xsl:apply-templates select="title/node()"/></a><br/>
</xsl:for-each>
  <a href="#{@id}">This: <xsl:value-of select="$n"/><xsl:text> </xsl:text>
 <xsl:apply-templates select="title/node()"/></a><br/>
<xsl:if test="$top">
<xsl:apply-templates mode="toc" select="section"/>
</xsl:if> <xsl:for-each  select="(following-sibling::chapter|following-sibling::appendix|following-sibling::bibliography)[not(@revisionflag='deleted')][1]">
 <xsl:variable name="next"><xsl:apply-templates mode="number" select="."/></xsl:variable>
  <a href="{$prefix}{translate($next,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz')}.xml">Next: <xsl:value-of select="$next"/><xsl:text> </xsl:text>
 <xsl:apply-templates select="title/node()"/></a><br/>
</xsl:for-each>
  </div>
</xsl:template>


<xsl:template match="chapter" mode="number">
<xsl:if test="not(@revisionflag='deleted')">
<xsl:number count="chapter[not(@revisionflag='deleted')]"/>
</xsl:if>
</xsl:template>

<xsl:template match="appendix">
<xsl:if test="$showdiffs or not(@revisionflag='deleted')">
<xsl:variable name="n">
<xsl:apply-templates mode="number" select="."/>
</xsl:variable>
<xsl:variable name="app">
 <div>
  <xsl:apply-templates select="@revisionflag"/>
<xsl:element name="h{$chapterlevel}">
  <xsl:attribute name="name"><xsl:value-of select="@id"/></xsl:attribute>
  <xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
  Appendix&#160;<xsl:value-of select="$n"/>
  <br/>
  <xsl:apply-templates select="title/node()"/>
</xsl:element>
<xsl:apply-templates/>
</div>
</xsl:variable>
<xsl:choose>
<xsl:when test="$chunk">
  <saxon:output method="xml" encoding="iso-8859-1" href="{$prefix}{translate($n,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz')}.xml">
<xsl:copy-of select="$xsl"/>
<html  xml:space="preserve" xmlns:m="http://www.w3.org/1998/Math/MathML">
<xsl:text>&#10;</xsl:text>
<head>
<title><xsl:value-of select="title"/></title>

<xsl:copy-of select="$css"/>
</head>
<body>
  <xsl:call-template name="minitoc"/>
  <xsl:copy-of select="$app"/>
  <xsl:call-template name="minitoc">
  <xsl:with-param name="top" select ="false()"/>
  </xsl:call-template>
</body>
</html>
   </saxon:output>
</xsl:when>
<xsl:otherwise>
  <xsl:copy-of select="$app"/>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
</xsl:template>

<xsl:template match="appendix" mode="number">
<xsl:number format="A"/>
</xsl:template>


<xsl:template match="section">
<xsl:if test="$showdiffs or not(@revisionflag='deleted')">
 <div>
  <xsl:apply-templates select="@revisionflag"/>
<xsl:element name="h{count(ancestor::section)+$chapterlevel + 1}">
  <xsl:attribute name="name"><xsl:value-of select="@id"/></xsl:attribute>
  <xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
  <xsl:apply-templates mode="number" select="."/>&#160;<xsl:apply-templates select="title/node()"/>
</xsl:element>
<xsl:apply-templates/>
 </div>
</xsl:if>
</xsl:template>

<xsl:template match="section" mode="number">
<xsl:if test="not(@revisionflag='deleted')">
<xsl:apply-templates mode="number" select="ancestor::chapter|ancestor::appendix"/>
<xsl:text>.</xsl:text>
<xsl:number count="section[not(@revisionflag='deleted')]" level="multiple" format="1.1" from="chapter|appendix"/>
</xsl:if>
</xsl:template>


<xsl:template match="ulink">
<a href="{@url}"><xsl:apply-templates/></a>
</xsl:template>

<xsl:template match="quote">
<span>"<xsl:apply-templates/>"</span>
</xsl:template>


<xsl:template match="phrase">
<xsl:if test="$showdiffs or not(@revisionflag='deleted')">
<span><xsl:apply-templates select="@*|node()"/></span>
</xsl:if>
</xsl:template>

<xsl:template match="@role">
<xsl:attribute name="class"><xsl:value-of select="."/></xsl:attribute>
</xsl:template>


<xsl:template match="phrase[@role='sl']">
<span><i><xsl:apply-templates/></i></span>
</xsl:template>

<xsl:template match="phrase[@role='tt']">
<code><xsl:apply-templates/></code>
</xsl:template>

<xsl:template match="itemizedlist">
<xsl:if test="$showdiffs or not(@revisionflag='deleted')">
<ul>
<xsl:apply-templates select="@revisionflag"/>
<xsl:apply-templates/>
</ul>
</xsl:if>
</xsl:template>


<xsl:template match="orderedlist">
<xsl:if test="$showdiffs or not(@revisionflag='deleted')">
<ol>
<xsl:apply-templates select="@revisionflag"/>
<xsl:apply-templates select="@numeration"/>
<xsl:apply-templates/>
</ol>
</xsl:if>
</xsl:template>

<xsl:template match="@numeration">
<xsl:attribute name="class"><xsl:value-of select="."/></xsl:attribute>
</xsl:template>

<xsl:template match="variablelist">
<xsl:if test="$showdiffs or not(@revisionflag='deleted')">
<dl>
<xsl:apply-templates select="@revisionflag"/>
<xsl:apply-templates/>
</dl>
</xsl:if>
</xsl:template>

<xsl:template match="listitem">
<li>
<xsl:apply-templates select="@*|*"/>
</li>
</xsl:template>

<xsl:template match="varlistentry">
<xsl:apply-templates/>
</xsl:template>

<xsl:template match="varlistentry/listitem">
<dd>
<xsl:apply-templates select="../@*|node()"/>
</dd>
</xsl:template>

<xsl:template match="varlistentry/term">
<dt>
<xsl:apply-templates select="../@*|node()"/>
</dt>
</xsl:template>

<xsl:template match="varname">
<b><xsl:apply-templates/></b>
</xsl:template>

<xsl:template match="filename">
<b><xsl:apply-templates/></b>
</xsl:template>



<xsl:template match="systemitem">
<xsl:if test="$showdiffs or not(@revisionflag='deleted')">
<small><code><xsl:apply-templates select="@revisionflag|node()"/></code></small>
</xsl:if>
</xsl:template>


<xsl:template match="blockquote">
<xsl:if test="$showdiffs or not(@revisionflag='deleted')">
<blockquote><xsl:apply-templates select="@revisionflag|node()"/></blockquote>
</xsl:if>
</xsl:template>


<xsl:template match="figure">
<xsl:if test="$showdiffs or  not(ancestor-or-self::*/@revisionflag='deleted')">
<div class="figure">
<xsl:apply-templates select="(ancestor-or-self::*/@revisionflag)[last()]"/>
<a name="{@id}" id="{@id}"/>
<xsl:apply-templates/>
<div class="caption">
  Figure <xsl:apply-templates mode="number" select="."/>&#160;<xsl:apply-templates select="title/node()"/>
</div>
</div>
</xsl:if>
</xsl:template>


<xsl:template match="figure" mode="number">
<xsl:if test="not(ancestor-or-self::*/@revisionflag='deleted')">
<xsl:number level="multiple" count="chapter[$showdiffs or not(@revisionflag='deleted')]"/>.<xsl:number
count="figure[not(ancestor-or-self::*/@revisionflag='deleted')]" level="any"  from="chapter[$showdiffs or not(@revisionflag='deleted')]"/>
</xsl:if>
</xsl:template>


<xsl:template match="para" mode="number"/>

<xsl:template match="*" mode="number">
<xsl:message>no number for <xsl:value-of select="name()"
/>: <xsl:value-of select="@id"/>
</xsl:message>
</xsl:template>

<xsl:template match="xref">
<xsl:variable name="n" select="key('ids',@linkend)"/>
<xsl:variable name="c">
<xsl:if test="$chunk">
<xsl:value-of select="$prefix"/>
<xsl:apply-templates mode="number" select="$n/ancestor-or-self::appendix|$n/ancestor-or-self::chapter"/>
<xsl:text>.xml</xsl:text>
</xsl:if>
</xsl:variable>
<a href="{translate($c,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz')}#{@linkend}">
<xsl:choose>
<xsl:when test="$n/ancestor::appendix">Appendix</xsl:when>
<xsl:otherwise>
<xsl:value-of select="translate(substring(name($n),1,1),'acfs','ACFS')"/>
<xsl:value-of select="substring(name($n),2)"/>
</xsl:otherwise>
</xsl:choose>
<xsl:text>&#160;</xsl:text>
<xsl:apply-templates mode="number" select="$n"/>
</a>
</xsl:template>

<xsl:template match="programlisting|literallayout">
<xsl:if test="$showdiffs or not(@revisionflag='deleted')">
<xsl:variable name="c">
<xsl:choose>
  <xsl:when test="$showdiffs and @revisionflag='added'">
    <xsl:value-of select="'newliteral'"/>
  </xsl:when>
  <xsl:when test="$showdiffs and @revisionflag='deleted'">
    <xsl:value-of select="'delliteral'"/>
  </xsl:when>
  <xsl:otherwise>
    <xsl:value-of select="'literal'"/>
  </xsl:otherwise>
</xsl:choose>
</xsl:variable>
<div class="{$c}">
<pre>
<xsl:apply-templates/>
</pre>
</div>
</xsl:if>
</xsl:template>

<xsl:template match="sidebar">
<xsl:if test="$changelog='yes'">
changelog entry here
</xsl:if>
</xsl:template>


<xsl:template match="informaltable">
<xsl:if test="$showdiffs or not(@revisionflag='deleted')">
<table>
<xsl:apply-templates select="@revisionflag|tgroup/*"/>
</table>
</xsl:if>
</xsl:template>


<xsl:template match="tbody|thead">
<xsl:apply-templates/>
</xsl:template>

<xsl:template match="row">
<xsl:if test="$showdiffs or not(@revisionflag='deleted')">
<tr><xsl:apply-templates select="@revisionflag|node()"/></tr>
</xsl:if>
</xsl:template>

<xsl:template match="@revisionflag[.='added']">
<xsl:if test="$showdiffs">
 <xsl:attribute name="class">new</xsl:attribute>
</xsl:if>
</xsl:template>

<xsl:template match="@revisionflag[.='deleted']">
<xsl:if test="$showdiffs">
 <xsl:attribute name="class">del</xsl:attribute>
</xsl:if>
<xsl:if test="not($showdiffs)">
<xsl:message>!!!<xsl:value-of select="name(..)"/>
</xsl:message>
</xsl:if>
</xsl:template>

<xsl:template match="@revisionflag[.='changed']">
<xsl:if test="$showdiffs">
 <xsl:attribute name="class">chg</xsl:attribute>
</xsl:if>
</xsl:template>



<xsl:template match="entry">
<xsl:if test="$showdiffs or not(@revisionflag='deleted')">
<td><xsl:apply-templates select="@revisionflag|node()"/></td>
</xsl:if>
</xsl:template>


<xsl:template match="thead/row/entry" priority="2">
<th><xsl:apply-templates/></th>
</xsl:template>

<xsl:key name="cite" match="citation" use="."/>

<xsl:template match="graphic">
<xsl:choose>
<xsl:when test="system-property('xsl:vendor')='Microsoft'">
<embed  src="{@fileref}.svg" type="image/svg+xml" 
       height="{@depth}"
       width="{@width}"
/>
</xsl:when>
<xsl:otherwise>
<img src="{@fileref}.png" alt="{@fileref}.png"/>
</xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template match="footnote">
<sup><a href="#{@id}">*<xsl:number level="any"/></a></sup>
</xsl:template>

<xsl:template match="para[.//footnote]">
<p><xsl:apply-templates select="@revisionflag|node()"/></p>
<xsl:for-each select=".//footnote[$showdiffs or not(ancestor-or-self::*/@revisionflag='deleted')]">
<p class="footnote"><a name="{@id}" id="{@id}"/><sup>*<xsl:number level="any"/></sup> <xsl:apply-templates select="para/node()"/></p>
</xsl:for-each>
</xsl:template>
<!-- toc -->

<xsl:template match="toc">
<h2><a name="toc" id="toc"/>Contents</h2>
<xsl:for-each
select="(/book/chapter|/book/bibliography|/book/appendix)[$showdiffs or not(@revisionflag='deleted')]">
<xsl:if test="not(@id)">
<xsl:message>
No id on <xsl:value-of select="title"/>
</xsl:message>
</xsl:if>
<xsl:variable name="c">
<xsl:if test="$chunk">
<xsl:value-of select="$prefix"/>
<xsl:apply-templates mode="number" select="ancestor-or-self::appendix|ancestor-or-self::chapter|ancestor-or-self::bibliography"/>
<xsl:text>.xml</xsl:text>
</xsl:if>
</xsl:variable>
<a href="{translate($c,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz')}#{@id}">
<xsl:apply-templates select="."
mode="number"/>&#160;<xsl:apply-templates select="title/node()"/>
</a><br/>
<xsl:apply-templates select="section" mode="toc"/>
</xsl:for-each>
</xsl:template>


<xsl:template match="section" mode="toc">
<xsl:if test="$showdiffs or not(@revisionflag='deleted')">
&#160;&#160;&#160;&#160;<xsl:for-each select="ancestor::section">&#160;&#160;&#160;&#160;</xsl:for-each>
<xsl:variable name="c">
<xsl:if test="$chunk">
<xsl:value-of select="$prefix"/>
<xsl:apply-templates mode="number" select="ancestor-or-self::appendix|ancestor-or-self::chapter"/>
<xsl:text>.xml</xsl:text>
</xsl:if>
</xsl:variable>
<a href="{$c}#{@id}">
<xsl:apply-templates select="@revisionflag"/>
<xsl:apply-templates select="." mode="number"/>&#160;<xsl:apply-templates select="title/node()"/>
</a><br/>
<xsl:apply-templates select="section" mode="toc"/>
</xsl:if>
</xsl:template>


<xsl:template match="lot">
<h2><xsl:apply-templates select="title/node()"/></h2>
<xsl:for-each select="//figure[$showdiffs or not(ancestor-or-self::*/@revisionflag='deleted')]">
<xsl:variable name="c">
<xsl:if test="$chunk">
<xsl:value-of select="$prefix"/>
<xsl:apply-templates mode="number" select="ancestor-or-self::appendix|ancestor-or-self::chapter"/>
<xsl:text>.xml</xsl:text>
</xsl:if>
</xsl:variable>
<a href="{$c}#{@id}">
<xsl:apply-templates select="../@revisionflag"/>
<xsl:apply-templates select="."
mode="number"/>&#160;<xsl:apply-templates select="title/node()"/>
</a><br/>
</xsl:for-each>
</xsl:template>

<!-- bibliography -->
<xsl:template match="bibliography">
<xsl:variable name="n">
<xsl:apply-templates mode="number" select="."/>
</xsl:variable>
<xsl:variable name="app">
<div>
<xsl:element name="h{$chapterlevel}">
  <xsl:attribute name="name">bibliography</xsl:attribute>
  <xsl:attribute name="id">bibliography</xsl:attribute>
  <xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
  Appendix&#160;<xsl:value-of select="$n"/>
  <br/>Bibliography</xsl:element>
<xsl:for-each select="biblioentry[key('cite',@id)[$showdiffs or not(ancestor-or-self::*/@revisionflag='deleted')]][$showdiffs or not(@revisionflag='deleted')]">
<xsl:sort select="@revisionflag='deleted'"/>
<xsl:sort select="not(key('cite',@id)[not(ancestor-or-self::*[@revisionflag='deleted'])])"/>
<xsl:sort select="(author[$showdiffs or not(@revisionflag='deleted')][1]/surname|author[$showdiffs or not(@revisionflag='deleted')][1]/othername|bibliomisc[$showdiffs or not(@revisionflag='deleted')][@role='key'])[1]"/>
<p>
<xsl:if test="$showdiffs and not(key('cite',@id)[not(ancestor-or-self::*[@revisionflag='deleted'])])">
 <xsl:attribute name="class">del</xsl:attribute>
</xsl:if>
<xsl:apply-templates select="@revisionflag"/>
<a name="{@id}" id="{@id}"/><b>[<xsl:value-of select="position()"/>]</b>
<xsl:text>&#160;&#160;</xsl:text>
<xsl:for-each select="author[$showdiffs or not(@revisionflag='deleted')]">
 <xsl:choose>
   <xsl:when test="position() = last() and last() &gt; 1"> and </xsl:when>
   <xsl:when test="position() &lt; last() and position() &gt; 1">, </xsl:when>
 </xsl:choose>
 <xsl:value-of select="."/>
</xsl:for-each>
  <xsl:text> </xsl:text>
 <i><xsl:apply-templates select="title[$showdiffs or not(@revisionflag='deleted')]/node()"/>
    <xsl:if test="subtitle[$showdiffs or not(@revisionflag='deleted')]">
    <xsl:text> </xsl:text>
    <xsl:apply-templates select="subtitle[$showdiffs or not(@revisionflag='deleted')]/node()"/>
    </xsl:if>
</i>
 <xsl:for-each select="seriesvolnums[$showdiffs or not(@revisionflag='deleted')]">
  <xsl:text> </xsl:text>
   <xsl:value-of select="."/>
  </xsl:for-each>
 <xsl:for-each select="publisher[$showdiffs or not(@revisionflag='deleted')]">
  <xsl:text> </xsl:text>
   <xsl:apply-templates/>
  </xsl:for-each>
<xsl:if test="pubdate[$showdiffs or not(@revisionflag='deleted')]">
  <xsl:text>, </xsl:text>
 <xsl:if test="pubdate[$showdiffs or not(@revisionflag='deleted')][@role]">
   <xsl:apply-templates select="pubdate[$showdiffs or not(@revisionflag='deleted')][@role]/node()"/>
   <xsl:text> </xsl:text>
 </xsl:if>
 <xsl:apply-templates select="pubdate[$showdiffs or not(@revisionflag='deleted')][not(@role)]/node()"/>
</xsl:if>
<xsl:text>.</xsl:text>
<xsl:for-each select="bibliomisc[$showdiffs or not(@revisionflag='deleted')][contains(.,'http')]">
 <br/><a href="http{substring-after(.,'http')}">
   <xsl:apply-templates select="@revisionflag"/>
   <xsl:value-of select="."/>
  </a>
</xsl:for-each>
</p>
</xsl:for-each>
</div>
</xsl:variable>
<xsl:choose>
<xsl:when test="$chunk">
  <saxon:output method="xml" encoding="iso-8859-1" href="{$prefix}{translate($n,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz')}.xml">
<xsl:copy-of select="$xsl"/>
<html  xml:space="preserve" xmlns:m="http://www.w3.org/1998/Math/MathML">
<xsl:text>&#10;</xsl:text>
<head>
<title>Bibliography</title>

<xsl:copy-of select="$css"/>
</head>
<body>
  <xsl:call-template name="minitoc"/>
  <xsl:copy-of select="$app"/>
  <xsl:call-template name="minitoc">
  <xsl:with-param name="top" select ="false()"/>
  </xsl:call-template>
</body>
</html>
   </saxon:output>
</xsl:when>
<xsl:otherwise>
  <xsl:copy-of select="$app"/>
</xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template match="publishername">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="bibliography" mode="number">
<xsl:number format="A" value="1+count(preceding-sibling::appendix)"/>
</xsl:template>

<xsl:variable name="bib" select="/book/bibliography/biblioentry[key('cite',@id)[$showdiffs or not(ancestor-or-self::*/@revisionflag='deleted')]][$showdiffs or not(@revisionflag='deleted')]"/>

<xsl:template match="citation">
<xsl:if test="$showdiffs or not(@revisionflag='deleted')">
<xsl:variable name="x" select="."/>
<xsl:variable name="c">
<xsl:if test="$chunk">
<xsl:value-of select="$prefix"/>
<xsl:apply-templates mode="number" select="/book/bibliography"/>
<xsl:text>.xml</xsl:text>
</xsl:if>
</xsl:variable>
<a href="{translate($c,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz')}#{.}">[<xsl:for-each select="$bib">
<xsl:sort select="@revisionflag='deleted'"/>
<xsl:sort select="not(key('cite',@id)[not(ancestor-or-self::*[@revisionflag='deleted'])])"/>
<xsl:sort select="(author[1]/surname|author[1]/othername|bibliomisc[@role='key'])[1]"/>
<xsl:if test="@id=$x"><xsl:value-of select="position()"/></xsl:if>
</xsl:for-each>]</a>
</xsl:if>
</xsl:template>

<xsl:template match="releaseinfo|firstname|surname|othername">
 <xsl:value-of select="."/>
</xsl:template>

<xsl:template match="editor|author">
<xsl:for-each select="*">
  <xsl:apply-templates select="."/>
 <xsl:if test="position() &lt; last()">&#160;</xsl:if>
</xsl:for-each>
 <xsl:choose>
 <xsl:when test="position() &lt; last()-1">,&#160;</xsl:when>
 <xsl:when test="position() &lt; last()">&#160;and&#160;</xsl:when>
 </xsl:choose>
</xsl:template>


<!-- MathML -->
<xsl:template match="math">
<xsl:apply-templates mode="math" select="."/>
<xsl:if test="not(@display='block') and following-sibling::node()[1] and 
following-sibling::node()[1][starts-with(.,' ') or starts-with(.,'&#10;')]">&#160;</xsl:if>
</xsl:template>

<xsl:template
match="text()[starts-with(.,' ')][preceding-sibling::node()[1][self::math[not(@display='block')]]]">
 <xsl:value-of select="substring-after(.,' ')"/>
</xsl:template>
<xsl:template
match="text()[starts-with(.,'&#10;')][preceding-sibling::node()[1][self::math[not(@display='block')]]]">
 <xsl:value-of select="substring-after(.,'&#10;')"/>
</xsl:template>

<xsl:template mode="math" match="*">
<xsl:element name="m:{local-name(.)}" namespace="http://www.w3.org/1998/Math/MathML">
<xsl:copy-of select="@*"/>
<xsl:apply-templates mode="math"/>
</xsl:element>
</xsl:template>

<xsl:template match="comment">
<span style="color:brown;"><xsl:value-of select="."/></span></xsl:template>

<xsl:template match="token">
  <xsl:value-of select="."/>
</xsl:template>
<xsl:template match="string">
  <xsl:value-of select="."/>
</xsl:template>


<xsl:template match="token[not(preceding-sibling::*[1]='element' 
or preceding-sibling::*[1]='attribute')]" priority="2">
<a href="#rnc{ancestor::section[1]/@id[not(current()='OMOBJ')]}{.}"><xsl:value-of select="."/></a>
</xsl:template>

<xsl:template match="token[.='element' or .='attribute'
or .='default' or .='namespace' or .='pattern' or .='text' 
or .='include']"
priority="4">
  <span style="font-weight:bold;"><xsl:value-of select="."/></span>
</xsl:template>

<xsl:template
match="token[starts-with(normalize-space(following-sibling::node()[1]),'=')]"
priority="3">
<a name="rnc{ancestor::section[1]/@id[not(current()='OMOBJ')]}{preceding-sibling::*[1][.='namespace']}{.}" style="color:blue;"><xsl:value-of select="."/></a>
</xsl:template>


<xsl:template
match="token[contains(.,':')]" priority="5">
<a href="#rnc{ancestor::section[1]/@id}namespace{substring-before(.,':')}"><xsl:value-of
select="substring-before(.,':')"/>:</a>
<xsl:value-of select="substring-after(.,':')"/>
</xsl:template>

<xsl:template match="token[starts-with(.,'xsd:')]" priority="6">
  <span style="font-weight:bold;"><xsl:value-of select="."/></span>
</xsl:template>



<xsl:template match="rng:grammar" xmlns:rng="http://relaxng.org/ns/structure/1.0">
<xsl:apply-templates mode="verb" select="."/>
</xsl:template>


<xsl:template match="xsd:schema" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
<xsl:apply-templates mode="verb" select="."/>
</xsl:template>

<xsl:template match="cd:CD" xmlns:cd="http://www.openmath.org/OpenMathCD">
<xsl:apply-templates mode="verb" select="."/>
</xsl:template>

<xsl:template match="cdg:CDGroup" xmlns:cdg="http://www.openmath.org/OpenMathCDG">
<xsl:apply-templates mode="verb" select="."/>
</xsl:template>

<xsl:template match="cds:CDSignatures" xmlns:cds="http://www.openmath.org/OpenMathCDS">
<xsl:apply-templates mode="verb" select="."/>
</xsl:template>


<xsl:template match="cd:*" mode="name"  xmlns:cd="http://www.openmath.org/OpenMathCD">
<span style="font-weight: bold; color: blue">
<xsl:value-of select="local-name()"/>
</span>
</xsl:template>

<xsl:template match="cds:*" mode="name"  xmlns:cds="http://www.openmath.org/OpenMathCDS">
<span style="font-weight: bold; color: blue">
<xsl:value-of select="local-name()"/>
</span>
</xsl:template>

<xsl:template match="cdg:*" mode="name"  xmlns:cdg="http://www.openmath.org/OpenMathCDG">
<span style="font-weight: bold; color: blue">
<xsl:value-of select="local-name()"/>
</span>
</xsl:template>

<xsl:template match="om:*" mode="name"  xmlns:om="http://www.openmath.org/OpenMath">
<span style="font-weight: bold; color: green">
<xsl:value-of select="local-name()"/>
</span>
</xsl:template>

<xsl:template match="*" mode="name" >
<span style="font-weight: bold; color: red">
<xsl:value-of select="local-name()"/>
</span>
</xsl:template>




</xsl:stylesheet>

