(TeX-add-style-hook "python_scripts"
 (lambda ()
    (TeX-run-style-hooks
     "pdfpages"
     "final"
     "hyperref"
     "listings"
     "color"
     "vmargin"
     "tikz"
     "amsmath"
     "graphicx"
     "latex2e"
     "scrartcl10"
     "scrartcl"
     "article"
     "10pt")))
