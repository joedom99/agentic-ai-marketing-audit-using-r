# =======================================
# Agentic AI Marketing Assistant using R
# Performs a single website audit
# By: Joe Domaleski, 4/26/25
# https://blog.marketingdatascience.ai
# =======================================

# ---- STEP 1: Load API Key ----
openai_key <- Sys.getenv("OPENAI_API_KEY")
if (openai_key == "") stop("OPENAI_API_KEY not set. Please add it to your .Renviron file.")

# ---- STEP 2: Install & Load Required Packages ----

# Define required packages
required <- c("rvest", "httr", "dplyr", "jsonlite", "ellmer", "tidyprompt", "ggplot2", "wordcloud", "RColorBrewer")

# Install any missing packages automatically
to_install <- setdiff(required, rownames(installed.packages()))
if (length(to_install) > 0) install.packages(to_install)

# Load libraries
library(tidyprompt)   # Calling LLM models with prompts
library(ellmer)       # Tool creation and agent integration
library(rvest)        # Web scraping HTML pages
library(httr)         # HTTP requests (load time, links)
library(dplyr)        # Data manipulation
library(jsonlite)     # JSON parsing
library(ggplot2)      # Plotting charts
library(wordcloud)    # Creating word clouds
library(RColorBrewer) # Color palettes

# ---- STEP 3: Define Tool Functions ----

# Scrape the homepage title and meta description
web_scrape <- function(url) {
  message("Running web_scrape...")
  tryCatch({
    page <- read_html(url)
    title <- page %>% html_node("title") %>% html_text(trim = TRUE)
    meta <- page %>% html_node("meta[name='description']") %>% html_attr("content")
    list(title = title, description = meta)
  }, error = function(e) list(error = paste("Error:", e$message)))
}

# Extract keywords from a block of text
extract_keywords <- function(text) {
  message("Running extract_keywords...")
  tryCatch({
    words <- tolower(text) |> gsub("[^a-z ]", "", x = _) |> strsplit(" ") |> unlist() |> table() |> sort(decreasing = TRUE)
  }, error = function(e) NULL)
}

# Perform basic SEO analysis on title and meta
analyze_seo <- function(title, description) {
  message("Running analyze_seo...")
  tryCatch({
    paste(
      "SEO Analysis:\n",
      "- Title:", title, "\n",
      "- Meta Description:", description, "\n",
      "\nSuggested improvements:\n",
      "1. Include primary keywords early in the title.\n",
      "2. Make the meta description action-oriented and concise.\n",
      "3. Consider adding geo-targeted terms if relevant."
    )
  }, error = function(e) NULL)
}

# Summarize a block of text
summarize_text <- function(text) {
  message("Running summarize_text...")
  tryCatch({
    paste("Summary:", substr(text, 1, 200), "...")
  }, error = function(e) NULL)
}

# Return the current time
get_time <- function(tz = "UTC") {
  format(Sys.time(), tz = tz, usetz = TRUE)
}

# Check if page is mobile-friendly by looking for viewport tag
check_mobile_friendly <- function(url) {
  message("Running check_mobile_friendly...")
  tryCatch({
    page <- read_html(url)
    !is.na(html_node(page, "meta[name='viewport']"))
  }, error = function(e) FALSE)
}

# Measure homepage load time
measure_load_time <- function(url) {
  message("Running measure_load_time...")
  tryCatch({
    t0 <- Sys.time()
    httr::GET(url)
    t1 <- Sys.time()
    as.numeric(difftime(t1, t0, units = "secs"))
  }, error = function(e) NA)
}

# ---- STEP 4: Create Chat Agent and Register Tools ----

# Create OpenAI chat agent
chat <- chat_openai(model = "gpt-4")

# Register tools for agent use
chat$register_tool(tool(web_scrape, .description = "Scrapes title and meta description.", url = type_string("Full URL.")))
chat$register_tool(tool(extract_keywords, .description = "Extracts keywords from text.", text = type_string("Input text.")))
chat$register_tool(tool(analyze_seo, .description = "SEO analysis of title and meta.", title = type_string("Title."), description = type_string("Meta.")))
chat$register_tool(tool(summarize_text, .description = "Summarizes a block of text.", text = type_string("Text.")))
chat$register_tool(tool(get_time, .description = "Returns the current time.", tz = type_string("Timezone.")))
chat$register_tool(tool(check_mobile_friendly, .description = "Checks for viewport meta tag.", url = type_string("URL.")))
chat$register_tool(tool(measure_load_time, .description = "Measures page load time.", url = type_string("URL.")))

# ---- STEP 5: Audit Site Step-by-Step ----

# Define the website to audit
site <- "https://www.gatech.edu"   # Full address of the target site

message("Auditing: ", site)

# === ACTION 1 (AGENTIC): Scrape homepage title and meta ===
scraped_info <- web_scrape(site)
scraped_title <- scraped_info$title
scraped_meta <- scraped_info$description
action_1 <- paste("Homepage Title:", scraped_title, "\nMeta Description:", scraped_meta)

# === ACTION 2 (AGENTIC): Mobile-friendly check ===
is_mobile_friendly <- check_mobile_friendly(site)
action_2 <- paste("Mobile-friendly:", ifelse(is_mobile_friendly, "Yes", "No"))

# === ACTION 3 (DIRECT R): Extract keywords + create word cloud ===
keywords_table <- extract_keywords(paste(scraped_title, scraped_meta))
message("Creating keyword wordcloud...")
if (!is.null(keywords_table)) {
  # Set random seed for reproducibility
  set.seed(123)
  
  # Display wordcloud in RStudio plot pane
  wordcloud(
    names(keywords_table),
    freq = as.integer(keywords_table),
    scale = c(3, 0.7),
    min.freq = 1,
    max.words = 150,
    random.order = FALSE,
    rot.per = 0.15,
    colors = brewer.pal(8, "Dark2")
  )
  
  # Save wordcloud to PNG file
  png("keyword_wordcloud.png", width = 1000, height = 1000)
  set.seed(123)
  wordcloud(
    names(keywords_table),
    freq = as.integer(keywords_table),
    scale = c(3, 0.7),
    min.freq = 1,
    max.words = 150,
    random.order = FALSE,
    rot.per = 0.15,
    colors = brewer.pal(8, "Dark2")
  )
  dev.off()
}
action_3 <- "Keyword extraction and word cloud created."

# === ACTION 4 (DIRECT R): Load time measurement ===
load_time <- measure_load_time(site)
load_df <- data.frame(Site = c("gatech.edu", "Industry Average"), LoadTime = c(load_time, 2.5))

# Create horizontal bar plot
load_plot <- ggplot(load_df, aes(x = Site, y = LoadTime, fill = Site)) +
  geom_bar(stat = "identity") +
  coord_flip() +
  theme_minimal() +
  labs(title = "Homepage Load Time Comparison", y = "Seconds", x = "")

print(load_plot)
ggsave("load_time_comparison.png", load_plot, width = 6, height = 4)

action_4 <- paste("Homepage load time (seconds):", round(load_time, 2))

# === ACTION 5 (DIRECT R): Link ratio analysis ===
message("Running link analysis...")
page <- read_html(site)
links <- page %>% html_nodes("a") %>% html_attr("href")
links <- links[!is.na(links)]

# Classify links
internal_links <- sum(grepl("gatech.edu", links) | grepl("^/", links))
external_links <- sum(!grepl("gatech.edu", links) & !grepl("^/", links))

# Prepare data for plotting
link_data <- data.frame(Type = c("Internal", "External"), Count = c(internal_links, external_links))

# Create pie chart
link_plot <- ggplot(link_data, aes(x = "", y = Count, fill = Type)) +
  geom_col(width = 1) +
  coord_polar("y") +
  theme_void() +
  labs(title = "Link Ratio: Internal vs External")

print(link_plot)
ggsave("link_ratio_pie.png", link_plot, width = 5, height = 5)

action_5 <- "Link ratio pie chart created."

# === ACTION 6 (AGENTIC): SEO analysis ===
seo_prompt <- paste("Analyze SEO and give 3 specific improvement suggestions for this page:\n\n",
                    "Title: ", scraped_title, "\n",
                    "Meta Description: ", scraped_meta)

action_6 <- chat$chat(seo_prompt)

# ---- STEP 6: Save Results to File ----

# Clean domain name from URL for filename
domain <- gsub("https://|http://|www\\.|\\.edu|/", "", site)

# Define output file name
file_name <- paste0("audit_report_", domain, ".txt")

# Combine all audit results
result <- paste(
  "Website Audit for:", site, "\n\n",
  action_1, "\n\n",
  action_2, "\n\n",
  action_3, "\n\n",
  action_4, "\n\n",
  action_5, "\n\n",
  action_6
)

# Write audit report to text file
writeLines(result, file_name)

message("Report saved to ", file_name)
message("Audit complete.")