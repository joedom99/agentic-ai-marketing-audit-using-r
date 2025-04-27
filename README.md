# Agentic AI Marketing Audit Using R

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Built with R](https://img.shields.io/badge/Built%20with-R-276DC3?logo=R)](https://www.r-project.org/)

## Overview

This repository provides a complete example of **Agentic AI** using R to perform a marketing website audit.
It demonstrates a combination of **autonomous agent reasoning** (via OpenAI's GPT-4) and **direct R-based analysis** for an effective, practical application.

**Full details about this script can be found on my blog:**
👉 https://blog.marketingdatascience.ai/agentic-ai-with-r-building-an-automated-website-auditor-from-scratch-1a42d0bd7bae

The audit covers:
- Scraping the homepage title and meta description (Agentic)
- Checking for mobile-friendliness (Agentic)
- Extracting keywords and generating a word cloud (Direct R)
- Measuring homepage load time and visualizing it (Direct R)
- Analyzing internal vs external links (Direct R)
- Performing SEO improvement recommendations (Agentic)

Plots and output reports are automatically generated and saved during the audit process.

## Getting Started

### Prerequisites
- R 4.3 or later (tested on R 4.4.1)
- An OpenAI API key (saved to your `.Renviron` as `OPENAI_API_KEY`)
- Internet connection

### Installation
No manual package installation required! 
The script automatically checks for and installs any missing packages.

Required R packages:
- tidyprompt
- ellmer
- rvest
- httr
- dplyr
- jsonlite
- ggplot2
- wordcloud
- RColorBrewer

### Usage
1. Clone or download this repository.
2. Open the R script file `agentic-ai-demo-using-r.R`.
3. Set your working directory if needed.
4. Run the script step-by-step or source the entire file.

The script will:
- Audit the example website (`https://www.gatech.edu`)
- Generate and save:
  - `audit_report_gatech.txt`
  - `keyword_wordcloud.png`
  - `load_time_comparison.png`
  - `link_ratio_pie.png`

You can adapt the `site` variable to audit other websites!

## Project Structure
```plaintext
agentic-ai-marketing-audit-using-r/
├── agentic-ai-demo-using-r.R        # Main script
├── audit_report_gatech.txt          # Output report
├── keyword_wordcloud.png            # Word cloud image
├── load_time_comparison.png         # Load time comparison chart
├── link_ratio_pie.png               # Link ratio pie chart
```

## License
This project is licensed under the **MIT License** — see the [LICENSE](https://opensource.org/licenses/MIT) file for details.

## Author
Created by [Joe Domaleski](https://blog.marketingdatascience.ai)

---

**If you like this project, please star the repo!** ⭐

