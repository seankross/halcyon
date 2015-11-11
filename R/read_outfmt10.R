#' Import outfmt 10 result
#' 
#' Convert a result from using \code{blastn} with the \code{-outfmt "10"} flag
#' to a data frame.
#' 
#' @param path The path to the blast result.
#' @export
#' @examples
#' \dontrun{
#' 
#' # Choose the path to the file interactively
#' read_outfmt10()
#' 
#' # Or explicitly specify a path
#' read_outfmt10(file.path("path", "to", "file.out"))
#' 
#' }

read_outfmt10 <- function(path=ifelse(interactive(), file.choose(), NULL)){
  if(is.null(path)){
    stop("read_outfmt10: The path to the blast result file is not specified.")
  }
  tbl <- read.delim(path, header = FALSE, comment.char = "#", sep = ",")
  colnames(tbl) <- c("qseqid", "sseqid", "pident", "length", "mismatch",
                     "gapopen", "qstart", "qend", "sstart", "send",
                     "evalue", "bitscore")
  tbl
}
