# Simple data exploration - base R only, no packages needed.
# Save in the same folder as the CSV and run the whole file.

df <- read.csv("data/dataset2.csv", stringsAsFactors = FALSE)

cat("Rows:", nrow(df), " Columns:", ncol(df), "\n\n")

# Describes any column: numbers get stats, everything else gets counts.
# Skips a column quietly if the name doesn't exist.
describe <- function(col) {
  if (!(col %in% names(df))) {
    cat("--", col, "not found, skipped\n\n")
    return(invisible(NULL))
  }
  x <- df[[col]]
  cat("====", col, "====\n")
  if (is.numeric(x)) {
    cat("n:      ", sum(!is.na(x)), "\n")
    cat("mean:   ", round(mean(x, na.rm = TRUE), 2), "\n")
    cat("median: ", round(median(x, na.rm = TRUE), 2), "\n")
    cat("sd:     ", round(sd(x, na.rm = TRUE), 2), "\n")
    cat("min:    ", min(x, na.rm = TRUE), "\n")
    cat("max:    ", max(x, na.rm = TRUE), "\n")
  } else {
    counts <- table(x, useNA = "ifany")
    print(counts)
    cat("\nPercent:\n")
    print(round(100 * prop.table(counts), 1))
  }
  cat("\n")
}

# ---- Numeric columns ----
describe("ai_confidence_percentage")
describe("response_character_count")
describe("trust_score_out_of_10")
describe("verification_duration_mins")
describe("answer_accuracy_percentage")

# ---- Categorical columns ----
describe("ai_model_name")
describe("query_category")
describe("has_cited_sources")
describe("contains_hedging_words")
describe("includes_disclaimer")
describe("answer_detail_level")
describe("respondent_age_bracket")
describe("education_level")
describe("digital_literacy_score")
describe("ai_familiarity_level")
describe("decision_importance")
describe("urgency_level")
describe("belief_alignment_status")
describe("subject_matter_expertise")
describe("performed_fact_check")
describe("fact_check_method_used")
describe("trust_calibration_valid")
describe("user_skepticism_category")

# ---- Key comparison: trust vs. accuracy ----
# Trust is 0-10 and accuracy is 0-100, so multiply trust by 10.
if (all(c("trust_score_out_of_10", "answer_accuracy_percentage") %in% names(df))) {
  trust_pct <- df$trust_score_out_of_10 * 10
  cat("==== Trust vs accuracy ====\n")
  cat("Average trust (0-100):    ", round(mean(trust_pct, na.rm = TRUE), 1), "\n")
  cat("Average accuracy (0-100): ", round(mean(df$answer_accuracy_percentage, na.rm = TRUE), 1), "\n")
  cat("Average gap (trust - accuracy):",
      round(mean(trust_pct - df$answer_accuracy_percentage, na.rm = TRUE), 1), "\n")
  cat("Correlation:", round(cor(trust_pct, df$answer_accuracy_percentage,
                               use = "complete.obs"), 3), "\n\n")
}

# ---- Average trust and accuracy by group ----
by_group <- function(col) {
  if (!(col %in% names(df))) return(invisible(NULL))
  cat("==== Average by", col, "====\n")
  out <- aggregate(cbind(trust_score_out_of_10, answer_accuracy_percentage) ~ df[[col]],
                   data = df, FUN = function(v) round(mean(v), 2))
  names(out)[1] <- col
  print(out)
  cat("\n")
}

by_group("ai_model_name")
by_group("performed_fact_check")
by_group("user_skepticism_category")
by_group("query_category")
