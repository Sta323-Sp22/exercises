all: paper.html paper.pdf

paper.html: paper.Rmd fig1/fig.png fig2/fig.png
	Rscript -e "rmarkdown::render('paper.Rmd')"

paper.pdf: paper.Rmd fig1/fig.png fig2/fig.png
	Rscript -e "rmarkdown::render('paper.Rmd', output_format='pdf_document')"

fig1/fig.png: fig1/fig.R
	Rscript fig1/fig.R

fig2/fig.png: fig2/fig.R
	Rscript fig2/fig.R

clean:
	rm -f fig1/fig.png
	rm -f fig2/fig.png
	rm -f paper.html
	rm -f paper.pdf
	
.PHONY: all clean

