# !bin/zsh

# create .bbl
bibtex eco
bibtex med

# underline the owner's name in .bbl
sed -i 's/Konan\ Hara/\\textbf\{\\underline\{Konan\ Hara\}\}/g' eco.bbl
sed -e ':a' -e 'N' -e '$!ba' -i -e 's/Konan\n\ \ Hara,/\\textbf\{\\underline\{Konan\ Hara\}\},\n\ /g' eco.bbl
sed -i 's/Konan\ Hara/\\textbf\{\\underline\{Konan\ Hara\}\}/g' med.bbl
sed -e ':a' -e 'N' -e '$!ba' -i -e 's/Konan\n\ \ Hara,/\\textbf\{\\underline\{Konan\ Hara\}\},\n\ /g' med.bbl
