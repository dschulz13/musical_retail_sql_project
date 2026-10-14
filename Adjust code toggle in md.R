all_lines <- readLines("README.md")

# Delete empty lines immediately after the summary tag
idx_delete <- which(grepl("<summary>", all_lines)) + 1

all_lines <- all_lines[-idx_delete]
writeLines(all_lines, "README.md")

