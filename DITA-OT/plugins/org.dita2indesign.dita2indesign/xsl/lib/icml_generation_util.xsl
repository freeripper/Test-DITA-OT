<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
      xmlns:xs="http://www.w3.org/2001/XMLSchema"
      xmlns:idsc="http://www.reallysi.com/namespaces/indesign_style_catalog"
      xmlns:ditaarch="http://dita.oasis-open.org/architecture/2005/"
      xmlns:xmp-x="adobe:ns:meta/"
      xmlns:pam="http://prismstandard.org/namespaces/pam/1.0/"
      xmlns:prism="http://prismstandard.org/namespaces/basic/1.2/"
      xmlns:pim="http://prismstandard.org/namespaces/pim/1.2/"
      xmlns:dc="http://purl.org/dc/elements/1.1/"
      xmlns:xhtml="http://www.w3.org/1999/xhtml"
      xmlns:incxgen="http//dita2indesign.org/functions/incx-generation"
      exclude-result-prefixes="xs idsc incxgen ditaarch xmp-x pam prism dc pim xhtml"
      version="2.0">
  <!-- =================================================
       Adobe InCopy Markup Language (ICML) generation utilities.
       
       Copyright (c) 2011 DITA for Publishers.
       
       ================================================= -->
  
  <!-- URL (relative to the stylesheet document if not absolute)
       of the InDesign style catalog to use in generating 
       the result InCopy articles.
    -->
  <xsl:param name="styleCatalogUri" select="''" as="xs:string"/>
  
  <xsl:variable name="defaultStyleCatalogUri"
    select="'default-dita-indesign-style-catalog.xml'"
    as="xs:string"
  />

  <xsl:template name="makeBlock-cont">
    <xsl:param name="pStyle" select="'ID$/[No paragraph style]'" as="xs:string" tunnel="yes"/>
    <xsl:param name="cStyle" select="'ID$/[No character style]'" as="xs:string" tunnel="yes"/>
    <xsl:param name="txsrAtts" tunnel="yes" as="attribute()*"/>
    <xsl:param name="content" as="node()*"/>
    <xsl:param name="markerType" as="xs:string" select="'para'"/>
    
<!--    <xsl:message> + [DEBUG] makeBlock-cont: pStyle="<xsl:sequence select="$pStyle"/>", cStyle="<xsl:sequence select="$cStyle"/>"</xsl:message>-->
    
    <xsl:variable name="pcntContent" as="node()*">
      <xsl:choose>
        <xsl:when test="count($content) gt 0">
          <xsl:apply-templates select="$content" mode="block-children"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="text()|*|processing-instruction()" mode="block-children"/>
        </xsl:otherwise>
      </xsl:choose>      
    </xsl:variable>
    
    <xsl:sequence select="$pcntContent"/>
    <xsl:choose>
      <xsl:when test="$markerType = 'framebreak'">
        <ParagraphStyleRange
          AppliedParagraphStyle="ParagraphStyle/{$pStyle}">
          <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/$ID/[No character style]" ParagraphBreakType="NextFrame">
            <Br/>
          </CharacterStyleRange>
        </ParagraphStyleRange>  
      </xsl:when>
      <xsl:when test="$markerType = 'columnbreak'">
        <ParagraphStyleRange
          AppliedParagraphStyle="ParagraphStyle/{$pStyle}">
          <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/$ID/[No character style]" ParagraphBreakType="NextColumn">
            <Br/>
          </CharacterStyleRange>
        </ParagraphStyleRange>  
      </xsl:when>
      <xsl:when test="$markerType = 'linebreak'">
        <ParagraphStyleRange
          AppliedParagraphStyle="ParagraphStyle/{$pStyle}">
          <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/$ID/[No character style]">
            <Content><xsl:text>&#x2028;</xsl:text></Content>
          </CharacterStyleRange>
        </ParagraphStyleRange>  
      </xsl:when>
      <xsl:when test="$markerType = 'pagebreak'">
        <ParagraphStyleRange
          AppliedParagraphStyle="ParagraphStyle/{$pStyle}">
          <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/$ID/[No character style]" ParagraphBreakType="NextPage">
            <Br/>
          </CharacterStyleRange>
        </ParagraphStyleRange>  
      </xsl:when>
      <xsl:when test="$markerType = 'oddpagebreak'">
        <ParagraphStyleRange
          AppliedParagraphStyle="ParagraphStyle/{$pStyle}">
          <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/$ID/[No character style]" ParagraphBreakType="NextOddPage">
            <Br/>
          </CharacterStyleRange>
        </ParagraphStyleRange>  
      </xsl:when>
      <xsl:when test="$markerType = 'evenpagebreak'">
        <ParagraphStyleRange
          AppliedParagraphStyle="ParagraphStyle/{$pStyle}">
          <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/$ID/[No character style]" ParagraphBreakType="NextEvenPage">
            <Br/>
          </CharacterStyleRange>
        </ParagraphStyleRange>  
      </xsl:when>
      <xsl:when test="$markerType = 'none'"/>
      <xsl:otherwise>
        <ParagraphStyleRange
          AppliedParagraphStyle="ParagraphStyle/{$pStyle}">
          <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/$ID/[No character style]">
            <Br/>
          </CharacterStyleRange>
        </ParagraphStyleRange>  
      </xsl:otherwise>
    </xsl:choose>
    
  </xsl:template>
  
  <xsl:template mode="generateStyles" match="idsc:cStyle">
    <xsl:call-template name="makeStyleElement">
      <xsl:with-param name="tagName" select="'csty'"/>
    </xsl:call-template>  
  </xsl:template>
  
  <xsl:template name="makeStyleElement">
    <xsl:param name="tagName" select="xs:string"/>
    <xsl:element name="{$tagName}">
      <xsl:sequence select="@*[not(contains('^base^name^', concat('^', name(.), '^')))]"/>
      <xsl:attribute name="pnam" select="concat('k_', @name)"/>
      <xsl:attribute name="Self" select="concat('rc_', generate-id())"/>
      <xsl:if test="@base != ''">
        <xsl:variable name="baseStyleName" as="xs:string">
          <xsl:choose>
            <xsl:when test="$tagName = 'csty'">
              <xsl:sequence select="incxgen:getObjectIdForCharacterStyle(string(@base))"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:sequence select="incxgen:getObjectIdForParaStyle(string(@base))"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        
        <xsl:attribute name="basd" select="concat('k_', $baseStyleName)"/>
      </xsl:if>
    </xsl:element>
    
  </xsl:template>
  
  <xsl:template mode="generateStyles" match="idsc:pStyle">
    <xsl:call-template name="makeStyleElement">
      <xsl:with-param name="tagName" select="'psty'"/>
    </xsl:call-template>  
  </xsl:template>
  
  <xsl:template mode="generateStyles" match="idsc:tStyle">
    <xsl:call-template name="makeStyleElement">
      <xsl:with-param name="tagName" select="'tsty'"/>
    </xsl:call-template>  
  </xsl:template>
  
  <xsl:template match="idsc:InDesign_Style_Catalog" mode="generateStyles">
    <xsl:apply-templates select="idsc:CharacterStyles" mode="#current"/>
    <xsl:apply-templates select="idsc:ParagraphStyles" mode="#current"/>
    <xsl:apply-templates select="idsc:TableStyles" mode="#current"/>
    <xsl:apply-templates select="idsc:ObjectStyles" mode="#current"/>
  </xsl:template>
  
  <xsl:template match="idsc:ParagraphStyles | idsc:CharacterStyles | idsc:TableStyles | idsc:ObjectStyles  " mode="generateStyles">
    <xsl:apply-templates mode="#current"/>
  </xsl:template>
  <xsl:template mode="generateStyles" match="idsc:objStyle">
    <xsl:call-template name="makeStyleElement">
      <xsl:with-param name="tagName" select="'ObSt'"/>
    </xsl:call-template>  
  </xsl:template>
  
  <xsl:function name="incxgen:getObjectIdForParaStyle" as="xs:string">
    <xsl:param name="styleName" as="xs:string"/>
<!--    <xsl:message> + [DEBUG] getObjectIdForParaStyle(): styleName="<xsl:sequence select="$styleName"/>"</xsl:message>-->
    <xsl:variable name="targetStyle" select="$styleCatalog/*/idsc:ParagraphStyles/idsc:pStyle[@name = $styleName]" as="element()?"/>
    <xsl:variable name="styleId" 
      select="if ($targetStyle) 
      then generate-id($targetStyle)
      else 'styleNotFound'"
      as="xs:string"
    />
    <xsl:if test="$styleId = 'styleNotFound' and not(starts-with($styleName, '['))">
      <xsl:message> + [WARNING] getObjectIdForParaStyle(): No style definition found for style name "<xsl:sequence select="$styleName"/>"</xsl:message>
    </xsl:if>
<!--    <xsl:message> + [DEBUG] getObjectIdForParaStyle(): styleId="<xsl:sequence select="$styleId"/>"</xsl:message>-->
    <xsl:value-of select="$styleId"/>
  </xsl:function>
  
  <xsl:function name="incxgen:getObjectIdForTableStyle" as="xs:string">
    <xsl:param name="styleName" as="xs:string"/>
    <!--    <xsl:message> + [DEBUG] getObjectIdForTableStyle(): styleName="<xsl:sequence select="$styleName"/>"</xsl:message>-->
    <xsl:variable name="targetStyle" select="$styleCatalog/*/idsc:TableStyles/idsc:tStyle[@name = $styleName]" as="element()?"/>
    <xsl:variable name="styleId" 
      select="if ($targetStyle) 
      then generate-id($targetStyle)
      else 'styleNotFound'"
      as="xs:string"
    />
    <!--    <xsl:message> + [DEBUG] getObjectIdForTableStyle(): styleId="<xsl:sequence select="$styleId"/>"</xsl:message>-->
    <xsl:value-of select="$styleId"/>
  </xsl:function>
  
  <xsl:function name="incxgen:getObjectIdForCharacterStyle" as="xs:string">
    <xsl:param name="styleName" as="xs:string"/>
    <xsl:variable name="targetStyle" select="$styleCatalog/*/idsc:CharacterStyles/idsc:cStyle[@name = $styleName]" as="element()?"/>
    <xsl:variable name="styleId" 
      select="if ($targetStyle) 
      then generate-id($targetStyle)
      else 'styleNotFound'"
      as="xs:string"
    />
    <xsl:if test="$styleId = 'styleNotFound' and not(starts-with($styleName, '['))">
      <xsl:message> + [WARNING] getObjectIdForCharacterStyle(): No style definition found for style name "<xsl:sequence select="$styleName"/>"</xsl:message>
    </xsl:if>
    <xsl:value-of select="$styleId"/>
  </xsl:function>
  
  <xsl:function name="incxgen:normalizeText" as="xs:string">
    <xsl:param name="inString" as="xs:string"/>
    <xsl:variable name="noBreaks" select="replace($inString, '[&#x2029;&#x0A;]', '')" as="xs:string"/>
    <xsl:variable name="outString" select="replace($noBreaks, '[ ]+', ' ')" as="xs:string"/>
    <xsl:value-of select="$outString"/>
  </xsl:function>
  
  <xsl:function name="incxgen:dec2hex" as="xs:string">
    <xsl:param name="dec" as="xs:integer"/>
<!--    <xsl:message> + [DEBUG] dec2hex(): dec="<xsl:sequence select="$dec"/>"</xsl:message>-->
    <xsl:variable name="hexDigits" select="('0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F')" as="xs:string*"/>
    <xsl:variable name="result" as="xs:string">
      <xsl:choose>
        <xsl:when test="$dec &lt; 16">
          <xsl:sequence select="$hexDigits[$dec + 1]"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:sequence select="concat(incxgen:dec2hex($dec idiv 16), incxgen:dec2hex($dec mod 16))"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
<!--    <xsl:message> + [DEBUG] dec2hex(): result="<xsl:sequence select="$result"/>"</xsl:message>-->
    <xsl:sequence select="$result"/>
  </xsl:function>
  
  <xsl:function name="incxgen:makeCSpnAttr">
    <xsl:param name="colspan" as="xs:string"/>
    <xsl:param name="colCount" as="xs:integer"/>
    <xsl:choose>
          <!-- test for colspan value expressed as a percentage and process accordingly -->
          <xsl:when test="contains($colspan,'%')">
            <xsl:variable name="colspanValue" select="number(substring-before($colspan,'%'))"/>
            <xsl:variable name="multiplier" select="$colspanValue * .01"/>
            <xsl:variable name="colspan" select="xs:integer(round($colCount * $multiplier))" as="xs:integer"/>
            <xsl:value-of select="$colspan"/>
          </xsl:when>
          <xsl:otherwise>
            <!-- if integer value, take and transfer -->
            <xsl:value-of select="$colspan"/>
          </xsl:otherwise>
        </xsl:choose>       
  </xsl:function>
  
  <!-- Placeholder rowspan function -->
  <!-- This is adapted from the colspan function above -->
  <!-- Haven't seen samples of this to know if it's appropriate, e.g. if rowspan is represented as a percentage like colspan is -->
  
  <xsl:function name="incxgen:makeRSpnAttr">
    <!-- WEK: coded to account for possibility that default attributes aren't available in document being processed -->
    <xsl:param name="rowspanBase" as="xs:string"/>
    <xsl:param name="rowCount" as="xs:integer"/>
    <xsl:variable name="rowspan" select="if ($rowspanBase = '') then '1' else $rowspanBase" as="xs:string"/>
    <xsl:choose>
      <!-- test for rowspan value expressed as a percentage and process accordingly -->
      <xsl:when test="contains($rowspan,'%')">
        <xsl:variable name="rowspanValue" select="number(substring-before($rowspan,'%'))"/>
        <xsl:variable name="multiplier" select="$rowspanValue * .01"/>
        <xsl:variable name="rowspan" select="xs:integer(round($rowCount * $multiplier))" as="xs:integer"/>
        <xsl:message select="$rowspan"/>
        <xsl:value-of select="$rowspan"/>
      </xsl:when>
      <xsl:otherwise>
        <!-- if integer value, take and transfer -->
        <xsl:value-of select="$rowspan"/>
      </xsl:otherwise>
    </xsl:choose>       
  </xsl:function>
  
  <xsl:function name="incxgen:makeCcolElems" as="node()*">
    <xsl:param name="numCols" as="xs:integer"/>
    <xsl:param name="tableID" as="xs:string"/>
    <xsl:variable name="result" as="node()*">
      <xsl:for-each select="1 to $numCols">
        <xsl:element name="ccol">
          <xsl:attribute name="pnam" select="concat('rk_',position()-1)"/>
          <!-- Use default value for 6 column table for now. Should update to divide width of page by number of columns. -->
          <xsl:attribute name="klwd" select="'U_89.83333333333333'"/>
          <xsl:attribute name="Self" select="concat('rc_', $tableID, 'ccol',position()-1)"/>
        </xsl:element>
      </xsl:for-each>
    </xsl:variable>
    <xsl:copy-of select="$result"/>
  </xsl:function>
  
  <!-- Tables: -->
  
  
  <!-- Handle processing instructions. -->
  <!-- Insertion point markers, changes, and notes are all represented as PIs in the PAM XML. -->
  
  <!-- Simply pass through insertion point markers.  -->
  
  <xsl:template match="processing-instruction(aid)" mode="cont">
    <xsl:copy-of select="."/>
  </xsl:template>
  
  <xsl:template match="//processing-instruction(notes-Note)" mode="makeNotes">
    <!-- FIXME: Not sure where to get the data for the attributes. -->
      <Note 
        Collapsed="false" 
        CreationDate="2011-12-19T10:49:41" 
        ModificationDate="2011-12-19T10:49:47" 
        UserName="W. Eliot Kimber" 
        AppliedDocumentUser="dDocumentUser0">
        <ParagraphStyleRange AppliedParagraphStyle="ParagraphStyle/$ID/[No paragraph style]">
          <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/$ID/[No character style]">
            <Content><!-- FIXME: Content goes here --></Content>            
          </CharacterStyleRange>
        </ParagraphStyleRange>
      </Note>
  </xsl:template>
  
  
  <!-- Style catalog: -->
  
  <xsl:variable name="styleCatalog">
    <xsl:if test="$debugBoolean">
      <xsl:message> + [DEBUG] styleCatalogUri = "<xsl:sequence select="$styleCatalogUri"/>"</xsl:message>
    </xsl:if>
    <xsl:variable name="catalogUri" as="xs:string"
        select="if ($styleCatalogUri != '')
                   then $styleCatalogUri
                   else $defaultStyleCatalogUri
                   "/>
    <xsl:if test="$debugBoolean">
      <xsl:message> + [DEBUG] catalogUri = "<xsl:sequence select="$catalogUri"/>"</xsl:message>
    </xsl:if>
    <xsl:variable name="catalogDoc" select="document($catalogUri)" as="document-node()?"/>
    <xsl:if test="not($catalogDoc)">
      <xsl:message terminate="yes"> + [ERROR] Could not load InDesign style catalog "<xsl:sequence select="$catalogUri"/>"</xsl:message>
    </xsl:if>
    <xsl:sequence select="$catalogDoc/*[1]"/>
  </xsl:variable>
</xsl:stylesheet>
