rmarkdown::render("README.Rmd", output_file = "README.md", quiet = FALSE)
source("Adjust code toggle in md.R")
html <- markdown::markdownToHTML(
  "README.md",
  fragment.only = FALSE
)
writeLines(html, "README.html")
rstudioapi::viewer("README.html")