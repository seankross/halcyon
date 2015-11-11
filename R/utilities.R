check_outfmt10 <- function(outfmt10){
  column_names <- c("qseqid", "sseqid", "bitscore")
  if(!all(column_names %in% colnames(outfmt10))){
    stop("The argument passed to this function does not seem to have been
         imported with read_outfmt10().")
  }
}

#' @importFrom dplyr %>%
#' @export
dplyr::`%>%`