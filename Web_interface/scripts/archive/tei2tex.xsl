<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0">
    
    <xsl:output method="text" encoding="UTF-8"/>
    <xsl:strip-space elements="*"/>
    
    <xsl:template match="/">
        <xsl:text>% !TeX TS-program = lualatex
\documentclass{article}
\usepackage[T1]{fontenc}
\usepackage{microtype}% Pour l'ajustement de la mise en page
\usepackage[pdfusetitle,hidelinks]{hyperref}
\usepackage[english]{french} % Pour les règles typographiques du français
\usepackage{polyglossia}
\setotherlanguage{greek}
\usepackage[series={},nocritical,noend,noeledsec,nofamiliar,noledgroup]{reledmac}
\usepackage{reledpar} % Package pour l'édition

\usepackage{fontspec} % 
\setmainfont{Liberation Serif}

\usepackage{sectsty}
\usepackage{xcolor}

% Redefine \section font
\sectionfont{\normalfont\scshape\color{gray}}
\subsectionfont{\normalfont}
% Redefine \subsubsection font
\subsubsectionfont{\normalfont\footnotesize\color{black}}

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
            <xsl:text> <!-- create a table of content based on the commented verses -->
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
                <xsl:apply-templates select="*|node()"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    
    <xsl:template match="note">
        <xsl:choose>
            <xsl:when test="@type='MarginTextZone-Notes'">
    <xsl:text>
\subsubsection*{</xsl:text><xsl:apply-templates/><xsl:text>}</xsl:text>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    
  
    
</xsl:stylesheet>