# !bin/zsh

# remove lines for month
sed -i '' '/^month = {/d' *.bib

# create .bbl
bibtex eco
bibtex medsel
bibtex medoth

# underline the owner's name in .bbl
sed -i '' -e 's/Konan\ Hara/\\textbf\{\\underline\{Konan\ Hara\}\}/g' eco.bbl
sed -e ':a' -e 'N' -e '$!ba' -i '' -e 's/Konan\n\ \ Hara,/\\textbf\{\\underline\{Konan\ Hara\}\},\n\ /g' eco.bbl
sed -i '' -e 's/Konan\ Hara/\\textbf\{\\underline\{Konan\ Hara\}\}/g' medsel.bbl
sed -e ':a' -e 'N' -e '$!ba' -i '' -e 's/Konan\n\ \ Hara,/\\textbf\{\\underline\{Konan\ Hara\}\},\n\ /g' medsel.bbl
sed -i '' -e 's/Konan\ Hara/\\textbf\{\\underline\{Konan\ Hara\}\}/g' medoth.bbl
sed -e ':a' -e 'N' -e '$!ba' -i '' -e 's/Konan\n\ \ Hara,/\\textbf\{\\underline\{Konan\ Hara\}\},\n\ /g' medoth.bbl
