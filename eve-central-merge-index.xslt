<?xml version="1.0"  encoding="utf-8" ?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output indent="yes" />

<xsl:template match="index">
<evec_api version="2.0" method="marketstat_xml">
<marketstat>

      <xsl:apply-templates/>

</marketstat>
</evec_api>
</xsl:template>


<xsl:template match="entry">
   <xsl:apply-templates select="document(concat(.,'.xml'))"/>
</xsl:template>


<xsl:template match="type">
   <xsl:copy-of select="."/>

</xsl:template>


</xsl:stylesheet>
