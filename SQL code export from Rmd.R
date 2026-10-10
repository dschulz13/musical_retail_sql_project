export_chunk_group <- function(group_name = "sql") {
  env <- new.env(parent = globalenv())
  env$export_type <- group_name
  env$sql_chunk_activator <- function(export_type) {
    if (export_type == "sql") {
      return(TRUE)
    } else {
      return(FALSE)
    }
  }
  
  old_purl <- knitr::opts_chunk$get("purl")
  on.exit(knitr::opts_chunk$set(purl = old_purl))  
  knitr::opts_chunk$set(purl = FALSE)
  
  knitr::purl(
    input = "README.Rmd",
    output = paste0("Code ", group_name, ".R"),
    envir = env,
    documentation = 0
  )
}

export_chunk_group(group_name = "sql")