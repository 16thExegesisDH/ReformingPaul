<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0">
    <xsl:output method="html" indent="yes" encoding="UTF-8"/>
    
    <!-- Match the root element -->
    <xsl:template match="/">
        <html>
            <head>
                <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
                  <!-- Extract the title from short title -->
                <title>
                    <xsl:value-of select="//title[parent::titleStmt]"/>
                </title>
                <link href="../Website_Paul_projet/CSS/updated_2.css" rel="stylesheet"/>
                <script src="../Website_Paul_projet/JS/script.js" defer="defer"></script>
            </head>
            <body>
                <div id="mySidebar" class="sidebar">
                    <a href="../Website_Paul_projet/HTML/home.html">Accueil</a>
                    <a href="https://github.com/16thExegesisDH">Construction du projet: Github</a>
                    <a href="https://ihr-num.unige.ch/rrp/">RRP | Reformation Readings of Paul</a>
                </div> 
                
                <xsl:element name="div">
                    <xsl:attribute name="id">
                        <xsl:text>main</xsl:text>
                    </xsl:attribute>
                    
                    <button class="openbtn" onclick="openNav()">☰ Navigation</button>                      
                    
                    <xsl:element name="span">
                        <xsl:attribute name="class">
                            <xsl:text>download</xsl:text>
                        </xsl:attribute>
                        <xsl:element name="button">
                            <xsl:attribute name="class">
                                <xsl:text>openbtn</xsl:text>
                            </xsl:attribute>
                            <xsl:element name="a">
                                <xsl:attribute name="href">
                                    <xsl:text>../5_Lambertus_tei_NF.xml</xsl:text>
                                </xsl:attribute>
                                <xsl:attribute name="target">
                                    <xsl:text>_blank</xsl:text>
                                </xsl:attribute>
                                <xsl:text>[↓] XML-TEI</xsl:text>
                            </xsl:element>
                        </xsl:element>
                        <xsl:element name="button">
                            <xsl:attribute name="class">
                                <xsl:text>openbtn</xsl:text>
                            </xsl:attribute>
                            <xsl:element name="a">
                                <xsl:attribute name="href">
                                    <xsl:text>../Website_Paul_projet/PDF/</xsl:text>
                                    <xsl:value-of select="//TEI/@xml:id"/>
                                    <xsl:text>.update.pdf</xsl:text>
                                </xsl:attribute>
                                <xsl:attribute name="target">
                                    <xsl:text>_blank</xsl:text>
                                </xsl:attribute>
                                <xsl:text>[↓] PDF</xsl:text>
                            </xsl:element>
                        </xsl:element>
                    </xsl:element>
                    
                    <xsl:element name="div">
                        <xsl:attribute name="class">
                            <xsl:text>title</xsl:text>
                        </xsl:attribute>
                        <xsl:value-of select="//title[parent::titleStmt]"/>
                    </xsl:element>
                    
                    
                    <xsl:apply-templates/>
                    
                    <xsl:element name="div">
                        <xsl:attribute name="id">
                            <xsl:text>footer</xsl:text>
                        </xsl:attribute>
                        <xsl:element name="div">
                            <xsl:attribute name="class">
                                <xsl:text>logos</xsl:text>
                            </xsl:attribute>
                        <xsl:element name="img">
                            <xsl:attribute name="class">
                                <xsl:text>logo</xsl:text>
                            </xsl:attribute>
                            <xsl:attribute name="src">
                                <xsl:text>../IMG/ihreformation_blanc.png</xsl:text>
                            </xsl:attribute>
                        </xsl:element>
                        <xsl:element name="img">
                            <xsl:attribute name="class">
                                <xsl:text>logo2</xsl:text>
                            </xsl:attribute>
                            <xsl:attribute name="src">
                                <xsl:text>../IMG/SNF_logo_standard_web_sw_neg_e.png</xsl:text>
                            </xsl:attribute>
                        </xsl:element>
                        <xsl:element name="img">
                            <xsl:attribute name="class">
                                <xsl:text>logo3</xsl:text>
                            </xsl:attribute>
                            <xsl:attribute name="src">
                                <xsl:text>../IMG/uzh-logo-white.png</xsl:text>
                            </xsl:attribute>
                        </xsl:element>
                      </xsl:element>
                    </xsl:element>
                </xsl:element>
            </body>
        </html>
    </xsl:template>
    <xsl:template match="teiHeader"/>
    <xsl:template match="sourceDoc"/>
    <xsl:template match="orig"/>
    
    <xsl:template match="title[parent::titleStmt]">
        <xsl:element name="div">
            <xsl:attribute name="class">
                <xsl:text>title</xsl:text>
            </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template> 
        
    <xsl:template match="body">
        <xsl:element name="div">
            <xsl:attribute name="class">
                <xsl:text>document</xsl:text>
            </xsl:attribute>
            <xsl:for-each select="pb">
                <!-- Extract the relevant digit sequence from pb/@corresp -->
                <xsl:variable name="pbID" select="substring-after(@corresp, 'f')"/>
                <xsl:element name="div">
                    <xsl:attribute name="class">
                        <xsl:text>content-wrapper</xsl:text>
                    </xsl:attribute>
                    
                    <!-- Process matching text sections (fw/ab) -->
                    <xsl:element name="div">
                        <xsl:attribute name="class">
                            <xsl:text>text-container</xsl:text>
                        </xsl:attribute>
                        <xsl:apply-templates select="../fw[starts-with(@corresp, concat('#f', $pbID))]"/>
                        <xsl:apply-templates select="../ab[starts-with(@corresp, concat('#f', $pbID))]"/>
                    </xsl:element>
                    
                    <!-- Generate the image section after the text-container -->
                    <xsl:element name="div">
                        <xsl:attribute name="class">image-section</xsl:attribute>
                        <xsl:element name="img">
                            <xsl:attribute name="src">
                                <xsl:value-of select="concat('https://www.e-rara.ch/i3f/v20/', substring-after(@corresp, 'f'), '/full/full/0/default.jpg')"/>
                            </xsl:attribute>
                            <xsl:attribute name="alt">
                                <xsl:value-of select="substring-after(@corresp,'f')"/>
                            </xsl:attribute>
                        </xsl:element>
                    </xsl:element>
                </xsl:element>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>
    
    <!-- Copy the content of fw and ab elements -->
    <xsl:template match="fw | ab">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates select="node()"/>
        </xsl:copy>
    </xsl:template>
       
    <xsl:template match="ab">
        <!-- right section  with the text -->
        <xsl:element name="div">
            <xsl:attribute name="class">
                <xsl:text>text-section</xsl:text>
            </xsl:attribute>
        <xsl:choose>
            <xsl:when test="@type='DropCapitalZone'">
                <xsl:element name="span">
                    <xsl:attribute name="class">
                        <xsl:text>ab_Drop</xsl:text>
                    </xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
<!-- for determine the verset identify as MainZone-Haed -->
            <xsl:when test="@type='MainZone-Head' and not(hi/choice/orig[contains(text(), 'CAP')])">
                <xsl:element name="span">
                    <xsl:attribute name="class">
                        <xsl:text>ab_mzHead</xsl:text>
                    </xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
 <!-- Default case -->           
            <xsl:otherwise>          
                <xsl:element name="table">
                    <xsl:element name="tr">
                        <xsl:element name="td">
                            <xsl:attribute name="class">
                                <xsl:text>para</xsl:text>
                            </xsl:attribute>
                                <xsl:element name="p">
                                    <xsl:apply-templates/>
                                </xsl:element>
                        </xsl:element>
                    </xsl:element>
                </xsl:element>
            </xsl:otherwise>         
        </xsl:choose> 
      </xsl:element>
    </xsl:template>
    
    
    <xsl:template match="placeName">
        <xsl:element name="span">
            <xsl:attribute name="class">
                <xsl:text>placeName</xsl:text>
            </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="persName">
        <xsl:element name="span">
            <xsl:attribute name="class">
                <xsl:text>persName</xsl:text>
            </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="fw">
        <!-- right section  with the text -->
        <xsl:element name="div">
            <xsl:attribute name="class">
                <xsl:text>text-section</xsl:text>
            </xsl:attribute>
        <xsl:choose>
            <xsl:when test="@type='NumberingZone'">
                <xsl:element name="span">
                    <xsl:attribute name="class">
                        <xsl:text>fw_number</xsl:text>
                    </xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="@type='RunningTitleZone'">
                <xsl:element name="span">
                    <xsl:attribute name="class">
                        <xsl:text>fw_running</xsl:text> 
                    </xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="@type='QuireMarksZone'">
                <xsl:element name="span">
                    <xsl:attribute name="class">
                        <xsl:text>fw_quire</xsl:text>
                    </xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="span">
                    <xsl:attribute name="class">
                        <xsl:text>fw</xsl:text>
                    </xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
      </xsl:element>
    </xsl:template>
    
    <!--  -->
    <xsl:template match="choice">
        <xsl:choose>
            <xsl:when test="ancestor::ab[@type='Main*']">
                <xsl:variable name="truc">
                    <xsl:number level="any" count="choice[parent::ab/@type='Main*']" from="body"/>
                </xsl:variable>
                
                <xsl:variable name="absolute_line_number" select="count(ancestor::body/preceding-sibling::choice)"/>
                
                <xsl:value-of select="$truc"/>. <xsl:value-of select="reg"/><xsl:element name="br"/>
            </xsl:when>
           
                <xsl:when test="descendant::seg"><xsl:element name="i">                
                    <xsl:value-of select="reg"/> </xsl:element><xsl:element name="br"/>
                </xsl:when>
                <xsl:when test="descendant::reg">
                    <xsl:value-of select="reg"/><xsl:element name="br"/>
                </xsl:when>
           
            <xsl:otherwise>
                <xsl:value-of select="reg"/><xsl:element name="br"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    
    
    <xsl:template match="abbr"/>
    <xsl:template match="expan">
        <xsl:element name="span">
            <xsl:attribute name="class">
                <xsl:text>expan</xsl:text>
            </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

</xsl:stylesheet>
