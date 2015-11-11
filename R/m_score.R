#' Calculate the m-score for each element in a numeric vector
#' 
#' The m-score is calculated by the following formula:
#' For each element i in vector x calculate (i - median(x))/mad(x). This
#' function returns a vector of m-scores corresponding to the input vector.
#' 
#' @param x A numeric vector.
#' @export
#' @examples
#' \dontrun{
#' 
#' m_score(1:10)
#' m_score(rnorm(100))
#' 
#' }
m_score <- function(x){
  (x - median(x))/mad(x)
}

#' Calculate m-scores for a blast result
#'
#' @importFrom dplyr group_by summarise left_join mutate
#' @export
calc_m_scores <- function(outfmt10){
  check_outfmt10(outfmt10)
  
  med_table <- outfmt10 %>%
    group_by(qseqid) %>%
    summarise(med = median(bitscore))
  
  madev_table <- outfmt10 %>%
    group_by(qseqid) %>%
    summarise(madev = mad(bitscore))
  
  outfmt10 %>%
    left_join(med_table, by = "qseqid") %>%
    left_join(madev_table, by = "qseqid") %>%
    mutate(mscore = ifelse(madev == 0, 0, (bitscore - med)/madev))
}

