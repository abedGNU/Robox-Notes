#!/bin/sh

#Compile
pdflatex main.tex main.pdf


#Clean
rm -f *.ptc *.bcf *.run.xml *.toc *.aux *.idx *.log *.synctex.gz
