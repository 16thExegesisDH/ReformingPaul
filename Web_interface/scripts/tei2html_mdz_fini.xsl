<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    exclude-result-prefixes="xs xd"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    version="2.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Dec 3, 2025</xd:p>
            <xd:p><xd:b>Author:</xd:b> Floriane Goy</xd:p>
            <xd:p> XSLT stylesheet that generates semantic HTML, based on the April 30, 2025 script.</xd:p>
        </xd:desc>
    </xd:doc>
    
    <xd:doc>
        <xd:desc>
            <xd:p> 
                Remove unnecessary whitespace in the input XML and generate a clean, 
                properly indented HTML output</xd:p>
        </xd:desc>
    </xd:doc>
    
    <xsl:strip-space elements="*"/>
    <xsl:output method="html" indent="yes" encoding="UTF-8"/>
    
    <xd:doc>
        <xd:desc>
            <xd:p>
                Match the root node of the input document and generate the main HTML
                structure. This template assembles the core page layout by invoking 
                several named templates responsible for metadata, navigation elements, 
                content sections, and the footer.
            </xd:p>
            <xd:p>
                The <xd:i>div.main-wrapper</xd:i> contains the main page content and allows 
                it to move dynamically, for example, when the sidebar is opened or closed, 
                supporting responsive and interactive page behavior.
            </xd:p>
        </xd:desc>
        
        <xd:return>
            <xd:p>
                An <xd:i>html</xd:i> element containing the complete page structure,
                including head and body elements populated through the invoked templates.
            </xd:p>
        </xd:return>
    </xd:doc>
    
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
    
   
    <xd:doc>
        <xd:desc>
            <xd:p>
                Remove unneeded elements from the output HTML by matching and ignoring 
                specific elements in the source XML.
            </xd:p>
            <xd:p>
                1. <xd:i>teiHeader</xd:i> – the TEI header information is excluded from 
                the output, as it is not needed in the HTML rendering.
            </xd:p>
            <xd:p>
                2. <xd:i>sourceDoc</xd:i> – the source document wrapper element is omitted 
                from the output to prevent unnecessary markup.
            </xd:p>
            <xd:p>
                3. <xd:i>orig</xd:i> – original source text elements are ignored, as they 
                are not part of the displayed content.
            </xd:p>
        </xd:desc>
        
        <xd:return>
            <xd:p>
                These templates produce no output for the matched elements, effectively 
                removing them from the resulting HTML page while preserving the relevant 
                content.
            </xd:p>
        </xd:return>
    </xd:doc>
    
    <xsl:template match="teiHeader | /sourceDoc | orig"/>
    
    
    <xd:doc>
        <xd:desc>
            <xd:p>
                Process <xd:i>ab</xd:i> (anonymous block) elements in the source TEI document, 
                rendering them according to their type while skipping certain elements handled 
                elsewhere.
            </xd:p>
            <xd:p>
                The template ignores <xd:i>DropCapitalZone</xd:i> and <xd:i>MainZone-P</xd:i> 
                types, as these are handled by other templates.
            </xd:p>
            <xd:p>
                Rendering logic based on the <xd:i>@type</xd:i> attribute:
            </xd:p>
            <xd:p>
                1. <xd:i>MainZone-Head</xd:i> with a <xd:i>CAP.*</xd:i> marker:
                <br/>• Generates an <xd:i>h2</xd:i> element for the chapter heading.
                <br/>• Creates a unique <xd:i>id</xd:i> for the chapter based on the text of the last token in the header.
            </xd:p>
            <xd:p>
                2. <xd:i>MainZone-Head</xd:i> without a <xd:i>CAP.*</xd:i> marker:
                <br/>• Generates an <xd:i>h3</xd:i> element for sub-sections or verses.
                <br/>• Computes a unique <xd:i>id</xd:i> by combining the preceding chapter identifier and a sequential number.
                <br/>• Also generates a short anchor based on the first three words of the text for linking.
            </xd:p>
            <xd:p>
                3. <xd:i>MainZone-Entry</xd:i>:
                <br/>• Wraps the content in a <xd:i>span.ab_mzEntry</xd:i> with a bullet marker (◦).
            </xd:p>
            <xd:p>
                4. Default case:
                <br/>• Wraps the content in a standard paragraph (<xd:i>p</xd:i>) element.
            </xd:p>
        </xd:desc>
        
        <xd:return>
            <xd:p>
                HTML elements representing the TEI <xd:i>ab</xd:i> content, including 
                structured headings (<xd:i>h2</xd:i>, <xd:i>h3</xd:i>), entries, and 
                paragraphs<xd:i>p</xd:i>. Each heading and sub-section is given a unique identifier 
                to allow navigation and linking within the page.
            </xd:p>
        </xd:return>
    </xd:doc>
    
    
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
    
    <xd:doc>
        <xd:desc>delete the DropCapital for preventing double entry</xd:desc>
    </xd:doc>
    <xsl:template match="ab[@type='DropCapitalZone']"/>
    
    
    <xd:doc>
        <xd:desc>
            <xd:p>
                Handle <xd:i>DropCapitalZone</xd:i> and <xd:i>MainZone-P</xd:i> elements in the TEI document, 
                ensuring proper display of drop capitals in the HTML output.
            </xd:p>
            <xd:p>
                1. <xd:i>ab[@type='DropCapitalZone']</xd:i> elements are deleted by default, 
                preventing them from being rendered independently.
            </xd:p>
            <xd:p>
                2. <xd:i>ab[@type='MainZone-P']</xd:i> elements are rendered inside a paragraph 
                (<xd:i>p</xd:i>), and the template checks if the immediately preceding sibling 
                is a <xd:i>DropCapitalZone</xd:i>.
                <br/>• If so, the text from its <xd:i>choice/reg</xd:i> element is extracted 
                and wrapped in a <xd:i>span.ab_Drop</xd:i> to display the drop capital.
                <br/>• Then the content of the <xd:i>MainZone-P</xd:i> element itself is rendered.
            </xd:p>
            <xd:p>
                This approach ensures drop capitals are shown only in the context of their 
                associated main text blocks and not as standalone elements.
            </xd:p>
        </xd:desc>
        
        <xd:return>
            <xd:p>
                A paragraph (<xd:i>p</xd:i>) containing the main text of the <xd:i>MainZone-P</xd:i> 
                block, optionally preceded by a styled drop capital extracted from the 
                immediately preceding <xd:i>DropCapitalZone</xd:i> element.
            </xd:p>
        </xd:return>
    </xd:doc>
    

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
    
    <xd:doc>
        <xd:desc>
            <xd:p>
                Process <xd:i>fw</xd:i> (front matter) elements of type <xd:i>RunningTitleZone</xd:i> 
                in the TEI document, rendering them as headings with optional numbering.
            </xd:p>
            <xd:p>
                Rendering logic:
            </xd:p>
            <xd:p>
                1. If the immediately following sibling is a <xd:i>fw[@type='NumberingZone']</xd:i>:
                <br/>• Extracts the text from its <xd:i>choice/reg</xd:i> element.
                <br/>• Wraps it in a <xd:i>span.fw_number</xd:i> to display the number.
            </xd:p>
            <xd:p>
                2. The text of the <xd:i>RunningTitleZone</xd:i> itself is wrapped in 
                <xd:i>span.fw_running</xd:i> to display the running title.
            </xd:p>
            <xd:p>
                The combined result is enclosed in an <xd:i>h4</xd:i> element, providing 
                a clear and styled heading in the HTML output.
            </xd:p>
        </xd:desc>
        
        <xd:return>
            <xd:p>
                An <xd:i>h4</xd:i> element containing the optional number (from the following 
                <xd:i>NumberingZone</xd:i>) and the running title text, properly styled 
                using <xd:i>span</xd:i> elements.
            </xd:p>
        </xd:return>
    </xd:doc>
    
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
    
    
    <xd:doc>
        <xd:desc>
            <xd:p>
                Suppress other <xd:i>fw</xd:i> elements that are not of type <xd:i>RunningTitleZone</xd:i>, 
                preventing them from being rendered in the output.
            </xd:p>
        </xd:desc>
        
        <xd:return>
            <xd:p>
                No output is produced for <xd:i>fw</xd:i> elements without the <xd:i>RunningTitleZone</xd:i> type.
            </xd:p>
        </xd:return>
    </xd:doc>
    <xsl:template match="fw"/>

    
    <xd:doc>
        <xd:desc>
            <xd:p>
                Process <xd:i>choice</xd:i> elements in the TEI document, rendering their 
                <xd:i>reg</xd:i> text content and optionally adding line breaks (<xd:i>br</xd:i>) 
                depending on the context.
            </xd:p>
            <xd:p>
                Rendering logic:
            </xd:p>
            <xd:p>
                1. If the <xd:i>choice</xd:i> element is inside an <xd:i>ab[@type='DropCapitalZone']</xd:i>:
                <br/>• Only the text from <xd:i>reg</xd:i> is output; no line break is added.
            </xd:p>
            <xd:p>
                2. If the <xd:i>choice</xd:i> element is inside an <xd:i>ab</xd:i> of type 
                <xd:i>Main*</xd:i> or <xd:i>TitlePageZone</xd:i>, or in any other context:
                <br/>• The text from <xd:i>reg</xd:i> is output, followed by a <xd:i>br</xd:i> element 
                to create a line break in the HTML output.
            </xd:p>
            <xd:p>
                This ensures that drop capitals are displayed inline without line breaks, 
                while regular main text and title page content are properly separated visually.
            </xd:p>
        </xd:desc>
        
        <xd:return>
            <xd:p>
                The <xd:i>reg</xd:i> text content of the <xd:i>choice</xd:i> element, optionally 
                followed by a <xd:i>br</xd:i> element depending on the type of parent <xd:i>ab</xd:i> 
                element.
            </xd:p>
            <xd:p>The <xd:i>br</xd:i> line breaks allow the page text to correspond visually 
                with the line breaks of the original text in the image.</xd:p>
        </xd:return>
    </xd:doc>
    
    <xsl:template match="choice">
        <xsl:choose>
            <!-- IF inside DropCapitalZone, NO <br> -->
            <xsl:when test="ab[@type='DropCapitalZone']">
                <xsl:value-of select="reg"/>
            </xsl:when>
            <xsl:when test="ab[@type='Main*']">
                <xsl:value-of select="reg"/><xsl:element name="br"/>
            </xsl:when>
            <xsl:when test="ab[@type='TitlePageZone']">
                <xsl:value-of select="reg"/><xsl:element name="br"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="reg"/><xsl:element name="br"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>
            <xd:p>
                Process <xd:i>note</xd:i> elements in the TEI document, rendering marginal 
                notes and their corresponding numbers in the HTML output.
            </xd:p>
            <xd:p>
                Rendering logic based on the <xd:i>@type</xd:i> attribute:
            </xd:p>
            <xd:p>
                1. <xd:i>MarginTextZone</xd:i>:
                <br/>• Represents the number contained in the marginal zone.
                <br/>• The number from the <xd:i>reg</xd:i> element is rendered inside a 
                <xd:i>p.note-number</xd:i> paragraph.
            </xd:p>
            <xd:p>
                2. <xd:i>MarginTextZone-Notes</xd:i>:
                <br/>• Represents the text content of the marginal note.
                <br/>• The text from the <xd:i>reg</xd:i> element is rendered inside a 
                <xd:i>p.note-text</xd:i> paragraph.
            </xd:p>
            <xd:p>
                This ensures that marginal note numbers and their corresponding note texts 
                are displayed clearly and semantically in the HTML output.
            </xd:p>
        </xd:desc>
        
        <xd:return>
            <xd:p>
                Paragraph elements (<xd:i>p.note-number</xd:i> or <xd:i>p.note-text</xd:i>) 
                containing the marginal note number or note text, depending on the type of 
                the <xd:i>note</xd:i> element.
            </xd:p>
        </xd:return>
    </xd:doc>
    
    
    <xsl:template match="note">
        <xsl:choose>
            <xsl:when test="@type='MarginTextZone'">
                <p class="note-number">
                    <xsl:value-of select=".//reg"/>
                </p>
            </xsl:when>
            <xsl:when test="@type='MarginTextZone-Notes'">
                <p class="note-text">
                    <xsl:value-of select=".//reg"/>
                </p>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
 
    <xd:doc>
        <xd:desc>
            <xd:p>
                Create the metadata section of the generated HTML document. This template 
                defines the viewport configuration, extracts and sets the page title from 
                the <xd:i>titleStmt</xd:i> element, and includes the required stylesheet 
                and JavaScript resources for the interface.
            </xd:p>
        </xd:desc>
        
        <xd:return>
            <xd:p>
                A set of metadata elements inserted into the HTML <xd:i>head</xd:i> 
                section, including <xd:i>meta</xd:i>, <xd:i>title</xd:i>, 
                <xd:i>link</xd:i> and <xd:i>script</xd:i> elements.
            </xd:p>
        </xd:return>
    </xd:doc>
    
    <xsl:template name="metadata">
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        <!-- Extract the title from short title -->
        <title>
            <xsl:value-of select="//title[parent::titleStmt]"/>
        </title>
     <!--   <link href="../../../Web_interface/CSS/FG_stylesheet_fini.css" rel="stylesheet"/> -->
        <link href="../../../Web_interface/CSS/FG_stylesheet_small_fini.css" rel="stylesheet"/> 
        <script src="../../../Web_interface/JS/my_function_fini.js" defer="defer"></script>
    </xsl:template>
    
    
    <xd:doc>
        <xd:desc>
            <xd:p>
                Create the sidebar section of the HTML interface. This template generates 
                a collapsible navigation panel that includes:
            </xd:p>
            <xd:p>
                1. A close button for hiding the sidebar (<xd:i>×</xd:i>).<br/>
                2. A link to the home page.<br/>
                3. A dynamically constructed table of contents (TOC) built from elements 
                with <xd:i>MainZone-Head</xd:i> type, grouped by chapter headers matching 
                the pattern <xd:i>^CAP.*</xd:i>.<br/>
                4. Subpoints under each chapter representing sections or verses, with 
                text normalized and cleaned for anchor links.
            </xd:p>
            <xd:p>
                The TOC items are collapsible using JavaScript functions 
                <xd:i>toggleTOC()</xd:i> and <xd:i>toggleSubPoints()</xd:i>, and each 
                link generates a unique anchor based on the text content.
            </xd:p>
        </xd:desc>
        
        <xd:return>
            <xd:p>
                An <xd:i>aside</xd:i> element representing the sidebar, including: 
                a close button, home link, and a hierarchical list of navigation links. 
                Chapter headers are top-level list items, and sections/verses are nested 
                sub-items with automatically generated anchor links for navigation.
            </xd:p>
        </xd:return>
    </xd:doc>
    
    <xd:doc>
        <xd:desc>
            <xd:p>
                Create the sidebar section of the HTML interface. This template generates 
                a collapsible navigation panel that includes:
            </xd:p>
            <xd:p>
                1. A close button for hiding the sidebar (<xd:i>×</xd:i>).<br/>
                2. A link to the home page.<br/>
                3. A dynamically constructed table of contents (TOC) built from elements 
                with <xd:i>MainZone-Head</xd:i> type, grouped by chapter headers matching 
                the pattern <xd:i>^CAP.*</xd:i>.<br/>
                4. Subpoints under each chapter representing sections or verses, with 
                text normalized and cleaned for anchor links.
            </xd:p>
            <xd:p>
                The TOC items are collapsible using JavaScript functions 
                <xd:i>toggleTOC()</xd:i> and <xd:i>toggleSubPoints()</xd:i>, and each 
                link generates a unique anchor based on the text content.
            </xd:p>
        </xd:desc>
        
        <xd:return>
            <xd:p>
                An <xd:i>aside</xd:i> element representing the sidebar, including: 
                a close button, home link, and a hierarchical list of navigation links. 
                Chapter headers are top-level list items, and sections/verses are nested 
                sub-items with automatically generated anchor links for navigation.
            </xd:p>
        </xd:return>
    </xd:doc>
    
    <xsl:template name="sidebar">
        <aside class="sidebar" id="mySidebar" aria-label="Menu principal">
            <a class="closebtn" href="#" onclick="closeNav()" aria-label="Fermer le menu">×</a>
            <a href="../../../index.html">Home</a>
            <div id="toc_container">
                <a class="toc_title" href="javascript:void(0)" onclick="toggleTOC()">&gt; Table of Content</a>
                <ul class="toc_list" style="display: none; padding-left: 8px;">
                    <xsl:for-each-group select="//*[@type='MainZone-Head']"
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
                                    
                                    <xsl:variable name="versetFixedText" select="replace(normalize-space(string-join(.//reg, ' ')), '-\s+', '')"/>
                                    
                                    <xsl:if test="string-length($versetFixedText) &gt; 0">
                                        <li>
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
    
    <xd:doc>
        <xd:desc>
            <xd:p>
                Create the navigation bar section of the HTML interface. This template 
                generates a top-level <xd:i>nav</xd:i> element containing:
            </xd:p>
            <xd:p>
                1. A button to open the sidebar menu, with an <xd:i>aria-label</xd:i> 
                for accessibility and an <xd:i>onclick</xd:i> event calling the 
                <xd:i>openNav()</xd:i> JavaScript function.
            </xd:p>
            <xd:p>
                2. A download section with links to XML-TEI and PDF versions of the 
                current document. The file paths are dynamically constructed using the 
                <xd:i>xml:id</xd:i> attribute from the root <xd:i>TEI</xd:i> element. 
                Each link opens in a new tab (<xd:i>target="_blank"</xd:i>).
            </xd:p>
        </xd:desc>
        
        <xd:return>
            <xd:p>
                A <xd:i>nav</xd:i> element containing a menu toggle button and a set 
                of downloadable resource links, providing easy navigation and access 
                to the document files.
            </xd:p>
        </xd:return>
    </xd:doc>
    
    <xsl:template name="navigation-bar">
        <nav>
            <button class="openbtn" onclick="openNav()" aria-label="Ouvrir le menu de navigation" aria-expanded="false">☰ Navigation</button>
            <div class="download">
                <a href="{concat('../../TEI/',//TEI/@xml:id),'_tei_NF.zip'}" class="button" target="_blank">[↓] XML-TEI</a>
                <a href="{concat('../../PDF/',//TEI/@xml:id,'_update.pdf')}" class="button" target="_blank">[↓] PDF</a>
            </div>    
        </nav>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>
            <xd:p>
                Create the header section of the HTML page. This template generates a 
                <xd:i>header</xd:i> element containing a top-level heading (<xd:i>h1</xd:i>) 
                with the title of the document.
            </xd:p>
            <xd:p>
                The title is extracted dynamically from the <xd:i>title</xd:i> element 
                whose parent is <xd:i>titleStmt</xd:i> in the source XML document.
            </xd:p>
        </xd:desc>
        
        <xd:return>
            <xd:p>
                A <xd:i>header</xd:i> element with an <xd:i>h1</xd:i> element displaying 
                the document title, providing a clear, semantic page heading.
            </xd:p>
        </xd:return>
    </xd:doc>
    
    <xsl:template name="header">
    <header>
        <h1>
            <xsl:value-of select="//title[parent::titleStmt]"/>
        </h1>
    </header>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>
            <xd:p>
                Generate the main text section of the HTML page. This template iterates 
                over each <xd:i>pb</xd:i> (page break) element in the source XML document 
                (/TEI/text/body/pb) and creates structured content for each page.
            </xd:p>
            <xd:p>
                For each <xd:i>pb</xd:i> element:
            </xd:p>
            <xd:p>
                1. Extract the page identifier from <xd:i>@corresp</xd:i> using 
                <xd:i>substring-after</xd:i> to obtain a unique ID for sections and notes.
            </xd:p>
            <xd:p>
                2. Create a <xd:i>div.content-wrapper</xd:i> containing:
                <br/>• A <xd:i>div.text-container</xd:i> with:
                <br/> – A <xd:i>section.text</xd:i> containing the main text elements 
                (<xd:i>fw</xd:i> and <xd:i>ab</xd:i>) that correspond to the page.
                <br/> – A <xd:i>section.note</xd:i> containing related notes (<xd:i>note</xd:i>) 
                linked to the page.
                <br/>• A <xd:i>figure.image-text</xd:i> displaying the page image using 
                an IIIF URL constructed from the page identifier.
            </xd:p>
            <xd:p>
                The template ensures that each text, note, and image section is uniquely 
                identified using the page’s <xd:i>@corresp</xd:i> attribute, enabling 
                navigation and linking.
            </xd:p>
        </xd:desc>
        
        <xd:return>
            <xd:p>
                A <xd:i>main</xd:i> element containing all page content, with each page 
                represented as a structured wrapper including text, notes, and the corresponding 
                image. This allows the HTML page to display text and images in sync with 
                the original TEI document structure.
            </xd:p>
        </xd:return>
    </xd:doc>
    
    <xsl:template name="text-section">
        <main>
                <xsl:for-each select="/TEI/text/body/pb">
                    <!-- Extract the relevant digit sequence from pb/@corresp -->
                    <xsl:variable name="pbID" select="substring-after(@corresp, 'fbsb')"/>
                    <div class="content-wrapper">
                        <div class="text-container">
                        <!-- Process matching text sections (fw/ab) => section -->
                        <!-- Add a tag corresponding to the iiif identifier of the page -->
                        <section class="text" id="{substring-after(@corresp,'f')}">  
                            <xsl:apply-templates select="../fw[starts-with(@corresp, concat('#fbsb', $pbID))]"/>
                            <xsl:apply-templates select="../ab[starts-with(@corresp, concat('#fbsb', $pbID))]"/>
                        </section> <!-- div tex-contenaire -->
                        <section class="note" id="{concat('#', substring-after(@corresp, 'fbsb'))}"> 
                            <xsl:apply-templates select="../note[starts-with(@corresp, concat('#fbsb', $pbID))]"/>
                        </section> <!-- div note-section -->
                        </div> <!-- div text-container -->
                        <!-- Generate the image section after the text-container -->
                        <figure class="image-text">  <!-- div image-section => figure -->
                            <img src="{concat('https://api.digitale-sammlungen.de/iiif/image/v2/', substring-after(@corresp, 'f'), '/full/full/0/default.jpg')}" alt="{substring-after(@corresp,'f')}"/>
                        </figure>
                    </div> <!-- div content-wrapper-->
                </xsl:for-each>
        </main>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>
            <xd:p>
                Create the footer section of the HTML page. This template generates a 
                <xd:i>footer</xd:i> element containing two main sections:
            </xd:p>
            <xd:p>
                1. <xd:i>credits</xd:i> – displays terms of use and citation information 
                for the digital library, as well as the coding and design contact 
                information with a mailto link.
            </xd:p>
            <xd:p>
                2. <xd:i>logos</xd:i> – displays the logos of supporting institutions 
                using <xd:i>figure</xd:i> and <xd:i>img</xd:i> elements, each with 
                appropriate <xd:i>alt</xd:i> text for accessibility.
            </xd:p>
        </xd:desc>
        
        <xd:return>
            <xd:p>
                A <xd:i>footer</xd:i> element containing structured credit information 
                and institutional logos, providing page closure, attribution, and visual 
                branding for the digital library.
            </xd:p>
        </xd:return>
    </xd:doc>
    
    
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
    
</xsl:stylesheet>