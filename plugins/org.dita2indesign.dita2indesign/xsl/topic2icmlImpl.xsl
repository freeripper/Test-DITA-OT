<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
      xmlns:xs="http://www.w3.org/2001/XMLSchema"
      xmlns:local="urn:local-functions"
      xmlns:df="http://dita2indesign.org/dita/functions"
      xmlns:relpath="http://dita2indesign/functions/relpath"
      xmlns:incxgen="http//dita2indesign.org/functions/incx-generation"
      xmlns:e2s="http//dita2indesign.org/functions/element-to-style-mapping"
      xmlns:RSUITE="http://www.reallysi.com"
      xmlns:idsc="http://www.reallysi.com/namespaces/indesign_style_catalog"
      exclude-result-prefixes="xs local df relpath incxgen e2s RSUITE idsc"
      version="2.0">
  
  <!-- Topic to ICML Transformation.
    
       Into one or more InCopy (ICML) articles.
       
       This module handles the base (topic.mod) types. 
       Specialization modules should add their own
       XSL modules as necessary.
       
       Copyright (c) 2011 DITA2InDesign Project
       
  -->
  <xsl:import href="../../net.sourceforge.dita4publishers.common.xslt/xsl/lib/dita-support-lib.xsl"/>
  <xsl:import href="../../net.sourceforge.dita4publishers.common.xslt/xsl/lib/relpath_util.xsl"/>
  <xsl:import href="lib/icml_generation_util.xsl"/>
  
  <xsl:import href="elem2styleMapperIcml.xsl"/>
  <xsl:include href="topic2inlineContentIcmlImpl.xsl"/>
  <xsl:include href="calstbl2IcmlImpl.xsl"/>
  
  <!-- Directory, relative to result InDesign document, that
    contains linked articles:
  -->
  <!-- Doesn't need to be specified when the topic is being
       generated in isolation, only for generation from
       map-based processing.
    -->
  <xsl:param name="outputPath" as="xs:string" select="''"/>
  <xsl:param name="linksPath" as="xs:string" select="'links'"/>
  
  <xsl:strip-space elements="*"/>
  
  <xsl:output name="incx" 
    indent="no" 
    cdata-section-elements="GrPr" />
  
  <xsl:template match="/*[df:class(., 'topic/topic')]" priority="5">
    <!-- The topicref that points to this topic -->
    <xsl:param name="topicref" as="element()?" tunnel="yes"/>
    <xsl:param name="articleType" as="xs:string" tunnel="yes"/>
    <xsl:message> + [DEBUG] topic2IndesignImpl.xsl: Processing root topic</xsl:message>
    <!-- Create a new output InCopy article. 
      
      NOTE: This code assumes that all chunking has been performed
      so that each document-root topic maps to one result
      InCopy article and all nested topics are output as
      part of the same story. This behavior can be
      overridden by providing templates that match on
      specific topic types or output classes.
    -->
    
    <xsl:variable name="articleUrl" as="xs:string"
      select="local:getArticleUrlForTopic(.)"
    />
    <xsl:variable name="articlePath" as="xs:string"
      select="relpath:newFile($outputPath, $articleUrl)"
    />
    <xsl:variable name="effectiveArticleType" as="xs:string"
      select="if ($articleType) then $articleType else name(.)"
    />
    <xsl:message> + [DEBUG] effectiveArticleType="<xsl:sequence select="$effectiveArticleType"/>"</xsl:message>
    <xsl:message> + [INFO] Generating InCopy article "<xsl:sequence select="$articlePath"/>"</xsl:message>
    
    <xsl:result-document href="{$articlePath}" format="incx">
      <xsl:call-template name="makeInCopyArticle">
        <xsl:with-param name="articleType" select="$effectiveArticleType" as="xs:string" tunnel="yes"/>
        <xsl:with-param name="styleCatalog" select="$styleCatalog" as="node()*"/>
      </xsl:call-template>
    </xsl:result-document>    
  </xsl:template>
  
  <xsl:template name="makeInCopyArticle">
    <xsl:param name="content" as="node()*"/>
    <xsl:param name="leadingParagraphs" as="node()*"/>
    <xsl:param name="trailingParagraphs" as="node()*"/>
    <xsl:param name="articleType" as="xs:string" tunnel="yes"/>
    <!-- The style catalog can be the styles.xml file from an IDML package -->
    <xsl:param name="styleCatalog" as="node()*"/>
    
    <xsl:if test="$debugBoolean">
      <xsl:message> + [DEBUG] makeInCopyArticle: Article type is "<xsl:sequence select="$articleType"/>"</xsl:message>
    </xsl:if>
    
    <xsl:variable name="effectiveContents" as="node()*"
      select="
      if (count($content) gt 0)
        then $content
        else ./node()
      "
    />
    
    <!-- Get the generated paragraphs as a variable so we can
         then construct a set of stub style definitions for them.
      -->
    <xsl:variable name="articleContents" as="node()*">
      <xsl:sequence select="$leadingParagraphs"/>
      <xsl:apply-templates select="$effectiveContents"/>
      <xsl:sequence select="$trailingParagraphs"/>      
    </xsl:variable>
    
    <xsl:variable name="effectiveStyleCatalog" as="node()*"
      select="local:generateStyleCatalog($articleContents, $styleCatalog)"
      />
    
    <xsl:processing-instruction name="aid">
      style="50" type="snippet" readerVersion="6.0" featureSet="257" product="7.5(142)"
    </xsl:processing-instruction>
    <xsl:processing-instruction name="aid">
      SnippetType="InCopyInterchange"
    </xsl:processing-instruction>    
    <Document DOMVersion="7.5" Self="d">
      <!-- FIXME: It may be sufficient to simply generate no-property style
           definitions for each style name or it may be possible to omit
           the styles entirely.
      -->
      <xsl:sequence select="$effectiveStyleCatalog"/>
      <!-- Create the "story" for the topic contents: -->
      <Story 
        Self="{generate-id(.)}" 
        AppliedTOCStyle="n" 
        TrackChanges="false" 
        StoryTitle="story-{generate-id(.)}" 
        AppliedNamedGrid="n">
        <!-- include XMP:
          
          The XML metadata should include at least the topic
          title, if not the author and any copyright information
          in the topic.
        -->
        <MetadataPacketPreference>
          <Properties>
            <Contents>
              <xsl:text disable-output-escaping="yes">&lt;![CDATA[</xsl:text>
            <xsl:apply-templates mode="XMP" select="/*"/>
            <xsl:text disable-output-escaping="yes">]]&gt;</xsl:text>
            </Contents>
          </Properties>
        </MetadataPacketPreference>
        <!-- Core content elements go here -->
        <xsl:sequence select="$articleContents"/>
      </Story><xsl:text>&#x0a;</xsl:text>      
    </Document>        
  </xsl:template>
  
  
  <xsl:template match="
    *[df:class(., 'topic/p')][*[df:isBlock(.)]]
    ">
    <!-- Correctly handle paragraphs that contain mixed content with block-creating elements.
      -->
    <xsl:param name="articleType" as="xs:string" tunnel="yes"/>
    
    <xsl:variable name="pStyle" select="e2s:getPStyleForElement(., $articleType)" as="xs:string"/>
    <xsl:variable name="cStyle" select="e2s:getCStyleForElement(.)" as="xs:string"/>
    <xsl:for-each-group select="* | text()"
      group-adjacent="if (self::*) then if (df:isBlock(.)) then 'block' else 'text' else 'text'">
      <xsl:choose>
        <xsl:when test="self::* and df:isBlock(.)">
          <xsl:apply-templates select="current-group()"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="makeBlock-cont">
            <xsl:with-param name="pStyle" select="$pStyle" as="xs:string" tunnel="yes"/>
            <xsl:with-param name="cStyle" select="$cStyle" as="xs:string" tunnel="yes"/>
            <xsl:with-param name="content" as="node()*" select="current-group()"/>          
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each-group>
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'topic/related-links')]">
    <!-- Suppress by default -->
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'topic/table') or df:class(., 'topic/simpletable')]">
    <!-- Char="16" Self="rc_u643cinsfbb" -->
    <xsl:processing-instruction name="aid">Char="16" Self="rc_<xsl:value-of select="generate-id(.)"/>Anchor"</xsl:processing-instruction>  
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'topic/image')]">
    <xsl:variable name="linkUri"
      select="
      if (starts-with(@href, 'file:') or starts-with(@href, 'http:'))
         then string(@href)
         else relpath:newFile(relpath:getParent(relpath:base-uri(.)),string(@href))
      "
      as="xs:string"
    />
    <xsl:message> + [DEBUG] (mode images): linkUri="<xsl:sequence select="$linkUri"/>"</xsl:message>
    <Rectangle 
      Self="{generate-id()}">
      <Properties>
        <!-- NOTE: This geometry is totally bogus: it's just copied from a sample
          that worked. Probably not worth trying to generate usable
          geometry at this point.
        -->
        <PathGeometry>
          <GeometryPathType PathOpen="false">
            <PathPointArray>
              <PathPointType Anchor="-72.0 -47.0" LeftDirection="-72.0 -47.0" RightDirection="-72.0 -47.0"/>
              <PathPointType Anchor="-72.0 47.0" LeftDirection="-72.0 47.0" RightDirection="-72.0 47.0"/>
              <PathPointType Anchor="72.0 47.0" LeftDirection="72.0 47.0" RightDirection="72.0 47.0"/>
              <PathPointType Anchor="72.0 -47.0" LeftDirection="72.0 -47.0" RightDirection="72.0 -47.0"/>
            </PathPointArray>
          </GeometryPathType>
        </PathGeometry>
      </Properties>
      <Image 
        ImageRenderingIntent="UseColorSettings" 
        AppliedObjectStyle="ObjectStyle/$ID/[None]" 
        Visible="true" 
        Name="$ID/"
        Self="rc_{concat(generate-id(),'Image')}">
        <!-- NOTE: The LnkI= attribute is required in order to create a working link but generating
                   that value is pretty much beyond the ability of XSLT. Need to look at the 
                   link generation code in the RSI INX Utils library to see how best to do this.
                   It may require integrating that library with XSLT.
        -->
        <Link 
          Self="{concat(generate-id(),'Link')}" 
          AssetURL="$ID/" 
          AssetID="$ID/" 
          LinkResourceURI="{$linkUri}" 
        />
      </Image>
    </Rectangle>
  </xsl:template>
  
  <xsl:template match="text() | *" mode="XMP"/><!-- Suppress everything by default in XMP mode -->

  <xsl:template match="*[df:class(., 'topic/lq')]">
    <xsl:param name="articleType" as="xs:string" tunnel="yes"/>
    <xsl:choose>
      <xsl:when test="df:hasBlockChildren(.)">
        <!-- FIXME: Handle any non-empty text before the first paragraph -->
         <xsl:apply-templates/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="makeBlock-cont">
          <xsl:with-param name="pStyle" tunnel="yes" select="e2s:getPStyleForElement(., $articleType)"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>    
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'topic/fig')]">
    <!-- Override this template to put the title before or after the 
         figure content.
      -->
    <xsl:apply-templates select="*[df:class(., 'topic/title')]"/>
    <xsl:apply-templates select="*[not(df:class(., 'topic/title'))]"/>    
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'topic/section')]">
    <xsl:param name="articleType" as="xs:string" tunnel="yes"/>
    <xsl:if test="@spectitle">
      <xsl:call-template name="makeBlock-cont">
        <xsl:with-param name="pStyle" tunnel="yes" select="e2s:getPStyleForElement(., $articleType)"/>
        <xsl:with-param name="content" as="text()">
          <xsl:value-of select="@spectitle"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:if>
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template 
    match="
    *[df:class(., 'topic/dt')] |
    *[df:class(., 'topic/title')]
    ">
    <xsl:param name="articleType" as="xs:string" tunnel="yes"/>
    
    <!-- Elements that are not inherently block elements but are rendered as 
         blocks by default.
      -->
    <xsl:call-template name="makeBlock-cont">
      <xsl:with-param name="pStyle" tunnel="yes" select="e2s:getPStyleForElement(., $articleType)"/>
    </xsl:call-template>
  </xsl:template>
  
  <xsl:template 
    match="
    *[df:class(., 'topic/li')] |
    *[df:class(., 'topic/dd')]
    ">
    <xsl:param name="articleType" as="xs:string" tunnel="yes"/>
    
    <!-- FIXME: For LI, LQ, DD, etc., need general logic for handling
                as single block, sequence of blocks, or blocks preceded
                by mixed content.
      -->
    <xsl:call-template name="makeBlock-cont">
      <xsl:with-param name="pStyle" tunnel="yes" select="e2s:getPStyleForElement(., $articleType)"/>
    </xsl:call-template>
  </xsl:template>
  
  <xsl:template match="*[df:isBlock(.)]" priority="-0.5">
    <xsl:param name="articleType" as="xs:string" tunnel="yes"/>
    
    <xsl:call-template name="makeBlock-cont">
      <xsl:with-param name="pStyle" tunnel="yes" select="e2s:getPStyleForElement(.,$articleType)"/>
    </xsl:call-template>
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'topic/topic')]">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template 
    match="
    *[df:class(., 'topic/prolog')]
    ">
    <!-- Ignored in default mode -->
  </xsl:template>
    
  <xsl:template 
    match="
    *[df:class(., 'topic/bodydiv')] |
    *[df:class(., 'topic/sectiondiv')] 
    ">    
    <xsl:param name="articleType" as="xs:string" tunnel="yes"/>
    
    <xsl:choose>
      <xsl:when test="text()">
        <xsl:call-template name="makeBlock-cont">
          <xsl:with-param name="pStyle" tunnel="yes" select="e2s:getPStyleForElement(., $articleType)"/>
        </xsl:call-template>        
      </xsl:when>
      <xsl:otherwise><!-- No direct text, just apply templates -->
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
    
  </xsl:template>
  
  <xsl:template 
    match="
    *[df:class(., 'topic/body')] |
    *[df:class(., 'topic/ul')] |
    *[df:class(., 'topic/ol')] |
    *[df:class(., 'topic/dl')] |
    *[df:class(., 'topic/dlentry')]
    ">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template mode="generate-styles" match="idsc:InDesign_Style_Catalog">
    <!-- Simply copy the styles in the catalog to the output -->
    <xsl:sequence select="node()"/>
  </xsl:template>
  
  <xsl:template match="RSUITE:*" mode="#all" priority="10"/><!-- Ignore in all modes -->
    
  <xsl:template mode="#default" match="*" priority="-1">
    <xsl:message> + [WARNING] topic2indesignImpl (default mode): Unhandled element <xsl:sequence select="name(..)"/>/<xsl:sequence 
      select="concat(name(.), ' [', normalize-space(@class), ']')"/></xsl:message>
  </xsl:template>
  
  
  <xsl:function name="local:getArticleUrlForTopic" as="xs:string">
    <xsl:param name="context" as="element()"/>
    <xsl:variable name="topicFilename" select="relpath:getNamePart(document-uri(root($context)))" as="xs:string"/>
<!--    <xsl:variable name="articleUrl" select="concat($linksPath, '/', $topicFilename, '.incx')" as="xs:string"/>
-->  
    <xsl:variable name="articleUrl" select="concat($topicFilename, '.incx')" as="xs:string"/>
    <xsl:sequence select="$articleUrl"/>
  </xsl:function>
  
  <xsl:function name="local:generateStyleCatalog" as="node()*">
    <xsl:param name="icmlParas" as="node()*"/>
    <xsl:param name="baseStyleCatalog" as="node()*"/>
    
    <xsl:variable name="pStyleNames"
      select="distinct-values($icmlParas//ancestor-or-self::ParagraphStyleRange/@AppliedParagraphStyle)"
    />
<!--    <xsl:message> + [DEBUG] generateStyleCatalog: pStyleName=<xsl:sequence select="$pStyleNames"/></xsl:message>-->
    <xsl:variable name="cStyleNames"
      select="distinct-values($icmlParas//CharacterStyleRange/@AppliedCharacterStyle)"
    />
<!--    <xsl:message> + [DEBUG] generateStyleCatalog: cStyleName=<xsl:sequence select="$pStyleNames"/></xsl:message>-->
    <xsl:variable name="styleCatalog" as="node()*">
      <RootCharacterStyleGroup Self="rootCharacterStyleGroup">
        <xsl:for-each select="$cStyleNames">
          <xsl:variable name="styleId" select="." as="xs:string"/>
          <xsl:variable name="name" 
            as="xs:string"
            select="substring-after(., 'CharacterStyle/')" 
          />
          <xsl:variable name="baseStyle" select="$styleCatalog//CharacterStyle[@Self = $styleId]" as="node()*"/>
          <xsl:choose>
            <xsl:when test="$baseStyle">
              <xsl:sequence select="$baseStyle"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:if test="$baseStyleCatalog">
                <xsl:message> + [WARN] Character style "<xsl:sequence select="$name"/>" not in style catalog. Generating stub style definition.</xsl:message>
              </xsl:if>
              <CharacterStyle 
                Self="CharacterStyle/{$name}" 
                Name="{$name}" >
                <Properties>
                  <BasedOn type="string">$ID/[No character style]</BasedOn>
                </Properties>
              </CharacterStyle>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>
      </RootCharacterStyleGroup>  
      <RootParagraphStyleGroup Self="rootParagraphStyleGroup">
        <xsl:for-each select="$pStyleNames">
          <xsl:variable name="styleId" select="." as="xs:string"/>
          <xsl:variable name="name" 
            as="xs:string"
            select="substring-after(., 'ParagraphStyle/')" 
          />
          <xsl:variable name="baseStyle" select="$styleCatalog//ParagraphStyle[@Self = $styleId]" as="node()*"/>
          <xsl:choose>
            <xsl:when test="$baseStyle">
              <xsl:sequence select="$baseStyle"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:if test="$baseStyleCatalog">
                <xsl:message> + [WARN] Paragraph style "<xsl:sequence select="$name"/>" not in style catalog. Generating stub style definition.</xsl:message>
              </xsl:if>
              <ParagraphStyle 
                Self="ParagraphStyle/{$name}" 
                Name="{$name}" 
                >
                <Properties>
                  <BasedOn type="string">$ID/[No paragraph style]</BasedOn>
                </Properties>
              </ParagraphStyle>      
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>
      </RootParagraphStyleGroup>
    </xsl:variable>
    
    <xsl:sequence select="$styleCatalog"/>
  </xsl:function>
  
</xsl:stylesheet>
