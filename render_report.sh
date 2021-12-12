#!/bin/bash

ID=$1
inputdir=/data/Test_task/output_old/${ID}
path=D:/Work/CR_Assessment/Test_task/output_old/005
# change directory to make writing to html look a bit cleaner
cd ${inputdir}

echo "<html>" 												>  QA.html
echo "<head>"                         >> QA.html
echo "<style type=\"text/css\">"			>> QA.html
echo "*"                              >> QA.html
echo "{"														  >> QA.html
echo "margin: 0px;"										>> QA.html
echo "padding: 0px;"									>> QA.html
echo "}"														  >> QA.html
echo "html, body"											>> QA.html
echo "{"														  >> QA.html
echo "height: 100%;"									>> QA.html
echo "}"														  >> QA.html
echo "</style>"												>> QA.html
echo "</head>"												>> QA.html
echo "<body>" 												>> QA.html

echo "<table cellspacing=\"1\" style=\"width:100%;\">"				>> QA.html
echo "<tr>"																					                                >> QA.html
echo "<hr><p><b> <FONT COLOR=BLACK FACE=\"Geneva, Arial\" SIZE=5> SCAN ID: ${ID}</b><p>"      >> QA.html
echo "</tr>"                                                                        >> QA.html
echo "<tr>"                                                                         >> QA.html
echo "<hr><p><b> <FONT COLOR=BLACK FACE=\"Geneva, Arial\" SIZE=3> Motion parameters</b><p><IMG BORDER=0 SRC=\"${path}/plots/motion_plot.jpg\">" >> QA.html
#echo "<hr><p><b>FLIRT standard space registration results</b><p><IMG BORDER=0>" >> QA.html
#echo "<td><a href=\"file:"${path}"/plots/motion_plot.jpg\"><img src=\"${path}/plots/motion_plot.jpg\" width=\"70%\" ></a></td>"	>> QA.html
echo "</tr>"																				>> QA.html
echo "<tr>"																					>> QA.html
echo "<hr><p><b><FONT COLOR=BLACK FACE=\"Geneva, Arial\" SIZE=3> Timeseries Summary</b><p><IMG BORDER=0 SRC=\"${path}/plots/carpet_plot.jpg\">" >> QA.html
echo "</tr>"																				>> QA.html
echo "<tr>"																					>> QA.html
echo "<hr><p><b><FONT COLOR=BLACK FACE=\"Geneva, Arial\" SIZE=3> Rigid Alignment</b><p><IMG BORDER=0 SRC=\"${path}/plots/template_on_avg.png\">" >> QA.html
