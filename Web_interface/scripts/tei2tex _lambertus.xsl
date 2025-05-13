<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0">
    
    <xsl:output method="text" encoding="UTF-8"/>
    <xsl:strip-space elements="*"/>
    
    <xsl:template match="/">
        <xsl:text>
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% SCRIPT FOR LAMBERT DANNEAU DATA     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%% fini le 30.04.2025 par F. GOY            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%the data are old insert manually the \section{} %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% same for huge bftext in the drop capital %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
eX TS-program = lualatex
\documentclass{article}
\usepackage[T1]{fontenc}
\usepackage{microtype}
\usepackage[pdfusetitle,hidelinks]{hyperref}

\usepackage{polyglossia}
\setmainlanguage{english}
\setotherlanguages{latin,greek}
\usepackage[series={},nocritical,noend,noeledsec,nofamiliar,noledgroup]{reledmac}
\usepackage{reledpar}

\usepackage{fontspec}
\setmainfont{TeX Gyre Termes}

\usepackage{sectsty}
\usepackage{xcolor}

\usepackage{fancyhdr}
\pagestyle{fancy}
\fancyhf{}
\fancyhead[LE,RO]{\nouppercase{\leftmark}}  
\cfoot{\thepage}
\renewcommand{\headrulewidth}{0.4pt}

% Redefine \section to remove numbering
\usepackage{titlesec}
\titleformat{\section}[block]{\normalfont\scshape\color{gray}}{}{0pt}{} % no number in heading
\titleformat{\subsection}[hang]{\normalfont}{}{0pt}{} % also remove subsection number
\titleformat{\subsubsection}[hang]{\normalfont\footnotesize\color{black}}{}{0pt}{}

% Modify how section marks are stored to exclude numbers
\makeatletter
\renewcommand{\sectionmark}[1]{%
	\markboth{#1}{}} % Only store the section title, without number
\renewcommand{\subsectionmark}[1]{%
	\markright{#1}} % Only store the subsection title, without number
\renewcommand{\numberline}[1]{} % Hide the section number in TOC
\makeatother

\begin{document}

\date{}
        </xsl:text>
        <xsl:text>\title{</xsl:text><xsl:value-of select="//title[parent::titleStmt]"/><xsl:text>}
\maketitle
\tableofcontents
\clearpage
\begin{pages} 
\beginnumbering
        </xsl:text>
        <xsl:apply-templates/>
        <xsl:text>
\endnumbering
\end{pages}
\end{document}
        </xsl:text>
    </xsl:template>  
    
    <xsl:template match="teiHeader"/>
    <xsl:template match="sourceDoc"/>
    <xsl:template match="orig"/>
   
    
    <xsl:template match="reg">
        <xsl:apply-templates/><xsl:text> </xsl:text>
    </xsl:template>
    
    <xsl:template match="fw">
        <xsl:choose>
            <xsl:when test="@type='NumberingZone'">
                <xsl:text>
\marginpar{[ p.</xsl:text><xsl:apply-templates/><xsl:text>]}</xsl:text>
            </xsl:when>
            <xsl:when test="@type='RunningTitleZone'">
                <xsl:text>
\section*{</xsl:text><xsl:apply-templates/><xsl:text>}</xsl:text>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    
    <!-- Process text sections (ab elements) -->
    <xsl:template match="ab">
        <xsl:choose>
            <xsl:when test="@type='DropCapitalZone'">
                <xsl:text>
\textbf{</xsl:text><xsl:apply-templates/><xsl:text>}</xsl:text>
            </xsl:when>
            
            <xsl:when test="@type='MainZone-Head' and not(hi/choice/orig[contains(text(), 'CAP')])">
                <xsl:text>
\phantomsection
\addcontentsline{toc}{subsection}{\textit{</xsl:text><xsl:apply-templates/><xsl:text>}}
\subsection*{\textit{</xsl:text><xsl:apply-templates/><xsl:text>}}</xsl:text>
            </xsl:when>
            
            <xsl:when test="@type='MainZone-P'">
                <xsl:text>\pstart </xsl:text>
                <xsl:apply-templates/>
                <xsl:text> \pend</xsl:text>
            </xsl:when>
            
            <xsl:when test="@type='MainZone-P-Continued'">
                <xsl:text>\pstart </xsl:text>
                <xsl:apply-templates/>
                <xsl:text> \pend</xsl:text>
            </xsl:when>
            
            <xsl:when test="@type='MainZone'">
                <xsl:text>\pstart </xsl:text>
                <!-- Handle all 'verset' segments together in one subsection -->
                <xsl:variable name="versets" select=".//seg[@type='verset']"/>
                <xsl:if test="$versets">
                    <xsl:text>\phantomsection
\addcontentsline{toc}{subsection}{\textit{</xsl:text>
                    <xsl:for-each select="$versets">
                        <xsl:value-of select="normalize-space(.)"/>
                        <xsl:if test="position() != last()">
                            <xsl:text> </xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                    <xsl:text>}}
\subsection*{\textit{</xsl:text>
                    <xsl:for-each select="$versets">
                        <xsl:value-of select="normalize-space(.)"/>
                        <xsl:if test="position() != last()">
                            <xsl:text> </xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                    <xsl:text>}}</xsl:text>
                </xsl:if>
                <xsl:apply-templates/>
                <xsl:text> \pend</xsl:text>
                <!-- Continue applying templates for the rest of the content -->
                
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="note">
        <xsl:choose>
            <xsl:when test="@type='MarginTextZone-Notes'">
                <!-- Insert LaTeX rule only if the immediately preceding sibling is an <ab> -->
                <xsl:if test="preceding-sibling::*[1][self::ab]">
                    <xsl:text>
\vspace{0.5cm}\noindent</xsl:text> <!--\- Align with left margin -\-->
                    <xsl:text>
\vspace{0.2cm}\rule{1cm}{0.2pt}\\ </xsl:text>
                </xsl:if>
                <xsl:text>
\hspace{0.2cm}\textit{mg}
\footnotesize </xsl:text>
                <xsl:apply-templates/>
                <xsl:text>
\normalsize| </xsl:text>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    
  
    
</xsl:stylesheet>