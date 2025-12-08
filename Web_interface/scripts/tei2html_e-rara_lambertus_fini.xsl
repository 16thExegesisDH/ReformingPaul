<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0">
    
    <!-- script build ob the same code as mdz_toc_fini.xsl, by Floriane Goy, the 3rd decembre 2025
       The only changes concern
    1. e-rara identifier in "template-name ="text-section"
    2. the place of the Dropcapital in "template match ab" -->
    
    
    <!-- NOTA BENE : le script concerne seulement les données de Lambert qui est un vieux document, il faut faire quelque changement manuel dans la table des matières -->
    
    <xsl:strip-space elements="*"/>
    <xsl:output method="html" indent="yes" encoding="UTF-8"/>
    
    <!-- MAIN STRUCTURE OF WEB PAGE -->
    <xsl:template match="/">
        <html>
            <head>
                <xsl:call-template name="metadata"></xsl:call-template>
            </head>
            <body>
                <xsl:call-template name="sidebar"/>           
            <div class="main-wrapper">
                <xsl:call-template name="navigation-bar"/>
                <xsl:call-template name="header"/>
           
                <xsl:call-template name="text-section"/>        
            
                <xsl:call-template name="footer"/>
            </div>
            </body>
        </html>
    </xsl:template>
    

<!-- TEMPLATE FOR THE HTML STRUCTURE -->
    
    <xsl:template name="metadata">
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        <!-- Extract the title from short title -->
        <title>
            <xsl:value-of select="//title[parent::titleStmt]"/>
        </title>
        <link href="../../../Web_interface/CSS/FG_stylesheet_fini.css" rel="stylesheet"/> 
        <!--<link href="../../../Web_interface/CSS/FG_stylesheet_small_fini.css" rel="stylesheet"/> -->
        <script src="../../../Web_interface/JS/my_function_fini.js" defer="defer"></script>
    </xsl:template>

       
    <xsl:template name="sidebar">
        <aside class="sidebar" id="mySidebar" aria-label="Menu principal">
            <a class="closebtn" href="#" onclick="closeNav()" aria-label="Fermer le menu">×</a>
            <a href="../../../index.html">Home</a>
            <div id="toc_container">
                <a class="toc_title" href="javascript:void(0)" onclick="toggleTOC()">&gt; Table of Content</a>
                <ul class="toc_list" style="display: none; padding-left: 8px;">
                    <!-- add the MainZone type for Lambertus -->
                    <xsl:for-each-group select="//*[@type='MainZone-Head'or @type='MainZone']" 
                        group-starting-with="*[choice/reg[matches(., '^CAP.*')] or hi/choice/reg[matches(., '^CAP.*')]]">
                        <xsl:variable name="FirstNode" select="current-group()[1]"/>
                        <xsl:variable name="firstNodeText" select="string-join($FirstNode//reg, ' ')"/>
                        
                        <li>
                            <a href="#{
                                if ($FirstNode[choice/reg[matches(., '^CAP.*')] or hi/choice/reg[matches(., '^CAP.*')]])
                                then translate(normalize-space($firstNodeText), ' ', '_')
                                else 'Introduction'
                                }"
                                class="point-header"
                                onclick="toggleSubPoints(this)">
                                <xsl:value-of select="
                                    if ($FirstNode[choice/reg[matches(., '^CAP.*')] or hi/choice/reg[matches(., '^CAP.*')]])
                                    then concat('> ', normalize-space($firstNodeText))
                                    else '> Introduction'"/>
                                
                            </a>
                            <ul style="display: none; padding-left: 8px;">
                                <xsl:for-each select="if ($FirstNode[choice/reg[matches(., '^CAP')]] or $FirstNode[hi/choice/reg[matches(., '^CAP')]]) 
                                    then current-group()[position() > 1] 
                                    else current-group()">
                                    <!-- change the path for lambertus use the "seg" element and not the "reg" -->
                                    <xsl:variable name="versetFixedText" select="replace(normalize-space(string-join(.//seg, ' ')), '-\s+', '')"/> 
                                    
                                    <xsl:if test="string-length($versetFixedText) &gt; 0">
                                        <li>
                                            <!-- for a explicite descriptopm of the use of the fonction (lower-case..etc) see the part concerning MainZoneHead -->
                                            <a href="#{lower-case(string-join(subsequence(tokenize($versetFixedText, '\s+'), 1, 3),'_'))}">
                                                <xsl:value-of select="$versetFixedText"/>
                                            </a>
                                        </li>
                                    </xsl:if>
                                </xsl:for-each>
                            </ul>
                        </li>
                    </xsl:for-each-group>
                </ul>
            </div>
        </aside>
    </xsl:template>
    
    
    <xsl:template name="navigation-bar">
        <nav>
            <button class="openbtn" onclick="openNav()" aria-label="Ouvrir le menu de navigation" aria-expanded="false">☰ Navigation</button>
            <div class="download">
                <a href="{concat('../../TEI/',//TEI/@xml:id),'_tei_NF.zip'}" class="button" target="_blank">[↓] XML-TEI</a>
                <a href="{concat('../../PDF/',//TEI/@xml:id,'_update.pdf')}" class="button" target="_blank">[↓] PDF</a>
            </div>    
        </nav>
    </xsl:template>
    
    <xsl:template name="header">
    <header>
        <h1>
            <xsl:value-of select="//title[parent::titleStmt]"/>
        </h1>
    </header>
    </xsl:template>

    
    <!-- here the script change for e-rara identifier for fw/ab/and img scr -->
    <xsl:template name="text-section">
        <main>
                <xsl:for-each select="/TEI/text/body/pb">
                    <!-- Extract the relevant digit sequence from pb/@corresp -->
                    <xsl:variable name="pbID" select="substring-after(@corresp, 'f')"/>
                    <div class="content-wrapper">
                        <div class="text-container">
                        <!-- Process matching text sections (fw/ab) => section -->
                        <!-- Add a tag corresponding to the iiif identifier of the page -->
                        <section class="text" id="{substring-after(@corresp,'f')}">  
                            <xsl:apply-templates select="../fw[starts-with(@corresp, concat('#f', $pbID))]"/>
                            <xsl:apply-templates select="../ab[starts-with(@corresp, concat('#f', $pbID))]"/>
                        </section> <!-- div tex-contenaire -->
                        <section class="note" id="{concat('#', substring-after(@corresp, 'f'))}"> 
                            <xsl:apply-templates select="../note[starts-with(@corresp, concat('#f', $pbID))]"/>
                        </section> <!-- div note-section -->
                        </div> <!-- div text-container -->
                        <!-- Generate the image section after the text-container -->
                        <figure class="image-text">  <!-- div image-section => figure -->
                            <img src="{concat('https://www.e-rara.ch/i3f/v20/', substring-after(@corresp, 'f'), '/full/full/0/default.jpg')}" alt="{substring-after(@corresp,'f')}"/>
                        </figure>
                    </div> <!-- div content-wrapper-->
                </xsl:for-each>
        </main>
    </xsl:template>

        
    <xsl:template name="footer">
        <footer>
            <section id="credits">
                <p><strong>Terms of Use and Citation </strong>The citation terms are as follows :
                    "16th Century Exegesis of Paul - a Digital Library: 16th Century Exegesis of Paul,
                    SNF207696, Universties of Geneva and Zürich, dir. Ueli Zahnd and Stefan Krauter, [date
                    of consultation]". </p>
                <p>coding &amp; design :<a href="mailto:floriane.goy@unige.ch">floriane.goy@unige.ch</a></p>
            </section>
            <section id="logos">
                <figure class="logos-images">
                    <img src="../../../Web_interface/IMG/IHR_blanc.png" alt="Logo IHR"/>
                    <img src="../../../Web_interface/IMG/SNF_blanc.png" alt="Logo SNF"/>
                    <img src="../../../Web_interface/IMG/UZH_blanc.png" alt="Logo UZH"/>
                </figure>
            </section>
        </footer>
    </xsl:template>
    
    <!-- TEMPLATE : TRANSFORMATION AND REORGANISATION OF THE XML -->
    
    <xsl:template match="teiHeader | /sourceDoc | orig"/>
    
    <xsl:template match="ab">
        <!-- DropCapitalZone is handled by MainZone-P, so we skip rendering it here -->
        <xsl:if test="@type != 'DropCapitalZone' and @type != 'MainZone-P'">
            <xsl:choose>
                <!-- MainZone-Head special case -->
                
                <xsl:when test="@type='MainZone-Head' and (choice/reg[matches(., '^CAP.*')] or hi/choice/reg[matches(., '^CAP.*')])">
                    <xsl:variable name="Chapter" select="translate(normalize-space(string-join(.//reg, ' ')), ' ', '_')"/>
                    
                    
                    <!--</xsl:variable>-->
                    <h2>
                        <!-- ajoiuter un identifier spécifique au titre de chapitre -->
                        <xsl:variable name="chapter-token" 
                            select="tokenize(normalize-space(string-join(.//reg, ' ')), '\s+')[last()]"/>
                        <xsl:attribute name="id"
                            select="concat('C_', replace(replace($chapter-token, '^CAP\.',''), '\.$',''))"/>
                        
                        <span class="ab_mzHead" id="{$Chapter}">
                            
                            <xsl:apply-templates/>
                        </span>
                    </h2>
                </xsl:when>
                
                <xsl:when test="@type='MainZone-Head' and not(choice/reg[matches(., '^CAP')]) and not(hi/choice/reg[matches(., '^CAP')])">
                    
                    <h3> <!-- ajouter un identifiant pour chaque verset  -->
                        <xsl:variable name="chapter-id" 
                            select="
                            concat(
                            'C_',
                            replace(
                            replace(
                            tokenize(
                            normalize-space(string-join(
                            (preceding-sibling::ab[@type='MainZone-Head' 
                            and (choice/reg[matches(., '^CAP')] 
                            or hi/choice/reg[matches(., '^CAP')])]
                            //reg), ' ')), '\s+')[last()],
                            '^CAP\.',''),
                            '\.$','')
                            )
                            "/>
                        <xsl:attribute name="id">
                            <xsl:value-of select="concat($chapter-id, '_v')"/>
                            <xsl:number 
                                level="any"
                                count="ab[@type='MainZone-Head' 
                                and not(choice/reg[matches(., '^CAP')])
                                and not(hi/choice/reg[matches(., '^CAP')])]"
                                from="ab[@type='MainZone-Head' 
                                and (choice/reg[matches(., '^CAP')] 
                                or hi/choice/reg[matches(., '^CAP')])]"/>
                        </xsl:attribute>
                        <!-- Show DropCap if it exists some e-rara doc have the dropCapital in the verse-->
                        <xsl:if test="preceding-sibling::*[1][self::ab[@type='DropCapitalZone']]">
                            <span class="ab_Drop">
                                <xsl:value-of select="preceding-sibling::ab[@type='DropCapitalZone'][1]//choice/reg"/>
                            </span>
                        </xsl:if>
                        <span class="ab_mzHead" id="{
                            lower-case(string-join(subsequence(tokenize(replace(string-join(.//reg, ' '), '-\s+', ''), '\s+'),1, 3),'_'))}">
                            <xsl:apply-templates/>
                        </span>
                        
                    </h3>
                </xsl:when>
                
                <xsl:when test="@type='MainZone-Entry'">
                    <span class="ab_mzEntry">
                        ◦  <xsl:apply-templates/>
                    </span>
                </xsl:when>
                <!-- Default case -->
                <xsl:otherwise>
                    <p>
                        <xsl:apply-templates/>
                    </p>   
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="ab[@type='DropCapitalZone']"/>
    
    <!-- MainZone-P with potential DropCapitalZone integration -->
    <xsl:template match="ab[@type='MainZone-P']">
        <p>
            <!-- Only show DropCapital if immediately it precede a MainZone-P -->
            <xsl:if test="preceding-sibling::*[1][self::ab[@type='DropCapitalZone']]">
                <span class="ab_Drop">
                    <xsl:value-of select="preceding-sibling::ab[@type='DropCapitalZone'][1]//choice/reg"/>
                </span>
            </xsl:if>
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    
    
    <xsl:template match="fw[@type='RunningTitleZone']">
        <h4>
            <xsl:if test="following-sibling::*[1][self::fw[@type='NumberingZone']]">
                <span class="fw_number">
                    <xsl:value-of select="following-sibling::fw[@type='NumberingZone'][1]//choice/reg"/>
                </span>
            </xsl:if>
            <span class="fw_running">
                <xsl:apply-templates/>
            </span>
        </h4>
    </xsl:template>
    
    <xsl:template match="fw"/>
    
    
    <!--add the br break at the end of each line  -->
    <xsl:template match="choice">
        <xsl:choose>
            <!-- IF inside DropCapitalZone, NO <br> -->
            <xsl:when test="ancestor::ab[@type='DropCapitalZone']">
                <xsl:choose>
                    <xsl:when test="descendant::seg">
                        <i><xsl:value-of select="reg"/></i>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="reg"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <!-- IF inside Main* -->            
            <!-- Normal cases -->
            <xsl:when test="descendant::seg">
                <xsl:variable name="versetFixedText" select="replace(normalize-space(string-join(.//seg, ' ')), '-\s+', '')"/>
                
                <xsl:if test="string-length($versetFixedText) &gt; 0">
                    
                    <!-- for a explicite description of the use of the fonction (lower-case..etc) see the part concerning MainZoneHead  -->
                    <h3><span class="ab_mzHeadLam" id="{lower-case(string-join(subsequence(tokenize($versetFixedText, '\s+'), 1, 3),'_'))}">
                        <xsl:value-of select="$versetFixedText"/>
                        
                        <xsl:value-of select="seg"/>
                        <br/>
                    </span></h3> 
                    
                </xsl:if>
            </xsl:when>
            
            
            <xsl:when test="descendant::reg">
                <xsl:value-of select="reg"/>
                <br/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="reg"/>
                <br/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    
    <xsl:template match="note">
        <xsl:choose>
            <xsl:when test="@type='MarginTextZone'">
                <p class="note-number">
                    <xsl:value-of select=".//reg"/>
                </p>
            </xsl:when>
            <xsl:when test="@type='MarginTextZone-Notes'">
                <p class="note-text">
                    <xsl:value-of select="translate(string-join(.//reg, ' '), '-', '')"/>
                </p>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <!-- removes all the hyphens and add a space at the end of the line if there is no hyphens -->
  <!--  <xsl:template match="note/choice/reg">
        <xsl:choose>
            <xsl:when test="contains(., '-')">
                <xsl:value-of select="translate(., '-', '')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="concat(., ' ')"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>-->
    
    
</xsl:stylesheet>