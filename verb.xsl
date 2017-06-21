

<xsl:stylesheet 
  version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns="http://www.w3.org/1999/xhtml"
  >

<!--
Copyright 1999 2000 2001 David Carlisle

Use and distribution of this code are permitted under the terms of the <a
href="http://www.w3.org/Consortium/Legal/copyright-software-19980720"
>W3C Software Notice and License</a>.
-->

<xsl:template match="node()" mode="name">
  <xsl:value-of select="local-name(.)"/>
</xsl:template>

<!-- non empty elements and other nodes. -->
<xsl:template mode="verb"
match="*[*]|*[text()]|*[comment()]|*[processing-instruction()]" priority="2">
  <xsl:value-of select="'&lt;'"/>
  <xsl:apply-templates select="." mode="name"/>
  <xsl:for-each select="namespace::*">
  <xsl:choose>
   <xsl:when test="name()='xml'"/>
   <xsl:when test="string(../../namespace::*[name()=name(current())])=concat(.,'G')"/>
   <xsl:when test="string(../../namespace::*[name()=name(current())])=."/>
   <xsl:when test="name()=''">&#10; xmlns="<xsl:value-of select="."/>"</xsl:when>
   <xsl:otherwise>&#10; xmlns:<xsl:value-of select="name()"/>="<xsl:value-of select="."/>"</xsl:otherwise>
  </xsl:choose>
</xsl:for-each>
  <xsl:apply-templates mode="verb" select="@*"/>
  <xsl:text>&gt;</xsl:text>
  <xsl:apply-templates mode="verb"/>
  <xsl:value-of select="'&lt;/'"/>
  <xsl:apply-templates select="." mode="name"/>
  <xsl:value-of select="'&gt;'"/>
</xsl:template>

<!-- empty elements -->
<xsl:template mode="verb" match="*" priority="1.5">
  <xsl:value-of select="'&lt;'"/>
  <xsl:apply-templates select="." mode="name"/>
  <xsl:apply-templates mode="verb" select="@*"/>
  <xsl:text>/&gt;</xsl:text>
</xsl:template>

<!-- attributes
     Output always surrounds attribute value by "
     so we need to make sure no literal " appear in the value  -->
<xsl:template mode="verb" match="@*" priority="1.5">
  <xsl:if test="(../@*)[string-length(.)&gt;50]">
  <xsl:text>&#10;</xsl:text>
  </xsl:if>
  <xsl:value-of select="concat(' ',name(.),'=')"/>
  <xsl:text>"</xsl:text>
  <xsl:call-template name="string-replace">
    <xsl:with-param name="from" select="'&quot;'"/>
    <xsl:with-param name="to" select="'&amp;quot;'"/> 
    <xsl:with-param name="string" select="."/>
  </xsl:call-template>
  <xsl:text>"</xsl:text>
</xsl:template>



<!-- pis -->
<xsl:template mode="verb" match="processing-instruction()">
  <xsl:text>&lt;?</xsl:text>
  <xsl:value-of select="."/>
  <xsl:text>?></xsl:text>
</xsl:template>

<!-- only works if parser passes on comment nodes -->
<xsl:template mode="verb" match="comment()" priority="2">
  <xsl:text>&lt;!--</xsl:text>
  <xsl:value-of select="."/>
  <xsl:text>--></xsl:text>
</xsl:template>


<!-- text elements
     need to replace & and < by entity references-->
<xsl:template mode="verb" match="text()" priority="2">
  <a name="{generate-id(.)}"/>
  <xsl:call-template name="string-replace">
    <xsl:with-param name="to" select="'&amp;gt;'"/>
    <xsl:with-param name="from" select="'&gt;'"/> 
    <xsl:with-param name="string">
      <xsl:call-template name="string-replace">
        <xsl:with-param name="to" select="'&amp;lt;'"/>
        <xsl:with-param name="from" select="'&lt;'"/> 
        <xsl:with-param name="string">
          <xsl:call-template name="string-replace">
            <xsl:with-param name="to" select="'&amp;amp;'"/>
            <xsl:with-param name="from" select="'&amp;'"/> 
            <xsl:with-param name="string" select="."/>
          </xsl:call-template>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>


<!-- end  verb mode -->

<!-- replace all occurences of the character(s) `from'
     by the string `to' in the string `string'.-->
<xsl:template name="string-replace" >
  <xsl:param name="string"/>
  <xsl:param name="from"/>
  <xsl:param name="to"/>
  <xsl:choose>
    <xsl:when test="contains($string,$from)">
      <xsl:value-of select="substring-before($string,$from)"/>
      <xsl:value-of select="$to"/>
      <xsl:call-template name="string-replace">
      <xsl:with-param name="string" select="substring-after($string,$from)"/>
      <xsl:with-param name="from" select="$from"/>
      <xsl:with-param name="to" select="$to"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$string"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>

