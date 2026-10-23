# FIRE-research
Question: Among adults who received AI advice on an everyday classification task, how do demographic characteristics relate to their stated trust in that advice, and are these differences specific to AI and sensitive to the AI's stated accuracy?


## Methods

### Research design

This study is a **quantitative secondary analysis** of a publicly available dataset. In the original study, participants completed a classification task with advice and then answered a short survey, which included how much they trusted the advice they received. The original authors analyzed how participants used the advice during the task; they did **not** analyze the post-task survey responses, including the trust item. We analyze that unused trust item.

We ask three research questions:

- **RQ1 (demographics).** Do age, gender, education, socioeconomic status, programming experience and everyday AI use predict how much people say they trust AI advice?
- **RQ2 (AI-specificity).** Are these demographic differences specific to AI, or do they also appear when the same advice is labeled as coming from a human? Advice source was randomly assigned, so the human-advice group serves as a comparison group.
- **RQ3 (calibration to stated accuracy).** Does stated trust rise when the AI is described as more accurate (65% vs 80% vs 95%), and does this sensitivity differ across demographic groups? People whose trust tracks the AI's stated accuracy are better calibrated than people whose trust stays the same regardless of how accurate the AI is said to be.

### Data source and selection

We searched Kaggle, GitHub and Google Dataset Search using terms such as "human trust in AI". Datasets were eligible if they:

1. contained an individual-level, self-report measure of trust in AI;
2. included at least two demographic variables (age, gender or education);
3. came from adult human respondents; and
4. were documented well enough to identify item wording and response scales.

Of 15 candidate datasets screened, 6 were reviewed in full and 1 was retained.

| Label | File | Source |
|---|---|---|
| **Analyzed** | `data/dataset1.csv` | Vodrahalli, K., Daneshjou, R., Gerstenberg, T., & Zou, J. (2022). *Do humans trust advice more if it comes from AI? An analysis of human-AI interactions.* AIES '22. Data: github.com/kailas-v/human-ai-interactions |
| Excluded | `data/dataset2.csv` | *AI trust insights* (Kaggle) [*author, URL, access date*] |
| Excluded | `data/dataset3.csv` | *The impact of artificial intelligence on society* (Kaggle) [*author, URL, access date*] |

**Why the other two datasets were excluded.**

- *AI trust insights* (1,000 rows) showed signs of synthetic generation:
  - all demographic and design variables were consistent with perfectly uniform distributions (χ² goodness-of-fit p = .21–.68);
  - age bracket and education were statistically independent (χ² p = .95), implying that 26% of respondents aged 18–24 held a PhD;
  - trust was unrelated to age (p = .97) and education (p = .76) but strongly related to model-generated features such as AI confidence (r = .70);
  - it had no respondent identifiers, no documented collection procedure, and its documentation states that some values were filled in by the author.
- *The impact of artificial intelligence on society* is focused on Turkish participants, with only 167 respondents as adults. This is too few to support demographic comparisons.

Both files are kept in the repository for transparency but are not analyzed.

### Participants

Participants were adults recruited through the crowdsourcing platform Prolific. The raw file has 35,671 rows from 1,125 participants (about 30 task trials each). Each participant:

- was randomly assigned to receive advice labeled as coming from an **AI** or a **human**;
- completed one task type (art, sarcasm, cities, census or dermatology); and
- was told the advisor was 65%, 80% or 95% accurate.

After removing expert dermatologists (identified by `job_title`), the analytic samples are:

| Sample | Used for | N |
|---|---|---|
| AI-advice condition | RQ1 | 552 |
| AI- and human-advice conditions | RQ2 | 1,096 |
| Art task, US participants, AI-advice condition | RQ3 | 171 (65%: 46, 80%: 68, 95%: 57) |

In the AI-advice condition, age ranges from 18 to 81 (median 27). The sample is 297 female, 250 male and 5 other/unknown. Most participants are from the United States and the United Kingdom, with smaller groups from Asian countries.

### Measures

All recoding rules below are fixed before analysis and recorded in the codebook.

| Concept | Column | Original scale | Coding |
|---|---|---|---|
| **Stated trust in the advice (outcome)** | `survey_q3_trust_in_advice` | Slider, 0 (no trust) to 1 (much trust) | Rescaled to 0–100 (score × 100) for readability. |
| **Advice source** | `advice_source` | AI / human (randomized) | Factor, AI = reference in RQ2. |
| **Stated accuracy** | `perceived_accuracy` | 65, 80, 95 (% accuracy told to participants) | Ordered factor in RQ3; covariate in RQ1–2. |
| **Age** | `age` | Years (18–81) | Grouped 18–24, 25–34, 35–44, 45+; continuous age used as a sensitivity check. |
| **Gender** | `gender` | female, male, Other/Unknown, prefer not to say | Female = reference. Groups with n < 10 are reported descriptively but not tested. |
| **Education** | `education_description` | 8 categories | *High school or less* (no formal qualifications, secondary, high school/A-levels) < *Associate/vocational* (technical/community college) < *Bachelor's* < *Postgraduate* (graduate, doctorate). "Don't know / not applicable" set to missing. |
| **Socioeconomic status** | `socioeconomic_status` | 1–10 (5 = middle class) | Numeric. |
| **Programming experience** | `programming_experience` | Yes / No / I don't know | Yes vs No; "I don't know" and blanks set to missing. |
| **Everyday AI use** | `survey_q5_AI_in_life` | 0 (never) to 1 (very often) | Numeric, rescaled to 0–100. |
| **Task type** | `task_name` | art, sarcasm, cities, census, dermatology | Covariate. Dermatology (n = 5 lay participants) excluded. |
| **Region** | `geographic_region` | Country | Grouped US / UK / Asia; covariate. |

**Defining trust.** We define trust in AI as a person's willingness to rely on an AI system's output when the outcome is uncertain (adapted from Lee & See, 2004). The outcome is **stated trust**: the participant's own rating, given right after the task, of how much they trusted the advice they had just received. This measures trust in a specific AI advisor after interacting with it. It does not measure general attitudes toward AI.

**Other survey items.** Perceived helpfulness of the advice (`survey_q2`, r = .72 with trust) is used only as a robustness check: we rerun the main models with helpfulness as the outcome. Perceived advice accuracy (`survey_q1`) and the belief that AI vs a person is better at the task (`survey_q4`) were asked at the same time as the trust item. They are not used as predictors, because they are judgments formed together with trust rather than causes of it. They are reported descriptively only.

### Data cleaning

All cleaning is done in R with scripted, reproducible steps:

1. **One row per participant.** Verify that survey and demographic answers are constant within each `participant_id` (confirmed for trust, age, gender, education and region), then keep one row per participant so each person is counted once.
2. **Sample restrictions.** Remove expert dermatologists and the dermatology task. For RQ1, keep the AI-advice condition; for RQ2, keep both conditions; for RQ3, keep US participants in the art task.
3. **Recoding.** Apply the rules in the Measures table.
4. **Missing data.** Report missingness for every variable. Use listwise deletion within each model, with no imputation.

### Analysis plan

**Descriptive statistics.** Report mean stated trust (SD) by each demographic group and condition.

**RQ1.**

1. *Bivariate tests:* Welch t-tests (gender, programming experience), one-way ANOVAs (age group, education) and Pearson correlations (socioeconomic status, AI use) of stated trust.
2. *Multiple regression:* OLS regression of stated trust on all demographic predictors together, controlling for task type, stated accuracy and region, with robust (HC3) standard errors.

Report effect sizes (Cohen's d, partial η², standardized β) with 95% confidence intervals.

**RQ2.** In the combined AI and human sample, fit the RQ1 regression with an `advice_source × demographic` interaction for each demographic variable. A significant interaction means the demographic difference is specific to AI (or to human) advice.

**RQ3.** In US art-task participants (the only task with all three stated-accuracy levels):

1. Test whether stated trust differs across 65%, 80% and 95% (one-way ANOVA with a linear trend contrast).
2. Exploratory: add `stated accuracy × demographic` interactions.

**Robustness checks.**

- Use continuous age instead of age groups.
- Use perceived helpfulness (`survey_q2`) as the outcome instead of trust.
- Inspect residuals for floor or ceiling effects of the 0–100 slider.

**Multiple comparisons.** Apply the Holm correction within each research question's family of demographic tests.

**Power.** At α = .05 and 80% power, the RQ1 sample (N = 552) can detect small effects: f = 0.14 across four age or education groups, and d = 0.24 for gender. RQ2 has roughly double the sample. RQ3 cells are small (46–68 per accuracy level), so the main RQ3 test can detect only medium effects (f ≈ 0.24) and its demographic interactions are exploratory, and non-significant results there are interpreted as inconclusive.

### Ethics

The data are publicly available and de-identified. The original authors report collecting no personally identifiable information. No new data were collected and no participants were contacted.

### Limitations

- **Task-specific, post-task trust.** The trust item asks about advice on one task, rated after the participant finished it. Results describe trust in a specific AI advisor after use, not attitudes toward AI in general, and stated trust may partly reflect how the task went.
- **Single-item measure.** Trust is measured with one slider item, so its reliability cannot be estimated. The helpfulness robustness check partly addresses this.
- **Stated-accuracy groups were collected separately.** In the original study, the 65% and 95% art-task groups were recruited after the main 80% experiment. RQ3 is therefore a comparison between separately recruited groups, not a fully randomized experiment.
- **Sample composition.** Participants are online crowdworkers, mostly young (median age 27) and from the US and UK, so findings may not generalize to older adults or other populations.
- **Observational demographics.** Advice source was randomized, but demographics were not. Demographic differences are associations, not causal effects.
