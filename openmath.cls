% LaTeX Class File for OpenMath Documents
%
% Author: David Carlisle (davidc@nag.co.uk)
%
% Copyright 1998 NAG Ltd and the OpenMath ESPRIT Consortium (number 24969)

% 

% NOTES ON USAGE AT END OF FILE AFTER ========
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\ProvidesClass{openmath}[2002/11/01 v2.5 OpenMath Project Class (DPC)]


% add keylogo option
% make copyright OM TN
\def\omwarn#1{\ClassWarningNoLine{openmath}{#1}}
\DeclareOption{section}{\def\@mainclass{article}}
\DeclareOption{chapter}{\def\@mainclass{report}}

\DeclareOption{colorlogo}{%
  \def\omlogo{%
    \includegraphics[width=175bp]{openmath}}}
\DeclareOption{keylogo}{%
  \def\omlogo{%
    \includegraphics[width=175bp]{keylogo}}}
\DeclareOption{bwlogo}{%
  \def\omlogo{%
    \includegraphics{openmath2}}}
\DeclareOption{texlogo}{%
  \def\omlogo{{%
    \unitlength1pt
    \begin{picture}(170.71652,76.46826)
      \put(0,5){\fontsize\@xxpt\@xxpt\bfseries\itshape OpenMath}%
      \put(120,12){\def\,{\kern.3pt}%
        \fontsize\@xiipt\@xiipt\sffamily\bfseries E\,S\,P\,R\,I\,T}%
      \put(120,5){\fontsize{6}{6}\sffamily PROJECT 24969}%
      \put(60,37){\fontsize{9}{9}\itshape Mathematics comes alive}%
      \put(70,28){\fontsize{6}{6}\tiny\selectfont$\scriptstyle
        \frac{\mathit{1}}{\mathit{2}\pi i}%
        \mathop{\textstyle\oint}\limits_C f(\!z\!)dz \,=\,
        \sum\limits_{k=1}^n%
        \mathop{\mathrm{Res}}\limits_{z=a_k\kern-3pt}\,%
       f(\!z\!)$}%
      \put(55,5){\framebox(115.71652,71.46826){}}
    \end{picture}}}}

\def\consortium{The OpenMath Society}
\DeclareOption{esprit}{\def\consortium{ESPRIT project 24969: OpenMath}}
\DeclareOption{tn}{\def\consortium{OpenMath Thematic Network (IST-2000-28719)}}

\DeclareOption*{\PassOptionsToClass\CurrentOption\@mainclass}

\ExecuteOptions{texlogo,section}

\ProcessOptions
\LoadClass[a4paper]{\@mainclass}
\RequirePackage{graphicx,exscale}

% a bit wider
\advance\evensidemargin-.5in
\advance\oddsidemargin-.5in
\advance\textwidth1in

\def\title#1{\gdef\@title{#1}}
\def\@title{\omwarn{Title not specified}}

\def\deliverable#1{\gdef\@deliverable{#1}}
\def\@deliverable{\omwarn{Deliverable not specified}}

\def\task#1{%
  \gdef\@workpackage{#1}%
  \gdef\@wpkg{\space (Task: \@workpackage)}}
\def\@workpackage{\omwarn{Task not specified}}
\let\@wpkg\@empty

\def\status#1{%
  \lowercase{\@ifundefined{status@#1}}%
    {\omwarn{Status must be one of: Confidential, Restricted, Public}}%
    {\lowercase{\gdef\@status{#1}}}}
\def\@status{\omwarn{Status not specified}}
\let\@@status\@status

\let\status@confidential\@empty
\let\status@restricted\@empty
\let\status@public\@empty

\newcount\om@auth
\def\author#1{%
  \advance\om@auth\@ne
  \g@addto@macro\@author{\do{#1}}}
\let\@author\@empty

\newcount\om@ed
\def\editor#1{%
  \advance\om@ed\@ne
  \g@addto@macro\@editor{\do{#1}}}
\let\@editor\@empty

\newcount\om@addr
\def\address#1{%
  \def\@tempa{#1}%
  \@tempswatrue
  \count@\@ne
  \def\do##1{%
    \def\@tempb{##1}%
    \ifx\@tempa\@tempb
      \@tempswafalse
      \let\do\@gobble
    \else
      \advance\count@\@ne
    \fi}%
  \@address
  \if@tempswa
    \advance\om@addr\@ne
    \g@addto@macro\@address{\do{#1}}%
  \fi
  \expandafter\g@addto@macro\expandafter\@author
  \expandafter{\expandafter\om@addrmark\expandafter{\the\count@}}}


\let\om@addrm@rk\textsuperscript
\let\@address\@empty


\def\version#1{\gdef\@version{Version:& #1\\}}
\def\@version{\omwarn{Version number not specified}}



\def\date#1{\gdef\@date{Date:& #1\\}}
\def\@date{\omwarn{Date not specified}}

\let\oldtableofcontents\tableofcontents
\def\tableofcontents{\oldtableofcontents\clearpage}

\def\maketitle{%
\clearpage
\pagenumbering{roman}%
\thispagestyle{cover}
\begingroup
\centering
\vspace*{-1.5cm}%

{\bfseries
\begin{tabular}[b]{@{}ll@{}}%
\ifx\@wpkg\@empty\else Task:& \@workpackage\\\fi
\@version
\@date
\end{tabular}%

\vspace{5mm}

\omlogo
}

\vspace{10mm}%
\LARGE\bfseries\@title
%\normalsize
\normalfont
\par
\ifnum\om@addr=\@ne
  \let\om@addrm@rk\@gobble
\fi
\sfcode`\,9000
%\vspace{24pt}%
\vspace{\parskip}%
\let\do\@author@do
\@author\om@addrmark\relax

\ifnum\om@ed>\z@
\vspace{12pt}%
Editor\ifnum\om@ed>\@ne s\fi
\fi

\def\do##1{%
  ##1%
  \advance\om@ed\m@ne
  \ifnum\om@ed>\@ne, \else\ifnum\om@ed=\@ne\space and \fi\fi}%
\@editor

\ifnum\om@addr>\z@
  \vspace{24pt}%
  \ifnum\om@addr=\@ne
    \def\do{}%
  \else
    \count@\z@
    \def\do##1{%
      \advance\count@\@ne
      \ifhmode\hskip 1em\fi\textsuperscript{\the\count@}##1}%
  \fi
  \@address
\fi
%\normalsize
\vfill
\enlargethispage{15pt}
\rightline{\bfseries\@deliverable
     \ifx\@status\@@status\else\ (\expandafter\MakeUppercase\@status)\fi}

\endgroup
\cleardoublepage
\begingroup
\ifvoid\absbox
  \omwarn{No Abstract}%
\else
\centering
  \usebox\absbox\par
\cleardoublepage
\fi
\endgroup
\pagenumbering{arabic}%
\gdef\thepageofx{Page~\thepage~of~\thelastpage}%
\g@addto@macro\abstract{\omwarn{\protect\begin{abstract}\MessageBreak
               must be before \protect\maketitle}}}


\def\@author@do#1#2\om@addrmark#3{%
  \advance\om@auth\m@ne
  \mbox{#1}\om@addrm@rk{#3}%
  \ifnum\om@auth>\@ne, \else\ifnum\om@auth=\@ne\space \mbox{and}
  \fi\fi%
  #2\om@addrmark{#3}}

\let\om@addrmark\@gobble



\newbox\absbox
\def\abstract{%
  \lrbox\absbox\minipage{.75\textwidth}\small
  \begin{center}\bfseries\large Abstract\end{center}}
\def\endabstract{\endminipage\endlrbox}


\def\ps@om{%
  \def\@oddhead{\parbox\hsize{%
    \rightline{\strut\textit{\consortium}}
    \hrule}}%
  \def\@evenhead{\parbox\hsize{%
    \leftline{\strut\textit{\consortium}}
    \hrule}}%
  \def\@oddfoot{%
   \parbox\hsize{\hrule\par\smallskip
    \@@line{\strut\footnotesize
   \@title\@wpkg\hfill
      \thepageofx}}}%
  \def\@evenfoot{%
   \parbox\hsize{\hrule\par\smallskip
    \@@line{\strut\footnotesize
    \thepageofx\hfill \@title\@wpkg}}}}

\def\ps@cover{%
  \def\@oddhead{}%
  \def\@oddfoot{%
   \parbox\hsize{\hrule\par\smallskip
    \@@line{\strut
   \copyright\  \theyear\ \consortium\hfill}}}}

\edef\theyear{\number\year}
\def\copyrightyear#1{\gdef\theyear{#1}}

\def\ps@plain{%
  \def\@oddhead{}%
  \let\@evenhead\@oddhead
  \def\@oddfoot{%
   \parbox\hsize{\hrule\par\smallskip
    \@@line{\strut\footnotesize
    \hfill
      \thepageofx}}}%
  \def\@evenfoot{%
   \parbox\hsize{\hrule\par\smallskip
    \@@line{\strut\footnotesize
    \thepageofx\hfill}}}}

\pagestyle{om}
\let\pagestyle\@gobble
\def\thepageofx{\thepage}

% Vertical space mods from Mike's old 2.09 version.
% Separate paragraphs, and subvert \item to leave less space!
%
\parskip=0.5\baselineskip
\parindent=0pt
%
\def\itemize{\ifnum \@itemdepth >3
  \@toodeep\else \advance\@itemdepth \@ne
\edef\@itemitem{labelitem\romannumeral\the\@itemdepth}%
\list{\csname\@itemitem\endcsname}{\itemsep=-2pt plus
5pt\def\makelabel##1{\hss\llap{##1}}}\fi}  
\def\description{\list{}{\labelwidth\z@ \itemindent-\leftmargin
\itemsep=-2pt plus 5pt \let\makelabel\descriptionlabel}}
\def\enumerate{\ifnum \@enumdepth >3 \@toodeep\else
      \advance\@enumdepth \@ne
      \edef\@enumctr{enum\romannumeral\the\@enumdepth}\list
      {\csname label\@enumctr\endcsname}{\usecounter
        {\@enumctr}\itemsep=-2pt plus 5pt
        \def\makelabel##1{\hss\llap{##1}}}\fi}
%


\AtEndDocument{%
  \clearpage
  \count@\c@page
  \advance\count@\m@ne
  \edef\@tempa{\the\count@}%
  \ifx\@tempa\thelastpage
  \else
    \omwarn{Last page changed: Rerun LaTeX}%
  \fi
  \immediate\write\@auxout{%
    \gdef\string\thelastpage{\the\count@}}}
\def\thelastpage{??}

% raggedright sections. added 1999/03/30
\let\om@startsection\@startsection
\def\@startsection#1#2#3#4#5#6{%
  \om@startsection{#1}{#2}{#3}{#4}{#5}{#6\boldmath\raggedright}}

% cleardouble
\def\cleardoublepage{\clearpage\if@twoside \ifodd\c@page\else
    \hbox{}\thispagestyle{empty}\newpage
    \if@twocolumn\hbox{}\newpage\fi\fi\fi}

% basic hyperref support in case hyperref package not loaded
\def\href#1#2{#2}
\endinput

===============================================================

openmath.cls
=============

This class is to be used for openmath documents.

Basic usage is

\documentclass{openmath}

It takes the same options as the standard article class, eg

\documentclass[11pt,twoside,openright]{openmath}

In addition you may use the options

section  :  Top level unit is \section (like article class)
chapter  :  Top level unit is \chapter (like report class)
         section is the default.


colorlogo : Use full colour OpenMath Logo on coverpage
bwlogo    : Use Black and White OpenMath Logo on coverpage
texlogo   : Use TeX mockup of logo (faster for previewing drafts)
          texlogo is the default

The frontmatter commands are the following, they must all be used
before \maketitle which uses the information to make up the title page
(and optional abstract page).

\author{authors name}
   one such command for each author

\address{Address (or just company/institution)}
   one such command after each group of authors at the same address.
   If the authors are not listed by institution, eg if given
   alphabetically, the \address should be repeated, the class will
   not print the address twice, but will do TheRightThing.

\editor{editors name} as for \author.

\title{Title}

\deliverable{..} optional command for deliverable string, eg
              \deliverable{Deliverable 1.1.1}

\task{..} optional command for workpackage task number.
       \task{1.4}

\status{...}  confidential. restricted or public

\begin{abstract}..\end{abstract}
  Optional text of abstract (must come before \maketitle.


\maketitle
   Makes a title page.

===========================================
Example document


\documentclass[12pt]{openmath}

\begin{document}
\title{openmath example document}

\deliverable{Deliverable 2.2.2}
\status{Restricted}
\task{0.0}
\status{confidential}
\date{September, 1066}
\copyrightyear{1066}

\author{D Carlisle}
\author{V Harvey}
\address{NAG}

\author{S Buswell}
\address{Stilo}

\begin{abstract}
Something terribly exiting about OpenMath
\end{abstract}

\maketitle
\section{aaa}
bbb
bbb
\clearpage
ggg
\end{document}
