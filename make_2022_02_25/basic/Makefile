all: paper.html

paper.html: paper.Rmd fig1/fig.png fig2/fig.png
	Rscript -e "rmarkdown::render('paper.Rmd')"

fig1/fig.png: fig1/fig.R
	Rscript fig1/fig.R

fig2/fig.png: fig2/fig.R
	Rscript fig2/fig.R

.PHONY: all
